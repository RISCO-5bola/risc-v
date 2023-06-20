module floating_point(
    input [31:0] floatingPoint1, floatingPoint2;
    input clk,
    output [31:0] result
);
    
    /* wires de sinal que saem da control e vao para os muxes */
    wire controlToMux01, controlToMux02, controlToMux03, controlToMux04 controlToMux05;

    /* wires de 8 bits */
    wire [7:0] mux01ToMux02, roundToMux02, mux02ToIncreaseOrDecrease,
               smallALUToExponentDifference, exponentDifferenceToControl,
               controlShiftRight;

    /* wires de 23 bits */
    wire [22:0] mux03Out, mux04ToBigALU, bigALUtoMux05, roundToMux05, 
                mux05Out, shiftRightToBigALU, controlShiftLeftOrRight,
                shiftLeftOrRightToRound;

    /* unidade de controle do datapath */
    fp_control control (.exponentDifference(), .bigALUOut(), .roundOut(),
                        .mux1(controlToMux01), .mux2(controlToMux02), .mux3(controlToMux03), 
                        .mux4(controlToMux04), .shiftRight(controlToShiftRight), 
                        .shiftLeftOrRight(), .incrementOrDecrement(), .round());

    /*  */
    ALU smallALU (.A(floatingPoint1[30:23]), .B(floatingPoint2[30:23]), .ALUOp(), 
                  .result(smallALUToExponentDifference), 
                  .equal(), .not_equal(), .lesser_than(), .greater_or_equal(), 
                  .unsigned_lesser(), .unsigned_greater_equal());

    /* ALU que faz a soma das mantissas */
    ALU bigALU (.A(shiftRightToBigALU), .B(mux04ToBigALU), .ALUOp(), 
                .result(bigALUtoMux05), 
                .equal(), .not_equal(), .lesser_than(), .greater_or_equal(), 
                .unsigned_lesser(), .unsigned_greater_equal());
    
    /* mux que recebe os expoentes e seleciona o menor deles */
    mux_2x1_8bit mux01 (.A(floatingPoint1[30:23]), .B(floatingPoint2[30:23]), 
                        .S(mux01), .X(mux01ToMux02));

    /* mux que recebe o menor expoente dos inputs e o expoente do rounder 
       e verifica se precisa ser incrementado ou decrementado*/
    mux_2x1_8bit mux02 (.A(mux01ToMux02), .B(roundToMux02), 
                        .S(controlToMux02), .X(mux02ToIncreaseOrDecrease));

    /* mux que recebe as fracoes e seleciona a menor delas para ser 
       shiftada para a direita */
    mux_2x1_23bit mux03 (.A(floatingPoint1[22:0]), .B(floatingPoint2[22:0]), 
                         .S(controlToMux03), .X(mux03Out));

    /* mux que recebe as fracoes e seleciona a maior delas para ser
       enviada direto para a big ALU */
    mux_2x1_23bit mux04 (.A(floatingPoint1[22:0]), .B(floatingPoint2[22:0]), 
                         .S(controlToMux04), .X(mux04ToBigALU));
    
    /* mux que recebe a soma das fracoes da big ALU e a fracao do rounder
       para verificar se precisa ser shiftado para a esquerda ou direita */
    mux_2x1_23bit mux05 (.A(bigALUtoMux05), .B(roundToMux05), 
                         .S(controlToMux05), .X(mux05Out));


    /* registrador que recebe o valor da small ALU */
    reg_parametrizado regSmallALU (.clk(clk), .load(1'b1), .in_data(smallALUToExponentDifference), 
                                   .out_data(exponentDifferenceToControl));

    /* valor shiftado para a direita que sai do mux 03 e vai para a big ALU */
    assign shiftRightToBigALU = mux03Out << controlShiftRight;

    /* valor shiftado para a esquerda ou direita que sai do mux 05 e vai
       para o rounder */
    assign shiftLeftOrRightToRound = mux05Out << controlShiftLeftOrRight;


    
    

endmodule