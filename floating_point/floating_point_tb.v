`timescale 1ns/1ns

module floating_point_tb ();
    reg [31:0] floatingPoint1, floatingPoint2;
    reg clk;
    wire [31:0] resultadoFinal;

    /* wire para ver se finalizou operacao */
    wire finalizeOperation;

    /* reg do shift right */
    reg [7:0] controlShiftRight;

    /* reg do increase or decrease */
    reg [3:0] controlToIncreaseOrDecrease;
    reg IncreaseOrDecreaseEnable;
    reg [7:0] howManyToIncreaseOrDecrease;

    /* reg do shift left ou right */
    reg rightOrLeft;
    reg [22:0] howMany;

    /* regs dos muxes */
    reg controlToMux01, controlToMux02, controlToMux03, 
        controlToMux04, controlToMux05, controlToMux06;

    /* regs da big ALU */
    reg sum_sub, isSum, reset, muxDataRegValor2;
        

    /* regs da small ALU */
    reg [3:0] smallALUOperation;
    reg loadRegSmall;
    reg muxAControlSmall;
    reg muxBControlSmall;
    
    integer errors = 0;

    task Check1;
        input [63:0] expect;
        if (expect[63:32] !== expect[31:0]) begin
            $display("Got %b, expected %b", expect[63:32], expect[31:0]);
            errors = errors + 1;
        end
    endtask

    floating_point UUT (.floatingPoint1(floatingPoint1), .floatingPoint2(floatingPoint2), 
                        .clk(clk), .resultadoFinal(resultadoFinal), 
                        /* muxes */
                        .controlToMux01(controlToMux01), .controlToMux02(controlToMux02), 
                        .controlToMux03(controlToMux03), .controlToMux04(controlToMux04), 
                        .controlToMux05(controlToMux05), .controlToMux06(controlToMux06), 
                        /* icrease or decrease */
                        .controlToIncreaseOrDecrease(controlToIncreaseOrDecrease),
                        .IncreaseOrDecreaseEnable(IncreaseOrDecreaseEnable),
                        .howManyToIncreaseOrDecrease(howManyToIncreaseOrDecrease),
                        /* shift right */
                        .controlShiftRight(controlShiftRight), 
                        /* ve se shifta left ou right */
                        .rightOrLeft(rightOrLeft), .howMany(howMany),
                        /* Big ALU */
                        .sum_sub(sum_sub), .isSum(isSum), .reset(reset), .muxDataRegValor2(muxDataRegValor2),
                        /* Small ALU */
                        .smallALUOperation(smallALUOperation), .muxAControlSmall(muxAControlSmall),
                        .muxBControlSmall(muxBControlSmall), .loadRegSmall(loadRegSmall));

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
       #10
       $display("Teste 1");
       /* adicao 0.75 + 2.25 = 3 */
       floatingPoint1 = 32'b0_01111110_10000000000000000000000; // 0.75 
       floatingPoint2 = 32'b0_10000000_00100000000000000000000; // 2.25
       #10      
    
       /* sinal dos muxes */
       controlToMux01 = 1'b1; 
       controlToMux02 = 1'b0; 
       controlToMux03 = 1'b0;
       controlToMux04 = 1'b1;
       controlToMux05 = 1'b0;
       controlToMux06 = 1'b0;

        /* shifters */
       controlShiftRight = 8'b0000_0010;
       controlToIncreaseOrDecrease = 4'b0000;
       IncreaseOrDecreaseEnable = 1'b0;
       howManyToIncreaseOrDecrease = 1'b1;
       rightOrLeft = 1'b1;
       howMany = 23'd1;

       /* big ALU */
       isSum = 1'b1;
       sum_sub = 1'b0;
       reset = 1'b0;
       muxDataRegValor2 = 1'b0;

       /* small ALU */
       smallALUOperation = 4'b0011;
       muxAControlSmall = 1'b0; 
       muxBControlSmall = 1'b0;
       loadRegSmall = 1'b1;
       #100

       Check1({resultadoFinal, 32'b01000000010000000000000000000000}); // 3

       $display("Teste 2");
       /* adicao 31.5 + 4.25 = 35.75 */
       floatingPoint1 = 32'b0_10000011_11111000000000000000000; // 31.5
       floatingPoint2 = 32'b0_10000001_00010000000000000000000; // 4.25
       #10      
    
       /* sinal dos muxes */
       controlToMux01 = 1'b0; 
       controlToMux02 = 1'b0; 
       controlToMux03 = 1'b1;
       controlToMux04 = 1'b0;
       controlToMux05 = 1'b0;
       controlToMux06 = 1'b0;//corrigido

        /* shifters */
       controlShiftRight = 8'b0000_0010;
       controlToIncreaseOrDecrease = 4'b0000;
       IncreaseOrDecreaseEnable = 1'b1;
       howManyToIncreaseOrDecrease = 8'd1;
       rightOrLeft = 1'b0;
       howMany = 23'd0;

       /* big ALU */
       isSum = 1'b1;
       sum_sub = 1'b0;
       reset = 1'b0;
       muxDataRegValor2 = 1'b0;

       /* small ALU */
       smallALUOperation = 4'b0011;
       muxAControlSmall = 1'b0; 
       muxBControlSmall = 1'b0;
       loadRegSmall = 1'b1;
       #100

       Check1({resultadoFinal, 32'b01000010_000011110000000000000000}); // 35.75

    //    $display("Teste 3");
    //    #10
    //    /* multiplicacao 1.5 * -2 = 3 */
    //    floatingPoint1 = 32'b0_01111111_10000000000000000000000;
    //    floatingPoint2 = 32'b1_10000000_00000000000000000000000;
    //    muxAControlSmall = 1'b1; 
    //    muxBControlSmall = 1'b1;
    //    #10      

    //    controlToMux01 = 1'b1; 
    //    controlToMux02 = 1'b0; 
    //    controlToMux03 = 1'b0;
    //    controlToMux04 = 1'b1;
    //    controlToMux05 = 1'b0;
    //    controlToMux06 = 1'b0;

    //    controlShiftRight = 8'b0000_0001;
    //    controlToIncreaseOrDecrease = 4'b0000;
    //    IncreaseOrDecreaseEnable = 1'b0;
    //    controlShiftLeftOrRight = 22'd0;
       
    //    /* big ALU */
    // //    muxAControl = 1'b0;
    // //    muxBControl = 1'b0;
    // //    muxControl = 1'b0;
    // //    sumOrMultiplication = 1'b0;
    // //    loadRegA = 1'b1;
    // //    loadRegB = 1'b1;
    // //    bigALUOperation = 4'b0000;

    //    /* small ALU */
    //    smallALUOperation = 4'b0000;
    //    muxAControlSmall = 1'b1; 
    //    muxBControlSmall = 1'b1;
    //    loadRegSmall = 1'b1;
    //    #10

    //    /* big ALU */
    // //    muxAControl = 1'b0;
    // //    muxBControl = 1'b1;
    // //    muxControl = 1'b1;
    // //    sumOrMultiplication = 1'b0;
    // //    loadRegA = 1'b1;
    // //    loadRegB = 1'b1;
    // //    bigALUOperation = 4'b0000;
    //    #100

    //    Check1({resultadoFinal, 32'b11000000010000000000000000000000});

       
    
       $display("Errors: %d", errors);
       $finish;

    end
endmodule