/*
A BigALU deverá realizar duas operações dependendo dos sinais recebidos:
1 - SOMA: soma simples entre os valores recebidos no registrador 1 e 2;
2 - MULTIPLICAÇÃO: soma entre o valor do registrador 1 e a entrada respectiva a tal valor,
decréscimo simultâneo do valor do registrador 2 em uma unidade. 

Módulos necessários:
*Levar em consideração que a ALU opera com entradas de 64bits.
ALU - para as operações matemáticas;
MinorALU - para retirar 1 do valor salvo no registrador 2; 
[63:0]Registrador1 e 2 -> recebe os valores das mantissas a serem somadas ou multiplicadas.
[63:0]Mux: para escolher entre somar entre o valor 1 e regA ou valor1 e valor2.
E outro mux similar, para escolher o que é salvo no regA;
Mais um Mux, para selecionar entre o valor2 e o valor do subtrator para ser salvo no regB;

*/


module BigALU(
    input [22:0] valor1, valor2,
    input clk,
    output [22:0] result,
    output endMultiplication,
    input muxA, muxB, muxC, loadRegA, loadRegB
);

    initial begin
        $dumpfile("BigALU.vcd");
        $dumpvars(0, BigALU);
    end
    //wires:
    wire [63:0] resultadoDaSoma;
    wire [63:0] resultadoDaSubtracao;
    wire [63:0] muxAResult, muxBResult, muxCResult;
    wire [63:0] regAtoALU, regAtoMux, regBtoMuxC, regBtoSubtractor, subtractorToMux;
    wire [63:0] valor1_64bits, valor2_64bits;
    wire [23:0] checkIfZero;
    //preencher de zeros antes de somar ou subtrair
    assign valor1_64bits[22:0] = valor1;
    assign valor2_64bits[22:0] = valor2;
    assign valor1_64bits[63:23] = 40'b0;
    assign valor2_64bits[63:23] = 40'b0;
    
    //MULTIPLICACAO:
    //Salva os valores1 e 2 recebidos em reg1 e reg2, respectivamente;
    //Soma o valor 1 ao valor do registrador 1
    //Decresce o valor 2 em uma unidade.

    //SOMA:
    //Soma o primeiro valor recebido com o segundo valor recebido, fim.

    mux_2x1_64bit muxA1 (.A(regAtoMux), .B(valor2_64bits), 
                         .S(muxA), .X(muxAResult));
    //muxB: primeiro ciclo: salva o valor1_64bits, segundo ciclo: salva o resultado da Soma.
    mux_2x1_64bit muxB1 (.A(valor1_64bits), .B(resultadoDaSoma), 
                         .S(muxB), .X(muxBResult));
    //muxC: primeiro ciclo: escolhe o valor2_64bits, segundo: escolhe a saída do subtrator
    mux_2x1_64bit muxC1 (.A(valor2_64bits), .B(subtractorToMux), 
                         .S(muxC), .X(muxCResult));

    ALU adder (.A(valor1_64bits), .B(muxAResult), .ALUOp(4'b0000), 
                  .result(resultadoDaSoma));
                  
    ALU subtractor (.A(regBtoSubtractor), .B(64'b1), .ALUOp(4'b0011), .result(resultadoDaSubtracao));
    
    assign regAtoMux = regAtoALU;
    assign subtractorToMux = resultadoDaSubtracao;

    //Salva o valor 1 ou o valor incrementado.
    reg_parametrizado_64b regA (.clk(clk), .load(loadRegA), .in_data(muxBResult), 
                                   .out_data(regAtoALU));

    reg_parametrizado_64b regB (.clk(clk), .load(loadRegB), .in_data(muxCResult), 
                                   .out_data(regBtoSubtractor));
    
    assign checkIfZero = resultadoDaSubtracao[22:0];

    assign endMultiplication = (checkIfZero[22] & checkIfZero[21] & checkIfZero[20] & checkIfZero[19] & checkIfZero[18] & checkIfZero[17] & checkIfZero[16] & 
                checkIfZero[15] & checkIfZero[14] & checkIfZero[13] & checkIfZero[12] & checkIfZero[11] & checkIfZero[10] & checkIfZero[9] & checkIfZero[8] & 
                checkIfZero[7] & checkIfZero[6] & checkIfZero[5] & checkIfZero[4] & checkIfZero[3] & checkIfZero[2] & checkIfZero[1] & checkIfZero[0]);
    
    assign result = resultadoDaSoma[22:0];

endmodule