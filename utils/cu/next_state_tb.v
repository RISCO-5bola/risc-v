module next_state_tb ();
    reg [5:0] op;
    reg s3, s2, s1, s0;
    wire ns3, ns2, ns1, ns0;
    
    integer errors;

    task Check1;
        input [7:0] expect;
        
        if (expect[7:4] !== expect[3:0]) begin
            $display("Got %b, expected %b (State error)", expect[7:4], expect[3:0]);
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

    next_state UUT (.op(op), .s3(s3), .s2(s2), .s1(s1), .s0(s0), 
                .ns3(ns3), .ns2(ns2), .ns1(ns1), .ns0(ns0));

    initial begin
        s3 = 0; s2 = 0; s1 = 0; s0 = 0;
        #5
        $display("Test #0");
        Check1({s3, s2, s1, s0, 4'b00_00});
        Check1({ns3, ns2, ns1, ns0, 4'b00_01});
        #5

        s3 = 0; s2 = 0; s1 = 0; s0 = 1;
        op[5] = 0; op[4] = 0; op[3] = 0; op[2] = 0; op[1] = 1; op[0] = 0;
        #5
        $display("Test #1");
        Check1({s3, s2, s1, s0, 4'b00_01});
        Check2({op[5], op[4], op[3], op[2], op[1], op[0], 6'b000_010});
        Check1({ns3, ns2, ns1, ns0, 4'b10_01});
        #5

        s3 = 0; s2 = 0; s1 = 0; s0 = 1;
        op[5] = 0; op[4] = 0; op[3] = 0; op[2] = 1; op[1] = 0; op[0] = 0;
        #5
        $display("Test #2");
        Check1({s3, s2, s1, s0, 4'b00_01});
        Check2({op[5], op[4], op[3], op[2], op[1], op[0], 6'b000_100});
        Check1({ns3, ns2, ns1, ns0, 4'b10_00});
        #5

        s3 = 0; s2 = 0; s1 = 0; s0 = 1;
        op[5] = 0; op[4] = 0; op[3] = 0; op[2] = 0; op[1] = 0; op[0] = 0;
        #5
        $display("Test #3");
        Check1({s3, s2, s1, s0, 4'b00_01});
        Check2({op[5], op[4], op[3], op[2], op[1], op[0], 6'b000_000});
        Check1({ns3, ns2, ns1, ns0, 4'b01_10});
        #5

        s3 = 0; s2 = 0; s1 = 1; s0 = 0;
        op[5] = 1; op[4] = 0; op[3] = 1; op[2] = 0; op[1] = 1; op[0] = 1;
        #5
        $display("Test #4");
        Check1({s3, s2, s1, s0, 4'b00_10});
        Check2({op[5], op[4], op[3], op[2], op[1], op[0], 6'b101_011});
        Check1({ns3, ns2, ns1, ns0, 4'b01_01});
        #5

        s3 = 0; s2 = 0; s1 = 1; s0 = 1;
        #5
        $display("Test #5");
        Check1({s3, s2, s1, s0, 4'b00_11});
        Check1({ns3, ns2, ns1, ns0, 4'b01_00});
        #5

        s3 = 0; s2 = 1; s1 = 1; s0 = 0;
        #5
        $display("Test #6");
        Check1({s3, s2, s1, s0, 4'b01_10});
        Check1({ns3, ns2, ns1, ns0, 4'b01_11});
        #5

        s3 = 0; s2 = 0; s1 = 0; s0 = 1;
        op[5] = 1; op[4] = 0; op[3] = 0; op[2] = 0; op[1] = 1; op[0] = 1;
        #5
        $display("Test #7");
        Check1({s3, s2, s1, s0, 4'b00_01});
        Check2({op[5], op[4], op[3], op[2], op[1], op[0], 6'b100_011});
        Check1({ns3, ns2, ns1, ns0, 4'b00_10});
        #5

        s3 = 0; s2 = 0; s1 = 0; s0 = 1;
        op[5] = 1; op[4] = 0; op[3] = 1; op[2] = 0; op[1] = 1; op[0] = 1;
        #5
        $display("Test #8");
        Check1({s3, s2, s1, s0, 4'b00_01});
        Check2({op[5], op[4], op[3], op[2], op[1], op[0], 6'b101_011});
        Check1({ns3, ns2, ns1, ns0, 4'b00_10});
        #5

        s3 = 0; s2 = 0; s1 = 1; s0 = 0;
        op[5] = 1; op[4] = 0; op[3] = 0; op[2] = 0; op[1] = 1; op[0] = 1;
        #5
        $display("Test #9");
        Check1({s3, s2, s1, s0, 4'b00_10});
        Check2({op[5], op[4], op[3], op[2], op[1], op[0], 6'b100_011});
        Check1({ns3, ns2, ns1, ns0, 4'b00_11});
        #5

        $finish;
    end
endmodule