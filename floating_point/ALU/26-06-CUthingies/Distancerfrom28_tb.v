`timescale 1ns/1ns

module Distancerfrom28_tb ();

    reg signed [63:0] doubleWord;
    wire signed [63:0] distance;

    Distancerfrom28 UUT(.doubleWord(doubleWord), .distance(distance));

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
        $display("first test: distance is +7");
        doubleWord = 64'b00000000_00000000_00000000_0000_1_000_000_1_0000_00000000_00000000_00000000;
        #10
        Check(64'd7);
        #10
        //Second: -dist neg only
        $display("Second test: distance is -5");
        doubleWord = 64'b00000000_00000000_00000000_00000000_000_0_0000_1_0000000_00000000_00000000;
        #10
        Check(64'b1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1011);
        #10
        //THIRD: 0 distance
        $display("Third test: distance is 0");
        doubleWord = 64'b00000000_00000000_00000000_00000000_000_1_1111_1_0000000_00000000_00000000;
        #10
        Check(64'b0);

        //THIRD: 0 distance
        $display("Fourth test: distance is 3");
        doubleWord = 64'b00000000_00000000_00000000_00000000_100_1_1111_1_0000000_00000000_00000000;
        #10
        Check(64'd3);
        #10
        $display("Test finished. Erros: %d", errors);
        $finish;
    end
endmodule