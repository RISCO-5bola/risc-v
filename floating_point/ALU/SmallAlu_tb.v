`timescale 1ns/1ps

module testbench ();

    reg [7:0] valor1, valor2;
    reg clk;
    wire [7:0] result;
    reg  muxA, muxB, loadReg;
    reg [3:0] ALUOp;


    SmallAlu UUT (.clk(clk), .muxA(muxA), .muxB(muxB), .valor1(valor1), .valor2(valor2),
                  .ALUOp(ALUOp), .result(result), .loadReg(loadReg));

    integer i, errors = 0;
    task Check;
        input [7:0] expect;
        if (result !== expect) begin
                $display ("Error : A: %b B: %b expect: %b got: %b", valor1, valor2, expect, result);
                errors = errors + 1;
        end
    endtask

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        #10
        valor1 = 8'd120;
        valor2 = 8'd125;
        ALUOp = 4'b0000;
        muxA = 0;
        muxB = 0;
        loadReg = 1;
        #10
        Check(8'd245);
        #10
        ALUOp = 4'b0011;
        muxA = 1;
        muxB = 1;
        loadReg = 1;
        #10
        Check(8'd118);
        $display("Test finished. Erros: %d", errors);
        $finish;
    end
endmodule