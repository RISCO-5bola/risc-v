module next_state_tb ();
    reg [6:0] op;
    reg [3:0] state;
    wire [3:0] ns;
    
    integer errors = 0;

    task Check1;
        input [7:0] expect;
        
        if (expect[7:4] !== expect[3:0]) begin
            $display("Got %b, expected %b (State or ns error)", expect[7:4], expect[3:0]);
            errors = errors + 1;
        end
    endtask

    task Check2;
        input [13:0] expect;
        
        if (expect[13:7] !== expect[6:0]) begin
            $display("Got %b, expected %b (Op/ns code error)", expect[11:6], expect[5:0]);
            errors = errors + 1;
        end
    endtask

    next_state UUT (.op(op), .state(state), .ns(ns));

    /* cada teste abaixo representa um wire diferente 
       do next_state.v e a ordem esta a mesma*/

    initial begin

        /* tipo jal current state 1 para next state 9*/
        state[3:0] = 4'b00_01;
        op[6:0] = 7'b1101111;
        #5
        $display("Test wire0");
        Check1({state[3:0], 4'b00_01});
        Check2({op[6:0], 7'b1101111});
        Check1({ns[3:0], 4'b10_01});
        #5

        /* tipo b current state 1 para next state 8*/
        state[3:0] = 4'b00_01;
        op[6:0] = 7'b1100011;
        #5
        $display("Test wire1");
        Check1({state[3:0], 4'b00_01});
        Check2({op[6:0], 7'b1100011});
        Check1({ns[3:0], 4'b10_00});
        #5

        /* tipo b current state 8 para next state 14*/
        state[3:0] = 4'b10_00;
        op[6:0] = 7'b1100011;
        #5
        $display("Test wire17");
        Check1({state[3:0], 4'b10_00});
        Check2({op[6:0], 7'b1100011});
        Check1({ns[3:0], 4'b11_10});
        #5

        /* tipo r current state 1 para next state 6*/
        state[3:0] = 4'b00_01;
        op[6:0] = 7'b011x011;
        #5
        $display("Test wire2");
        Check1({state[3:0], 4'b00_01});
        Check2({op[6:0], 7'b011x011});
        Check1({ns[3:0], 4'b01_10});
        #5

        /* tipo sw current state 2 para next state 5*/
        state[3:0] = 4'b00_10;
        op[6:0] = 7'b0100011;
        #5
        $display("Test wire3");
        Check1({state[3:0], 4'b00_10});
        Check2({op[6:0], 7'b0100011});
        Check1({ns[3:0], 4'b01_01});
        #5

        /* current state 3 para next state 4*/
        state[3:0] = 4'b00_11;
        #5
        $display("Test wire4");
        Check1({state[3:0], 4'b00_11});
        Check1({ns[3:0], 4'b01_00});
        #5
        
        /* current state 6 para next state 7*/
        state[3:0] = 4'b01_10;
        #5
        $display("Test wire5");
        Check1({state[3:0], 4'b01_10});
        Check1({ns[3:0], 4'b01_11});
        #5

        /* tipo lw current state 1 para next state 2 */
        state[3:0] = 4'b00_01;
        op[6:0] = 7'b0000011;
        #5
        $display("Test wire6");
        Check1({state[3:0], 4'b00_01});
        Check2({op[6:0], 7'b0000011});
        Check1({ns[3:0], 4'b00_10});
        #5

        /* tipo sw current state 1 para next state 2 */
        state[3:0] = 4'b00_01;
        op[6:0] = 7'b0100011;
        #5
        $display("Test wire7");
        Check1({state[3:0], 4'b00_01});
        Check2({op[6:0], 7'b0100011});
        Check1({ns[3:0], 4'b00_10});
        #5

        /* tipo lw current state 2 para next state 3 */
        state[3:0] = 4'b00_10;
        op[6:0] = 7'b0000011;
        #5
        $display("Test wire8");
        Check1({state[3:0], 4'b00_10});
        Check2({op[6:0], 7'b0000011});
        Check1({ns[3:0], 4'b00_11});
        #5

        /* current state 0 para next state 1 */
        state[3:0] = 4'b00_00;
        #5
        $display("Test wire9");
        Check1({state[3:0], 4'b00_00});
        Check1({ns[3:0], 4'b00_01});
        #5

        /* tipo jal current state 9 para next state 10 */
        state[3:0] = 4'b10_01;
        op[6:0] = 7'b1101111;
        #5
        $display("Test wire10");
        Check1({state[3:0], 4'b10_01});
        Check2({op[6:0], 7'b1101111});
        Check1({ns[3:0], 4'b10_10});
        #5

        /* tipo I-Jalr current state 9 para next state 12 */
        state[3:0] = 4'b10_01;
        op[6:0] = 7'b1100111;
        #5
        $display("Test wire11");
        Check1({state[3:0], 4'b10_01});
        Check2({op[6:0], 7'b1100111});
        Check1({ns[3:0], 4'b11_00});
        #5

        /* tipo U-AUIPC current state 1 para next state 11 */
        state[3:0] = 4'b00_01;
        op[6:0] = 7'b0010111;
        #5
        $display("Test wire12");
        Check1({state[3:0], 4'b00_01});
        Check2({op[6:0], 7'b0010111});
        Check1({ns[3:0], 4'b10_11});
        #5

        /* tipo I-Jalr current state 1 para next state 9*/
        state[3:0] = 4'b00_01;
        op[6:0] = 7'b1100111;
        #5
        $display("Test wire13");
        Check1({state[3:0], 4'b00_01});
        Check2({op[6:0], 7'b1100111});
        Check1({ns[3:0], 4'b10_01});
        #5

        /* tipo I-addi current state 1 para next state 13 */
        state[3:0] = 4'b00_01;
        op[6:0] = 7'b001x011;
        #5
        $display("Test wire14");
        Check1({state[3:0], 4'b00_01});
        Check2({op[6:0], 7'b001x011});
        Check1({ns[3:0], 4'b11_01});
        #5

        /* tipo I-addi current sate 13 para next state 7 */
        state[3:0] = 4'b11_01;
        op[6:0] = 7'b001x011;
        #5
        $display("Test wire15");
        Check1({state[3:0], 4'b11_01});
        Check2({op[6:0], 7'b001x011});
        Check1({ns[3:0], 4'b01_11});
        #5

        /* tipo U-AUIPC current state 11 para next state 7 */
        state[3:0] = 4'b10_11;
        op[6:0] = 7'b0010111;
        #5
        $display("Test wire16");
        Check1({state[3:0], 4'b10_11});
        Check2({op[6:0], 7'b0010111});
        Check1({ns[3:0], 4'b01_11});
        #5

        /* tipo U-LUI  current state 1 para next state 15 */
        state[3:0] = 4'b00_01;
        op[6:0] = 7'b0110111;
        #5
        $display("Test wire18");
        Check1({state[3:0], 4'b00_01});
        Check2({op[6:0], 7'b0110111});
        Check1({ns[3:0], 4'b11_11});
        #5

        /* tipo U-LUI  current state 15 para next state 7 0010111*/
        state[3:0] = 4'b11_11;
        op[6:0] = 7'b0110111;
        #5
        $display("Test wire19");
        Check1({state[3:0], 4'b11_11});
        Check2({op[6:0], 7'b0110111});
        Check1({ns[3:0], 4'b01_11});
        #5


        $display ("\nErrors: %d", errors);
        $finish;
    end
endmodule