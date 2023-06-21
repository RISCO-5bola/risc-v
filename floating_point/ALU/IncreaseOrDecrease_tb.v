`timescale 1ns/1ns

module IncreaseOrDecrease_tb ();
    reg [7:0] valor1;
    reg clk;
    wire [7:0] result;
    reg [3:0] ALUOp; //0000 para soma, 0011 para subtração


    IncreaseOrDecrease UUT (.clk(clk), .ALUOp(ALUOp), .result(result), .valor1(valor1));

    integer i, errors = 0;
    task Check;
        input [7:0] expect;
        if (result !== expect) begin
                $display ("Error : A: %b expect: %b got: %b", valor1, expect, result);
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
        ALUOp = 4'b0000;
        #10
        Check(8'd121);
        #10
        valor1 = 8'd120;
        ALUOp = 4'b0011;
        #10
        Check(8'd119);
        $display("Test finished. Erros: %d", errors);
        $finish;
    end
endmodule