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

    initial begin
        // Teste state 0
        state[3:0] = 4'b00_00;
        #5
        $display("Test #0");
        Check1({state[3:0], 4'b00_00});
        Check1({ns[3:0], 4'b00_01});
        #5
        
        // Teste tipo-J
        state[3:0] = 4'b00_01;
        op[6:0] = 7'b1101111;
        #5
        $display("Test #1");
        Check1({state[3:0], 4'b00_01});
        Check2({op[6:0], 7'b1101111});
        Check1({ns[3:0], 4'b10_01});
        #5

        // Teste tipo-B
        state[3:0] = 4'b00_01;
        op[6:0] = 7'b1100011;
        #5
        $display("Test #2");
        Check1({state[3:0], 4'b00_01});
        Check2({op[6:0], 7'b1100011});
        Check1({ns[3:0], 4'b10_00});
        #5

        // Teste tipo-R
        state[3:0] = 4'b00_01;
        op[6:0] = 7'b0110011;
        #5
        $display("Test #3");
        Check1({state[3:0], 4'b00_01});
        Check2({op[6:0], 7'b0110011});
        Check1({ns[3:0], 4'b01_10});
        #5

        // Teste tipo-sw
        state[3:0] = 4'b00_10;
        op[6:0] = 7'b0100011;
        #5
        $display("Test #4");
        Check1({state[3:0], 4'b00_10});
        Check2({op[6:0], 7'b0100011});
        Check1({ns[3:0], 4'b01_01});
        #5

        // Teste state 3
        state[3:0] = 4'b00_11;
        #5
        $display("Test #5");
        Check1({state[3:0], 4'b00_11});
        Check1({ns[3:0], 4'b01_00});
        #5
        
        // Teste state 6
        state[3:0] = 4'b01_10;
        #5
        $display("Test #6");
        Check1({state[3:0], 4'b01_10});
        Check1({ns[3:0], 4'b01_11});
        #5

        // Teste tipo-lw
        state[3:0] = 4'b00_01;
        op[6:0] = 7'b0000011;
        #5
        $display("Test #7");
        Check1({state[3:0], 4'b00_01});
        Check2({op[6:0], 7'b0000011});
        Check1({ns[3:0], 4'b00_10});
        #5

        // Teste tipo-sw
        state[3:0] = 4'b00_01;
        op[6:0] = 7'b0100011;
        #5
        $display("Test #8");
        Check1({state[3:0], 4'b00_01});
        Check2({op[6:0], 7'b0100011});
        Check1({ns[3:0], 4'b00_10});
        #5

        // Teste tipo-lw
        state[3:0] = 4'b00_10;
        op[6:0] = 7'b0000011;
        #5
        $display("Test #9");
        Check1({state[3:0], 4'b00_10});
        Check2({op[6:0], 7'b0000011});
        Check1({ns[3:0], 4'b00_11});
        #5

        // Teste tipo-j
        state[3:0] = 4'b10_01;
        op[6:0] = 7'b1101111;
        #5
        $display("Test #10");
        Check1({state[3:0], 4'b10_01});
        Check2({op[6:0], 7'b1101111});
        Check1({ns[3:0], 4'b10_10});
        #5

        // Teste tipo-I-Jalr
        state[3:0] = 4'b10_01;
        op[6:0] = 7'b1100111;
        #5
        $display("Test #11");
        Check1({state[3:0], 4'b10_01});
        Check2({op[6:0], 7'b1100111});
        Check1({ns[3:0], 4'b11_00});
        #5

        // Teste tipo-U-AUIPC
        state[3:0] = 4'b00_01;
        op[6:0] = 7'b0010111;
        #5
        $display("Test #12");
        Check1({state[3:0], 4'b00_01});
        Check2({op[6:0], 7'b0010111});
        Check1({ns[3:0], 4'b10_11});
        #5

        // Teste tipo-I-Jalr
        state[3:0] = 4'b00_01;
        op[6:0] = 7'b1100111;
        #5
        $display("Test #13");
        Check1({state[3:0], 4'b00_01});
        Check2({op[6:0], 7'b1100111});
        Check1({ns[3:0], 4'b10_01});
        #5

        $display ("\nErrors: %d", errors);
        $finish;
    end
endmodule