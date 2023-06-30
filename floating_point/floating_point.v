module floating_point(
      input start,
      input [31:0] floatingPoint1, floatingPoint2,
      input loadRegSmall,
      input clk,
      input controlToMux01, controlToMux02, controlToMux03, 
            controlToMux04, controlToMux05, IncreaseOrDecreaseEnable,
      input [7:0] controlShiftRight,
      input [3:0] smallALUOperation, controlToIncreaseOrDecrease,
      input muxBControlSmall, muxAControlSmall,
      //inputs do bigALU:
      input sum_sub, isSum, reset, muxDataRegValor2,
      /* shift left or right */
      input rightOrLeft,
      input [22:0] howMany, 
      /*increaseOrDecrease*/
      input [7:0] howManyToIncreaseOrDecrease,
      output [31:0] resultadoFinal,
      output [7:0] smallAluResult,
      /*Lembrar de colocar todos os sinais de controle como inputs - E SÃO VÁRIOS*/
      //Todos os muxes;
      //Sinais Da SMALLALU;
      //Sinais Da BIGALU;
      output endMultiplication,
      output rounderOverflow,
      //Sinais do shifter;
      //Sinais do Rounder;
      output [63:0] posFirst28posReferential,
      output [63:0] posFirst27posReferential
);
   

   //  initial begin
   //              $dumpfile("wave.vcd");
   //              $dumpvars(0, floating_point);
   //          end
   
    /* wires do sinal para multiplicacao */
    wire sign;
    /* wires de 8 bits */
    wire [7:0] mux01ToMux02, Mux06ToMux02, mux02ToIncreaseOrDecrease,
               smallALUToRegSmallAlu, regSmallALUToControl, 
               regFAToSmallALU, regFBToSmallALU,
               IncreaseOrDecreaseToMux06, regSmallALUToMux06,
               regFAToMux01, regFBToMux01, mux06ToRegFinal;
    /* wires de 23 bits */
   wire [22:0] regFAToMux03Mantissa, regFBToMux03Mantissa,
               regFAToMux04Mantissa, regFBToMux04Mantissa,
               mux03OUTToRightShift, mux04OUTToBigALU,  
               rounderToRegFinal, shiftRightToBigALU, rounderOut,
               mux04ToBigALU;

   /*os aumentados*/
   wire [23:0] rightShiftToBigALU;
   wire [26:0] shiftLeftOrRightToRound;
   wire [27:0] rightShiftOUTToBigALU, roundToMux05; 
   wire [63:0] bigALUtoMux05, mux05ToRightShiftOrLeftShift;

   //    assign mux03ToRightShift[22:0] = mux03OUTToRightShift;
   //    assign mux03ToRightShift[23] = 1'b1;
   assign mux04ToBigALU = {1'b1, mux04OUTToBigALU};

    /* valor shiftado para a direita que sai do mux 03 e vai para a big ALU */
   assign rightShiftOUTToBigALU = {1'b1, mux03OUTToRightShift, 4'b0000} >> controlShiftRight;

   /*Rounder*/

   /*wires de 32 bits*/
   wire [31:0] regFinalInput;
   wire [31:0] regFAOUT, regFBOUT;
   assign regFinalInput[30:23] = IncreaseOrDecreaseToMux06; // CUIDADO NA HORA DE TIRAR ESSE MUX06 DAQUI
   assign regFinalInput[22:0] = rounderToRegFinal;
   assign regFinalInput[31] = finalSignal;
/*
AQUI ESTÃO OS SINAIS DO FELIPE E DO TADAKI PO, PARA O SINAL
*/

   wire [7:0] regSmallALUToDefineSignal;
   wire firstSignalToDefineSignal, secondSignalToDefineSignal;
   wire sumOrMultiplicationToDefineSignal; //0 se soma;
   wire [22:0] mantissaFirstToDefineSignal, mantissaSecondToDefineSignal;
   wire finalSignal;

   assign firstSignalToDefineSignal = regFAOUT[31];
   assign secondSignalToDefineSignal = regFBOUT[31];
   assign sumOrMultiplicationToDefineSignal = ~isSum;
   assign mantissaFirstToDefineSignal = regFAOUT[22:0];
   assign mantissaSecondToDefineSignal = regFBOUT[22:0];

   defineSignal defineSignal(.mantissaFirst(mantissaFirstToDefineSignal),
                             .mantissaSecond(mantissaSecondToDefineSignal), 
                             .signalFirst(firstSignalToDefineSignal),
                             .signalSecond(secondSignalToDefineSignal), 
                             .exponentDifference(regSmallALUToDefineSignal),
                             .sumOrMultiplication(sumOrMultiplicationToDefineSignal), 
                             .signalResult(finalSignal));
   //final

   assign Mux06ToMux02 = IncreaseOrDecreaseToMux06;
   /*registradores para salvar os valores de entrada para operar -> 64bits*/ 
   register_32bits regFA (.clk(clk), .load(1'b1), .in_data(floatingPoint1), 
                                   .out_data(regFAOUT));
   register_32bits regFB (.clk(clk), .load(1'b1), .in_data(floatingPoint2), 
                                   .out_data(regFBOUT));
   register_32bits regFinal (.clk(clk), .load(1'b1), .in_data(regFinalInput), 
                                   .out_data(resultadoFinal));
   /*Instanciação dos SOMADORES*/
   /*Alu que ou pega a diferenca entre 1 e 2 ou soma e retira o bias*/
   
   assign regFAToSmallALU = regFAOUT[30:23];
   assign regFBToSmallALU = regFBOUT[30:23];

   SmallAlu SmallAlu (.valor1(regFAToSmallALU), .valor2(regFBToSmallALU), .clk(clk), 
                      .result(smallALUToRegSmallAlu), .muxA(muxAControlSmall), .muxB(muxBControlSmall), .loadReg(loadRegSmall),
                      .ALUOp(smallALUOperation));

   /* ALU que faz a soma das mantissas */
   BigALU BigALU (.clk(clk), .valor1(rightShiftOUTToBigALU), .valor2({1'b1, mux04ToBigALU, 4'b0000}),
                  .result(bigALUtoMux05), .finishedMult(endMultiplication), .isSum(isSum), 
                  .sum_sub(sum_sub), .reset(reset), .muxDataRegValor2(muxDataRegValor2));

   /*Increase or decrease*/
   IncreaseOrDecrease IncreaseOrDecrease(.clk(clk),.howManyToIncreaseOrDecrease(howManyToIncreaseOrDecrease), 
                                         .enable(IncreaseOrDecreaseEnable), .valor1(mux02ToIncreaseOrDecrease), 
                                         .result(IncreaseOrDecreaseToMux06), .ALUOp(controlToIncreaseOrDecrease));

   /*Instanciação dos muxes básicos da datapath*/
   /* mux que recebe os expoentes e seleciona o menor deles */
   assign regFAToMux01 = regFAOUT[30:23];
   assign regFBToMux01 = regFBOUT[30:23];
   mux_2x1_8bit mux01 (.A(regFAToMux01), .B(regFBToMux01), 
                        .S(controlToMux01), .X(mux01ToMux02));

    /* mux que recebe o menor expoente dos inputs e o expoente do rounder 
       e verifica se precisa ser incrementado ou decrementado*/
   mux_2x1_8bit mux02 (.A(mux01ToMux02), .B(resultadoFinal[30:23]), 
                        .S(controlToMux02), .X(mux02ToIncreaseOrDecrease));//Mux06ToMux02 -> CORRIGIR

    /* mux que recebe as fracoes e seleciona a menor delas para ser 
       shiftada para a direita */
   assign regFAToMux03Mantissa = regFAOUT[22:0];
   assign regFBToMux03Mantissa = regFBOUT[22:0];
   assign regFAToMux04Mantissa = regFAOUT[22:0];
   assign regFBToMux04Mantissa = regFBOUT[22:0];
   mux_2x1_23bit mux03 (.A(regFAToMux03Mantissa), .B(regFBToMux03Mantissa), 
                         .S(controlToMux03), .X(mux03OUTToRightShift));

    /* mux que recebe as fracoes e seleciona a maior delas para ser
       enviada direto para a big ALU */
   mux_2x1_23bit mux04 (.A(regFAToMux04Mantissa), .B(regFBToMux04Mantissa), 
                         .S(controlToMux04), .X(mux04OUTToBigALU));

    /* mux que recebe a soma das fracoes da big ALU e a fracao do rounder
       para verificar se precisa ser shiftado para a esquerda ou direita */
   
   
   /* esse mux tem o caso especial que ele ja corta o bit mais significativo vindo
      da big ALU. Ja que estamos fazendo o papel da control nos que temos que ver 
      quanto precisa ser shiftado por causa desse corte.
      Para o sinal vindo do rounder (que entra pela porta B), esta sendo colocado
      um zero na frente do numero, entao nao vai precisar dar shift */
   assign roundToMux05 = {1'b0, rounderOut, 4'b0000};
   mux_2x1_28bit mux05 (.A(bigALUtoMux05), .B({36'd0,roundToMux05}), 
                         .S(controlToMux05), .X(mux05ToRightShiftOrLeftShift));

    /* registrador que recebe o valor da small ALU */
   reg_parametrizado regSmallALU (.clk(clk), .load(1'b1), .in_data(smallALUToRegSmallAlu), 
                                   .out_data(regSmallALUOUT));
   wire [7:0] regSmallALUOUT;
   assign smallAluResult = regSmallALUOUT;
   assign regSmallALUToDefineSignal = regSmallALUOUT;
    /* valor shiftado para a esquerda ou direita que sai do mux 05 e vai
       para o rounder */
   //assign shiftLeftOrRightToRound = mux05ToRightShiftOrLeftShift << controlShiftLeftOrRight;
   shiftLeftOrRight shiftLeftOrRight(.mantissaToShift(mux05ToRightShiftOrLeftShift), 
                                     .shifted(shiftLeftOrRightToRound), .howMany(howMany), 
                                     .rightOrLeft(rightOrLeft));

   /* Rounder */
   rounder rounder(.mantissa(shiftLeftOrRightToRound), .mantissaRounded(rounderOut), 
                   .notNormalized(rounderOverflow), .clk(clk));
         
      
   assign rounderToRegFinal = rounderOut;

   /* Mede distâncias até determinados bits para fazer arredondamentos */
   Distancerfrom28 distancer28 (.doubleWord(bigALUtoMux05), .distance(posFirst28posReferential));
   Distancerfrom27 distancer27 (.doubleWord(bigALUtoMux05), .distance(posFirst27posReferential));
endmodule