`timescale 1ns/1ns

module Distancer_tb ();

    reg signed [63:0] doubleWord;
    wire signed [63:0] distance;

    Distancer UUT(.doubleWord(doubleWord), .distance(distance));

    integer i, errors = 0;
    task Check;

        input [63:0] expect;
        if (distance !== expect) begin
                $display ("Error : A: %b expect: %d got: %d", doubleWord, expect, distance);
                errors = errors + 1;
        end
    endtask

    initial begin
        #10
        //First: dist positive only
        $display("first test: distance is +5");
        doubleWord = 64'b00000000_00000000_00000000_00000001_0000_1_000_00000000_00000000_00000000;
        #10
        Check(64'd5);
        #10
        //Second: -dist neg only
        $display("Second test: distance is -5");
        doubleWord = 64'b00000000_00000000_00000000_00000000_0000_1_000_01000000_00000000_00000000;
        #10
        Check(64'b1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1011);
        #10
        
        $display("Test finished. Erros: %d", errors);
        $finish;
    end
endmodule