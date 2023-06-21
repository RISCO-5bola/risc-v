module floating_point(
      input [31:0] floatingPoint1, floatingPoint2,
      input loadFinal, loadRegSmall,
      input clk,
      output [31:0] resultadoFinal,
      input controlToMux01, controlToMux02, controlToMux03, controlToMux04, controlToMux05, controlToMux06,
      input [7:0] controlShiftRight,
      input signed [22:0] controlShiftLeftOrRight, //not certain
      input [3:0] smallALUOperation, controlToIncreaseOrDecrease,
      input regSmallALULoad, muxBControlSmall, muxAControlSmall,
      //inputs do bigALU:
      input [3:0] bigALUOperation,
      input muxAControl, muxBControl, muxControl, sumOrMultiplication,
      input loadRegA, loadRegB,
      input IncreaseOrDecreaseEnable,
      output endMultiplication, finalizeOperation

    /*Lembrar de colocar todos os sinais de controle como inputs - E SÃO VÁRIOS*/
    //Todos os muxes;
    //Sinais Da SMALLALU;
    //Sinais Da BIGALU;
    //Sinais do shifter;
    //Sinais do Rounder;
);

    initial begin
                $dumpfile("wave.vcd");
                $dumpvars(0, floating_point);
            end
            
    /* wires do sinal para multiplicacao */
    wire wire0, sign;
    /* wires de 8 bits */
    wire [7:0] mux01ToMux02, Mux06ToMux02, mux02ToIncreaseOrDecrease,
               smallALUToRegSmallAlu, regSmallALUToControl, 
               regFAToSmallALU, regFBToSmallALU,
               IncreaseOrDecreaseToMux06, regSmallALUToMux06,
               regFAToMux01, regFBToMux01, mux06ToRegFinal;
    /* wires de 23 bits */
   wire [22:0] regFAToMux03Mantissa, regFBToMux03Mantissa,
               regFAToMux04Mantissa, regFBToMux04Mantissa,
               mux03OUTToRightShift, mux04OUTToBigALU, roundToMux05,  
               rounderToRegFinal, shiftRightToBigALU, rounderOut,
               shiftLeftOrRightToRound;

   /*os aumentados*/
   wire [23:0] mux04ToBigALU, rightShiftToBigALU, mux05ToRightShiftOrLeftShift, bigALUtoMux05,
   rightShiftOUTToBigALU;

//    assign mux03ToRightShift[22:0] = mux03OUTToRightShift;
//    assign mux03ToRightShift[23] = 1'b1;
   assign mux04ToBigALU = {1'b1, mux04OUTToBigALU};

    /* valor shiftado para a direita que sai do mux 03 e vai para a big ALU */
   assign rightShiftOUTToBigALU = {1'b1, mux03OUTToRightShift} >> controlShiftRight;

   /*Rounder*/

   /*wires de 32 bits*/
   wire [31:0] regFinalInput;
   wire [31:0] regFAOUT, regFBOUT;
   assign regFinalInput[30:23] = mux06ToRegFinal;
   assign regFinalInput[22:0] = rounderToRegFinal;

   xor(wire0, floatingPoint1[31], floatingPoint2[31]);
   and(sign, wire0, ~sumOrMultiplication);
   assign regFinalInput[31] = sign;

   assign Mux06ToMux02 = mux06ToRegFinal;
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
   BigALU BigALU (.clk(clk), .valor1(rightShiftOUTToBigALU), .valor2(mux04ToBigALU), .ALUOp(bigALUOperation), 
                  .result(bigALUtoMux05), .endMultiplication(endMultiplication), .muxA(muxAControl), .muxB(muxBControl),
                  .muxC(muxControl), .sumOrMultiplication(sumOrMultiplication),
                  .loadRegA(loadRegA), .loadRegB(loadRegB));

   /*Increase or decrease*/
   IncreaseOrDecrease IncreaseOrDecrease(.clk(clk),.enable(IncreaseOrDecreaseEnable), .valor1(mux02ToIncreaseOrDecrease), .result(IncreaseOrDecreaseToMux06),
   .ALUOp(controlToIncreaseOrDecrease));

   /*Instanciação dos muxes básicos da datapath*/
   /* mux que recebe os expoentes e seleciona o menor deles */
   assign regFAToMux01 = regFAOUT[30:23];
   assign regFBToMux01 = regFBOUT[30:23];
   mux_2x1_8bit mux01 (.A(regFAToMux01), .B(regFBToMux01), 
                        .S(controlToMux01), .X(mux01ToMux02));

    /* mux que recebe o menor expoente dos inputs e o expoente do rounder 
       e verifica se precisa ser incrementado ou decrementado*/
   mux_2x1_8bit mux02 (.A(mux01ToMux02), .B(Mux06ToMux02), 
                        .S(controlToMux02), .X(mux02ToIncreaseOrDecrease));

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
   

   mux_2x1_24bit mux05 (.A(bigALUtoMux05), .B({1'b0, roundToMux05}), 
                         .S(controlToMux05), .X(mux05ToRightShiftOrLeftShift));
   //FALTA PASSAR O MUX05 para 24 bits ou mais.


   /*mux recebe increase or decrease e o regSmallALU*/
   
   mux_2x1_8bit mux06 (.A(IncreaseOrDecreaseToMux06), .B(regSmallALUToMux06), 
                         .S(controlToMux06), .X(mux06ToRegFinal));

    /* registrador que recebe o valor da small ALU */
   reg_parametrizado regSmallALU (.clk(clk), .load(1'b1), .in_data(smallALUToRegSmallAlu), 
                                   .out_data(regSmallALUToMux06));

    /* valor shiftado para a esquerda ou direita que sai do mux 05 e vai
       para o rounder */
   assign shiftLeftOrRightToRound = mux05ToRightShiftOrLeftShift << controlShiftLeftOrRight;

   /*Rounder */
   rounder rounder(.mantissa(shiftLeftOrRightToRound), .mantissaRounded(rounderOut), 
                   .notNormalized(finalizeOperation), .clk(clk));
      
   assign rounderToRegFinal = rounderOut;

endmodule