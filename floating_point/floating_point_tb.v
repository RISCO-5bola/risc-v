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

    /* reg do shift left ou right */
    reg signed [22:0] controlShiftLeftOrRight;

    /* regs dos muxes */
    reg controlToMux01, controlToMux02, controlToMux03, 
        controlToMux04, controlToMux05, controlToMux06;

    /* regs da big ALU */
    reg muxAControl, muxBControl, muxControl, sumOrMultiplication, 
        loadRegA, loadRegB, muxAControlSmall, muxBControlSmall;
    reg [3:0] bigALUOperation;

    /* regs da small ALU */
    reg [3:0] smallALUOperation;
    reg loadRegSmall;
    
    integer errors = 0;

    task Check1;
        input [63:0] expect;
        if (expect[63:32] !== expect[31:0]) begin
            $display("Got %b, expected %b", expect[63:32], expect[31:0]);
            errors = errors + 1;
        end
    endtask

    // task Check2;
    //     input [1:0] expect;
        
    //     if (expect[1] !== expect[0]) begin
    //         $display("Got %b, expected %b (Op/ns code error)", expect[1], expect[0]);
    //         errors = errors + 1;
    //     end
    // endtask

    floating_point UUT (.floatingPoint1(floatingPoint1), .floatingPoint2(floatingPoint2), 
                        .clk(clk), .resultadoFinal(resultadoFinal), 
                        /* muxes */
                        .controlToMux01(controlToMux01), .controlToMux02(controlToMux02), 
                        .controlToMux03(controlToMux03), .controlToMux04(controlToMux04), 
                        .controlToMux05(controlToMux05), .controlToMux06(controlToMux06), 
                        /* icrease or decrease */
                        .controlToIncreaseOrDecrease(controlToIncreaseOrDecrease),
                        .IncreaseOrDecreaseEnable(IncreaseOrDecreaseEnable),
                        /* shift right */
                        .controlShiftRight(controlShiftRight), 
                        /* finaliza operacao */
                        .finalizeOperation(finalizeOperation),
                        /* ve se shifta left ou right */
                        .controlShiftLeftOrRight(controlShiftLeftOrRight),
                        /* Big ALU */
                        .muxAControl(muxAControl), .muxBControl(muxBControl), .muxControl(muxControl),
                        .sumOrMultiplication(sumOrMultiplication), .loadRegA(loadRegA), .loadRegB(loadRegB),
                        .bigALUOperation(bigALUOperation),
                        /* Small ALU */
                        .smallALUOperation(smallALUOperation), .muxAControlSmall(muxAControlSmall),
                        .muxBControlSmall(muxBControlSmall), .loadRegSmall(loadRegSmall));

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
       #10
       /* adicao 0.75 + 2.25 = 3 */
       floatingPoint1 = 32'b00111111010000000000000000000000; // 0.75 (-1)^0 * (1 + 0.1) * 2^-1
       floatingPoint2 = 32'b01000000000100000000000000000000; // 2.25 (-1)^0 * (1 + 0.001) * 2^1
       #10      

       controlToMux01 = 1'b1; 
       controlToMux02 = 1'b0; 
       controlToMux03 = 1'b0;
       controlToMux04 = 1'b1;
       controlToMux05 = 1'b0;
       controlToMux06 = 1'b0;

       controlShiftRight = 8'b0000_0010;
       controlToIncreaseOrDecrease = 4'b0000;
       IncreaseOrDecreaseEnable = 1'b0;
       controlShiftLeftOrRight = 22'b0;
       
       /* big ALU */
       muxAControl = 1'b1;
       muxBControl = 1'b0;
       muxControl = 1'b1;
       sumOrMultiplication = 1'b1;
       loadRegA = 1'b1;
       loadRegB = 1'b1;
       bigALUOperation = 4'b0000;

       /* small ALU */
       smallALUOperation = 4'b0011;
       muxAControlSmall = 1'b0; 
       muxBControlSmall = 1'b0;
       loadRegSmall = 1'b1;
       #100

       Check1({resultadoFinal, 32'b01000000010000000000000000000000});

       /* TESTE 2 */
       #10
       /* multiplicacao 1.5 * 2 = 3 */
       floatingPoint1 = 32'b0_01111111_10000000000000000000000;
       floatingPoint2 = 32'b0_10000000_00000000000000000000000;
       muxAControlSmall = 1'b1; 
       muxBControlSmall = 1'b1;
       #10      

       controlToMux01 = 1'b1; 
       controlToMux02 = 1'b0; 
       controlToMux03 = 1'b0;
       controlToMux04 = 1'b1;
       controlToMux05 = 1'b0;
       controlToMux06 = 1'b0;

       controlShiftRight = 8'b0000_0001;
       controlToIncreaseOrDecrease = 4'b0000;
       IncreaseOrDecreaseEnable = 1'b0;
       controlShiftLeftOrRight = 22'd0;
       
       /* big ALU */
       muxAControl = 1'b0;
       muxBControl = 1'b0;
       muxControl = 1'b0;
       sumOrMultiplication = 1'b0;
       loadRegA = 1'b1;
       loadRegB = 1'b1;
       bigALUOperation = 4'b0000;

       /* small ALU */
       smallALUOperation = 4'b0000;
       muxAControlSmall = 1'b1; 
       muxBControlSmall = 1'b1;
       loadRegSmall = 1'b1;
       #10

       /* big ALU */
       muxAControl = 1'b0;
       muxBControl = 1'b1;
       muxControl = 1'b1;
       sumOrMultiplication = 1'b0;
       loadRegA = 1'b1;
       loadRegB = 1'b1;
       bigALUOperation = 4'b0000;
       #100

       Check1({resultadoFinal, 32'b01000000010000000000000000000000});
    
       $display("Errors: %d", errors);
       $finish;

    end
endmodule