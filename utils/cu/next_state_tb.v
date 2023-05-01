module next_state_tb ();
    reg [5:0] op;
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
        input [11:0] expect;
        
        if (expect[11:6] !== expect[5:0]) begin
            $display("Got %b, expected %b (Op code error)", expect[11:6], expect[5:0]);
            errors = errors + 1;
        end
    endtask

    next_state UUT (.op(op), .state(state), .ns(ns));

    initial begin
        state[3:0] = 4'b00_00;
        #5
        $display("Test #0");
        Check1({state[3:0], 4'b00_00});
        Check1({ns[3:0], 4'b00_01});
        #5
        
        state[3:0] = 4'b00_01;
        op[5:0] = 6'b000_010;
        #5
        $display("Test #1");
        Check1({state[3:0], 4'b00_01});
        Check2({op[5:0], 6'b000_010});
        Check1({ns[3:0], 4'b10_01});
        #5

        state[3:0] = 4'b00_01;
        op[5:0] = 6'b000_100;
        #5
        $display("Test #2");
        Check1({state[3:0], 4'b00_01});
        Check2({op[5:0], 6'b000_100});
        Check1({ns[3:0], 4'b10_00});
        #5

        state[3:0] = 4'b00_01;
        op[5:0] = 6'b000_000;
        #5
        $display("Test #3");
        Check1({state[3:0], 4'b00_01});
        Check2({op[5:0], 6'b000_000});
        Check1({ns[3:0], 4'b01_10});
        #5

        state[3:0] = 4'b00_10;
        op[5:0] = 6'b101_011;
        #5
        $display("Test #4");
        Check1({state[3:0], 4'b00_10});
        Check2({op[5:0], 6'b101_011});
        Check1({ns[3:0], 4'b01_01});
        #5

        state[3:0] = 4'b00_11;
        #5
        $display("Test #5");
        Check1({state[3:0], 4'b00_11});
        Check1({ns[3:0], 4'b01_00});
        #5

        state[3:0] = 4'b01_10;
        #5
        $display("Test #6");
        Check1({state[3:0], 4'b01_10});
        Check1({ns[3:0], 4'b01_11});
        #5

        state[3:0] = 4'b00_01;
        op[5:0] = 6'b100_011;
        #5
        $display("Test #7");
        Check1({state[3:0], 4'b00_01});
        Check2({op[5:0], 6'b100_011});
        Check1({ns[3:0], 4'b00_10});
        #5

        state[3:0] = 4'b00_01;
        op[5:0] = 6'b101_011;
        #5
        $display("Test #8");
        Check1({state[3:0], 4'b00_01});
        Check2({op[5:0], 6'b101_011});
        Check1({ns[3:0], 4'b00_10});
        #5

        state[3:0] = 4'b00_10;
        op[5:0] = 6'b100_011;
        #5
        $display("Test #9");
        Check1({state[3:0], 4'b00_10});
        Check2({op[5:0], 6'b100_011});
        Check1({ns[3:0], 4'b00_11});
        #5

        $display ("\nErrors: %d", errors);
        $finish;
    end
endmodule