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
[63:0]Mux:
1 - MUXA: para escolher entre somar entre o valor 1 e regA ou valor1 e valor2.
2 - MUXB: outro mux similar, para escolher o que é salvo no regA;
3 - MUXC: Para selecionar entre o valor2 e o valor do subtrator para ser salvo no regB;
4 - MUXFINAL: final, para tratar do caso da multiplicação por zero;
5 - Mais um mux, para tratar do caso em que se multiplica o primeiro valor por outro, que vale 1.
*/

//sumOrMultiplication: 0 para multiplicação, 1 para soma; (economiza 1 not)
module BigALU(
    input [23:0] valor1, valor2,
    input clk,
    input sumOrMultiplication, 
    input [3:0] ALUOp,
    output [23:0] result,
    output endMultiplication,
    input muxA, muxB, muxC, loadRegA, loadRegB
);

    // initial begin
    //     $dumpfile("BigALU.vcd");
    //     $dumpvars(0, BigALU);
    // end

    //wires:
    wire [63:0] resultadoDaSoma;
    wire [63:0] resultadoDaSubtracao;
    wire [63:0] muxAResult, muxBResult, muxCResult, muxFinalResult;
    wire [63:0] regAtoALU, regAtoMux, regBtoSubtractor, subtractorToMux;
    wire [63:0] valor1_64bits, valor2_64bits;
    wire [23:0] checkIfRegBisZero;
    wire [63:0] regBtoChecker;
    wire subtractionIsOne;
    wire regBIsOne;
    //lógica do decisor de resultado zero ou somador.
    wire [63:0] zero;
    wire muxAdderOrZero;
    wire [23:0]checkerFirst, checkerSecond;
    wire firstIsZero, secondIsZero;
    wire ZeroResult;
    //Multiplicação identidade
    wire [63:0] valor1_64bitsParaMuxIdentidade;
    wire multiplicaPorUm;
    wire [63:0] muxIdentidadeResult;
    //lógica para verificar se uma das entradas é zero.
    assign zero = 64'b0;
    assign checkerFirst = valor1;
    assign checkerSecond = valor2;
    assign muxAdderOrZero = ZeroResult;

    //Zero result = 0 caso o valor 1 ou o 2 sejam zero e a operação seja de multiplicacao.
    assign firstIsZero = ~(checkerFirst[23] | checkerFirst[22] | checkerFirst[21] | checkerFirst[20] | checkerFirst[19] | checkerFirst[18] | checkerFirst[17] | checkerFirst[16] | 
                checkerFirst[15] | checkerFirst[14] | checkerFirst[13] | checkerFirst[12] | checkerFirst[11] | checkerFirst[10] | checkerFirst[9] | checkerFirst[8] | checkerFirst[7] | checkerFirst[6] | checkerFirst[5] | checkerFirst[4]
    | checkerFirst[3] | checkerFirst[2] | checkerFirst[1] | checkerFirst[0] | sumOrMultiplication);

    assign secondIsZero = ~(checkerSecond[23] | checkerSecond[22] | checkerSecond[21] | checkerSecond[20] | checkerSecond[19] | checkerSecond[18] | checkerSecond[17] | checkerSecond[16] | 
                checkerSecond[15] | checkerSecond[14] | checkerSecond[13] | checkerSecond[12] | checkerSecond[11] | checkerSecond[10] | checkerSecond[9] | checkerSecond[8] | checkerSecond[7] | checkerSecond[6] | checkerSecond[5] | checkerSecond[4]
    | checkerSecond[3] | checkerSecond[2] | checkerSecond[1] | checkerSecond[0] | sumOrMultiplication);
    
    or(ZeroResult, firstIsZero, secondIsZero);
    
    //Identificar que o segundo vale 1;
    assign multiplicaPorUm = ~(checkerSecond[23] | checkerSecond[22] | checkerSecond[21] | checkerSecond[20] | checkerSecond[19] | checkerSecond[18] | checkerSecond[17] | checkerSecond[16] | 
                checkerSecond[15] | checkerSecond[14] | checkerSecond[13] | checkerSecond[12] | checkerSecond[11] | checkerSecond[10] | checkerSecond[9] | checkerSecond[8] |checkerSecond[7] | checkerSecond[6] | checkerSecond[5] | checkerSecond[4]
    | checkerSecond[3] | checkerSecond[2] | checkerSecond[1] | ~checkerSecond[0] | sumOrMultiplication);

    //preencher de zeros antes de somar ou subtrair
    assign valor1_64bits[23:0] = valor1;
    assign valor2_64bits[23:0] = valor2;
    assign valor1_64bits[63:24] = 39'b0;
    assign valor2_64bits[63:24] = 39'b0;
    
    assign valor1_64bitsParaMuxIdentidade = valor1_64bits;
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
    
    //muxFinal: o resultado será a saída do somador ou o zero, a depender das entradas 1 e 2.
    mux_2x1_64bit muxIdentidade (.A(resultadoDaSoma), .B(valor1_64bitsParaMuxIdentidade), 
                         .S(multiplicaPorUm), .X(muxIdentidadeResult));
    
    //muxFinal: o resultado será a saída do somador ou o zero, a depender das entradas 1 e 2.
    mux_2x1_64bit muxFinal (.A(muxIdentidadeResult), .B(zero), 
                         .S(ZeroResult), .X(muxFinalResult));

    //Instanciação dos somadores e demais coisas: 
    ALU adder (.A(valor1_64bits), .B(muxAResult), .ALUOp(ALUOp), 
               .result(resultadoDaSoma));
                  
    ALU subtractor (.A(regBtoSubtractor), .B(64'b1), .ALUOp(4'b0011), .result(resultadoDaSubtracao));
    
    assign regAtoMux = regAtoALU;
    assign subtractorToMux = resultadoDaSubtracao;

    //Salva o valor 1 ou o valor incrementado.
    reg_parametrizado_64b regA (.clk(clk), .load(loadRegA), .in_data(muxBResult), 
                                   .out_data(regAtoALU));

    reg_parametrizado_64b regB (.clk(clk), .load(loadRegB), .in_data(muxCResult), 
                                   .out_data(regBtoSubtractor));
    //logica de checagem se o regB vale zero, finalizando a multiplicacao com uma flag
    assign checkIfRegBisZero = resultadoDaSubtracao[23:0];
    assign regBtoChecker = regBtoSubtractor;

    assign regBIsOne = ~(regBtoChecker[23] | regBtoChecker[22] | regBtoChecker[21] | regBtoChecker[20] | regBtoChecker[19] | regBtoChecker[18] | regBtoChecker[17] | regBtoChecker[16] | 
                regBtoChecker[15] | regBtoChecker[14] | regBtoChecker[13] | regBtoChecker[12] | regBtoChecker[11] | regBtoChecker[10] | regBtoChecker[9] | regBtoChecker[8] | 
                regBtoChecker[7] | regBtoChecker[6] | regBtoChecker[5] | regBtoChecker[4] | regBtoChecker[3] | regBtoChecker[2] | regBtoChecker[1] | ~regBtoChecker[0] | ~multiplicaPorUm);
    assign subtractionIsOne = ~(checkIfRegBisZero[23] | checkIfRegBisZero[22] | checkIfRegBisZero[21] | checkIfRegBisZero[20] | checkIfRegBisZero[19] | checkIfRegBisZero[18] | checkIfRegBisZero[17] | checkIfRegBisZero[16] | 
                checkIfRegBisZero[15] | checkIfRegBisZero[14] | checkIfRegBisZero[13] | checkIfRegBisZero[12] | checkIfRegBisZero[11] | checkIfRegBisZero[10] | checkIfRegBisZero[9] | checkIfRegBisZero[8] | 
                checkIfRegBisZero[7] | checkIfRegBisZero[6] | checkIfRegBisZero[5] | checkIfRegBisZero[4] | checkIfRegBisZero[3] | checkIfRegBisZero[2] | checkIfRegBisZero[1] | ~checkIfRegBisZero[0]);
    
    assign endMultiplication = (regBIsOne | subtractionIsOne);

    assign result = muxFinalResult[23:0];//MUDAR para resultado do muxFinal

endmodule