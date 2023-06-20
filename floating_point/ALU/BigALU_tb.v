`timescale 1ns/1ns

module testbench ();

    reg [22:0] valor1, valor2;
    reg clk;
    wire [22:0] result;
    wire endMultiplication;
    reg muxA, muxB, muxC, loadRegA, loadRegB;

    BigALU UUT (.clk(clk), .muxA(muxA), .muxB(muxB), .muxC(muxC), .valor1(valor1), .valor2(valor2),
                  .result(result), .loadRegA(loadRegA), .loadRegB(loadRegB), .endMultiplication(endMultiplication));

    integer i, errors = 0;
    task Check;
        input [22:0] expect;
        if (result !== expect) begin
                $display ("Error : A: %d B: %d expect: %d got: %d", valor1, valor2, expect, result);
                errors = errors + 1;
        end
    endtask
        task Check2;
        input expect2;
        if (endMultiplication !== expect2) begin
                $display("endMultiplication: %b", endMultiplication);
                errors = errors + 1;
        end

    endtask

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        #10
        valor1 = 23'd20;
        valor2 = 23'd5;
        muxA = 0;
        muxB = 0;
        muxC = 0;
        loadRegA = 1;
        loadRegB = 1;
        #10
        Check(22'd40);
        Check2(1'b0);

        valor1 = 23'd20;
        valor2 = 23'd5;
        muxA = 0;
        muxB = 1;
        muxC = 1;
        loadRegA = 1;
        loadRegB = 1;
        #10
        Check(22'd60);
        Check2(1'b0);
        
        valor1 = 23'd20;
        valor2 = 23'd5;
        muxA = 0;
        muxB = 1;
        muxC = 1;
        loadRegA = 1;
        loadRegB = 1;
        #10
        Check(22'd80);
        Check2(1'b0);
        
        valor1 = 23'd20;
        valor2 = 23'd5;
        muxA = 0;
        muxB = 1;
        muxC = 1;
        loadRegA = 1;
        loadRegB = 1;
        #10
        Check(22'd100);
        Check2(1'b1);

        valor1 = 23'd20;
        valor2 = 23'd5;
        muxA = 0;
        muxB = 1;
        muxC = 1;
        loadRegA = 0;
        loadRegB = 1;
        #10
        Check(22'd100);
        Check2(1'b0);
        #50

        $display("Test finished. Erros: %d", errors);
        $finish;
    end
endmodule