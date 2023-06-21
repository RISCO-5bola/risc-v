`timescale 1ns/1ns

module testbench ();

    reg [23:0] valor1, valor2;
    reg clk;
    reg [3:0] ALUOp;
    wire [23:0] result;
    wire endMultiplication;
    reg muxA, muxB, muxC, sumOrMultiplication, loadRegA, loadRegB;

    BigALU UUT (.clk(clk),.ALUOp(ALUOp),.sumOrMultiplication(sumOrMultiplication), .muxA(muxA), .muxB(muxB), .muxC(muxC), .valor1(valor1), .valor2(valor2),
                  .result(result), .loadRegA(loadRegA), .loadRegB(loadRegB), .endMultiplication(endMultiplication));

    integer i, errors = 0;
    task Check;
        input [23:0] expect;
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
        valor1 = 24'd20;
        valor2 = 24'd5;
        muxA = 0;
        muxB = 0;
        muxC = 0;
        sumOrMultiplication = 0;
        loadRegA = 1;
        loadRegB = 1;
        ALUOp = 4'b0000;
        #10
        Check(24'd40);
        Check2(1'b0);

        valor1 = 24'd20;
        valor2 = 24'd5;
        muxA = 0;
        muxB = 1;
        muxC = 1;
        sumOrMultiplication = 0;
        loadRegA = 1;
        loadRegB = 1;
        ALUOp = 4'b0000;
        #10
        Check(24'd60);
        Check2(1'b0);
        
        valor1 = 24'd20;
        valor2 = 24'd5;
        muxA = 0;
        muxB = 1;
        muxC = 1;
        sumOrMultiplication = 0;
        loadRegA = 1;
        loadRegB = 1;
        ALUOp = 4'b0000;
        #10
        Check(24'd80);
        Check2(1'b0);
        
        valor1 = 24'd20;
        valor2 = 24'd5;
        muxA = 0;
        muxB = 1;
        muxC = 1;
        sumOrMultiplication = 0;
        loadRegA = 1;
        loadRegB = 1;
        ALUOp = 4'b0000;
        #10
        Check(24'd100);
        Check2(1'b1);

        valor1 = 24'd20;
        valor2 = 24'd5;
        muxA = 0;
        muxB = 1;
        muxC = 1;
        sumOrMultiplication = 0;
        loadRegA = 0;
        loadRegB = 1;
        ALUOp = 4'b0000;
        #10
        Check(24'd100);
        Check2(1'b0);
        //TESTE2 = Checar se a multiplicação por zero devolve zero
        valor1 = 24'd20;
        valor2 = 24'd0;
        muxA = 0;
        muxB = 1;
        muxC = 1;
        sumOrMultiplication = 0;
        loadRegA = 1;
        loadRegB = 1;
        ALUOp = 4'b0000;
        #10
        Check(24'd0);
        Check2(1'b0); 
        //TESTE3: Checar se a soma entre valores normais, maiores que zero, funcionam adequadamente.
        valor1 = 24'd20;
        valor2 = 24'd10;
        muxA = 1;
        muxB = 0;
        muxC = 1;
        sumOrMultiplication = 1;
        loadRegA = 1;
        loadRegB = 1;
        ALUOp = 4'b0000;
        #10 
        Check(24'd30);
        Check2(1'b0);

        //Teste4: checar se a multiplicação por 1 funciona

        valor1 = 24'd40;
        valor2 = 24'd1;
        muxA = 0;
        muxB = 0;
        muxC = 0;
        sumOrMultiplication = 0;
        loadRegA = 1;
        loadRegB = 1;
        ALUOp = 4'b0000;
        #10
        Check(24'd40);
        Check2(1'b1);
        #20

        $display("Test finished. Erros: %d", errors);
        $finish;
    end
endmodule