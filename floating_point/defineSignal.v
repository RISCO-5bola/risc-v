module defineSignal(
    input signed [7:0] exponentDifference,
    input signalFirst, signalSecond,
    input sumOrMultiplication,
    input [22:0] mantissaFirst, mantissaSecond,
    output signalResult
);
    // initial begin
    //         $dumpfile("wave2.vcd");
    //         $dumpvars(0, defineSignal);
    // end
    
    //sinais iguais:
    wire equalSignals;
    assign equalSignals = ((signalFirst & signalSecond)|(~signalFirst & ~signalSecond));
    
    //setar o sinal da multiplicação
    wire multiplicationSignal;
    //assign multiplicationSignal = signalFirst ^ signalSecond;
    xor(multiplicationSignal, signalFirst, signalSecond);

    //ver qual eh o maior expoente: 0 se o primeiro e 1 se o segundo;
    wire secondExponentIsBigger;
    assign secondExponentIsBigger = exponentDifference[7];
    //ver se a diferenca de expoentes é ZERO:
    wire firstExponentAndSecondExponentAreEqual;

    assign firstExponentAndSecondExponentAreEqual = ~(exponentDifference[7] |
    exponentDifference[6] | exponentDifference[5] | exponentDifference[4] |
    exponentDifference[3] | exponentDifference[2] | exponentDifference[1] |
    exponentDifference[0]);

    //logica para a soma:
     /*
     1 - mesmo sinal -> manda o sinal do primeiro,
     2 - sinais diferentes: resultado da seleção a seguir:
       a - xp1 > xp2 -> manda o sinal do primeiro
       b - xp2 > xp1 -> manda o sinal do segundo
     3 - expoentes iguais: mais uma lógica:
       a - m1 > m2 -> manda o sinal do primeiro
       b - m2 > m1 -> manda o sinal do segundo
     4 - sinais diferentes, expoentes iguais, mesma mantissa
     //se é diferente -> mux 02 vai para o 03;
     //se é igual -> 1'b0
     */
     
    //ver qual eh a maior mantissa: 0 se o primeiro e 1 se o segundo o eh;
    wire [63:0] mantissaDifference;
    wire secondMantissaIsBigger;
    ALU mantissaDifferenceGetter(.A({41'b0, mantissaFirst}), .B({41'b0, mantissaSecond}),
    .ALUOp(4'b0011), .result(mantissaDifference));
    //Check if mantissa is EQUAL -> mantissasAreEqual = 1 caso sejam iguais
    wire mantissasAreEqual;
    assign mantissasAreEqual = ~(mantissaDifference[63] | mantissaDifference[62] | mantissaDifference[61] |
                                 mantissaDifference[60] | mantissaDifference[59] | mantissaDifference[58] |
                                 mantissaDifference[57] | mantissaDifference[56] | mantissaDifference[55] |
                                 mantissaDifference[54] | mantissaDifference[53] | mantissaDifference[52] |
                                 mantissaDifference[51] | mantissaDifference[50] | mantissaDifference[49] |
                                 mantissaDifference[48] | mantissaDifference[47] | mantissaDifference[46] |
                                 mantissaDifference[45] | mantissaDifference[44] | mantissaDifference[43] |
                                 mantissaDifference[42] | mantissaDifference[41] | mantissaDifference[40] |
                                 mantissaDifference[39] | mantissaDifference[38] | mantissaDifference[37] |
                                 mantissaDifference[36] | mantissaDifference[35] | mantissaDifference[34] |
                                 mantissaDifference[33] | mantissaDifference[32] | mantissaDifference[31] |
                                 mantissaDifference[30] | mantissaDifference[29] | mantissaDifference[28] |
                                 mantissaDifference[27] | mantissaDifference[26] | mantissaDifference[25] |
                                 mantissaDifference[24] | mantissaDifference[23] | mantissaDifference[22] |
                                 mantissaDifference[21] | mantissaDifference[20] | mantissaDifference[19] |
                                 mantissaDifference[18] | mantissaDifference[17] | mantissaDifference[16] |
                                 mantissaDifference[15] | mantissaDifference[14] | mantissaDifference[13] |
                                 mantissaDifference[12] | mantissaDifference[11] | mantissaDifference[10] |
                                 mantissaDifference[9]  | mantissaDifference[8]  | mantissaDifference[7]  |
                                 mantissaDifference[6]  | mantissaDifference[5]  | mantissaDifference[4]  |
                                 mantissaDifference[3]  | mantissaDifference[2]  | mantissaDifference[1]  |
                                 mantissaDifference[0]);

    assign secondMantissaIsBigger = mantissaDifference[63];

    //cascata de muxes:
    //xp2> xp1?
    wire mux01ToMux03;
    mux_2x1_1bit mux01 (.A(signalFirst), .B(signalSecond), .S(secondExponentIsBigger), .X(mux01ToMux03));

    //m2 > m1?
    wire mux02ToMuxMEqual;
    mux_2x1_1bit mux02 (.A(signalFirst), .B(signalSecond), .S(secondMantissaIsBigger), .X(mux02ToMuxMEqual));

    wire mux02ifMantissaNotEqual;
    mux_2x1_1bit muxMEqual(.A(mux02ToMuxMEqual), .B(1'b0), .S(mantissasAreEqual), .X(mux02ifMantissaNotEqual));

    //equal xps?
    wire mux03ToMux04;
    mux_2x1_1bit mux03 (.A(mux01ToMux03), .B(mux02ifMantissaNotEqual), .S(firstExponentAndSecondExponentAreEqual), .X(mux03ToMux04));

    //same signals?
    wire mux04ToMux05;
    mux_2x1_1bit mux04 (.A(mux03ToMux04), .B(signalFirst), .S(equalSignals), .X(mux04ToMux05));

    //sum or mult?
    mux_2x1_1bit mux05 (.A(mux04ToMux05), .B(multiplicationSignal), .S(sumOrMultiplication), .X(signalResult));
    
endmodule