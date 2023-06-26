`timescale 1ns/1ps

module TwosComplementToInt_tb ();

    reg signed [63:0] TwosComplementValue;
    wire [63:0] result;

    TwosComplementToInt UUT(.TwosComplementValue(TwosComplementValue), .result(result));

    integer i, errors = 0;
    task Check;

        input [63:0] expect;
        if (result !== expect) begin
                $display ("Error : A: %b B: %b expect: %b got: %b", TwosComplementValue, expect, result);
                errors = errors + 1;
        end
    endtask

    initial begin
        #10
        //First: +200 -> +200
        $display("first test: +200 -> +200");
        TwosComplementValue = 64'd200;
        #10
        Check(64'd200);
        #10
        //Second: -200 -> Twos00
        $display("Second test: -200 -> +200");
        TwosComplementValue = -64'd200;
        #10
        Check(64'd200);
        #10
        //Second: 0 -> 0
        $display("Third test: 0 -> 0");
        TwosComplementValue = -64'd0;
        #10
        Check(64'd0);
        #10
        //Second: -205 -> +205
        $display("Fourth test: -205 -> +205");
        TwosComplementValue = -64'd0;
        #10
        Check(64'd0);
        #10
        
        $display("Test finished. Erros: %d", errors);
        $finish;
    end
endmodule