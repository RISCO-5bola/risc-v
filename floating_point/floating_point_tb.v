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
        controlToMux04, controlToMux05;

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
                        .controlToMux05(controlToMux05),
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
       $display("Teste 1 - soma sinais iguais, primeiro expoente menor que o segundo");
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

        /* shifters */
       controlShiftRight = 8'b0000_0010;
       controlToIncreaseOrDecrease = 4'b0000;
       IncreaseOrDecreaseEnable = 1'b0;
       howManyToIncreaseOrDecrease = 8'b1;
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

       $display("Teste 2 - soma sinais iguais, primeiro expoente maior que o segundo");
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

       $display("Teste 3 - multiplicacao, ambos positivos");
       #10
       /* multiplicacao 0.38*3.34543 */
       floatingPoint1 = 32'b0_10000000_10101100001101110000110;
       floatingPoint2 = 32'b0_01111101_10000101000111101011100;
       muxAControlSmall = 1'b0; 
       muxBControlSmall = 1'b0;
       reset = 1'b1;
       muxDataRegValor2 = 1'b0;
       #20
       reset = 1'b0;
       muxAControlSmall = 1'b1; 
       muxBControlSmall = 1'b1;
    
       /* sinal dos muxes */
       controlToMux01 = 1'b1; 
       controlToMux02 = 1'b0; 
       controlToMux03 = 1'b1;
       controlToMux04 = 1'b0;
       controlToMux05 = 1'b0;

        /* shifters */
       controlShiftRight = 8'b0000_0011;
       controlToIncreaseOrDecrease = 4'b0000;
       IncreaseOrDecreaseEnable = 1'b1;
       howManyToIncreaseOrDecrease = 8'd2;
       rightOrLeft = 1'b1;
       howMany = 23'd3;

       /* big ALU */
       isSum = 1'b0;
       sum_sub = 1'b0;
       muxDataRegValor2 = 1'b1;

       /* small ALU */
       smallALUOperation = 4'b0011;
       muxAControlSmall = 1'b0; 
       muxBControlSmall = 1'b0;
       loadRegSmall = 1'b1;
       #1000

       Check1({resultadoFinal, 32'b00111111101000101011100011000010});

       $display("Teste 4 - multiplicacao, sinais distintos");
       #10
       /* multiplicacao -0.38*3.34543 */
       floatingPoint1 = 32'b1_10000000_10101100001101110000110;
       floatingPoint2 = 32'b0_01111101_10000101000111101011100;
       muxAControlSmall = 1'b0; 
       muxBControlSmall = 1'b0;
       reset = 1'b1;
       muxDataRegValor2 = 1'b0;
       #20
       reset = 1'b0;
       muxAControlSmall = 1'b1; 
       muxBControlSmall = 1'b1;
    
       /* sinal dos muxes */
       controlToMux01 = 1'b1; 
       controlToMux02 = 1'b0; 
       controlToMux03 = 1'b1;
       controlToMux04 = 1'b0;
       controlToMux05 = 1'b0;

        /* shifters */
       controlShiftRight = 8'b0000_0011;
       controlToIncreaseOrDecrease = 4'b0000;
       IncreaseOrDecreaseEnable = 1'b1;
       howManyToIncreaseOrDecrease = 8'd2;
       rightOrLeft = 1'b1;
       howMany = 23'd3;

       /* big ALU */
       isSum = 1'b0;
       sum_sub = 1'b0;
       muxDataRegValor2 = 1'b1;

       /* small ALU */
       smallALUOperation = 4'b0011;
       muxAControlSmall = 1'b0; 
       muxBControlSmall = 1'b0;
       loadRegSmall = 1'b1;
       #1000

       Check1({resultadoFinal, 32'b10111111101000101011100011000010});

        $display("Teste 5 - multiplicacao, sinais distintos");
       #10
       /* multiplicacao -3.34543*0.38 */
       floatingPoint1 = 32'b1_01111101_10000101000111101011100;
       floatingPoint2 = 32'b1_10000000_10101100001101110000110;
       muxAControlSmall = 1'b0; 
       muxBControlSmall = 1'b0;
       reset = 1'b1;
       muxDataRegValor2 = 1'b0;
       #20
       reset = 1'b0;
       muxAControlSmall = 1'b1; 
       muxBControlSmall = 1'b1;
    
       /* sinal dos muxes */
       controlToMux01 = 1'b1; 
       controlToMux02 = 1'b0; 
       controlToMux03 = 1'b1;
       controlToMux04 = 1'b0;
       controlToMux05 = 1'b0;

        /* shifters */
       controlShiftRight = 8'b0000_0011;
       controlToIncreaseOrDecrease = 4'b0011;
       IncreaseOrDecreaseEnable = 1'b1;
       howManyToIncreaseOrDecrease = 8'd1;
       rightOrLeft = 1'b1;
       howMany = 23'd3;

       /* big ALU */
       isSum = 1'b0;
       sum_sub = 1'b0;
       muxDataRegValor2 = 1'b1;

       /* small ALU */
       smallALUOperation = 4'b0011;
       muxAControlSmall = 1'b0;
       muxBControlSmall = 1'b0;
       loadRegSmall = 1'b1;
       #1000

       Check1({resultadoFinal, 32'b00111111101000101011100011000010});

       $display("Teste 6 - soma com sinais distintos, primeiro positivo e segundo negativo");
       /* adicao 31.5 - 4.25 = 27.25*/
       floatingPoint1 = 32'b0_10000011_11111000000000000000000 ; // 31.5
       floatingPoint2 = 32'b1_10000001_00010000000000000000000; // -4.25
       #10      

    
       /* sinal dos muxes */
       controlToMux01 = 1'b0; 
       controlToMux02 = 1'b0; 
       controlToMux03 = 1'b1;
       controlToMux04 = 1'b0;
       controlToMux05 = 1'b0;

        /* shifters */
       controlShiftRight = 8'b0000_0010;
       controlToIncreaseOrDecrease = 4'b0000;
       IncreaseOrDecreaseEnable = 1'b0;
       howManyToIncreaseOrDecrease = 8'd0;
       rightOrLeft = 1'b1;
       howMany = 23'd1;

       /* big ALU */
       isSum = 1'b1;
       sum_sub = 1'b1;
       reset = 1'b0;
       muxDataRegValor2 = 1'b0;

       /* small ALU */
       smallALUOperation = 4'b0011;
       muxAControlSmall = 1'b0; 
       muxBControlSmall = 1'b0;
       loadRegSmall = 1'b1;
       #100

       Check1({resultadoFinal, 32'b0_10000011_10110100000000000000000}); // 27.25

       $display("Teste 7 - soma com sinais iguais, ambos negativos");
       /* adicao (-31.5) + (-4.25) = -35.75 */
                            
       floatingPoint1 = 32'b1_10000011_11111000000000000000000; // 31.5
       floatingPoint2 = 32'b1_10000001_00010000000000000000000; // 4.25
       #10      
    
       /* sinal dos muxes */
       controlToMux01 = 1'b0; 
       controlToMux02 = 1'b0; 
       controlToMux03 = 1'b1;
       controlToMux04 = 1'b0;
       controlToMux05 = 1'b0;

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

       Check1({resultadoFinal, 32'b1_10000100_00011110000000000000000}); // -35.75

       $display("Teste 8 - multiplicacao, ambos negativos");
       #10
       /* multiplicacao -0.38*-3.34543 */
       floatingPoint1 = 32'b1_10000000_10101100001101110000110;
       floatingPoint2 = 32'b1_01111101_10000101000111101011100;
       muxAControlSmall = 1'b0; 
       muxBControlSmall = 1'b0;
       reset = 1'b1;
       muxDataRegValor2 = 1'b0;
       #20
       reset = 1'b0;
       muxAControlSmall = 1'b1; 
       muxBControlSmall = 1'b1;
    
       /* sinal dos muxes */
       controlToMux01 = 1'b1; 
       controlToMux02 = 1'b0; 
       controlToMux03 = 1'b1;
       controlToMux04 = 1'b0;
       controlToMux05 = 1'b0;

        /* shifters */
       controlShiftRight = 8'b0000_0011;
       controlToIncreaseOrDecrease = 4'b0000;
       IncreaseOrDecreaseEnable = 1'b1;
       howManyToIncreaseOrDecrease = 8'd2;
       rightOrLeft = 1'b1;
       howMany = 23'd3;

       /* big ALU */
       isSum = 1'b0;
       sum_sub = 1'b0;
       muxDataRegValor2 = 1'b1;

       /* small ALU */
       smallALUOperation = 4'b0011;
       muxAControlSmall = 1'b0; 
       muxBControlSmall = 1'b0;
       loadRegSmall = 1'b1;
       #1000

       Check1({resultadoFinal, 32'b00111111101000101011100011000010});

       $display("Teste 9 - teste do rounder com overflow");
       #10
       /* adicacao 2.49999976158 + 1.50000011921 */
       floatingPoint1 = 32'b0_10000000_00111111111111111111111;
       floatingPoint2 = 32'b0_01111111_10000000000000000000001;
       #10      
    
       /* sinal dos muxes */
       controlToMux01 = 1'b0; 
       controlToMux02 = 1'b0; 
       controlToMux03 = 1'b1;
       controlToMux04 = 1'b0;
       controlToMux05 = 1'b0;

        /* shifters */
       controlShiftRight = 8'b0000_0001;
       controlToIncreaseOrDecrease = 4'b0000;
       IncreaseOrDecreaseEnable = 1'b0;
       howManyToIncreaseOrDecrease = 8'd1;
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
       /* sinal dos muxes */
       controlToMux02 = 1'b1; 
       controlToMux05 = 1'b1; 

        /* shifters */
       IncreaseOrDecreaseEnable = 1'b1;
       howManyToIncreaseOrDecrease = 8'b1;
       rightOrLeft = 1'b1;
       howMany = 23'd1;
       #10
       Check1({resultadoFinal, 32'b01000000100000000000000000000000}); // 3.99999988079
       #10

       $display("Errors: %d", errors);
       $finish;

    end
endmodule