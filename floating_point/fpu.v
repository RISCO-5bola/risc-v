module fpu (clk, rst, A, B, R, op, start, done);
    input clk, rst;
    input [31:0] A, B;
    output [31:0] R;
    input [1:0] op;
    input start;
    output done;

    initial begin
            $dumpfile("wave.vcd");
            $dumpvars(0, fpu);
    end

    wire rounderOverflow;
    wire [7:0] smallAluResult;
    wire [63:0] posFirst27posReferential;
    wire [63:0] posFirst28posReferential;
    /* sinais de controle para o restante da FPU */
    wire loadRegSmall;
    wire controlToMux01, controlToMux02, controlToMux03, 
         controlToMux04, controlToMux05, IncreaseOrDecreaseEnable;
    wire [7:0] controlShiftRight;
    wire [3:0] smallALUOperation, controlToIncreaseOrDecrease;
    wire regSmallALULoad, muxBControlSmall, muxAControlSmall;
    wire sum_sub, isSum, muxDataRegValor2;
    wire rightOrLeft;
    wire [22:0] howMany;
    wire [7:0] howManyToIncreaseOrDecrease;

    //Instanciação do controle da FPU
    floating_point_uc fp_uc (.clk(clk), .reset(rst), .start(start),
                             .operation(op), .rounderOverflow(rounderOverflow),
                             .expDifferencePos(smallAluResult[7]), .smallAluResult(smallAluResult),
                             .signalFP1(A[31]), .signalFP2(B[31]), .posFirst27posReferential(posFirst27posReferential[22:0]),
                             .posFirst28posReferential(posFirst28posReferential[22:0]), .done(done),
                             .loadRegSmall(loadRegSmall), .controlToMux01(controlToMux01), .controlToMux02(controlToMux02),
                             .controlToMux03(controlToMux03), .controlToMux04(controlToMux04), .controlToMux05(controlToMux05),
                             .IncreaseOrDecreaseEnable(IncreaseOrDecreaseEnable), .controlShiftRight(controlShiftRight),
                             .smallALUOperation(smallALUOperation), .controlToIncreaseOrDecrease(controlToIncreaseOrDecrease),
                             .regSmallALULoad(regSmallALULoad), .muxBControlSmall(muxBControlSmall), .muxAControlSmall(muxAControlSmall),
                             .sum_sub(sum_sub), .isSum(isSum), .muxDataRegValor2(muxDataRegValor2), .rightOrLeft(rightOrLeft),
                             .howMany(howMany), .howManyToIncreaseOrDecrease(howManyToIncreaseOrDecrease));
     
     //Instanciação da datapath da FPU
    floating_point fp_datapath (.start(start), .floatingPoint1(A), .floatingPoint2(B), .loadRegSmall(loadRegSmall), .clk(clk),
                                .controlToMux01(controlToMux01), .controlToMux02(controlToMux02), .controlToMux03(controlToMux03),
                                .controlToMux04(controlToMux04), .controlToMux05(controlToMux05), .IncreaseOrDecreaseEnable(IncreaseOrDecreaseEnable),
                                .controlShiftRight(controlShiftRight), .smallALUOperation(smallALUOperation), .rounderOverflow(rounderOverflow),
                                .controlToIncreaseOrDecrease(controlToIncreaseOrDecrease), .muxBControlSmall(muxBControlSmall),
                                .muxAControlSmall(muxAControlSmall), .sum_sub(sum_sub), .isSum(isSum), .reset(rst), .muxDataRegValor2(muxDataRegValor2),
                                .rightOrLeft(rightOrLeft), .howMany(howMany), .howManyToIncreaseOrDecrease(howManyToIncreaseOrDecrease), .resultadoFinal(R),
                                .posFirst28posReferential(posFirst28posReferential), .posFirst27posReferential(posFirst27posReferential), .smallAluResult(smallAluResult));
endmodule