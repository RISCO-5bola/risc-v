//THE 8251A EXAMPLE
//Cadence Design Systems, Inc. does not guarantee
//the accuracy or completeness of this model.
//Anyone using this does so at their own risk.
//Intel and MCS are trademarks of the Intel Corporation.
module I8251A(dbus,rcd,gnd,txc_,write_,chipsel_,comdat_,read_,rxrdy,
             txrdy,syndet,cts_,txe,txd,clk,reset,dsr_,rts_,dtr_,rxc_,vcc);

    parameter [7:0] instance_id = 8'h00;

    parameter [8:1] dflags     =      8'b00000100; // Defaults for diagnostics
    //                                      |||||
    // diagnostic dflags:                   |||||
    // bit 5 (16)  operation event trace  <-+||||
    // bit 4 (8)  communication errors   <---+||| (parity, frame, overrun)
    // bit 3 (4)  timing check          <-----+||
    // bit 2 (2) = print receiving     <-------+|
    // bit 1 (1) = print transmitting <---------+

    /* timing constants, for A. C. timing check, only non-zero times 
       are specified, in nano-sec */

    /* nao entendi a aplicacao dos timings, devemos alterar algo para funcionar na FPGA? */
    /* read cycle */
    `define TRR  250
    `define TRD  200
    `define TDF  100  // max. time used

    /* write cycle */
    `define TWW  250
    `define TDW  150
    `define TWD  20
    `define TRV  6  // in terms of clock cycles

    /* other timing */
    `define TTXRDY 8 // 8 clock cycles

    /* vamos ter que aumentar o memory controller para ajudar no controle da UART também */
    input
        /* deve ser uma serial, como simular uma serial? */
        /* recebe pela FPGA */
        rcd, // receive data

        /* recebe um clock separado */
        /* recebe pela FPGA */
        rxc_, // receive clock

        /* recebe um clock separado */
        /* recebe pela FPGA */
        txc_, // transmit clock

        /* deixar como 0 para selecionar ele mesmo */
        /* deixar hardwired do processador */
        chipsel_, // chip selected when low

        /* 1 se CONTROL/STATUS, 0 se DATA */
        /* seleciona se eu quero que meu output seja um status (se tiver fazendo read)
            ou controle (se for write), ou o negocio e dado mesmo */
        /* vem do memory controller */
        comdat_,  // command/data_ select

        /* comandos da CPU dizendo se esta fazendo um read ou um write */
        /* vem do memory controller */
        read_, write_,

        /* nao entendi */
        dsr_, // data set ready

        /* deixa transimitir se o bit da instrucao de tx é 1 */
        cts_, // clear to send

        /* coloca uart em estado de espera */
        reset,// reset when high

        /* clock que recebe do processador, nao e separado */
        /* no minimo 30 vezes maior do que  o do Tx e Rx */
        clk, // at least 30 times of the transmit/receive data bit rates

        /* precisa mexer? */
        gnd,
        vcc;

    /* tudo passado para a memory controler interpretar e pausar o processador, se necessario */
    output
        /* UART tem um caractere pronto para ser transmitido */
        /* vai para o memory controller para dizer que em breve vai chegar algo para ela ler? */
        rxrdy, // receive data ready when high 

        /* UART esta pronta para receber caracteres */
        /* nao faz sentido colocar esse sinal no memory controller, devo mandar para outro lugar? */
        txd, // transmit data line

        /* UART esta disponivel transmitir */
        /* nao faz sentido colocar esse sinal no memory controller, devo mandar para outro lugar? */
        txrdy, // transmit buffer ready to accept another byte to transfer

        /* significa que a UART nao tem nada para enviar */
        txe, // transmit buffer empty

        /* quer dizer que terminou de receber e agora quer enviar a informacao */
        /* confuso no datasheet */
        rts_, // request to send 

        /* o que exatamente ele significa? */
        dtr_; // data terminal ready

    /* input e output de dados, tanto de read (Rx) e write (Tx) */
    inout[7:0]
        dbus;

    inout
        /* algo para sincronizar com o processador? */
        syndet; //outside synchonous detect or output to indicate syn det

    /* O que o freertos tem de diferente no endereçamento */
    /* https://freertos.org/a00111.html */
    
    supply0
        gnd;
    supply1
        vcc;

    reg
        txd,
        rxrdy,
        txe,
        dtr_,
        rts_;

    reg[7:0]
        receivebuf,
        rdata,
        status;

    reg
        recvdrv,
        statusdrv;

    assign
        // if recvdrv 1 dbus is driven by rdata
        dbus = recvdrv ? rdata : 8'bz,
        dbus = statusdrv ? status : 8'bz;

    reg[7:0]
        command,
        tdata_out,  // data being transmitted serially
        tdata_hold, // data to be transmitted next if tdata_out is full
        sync1, sync2, // synchronous data bytes
        modreg;
    and  (txrdy,status[0],command[0], ~ cts_);

    reg transmitter_reset, // set to 1 upon a reset, cleared upon write data
        tdata_out_full,  // 1 if data in tdata_out has not been transmitted.
        tdata_hold_full, // 1 if data in tdata_hold has not been transferred to
                         //   tdata_out for serial transmission.
        tdata_hold_cts;  // 1 if tdata_hold_full and it was cts when data was
                         //   transferred to tdata_hold.
                         // 0 if tdata_hold is empty or is full but was filled
                         //   while it was not cts.

    reg tdata_out_wait;  // 0 if a stop bit was just sent and we do not need
                         //   to wait for a negedge on txc before transmitting

    reg[7:0]   syncmask;
    nmos  syndet_gate1(syndet,status[6], ~ modreg[6]);

    reg   sync_to_receive; // 1(2) if looking for 1st(2nd) sync on rxd
    reg   syncs_received;  // 1 if sync chars received, 0 if looking for sync(s)
    reg   rec_sync_index; // indicating the syn. character to be matched
   
    integer  breakcount_period; // number of clock periods to count as break

    reg   sync_to_transmit;  // 1(2) if 1st(2nd) sync char should be sent next

    reg[7:0]  data_mask;    // masks off the data bits (if char size is not 8)
    // temporary registers
    reg[1:0] csel;          // indicates what next write means if comdat_=1:
                            // (0=mode instruction,1=sync1,2=sync2,3=command)
    reg[5:0]
        baudmx,
        tbaudcnt,
        rbaudcnt; // baud rate 
    reg[7:0]
        tstoptotal; // no. of tranmit clock pulses for stop bit (0 if sync mode)
    reg[3:0]
        databits;   // no. of data bits in a character (5,6,7 or 8)

    reg
        rdatain; // a data byte is read in if 1

    reg was_cts_when_received;  // 0: if cts_ was high when char was received
                                // 1: if cts_ was low when char was received
                                //    (and so char was sent before shutdown)

    event
        resete,
        start_receiver_e;

    reg receive_in_progress;


    event txende;



                /*** COMMUNICATION ERRORS ***/

    task frame_error;
        begin
            if(dflags[4])
                $display("I8251A (%h) at %d: *** frame error",
                                                          instance_id, $time);
            status[5]=1;
        end
    endtask

    task parity_error;
        begin
            if(dflags[4])
                $display("I8251A (%h) at %d: *** parity error on data: %b",
                                              instance_id, $time, receivebuf);
            status[3]=1;
        end
    endtask

    task overrun_error;
        begin
            if(dflags[4])
                $display("I8251A (%h) at %d: *** overrun error",
                                                          instance_id, $time);
            status[4]=1;
        end
    endtask



                /*** TIMING VIOLATIONS ***/

    integer
        time_dbus_setup,
        time_write_begin,
        time_write_end,
        time_read_begin,
        time_read_end,
        between_write_clks; // to check between write recovery
    reg reset_signal_in;    // to check the reset signal pulse width

    initial
    begin
        time_dbus_setup  = -9999;
        time_write_begin = -9999;
        time_write_end   = -9999;
        time_read_begin  = -9999;
        time_read_end    = -9999;
        between_write_clks = `TRV; // start: TRV clk periods since last write

    end



                /** Timing analysis for read cycles **/
 
    always @(negedge read_) 
        if (chipsel_==0)
        begin
            time_read_begin=$time;
            read_address_watch;
        end

       /* Timing violation: read pulse must be TRR ns */

    always @(posedge read_)
        if (chipsel_==0)
        begin
            disable read_address_watch;
            time_read_end=$time;

            if(dflags[3] && (($time-time_read_begin) < `TRR))
                $display("I8251A (%h) at %d: *** read pulse width violation",
                                                           instance_id, $time);
        end

       /* Timing violation: address (comdat_ and chipsel_) must be stable */
       /*                   stable throughout read                        */

    task read_address_watch;
        @(comdat_ or chipsel_) // if the "address" changes
            if (read_==0)      //    and read_ did not change at the same time
                if (dflags[3])
                    $display("I8251A (%h) at %d: *** address hold error on read",
                                                          instance_id, $time);
    endtask

                /** Timing analysis for write cycles **/
 
    always @(negedge write_) 
        if (chipsel_==0)
        begin
            time_write_begin=$time;
            write_address_watch;
        end


       /* Timing violation: read pulse must be TRR ns */
       /* Timing violation: TDW ns bus setup time before posedge write_ */
       /* Timing violation: TWD ns bus hold  time after  posedge write_ */

    always @(posedge write_)
        if (chipsel_==0)
        begin
            disable write_address_watch;
            time_write_end=$time;

            if(dflags[3] && (($time-time_write_begin) < `TWW))
                $display("I8251A (%h) at %d: *** write pulse width violation",
                                                           instance_id, $time);

            if(dflags[3] && (($time-time_dbus_setup) < `TDW))
                $display("I8251A (%h) at %d: *** data setup violation on write",
                                                           instance_id, $time);
        end

    always @dbus
        begin
            time_dbus_setup=$time;

            if(dflags[3] && (($time-time_write_end < `TWD)))
                $display("I8251A (%h) at %d: *** data hold violation on write",
                                                           instance_id, $time);
        end


       /* Timing violation: address (comdat_ and chipsel_) must be stable */
       /*                   stable throughout write                       */

    task write_address_watch;
        @(comdat_ or chipsel_) // if the "address" changes
            if (write_==0)     //    and write_ did not change at the same time
                if (dflags[3])
                   $display("I8251A (%h) at %d: *** address hold error on write",
                                                          instance_id, $time);
    endtask


        /* Timing violation: minimum of TRV clk cycles between writes */

    always @(negedge write_)
        if (chipsel_== 0)
        begin
            time_write_begin=$time;
            if(dflags[3] && between_write_clks < `TRV)
               $display("I8251A (%h) at %d: *** between write recovery violation",
                                                           instance_id, $time);
            between_write_clks = 0;
        end
 
    always @(negedge write_)
        repeat (`TRV) @(posedge clk)
            between_write_clks = between_write_clks + 1;



                /** Timing analysis for reset sequence **/

       /* Timing violation: reset pulse must be 6 clk cycles */

    always @(posedge reset)
        begin :reset_block
        reset_signal_in=1;
        repeat(6) @(posedge clk);
        reset_signal_in=0;
        // external reset
        -> resete;
        end

    always @(negedge reset)
        begin
        if(dflags[3] && (reset_signal_in==1))
            $display("I8251A (%h) at %d: *** reset pulse too short",
                                                           instance_id, $time);
        disable reset_block;
        end




                /*** BEHAVIORAL DESCRIPTION ***/


        /* Reset sequence */

    initial
        begin // power-on reset
        reset_signal_in=0;
        ->resete;
        end

    always @resete
        begin
        if(dflags[5])
            $display("I8251A (%h) at %d: performing reset sequence",
                                                           instance_id, $time);
        csel=0;
        transmitter_reset=1;
        tdata_out_full=0;
        tdata_out_wait=0;
        tdata_hold_full=0;
        tdata_hold_cts=0;
        rdatain=0;
        status=4;  // only txe is set
        txe=1;
        statusdrv=0;
        recvdrv=0;
        txd=1; // line at mark state upon reset until data is transmitted
        // assign not allowed for status, etc.
        rxrdy=0;
        command=0;
        dtr_=1;
        rts_=1;
        status[6]=0; // syndet is reset to output low 
        sync_to_transmit=1;     // transmit sync char #1 when sync are transmt'd
        sync_to_receive=1;
        between_write_clks = `TRV;
        receive_in_progress=0;
        disable read_address_watch;
        disable write_address_watch;
        disable trans1;
        disable trans2;
        disable trans3;
        disable trans4;
        disable rcv_blk;
        disable sync_hunt_blk;
        disable double_sync_hunt_blk;
        disable parity_sync_hunt_blk;
        disable syn_receive_internal;
        disable asyn_receive;
        disable break_detect_blk;
        disable break_delay_blk;
        end


    always @(negedge read_) 
        if (chipsel_==0)
        begin
            #(`TRD) // time for data to show on the data bus

            if (comdat_==0)     // 8251A DATA ==> DATA BUS
            begin
                recvdrv=1;
                rdatain=0; // no receive byte is ready
                rxrdy=0;
                status[1]=0;
            end
            else                // 8251A STATUS ==> DATA BUS
            begin
                statusdrv=1;
                if (modreg [1:0] == 2'b00) // if sync mode
                    status[6]=0;           //     reset syndet upon status read
                                           // Note: is only reset upon reset
                                           //       or rxd=1 in async mode
            end
        end

    always @(posedge read_)
        begin
            #(`TDF)  // data from read stays on the bus after posedge read_
            recvdrv=0;
            statusdrv=0;
        end


    always @(negedge write_)
    begin
        if((chipsel_==0) && (comdat_==0))
        begin
            txe=0;
            status[2]=0; // transmitter not empty after receiving data
            status[0]=0; // transmitter not ready after receiving data
        end
    end


    always @(posedge write_)          // read the command/data from the CPU
        if (chipsel_==0)
        begin
            if (comdat_==0)       // DATA BUS ==> 8251A DATA
            begin
                case (command[0] & ~ cts_)
                0:                    // if it is not clear to send
                begin
                    tdata_hold=dbus;
                    tdata_hold_full=1;//    then mark the data as received and
                    tdata_hold_cts=0; //    that it should be sent when cts
                end
                1:                    // if it is clear to send ...
                if(transmitter_reset) // ... and this is 1st data since reset
                begin
                    transmitter_reset=0;
                    tdata_out=dbus;
                    tdata_out_wait=1; //    then wait for a negedge on txc
                    tdata_out_full=1; //         and transmit the data
                    tdata_hold_full=0;
                    tdata_hold_cts=0;
                    repeat(`TTXRDY) @(posedge clk);
                    status[0]=1;      //         and set the txrdy status bit
                end
                else                  // ... and a sync/data char is being sent
                begin
                    tdata_hold=dbus;  //    then mark the data as being received
                    tdata_hold_full=1;//    and that it should be transmitted if
                    tdata_hold_cts=1; //    it becomes not cts,
                                      //    but do not set the txrdy status bit
                end
                endcase
            end
            else                  // DATA BUS ==> CONTROL
            begin
                case (csel)
                0:                // case 0:  MODE INSTRUCTION
                begin
                    modreg=dbus; 
                    if(modreg[1:0]==0)    // synchronous mode
                    begin
                        csel=1;
                        baudmx=1;
                        tstoptotal=0; // no stop bit for synch. op.
                    end
                    else
                    begin                 // asynchronous mode
                        csel=3;
                        baudmx=1; // 1X baud rate
                        if(modreg[1:0]==2'b10)baudmx=16;
                        if(modreg[1:0]==2'b11)baudmx=64;
                        // set up the stop bits in clocks
                        tstoptotal=baudmx;
                        if(modreg[7:6]==2'b10)tstoptotal=
                                   tstoptotal+baudmx/2;
                        if(modreg[7:6]==2'b11)tstoptotal=
                                   tstoptotal+tstoptotal;
                    end
                    databits=modreg[3:2]+5; // bits per char
                    data_mask=255 >> (3-modreg[3:2]);
                end

                1:                // case 1:  1st SYNC CHAR - SYNC MODE
                begin
                    sync1=dbus; 
                    /* the syn. character will be adjusted to the most
                       significant bit to simplify syn. hunt, 
                       syncmask is also set to test the top data bits  */
                    case (modreg[3:2])
                    0:
                    begin
                        sync1=sync1<< 3;
                        syncmask=8'b11111000;
                    end

                    1:
                    begin
                        sync1=sync1<< 2;
                        syncmask=8'b11111100;
                    end

                    2:
                    begin
                        sync1=sync1<< 1;
                        syncmask=8'b11111110;
                    end
                    3:
                        syncmask=8'b11111111;
                    endcase

                    if(modreg[7]==0)
                        csel=2;   // if in double sync char mode, get 2 syncs
                    else
                        csel=3;   // if in single sync char mode, get 1 sync
                end

                2:                // case 2:  2nd SYNC CHAR - SYNC MODE
                begin
                    sync2=dbus;
                    case (modreg[3:2])
                    0: sync2=sync2<< 3;
                    1: sync2=sync2<< 2;
                    2: sync2=sync2<< 1;
                    endcase

                    csel=3;
                end

                3:             // case 3:  COMMAND INSTRUCTION - SYNC/ASYNC MODE
                begin
                    status[0]=0; // Trick: force delay txrdy pin if command[0]=1
                    command=dbus;
                    dtr_= ! command[1];

                    if(command[3])           // if send break command
                        assign txd=0;        //    set txd=0 (ignores/overrides
                    else                     //    later non-assign assignments)
                        deassign txd;

                    if(command[4]) status[5:3]=0; // Clear Frame/Parity/Overrun
                    rts_= ! command[5];
                    if(command[6]) ->resete;      // internal reset

                    if(modreg[1:0]==0 && command[7])
                    begin                    // if sync mode and enter hunt
                        disable              //    disable the sync receiver
                            syn_receive_internal;
                        disable
                            syn_receive_external;

                        receivebuf=8'hff;    //    reset recieve buffer 1's
                        -> start_receiver_e; //    restart sync mode receiver
                    end

                    if(receive_in_progress==0)
                        -> start_receiver_e;

                    repeat(`TTXRDY) @(posedge clk);
                    status[0]=1;
                end
                endcase  
            end
        end


    reg [7:0] serial_data;
    reg parity_bit;


    always wait (tdata_out_full==1)
    begin :trans1

        if(dflags[1])
            $display("I8251A (%h) at %d: transmitting data: %b",
            			  instance_id, $time, tdata_out);

        if (tdata_out_wait)                 // if the data arrived any old time
            @(negedge txc_);                //     wait for a negedge on txc_
                                            // but if a stop bit was just sent
                                            //     do not wait
        serial_data=tdata_out;

        if (tstoptotal != 0)                // if async mode ...
        begin
           txd=0;                           //    then send a start bit 1st
           repeat(baudmx) @(negedge txc_);
        end

        repeat(databits)                    // send all start, data bits
        begin
            txd=serial_data[0];
            repeat(baudmx) @(negedge txc_);
            serial_data=serial_data>> 1;
        end

        if (modreg [4])                     // if parity is enabled ...
        begin
            parity_bit= ^ (tdata_out & data_mask);
            if(modreg[5]==0)parity_bit= ~parity_bit; // odd parity

            txd=parity_bit;
            repeat(baudmx) @(negedge txc_); //    then send the parity bit
        end

        if(tstoptotal != 0)                 // if sync mode
        begin
            txd=1;                          //    then send out the stop bit(s)
            repeat(tstoptotal) @(negedge txc_);
        end

        tdata_out_full=0;// block this routine until data/sync char to be sent
                         // is immediately transferred to tdata_out.

        ->txende;        // decide what data should be sent (data/sync/stop bit)
    end

    event transmit_held_data_e,
          transmitter_idle_e;

    always @txende                    // end of transmitted data/sync character
    begin :trans2

        case (command[0] & ~ cts_)
        0:                           // if it is not now cts
                                     //   but data was received while it was cts
        if (tdata_hold_full && tdata_hold_cts)
            -> transmit_held_data_e; // then send the data char
        else
            -> transmitter_idle_e;   // else send sync char(s) or 1 stop bit

        1:                           // if it is now cts
        if (tdata_hold_full)         //    if a character has been received
                                     //       but not yet transmitted ...
            -> transmit_held_data_e; //       then send the data char

        else                         //    else (no character has been received)
            -> transmitter_idle_e;   //       send sync char(s) or 1 stop bit
        endcase
    end


    always @transmitter_idle_e     // if there are no data chars to send ...
    begin :trans3
        status[2]=1;               //       mark transmitter as being empty
        txe=1;


        if (tstoptotal != 0 ||     //        if async mode or after a reset
          command[0]==0 || cts_==1)//           or TxEnable=false or cts_=false
        begin
            if(dflags[1])
                $display("I8251A (%h) at %d: transmitting data: 1 (stop bit)",
                                                           instance_id, $time);

            txd=1;                 //            then  send out 1 stop bit
            tdata_out=1;           //                  and make any writes
                                   //                  go to tdata_hold
            repeat(baudmx) @(negedge txc_);
            -> txende;
        end
        else                       //        if sync mode
        case (sync_to_transmit)
        1:                         //         ... send 1st sync char now
            begin
            tdata_out=sync1 >> (8-databits);
            tdata_out_wait=0;      //             without waiting on negedge txc
            tdata_out_full=1;
            if(modreg[7]==0)       //             if double sync mode
                sync_to_transmit=2;//                send 2nd sync after 1st
            end
        2:                         //         ... send 2nd sync char now
            begin
            tdata_out=sync2 >> (8-databits);
            tdata_out_wait=0;      //             without waiting on negedge txc
            tdata_out_full=1;
            sync_to_transmit=1;    //             send 1st sync char next
            end
        endcase
    end


    always @ transmit_held_data_e  //    if a character has been received
    begin :trans4
        tdata_out=tdata_hold;      //        but not transmitted ...
        tdata_out_wait=0;          //        then do not wait on negedge txc
        tdata_out_full=1;          //             and send the char immediately
        tdata_hold_full=0;
        repeat(`TTXRDY) @(posedge clk);
        status[0]=1;               //        and set the txrdy status bit
    end





     /******************** RECEIVER PORTION OF THE 8251A  ********************/

                             // data is received at leading edge of the clock

    event  break_detect_e,   //
           break_delay_e;    //

    event  hunt_sync1_e,     // hunt for the 1st sync char
           hunt_sync2_e,     // hunt for the 2nd sync char (double sync mode)
           sync_hunted_e,    // sync char(s) was found (on a bit aligned basis)
           external_syndet_watche;// external sync mode: whenever syndet pin
                                  // goes high, set the syndet status bit


    always @start_receiver_e
    begin :rcv_blk
        receive_in_progress=1;

        case(modreg[1:0])
        2'b00:
            if(modreg[6]==0)              // if internal syndet mode ...
            begin
                if(dflags[5])
                   $display("I8251A (%h) at %d: starting internal sync receiver",
                                                           instance_id, $time);

                if(dflags[5] && command[7])
                   $display("I8251A (%h) at %d: hunting for syncs",
                                                           instance_id, $time);

                if(modreg[7]==1)          //   if enter hunt mode
                begin
                    if(dflags[5])
                        $display("I8251A (%h) at %d: receiver waiting on syndet",
                                                           instance_id, $time);

                    -> hunt_sync1_e;      //      start search for sync char(s)
                                          //      & wait for syncs to be found
                    @(posedge syndet);

                    if(dflags[5])
                       $display("I8251A (%h) at %d: receiver DONE waiting on syndet",
                                                           instance_id, $time);
                end

                syn_receive_internal;     //   start sync mode receiver
            end
            else                          // if external syndet mode ...
            begin
                if(dflags[5])
                   $display("I8251A (%h) at %d: starting external sync receiver",
                                                           instance_id, $time);

                if(dflags[5] && command[7])
                   $display("I8251A (%h) at %d: hunting for syncs",
                                                           instance_id, $time);

                -> external_syndet_watche;//    whenever syndet pin goes to 1
                                          //        set syndet status bit

                if (command[7]==1)        //    if enter hunt mode
                begin :external_syn_hunt_blk
                   fork
                      syn_receive_external;//      assemble chars while waiting

                      @(posedge syndet)   //       after rising edge of syndet
                        @(negedge syndet) //       wait for falling edge
                                          //       before starting char assembly
                          disable external_syn_hunt_blk;
                    join
                end

            syn_receive_external;         //   start external sync mode receiver
            end

        default:                          // if async mode ...
            begin
                if(dflags[5])
                   $display("I8251A (%h) at %d: starting asynchronous receiver",
                                                           instance_id, $time);

                -> break_detect_e;        //     start check for rcd=0 too long
                asyn_receive;             //     and start async mode receiver
            end
        endcase
    end


                /**** EXTERNAL SYNCHRONOUS MODE RECEIVE ****/

    task syn_receive_external;
    forever
    begin
        repeat(databits)   // Whether in hunt mode or not, assemble a character
        begin
            @(posedge rxc_)
            receivebuf={rcd, receivebuf[7:1]};
        end

        get_and_check_parity;    // reveive and check parity bit, if any

        mark_char_received;      // set rxrdy line, if enabled
    end
    endtask

    always @external_syndet_watche
        @(posedge rxc_)
            status[6]=1;

                /**** INTERNAL SYNCHRONOUS MODE RECEIVE ****/


                /* Hunt for the sync char(s)                     */
                /* (if in synchronous internal sync detect mode) */
                /* Syndet is set high when the sync(s) are found */

    always @ hunt_sync1_e      // search for 1st sync char in the data stream
    begin :sync_hunt_blk
        while(!(((receivebuf ^ sync1) & syncmask)===8'b00000000))
        begin
            @(posedge rxc_)
            receivebuf={rcd, receivebuf[7:1]};
        end
        if(modreg[7]==0)       // if double sync mode
            -> hunt_sync2_e;   //     check for 2nd sync char directly after 1st
        else
            -> sync_hunted_e;  // if single sync mode, sync hunt is complete
    end

    always @ hunt_sync2_e // find the second synchronous character
    begin :double_sync_hunt_blk
        repeat(databits)
        begin
            @(posedge rxc_)
            receivebuf={rcd, receivebuf[7:1]};
        end
        if(((receivebuf ^ sync2) & syncmask)===8'b00000000)
            ->sync_hunted_e;   // if sync2 followed syn1, sync hunt is complete
        else
            ->hunt_sync1_e;    // else hunt for sync1 again

        // Note: the data stream [sync1 sync1 sync2] will have sync detected.
        // Suppose sync1=11001100:
        // then [1100 1100 1100 sync2] will NOT be detected.
        // In general: never let a suffix of sync1 also be a prefix of sync1.
    end

    always @ sync_hunted_e
    begin :parity_sync_hunt_blk
        get_and_check_parity;
        status[6]=1;            // set syndet status bit (sync chars detected)
    end

    task syn_receive_internal;
    forever
    begin
        repeat(databits)   // no longer in hunt mode so read entire chars and
        begin              // then look for syncs (instead of on bit boundaries)
            @(posedge rxc_)
            receivebuf={rcd, receivebuf[7:1]};
        end


        case (sync_to_receive)
        2:                                // if looking for 2nd sync char ...
        begin
            if(((receivebuf ^ sync2)
                         & syncmask)===0)
            begin                         // ... and 2nd sync char is found
                sync_to_receive=1;        //    then look for 1st sync (or data)
                status[6]=1;              //         and mark sync detected
            end
            else if(((receivebuf ^ sync1)
                         & syncmask)===0)
            begin                         // ... and 1st sync char is found
                sync_to_receive=2;        //    then look for 2nd sync char
            end
        end
        1:                                // but if looking for 1st or data ...
        begin
            if(((receivebuf ^ sync1)      // ... and 1st sync is found
                         & syncmask)===0)
            begin
                if(modreg[7]==0)          //     if double sync mode
                    sync_to_receive=2;    //         look for 2nd sync to follow
                else                      //     else look for 1st or data
                    status[6]=1;          //          and mark sync detected
            end
            else ;                        // ... and data was found, do nothing
        end
        endcase

        get_and_check_parity;    // reveive and check parity bit, if any

        mark_char_received;
    end
    endtask



    task get_and_check_parity;
    begin
        receivebuf=receivebuf >> (8-databits);
        if (modreg[4]==1)
        begin
            @(posedge rxc_)
            if((^receivebuf ^ modreg[5] ^ rcd) != 1)
                parity_error;
        end
    end
    endtask


    task mark_char_received;
    begin
        if (command[2]==1)       // if receiving is enabled
        begin
            rxrdy=1;
            status[1]=1;         //    set receive ready status bit
            if (rdatain==1)      //    if previous data was not read
                overrun_error;   //        overrun error

            rdata=receivebuf;    //    latch the data
            rdatain=1;           //    mark data as not having been read
        end

        if(dflags[2])
            $display("I8251A (%h) at %d: received data: %b",
                                               instance_id, $time, receivebuf);
    end
    endtask


          /************** ASYNCHRONOUS MODE RECEIVER **************/



                /* Check for break detection (rcd low through 2 */
                /* receive sequences) in the asynchronous mode. */

    always @ break_detect_e
    begin :break_detect_blk
        #1  /* to be sure break_delay_blk is waiting on break_deley_e
               after it triggered break_detect_e  */

        if(rcd==0)
        begin
            -> break_delay_e;//start + databits + parity    + stop bit
            breakcount_period =  1   + databits + modreg[4] + (tstoptotal != 0);

                    // the number of rxc periods needed for 2 receive sequences
            breakcount_period = 2 * breakcount_period * baudmx;

                                  // If rcd stays low through 2 consecutive
                                  // (start,data,parity,stop) sequences ...
            repeat(breakcount_period)
                @(posedge rxc_);
            status[6]=1;          // ... then set break detect (status[6]) high
        end
    end

    always @break_delay_e
    begin : break_delay_blk
        @(posedge rcd)            // but if rcd goes high during that time ...
        begin :break_delay_blk
            disable break_detect_blk;
            status[6]=0;          // ... then set the break detect low
            @(negedge rcd)        //     and when rcd goes low again ...
            -> break_detect_e;    //     ... start the break detection again
        end
    end


                /**** ASYNCHRONOUS MODE RECEIVE TASK ****/

    task asyn_receive;
    forever
        @(negedge rcd) // the receive line went to zero, maybe a start bit 
        begin
            rbaudcnt = baudmx / 2;
            if(baudmx==1)
                rbaudcnt=1;
            repeat(rbaudcnt) @(posedge rxc_); // after half a bit ...

            if (rcd == 0)                     // if it is still a start bit
            begin
                rbaudcnt=baudmx;
                repeat(databits)              //     receive the data bits
                begin
                    repeat(rbaudcnt) @(posedge rxc_);
                    #1 receivebuf= {rcd, receivebuf[7:1]};
                end

                repeat(rbaudcnt) @(posedge rxc_);


                // shift the data to the low part
                receivebuf=receivebuf >> (8-databits);

                if (modreg[4]==1)            // if parity is enabled
                begin
                    if((^receivebuf ^ modreg[5] ^ rcd) != 1)
                        parity_error;        //     check for a parity error

                    repeat(rbaudcnt) @(posedge rxc_);
                end

                #1 if (rcd==0)               // if middle of stop bit is 0
                    frame_error;             //     frame error (should be 1)

                mark_char_received;
            end
        end
    endtask
endmodule