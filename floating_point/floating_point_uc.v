module floating_point_uc (
    /* inputs padroes para control unit */
    input clk,
    input reset,
    input start,

    /* input para escolher qual a operação a ser feita */
    input [1:0] operation,
    //00 -> soma; 01 -> multiplicação
    /* estado do restante da FPU */
    input rouderOverflow,
    input expDifferencePos, 
    input [7:0] smallAluResult,
    input signalFP1,
    input signalFP2,
    input [22:0] posFirst27posReferential,
    input [22:0] posFirst28posReferential,
    input doneMultiplication,

    /* sinal para o processador de que terminou a operação */
    output reg done,
    /* sinais de controle para o restante da FPU */
    output reg loadRegSmall,
    output reg controlToMux01, controlToMux02, controlToMux03, 
           controlToMux04, controlToMux05, IncreaseOrDecreaseEnable,
    output reg [7:0] controlShiftRight,
    output reg [3:0] smallALUOperation, controlToIncreaseOrDecrease,
    output reg regSmallALULoad, muxBControlSmall, muxAControlSmall,
    output reg sum_sub, isSum, muxDataRegValor2,
    output reg rightOrLeft,
    output reg [22:0] howMany, 
    output reg [7:0] howManyToIncreaseOrDecrease
);
    /* parametrização dos estados */
    /* FPU não está fazendo nenhuma operação */
    parameter IDLE = 5'b00000;
    /* guarda os inputs em registradores */
    parameter LOAD = 5'b00001;
    /* soma com dois sinais iguais */
    parameter SUM_EQUAL_SIGNALS = 5'b00010;
    /* estado para o caso no qual precisa normalizar novamente */
    parameter RE_NORMALIZE = 5'b00011;
    /* estado para a multiplicação de dois valores em floating point */
    parameter MULTIPLICATION = 5'b00100;

    /* registradores padrões para máquinas de estado */
    reg [4:0] currentState;
    reg [4:0] nextState;

    /* registrador para contar o tempo necessário para fazer uma operação */
    reg [4:0] counter;

    /* estado inicial da UC no IDLE */
    initial begin
        currentState = IDLE;
    end
    
    /* trata outputs dos sinais */
    always @(posedge clk) begin
        case (currentState)
            IDLE: begin
                done <= 1'b1;
                counter <= 5'd10;
                loadRegSmall <= 1'b0;
                controlToMux01 <= 1'b0; 
                controlToMux02 <= 1'b0;
                controlToMux03 <= 1'b0; 
                controlToMux04 <= 1'b0;
                controlToMux05 <= 1'b0;
                IncreaseOrDecreaseEnable <= 1'b0;
                controlShiftRight <= 8'd0;
                smallALUOperation <= 4'd0;
                controlToIncreaseOrDecrease <= 4'd0;
                regSmallALULoad <= 1'b0;
                muxBControlSmall <= 1'b0;
                muxAControlSmall <= 1'b0;
                sum_sub <= 1'b0;
                isSum <= 1'b0;
                muxDataRegValor2 <= 1'b0;
                rightOrLeft <= 1'b0;
                rightOrLeft <= posFirst28posReferential[22];
                howMany <= distancer27toTwoComplement;
            end 
            LOAD: begin
                done <= 1'b0;
                counter <= 5'd10;
                loadRegSmall <= 1'b0;
                controlToMux01 <= 1'b0; 
                controlToMux02 <= 1'b0;
                controlToMux03 <= 1'b0; 
                controlToMux04 <= 1'b0;
                controlToMux05 <= 1'b0;
                IncreaseOrDecreaseEnable <= 1'b0;
                controlShiftRight <= 8'd0;
                smallALUOperation <= 4'd0;
                controlToIncreaseOrDecrease <= 4'd0;
                regSmallALULoad <= 1'b0;
                muxBControlSmall <= 1'b0;
                muxAControlSmall <= 1'b0;
                sum_sub <= 1'b0;
                isSum <= 1'b0;
                muxDataRegValor2 <= 1'b0;
                rightOrLeft <= 1'b0;
                howMany <= 23'd0; 
                howManyToIncreaseOrDecrease <= 8'd0; 
            end
            SUM_EQUAL_SIGNALS: begin
                done <= 1'b0;
                counter <= counter - 1;
                loadRegSmall <= 1'b1;
                controlToMux01 <= expDifferencePos; 
                controlToMux02 <= 1'b0;
                controlToMux03 <= ~expDifferencePos; 
                controlToMux04 <= expDifferencePos;
                controlToMux05 <= 1'b0;
                IncreaseOrDecreaseEnable <= 1'b1;
                controlShiftRight <= smallAluResultInt[7:0];
                smallALUOperation <= 4'b0011;
                controlToIncreaseOrDecrease <= {2'd0, posFirst28posReferential[22], posFirst28posReferential[22]};
                muxBControlSmall <= 1'b0;
                muxAControlSmall <= 1'b0;
                sum_sub <= ^{signalFP1, signalFP2};
                isSum <= 1'b1;
                muxDataRegValor2 <= 1'b0;
                rightOrLeft <= posFirst28posReferential[22];
                howMany <= distancer28toTwoComplement; 
                howManyToIncreaseOrDecrease <= distancer27toTwoComplement; 
            end

            RE_NORMALIZE: begin
                done <= 1'b0;
                counter <= counter - 1;
                loadRegSmall <= 1'b1;
                controlToMux01 <= ~expDifferencePos; 
                controlToMux02 <= 1'b1;
                controlToMux03 <= expDifferencePos; 
                controlToMux04 <= ~expDifferencePos;
                controlToMux05 <= 1'b1;
                IncreaseOrDecreaseEnable <= 1'b1;
                controlShiftRight <= smallAluResultInt[7:0];
                smallALUOperation <= 4'b0011;
                controlToIncreaseOrDecrease <= {2'd0, posFirst28posReferential[22], posFirst28posReferential[22]};
                muxBControlSmall <= 1'b0;
                muxAControlSmall <= 1'b0;
                sum_sub <= 1'b0;
                isSum <= 1'b1;
                muxDataRegValor2 <= 1'b0;
                rightOrLeft <= 1'b1;
                howMany <= 23'd1; 
                howManyToIncreaseOrDecrease <= 8'd1; 
            end
            //Não testado, mas faz sentido.
            MULTIPLICATION:
            begin
                done <= 1'b0;
                //counter <= counter - 1;
                loadRegSmall <= 1'b1;
                controlToMux01 <= ~expDifferencePos; 
                controlToMux02 <= 1'b0;
                controlToMux03 <= 1'b0; //Seta o primeiro para o mux
                controlToMux04 <= 1'b1; //Seta o segundo para o mux
                controlToMux05 <= 1'b0; //Mandar o resultado da BIGALU para o shift left or right
                IncreaseOrDecreaseEnable <= 1'b0; //Não incrementar
                controlShiftRight <= smallAluResultInt[7:0]; //ADICIONAR O VALOR DA DISTÂNCIA PARA O BIT 
                smallALUOperation <= 4'b0000; //SOMAR OS EXPOENTES
                controlToIncreaseOrDecrease <= {2'd0, posFirst28posReferential[22], posFirst28posReferential[22]};
                muxBControlSmall <= 1'b1; //expoente
                muxAControlSmall <= 1'b1; //expoente //somados!
                sum_sub <= 1'b0;
                isSum <= 1'b0; //não é soma
                muxDataRegValor2 <= 1'b1; // Isso indica que é para somar;
                rightOrLeft <= posFirst28posReferential[22];
                howMany <= distancer28toTwoComplement; 
                howManyToIncreaseOrDecrease <= distancer27toTwoComplement; 
            end

            default: begin
                done <= 1'b0;
                counter <= counter - 1;
                loadRegSmall <= 1'b0;
                controlToMux01 <= 1'b0; 
                controlToMux02 <= 1'b0;
                controlToMux03 <= 1'b0; 
                controlToMux04 <= 1'b0;
                controlToMux05 <= 1'b0;
                IncreaseOrDecreaseEnable <= 1'b0;
                controlShiftRight <= 8'd0;
                smallALUOperation <= 4'd0;
                controlToIncreaseOrDecrease <= 4'd0;
                regSmallALULoad <= 1'b0;
                muxBControlSmall <= 1'b0;
                muxAControlSmall <= 1'b0;
                sum_sub <= 1'b0;
                isSum <= 1'b0;
                muxDataRegValor2 <= 1'b0;
                rightOrLeft <= 1'b0;
                howMany <= 23'd0; 
                howManyToIncreaseOrDecrease <= 8'd0; 
            end 
        endcase

        currentState <= nextState;
    end

    /* trata o sinal de reset na UC e seta próximo estado */
    always @(*) begin
        if (reset == 1'b1) begin
            currentState <= IDLE;
        end

        /* calcula próximo estado */
        if (currentState === IDLE) begin
            if (start == 1'b0) begin
                nextState <= IDLE;
            end else begin
                nextState <= LOAD;
            end
        end
        
        else if (currentState === LOAD) begin
            if (operation === 2'b00) begin
                nextState <= SUM_EQUAL_SIGNALS;
            end else begin
                /* implementar multiplicação */
                if (operation === 2'b01) begin
                nextState <= MULTIPLICATION;
                end
            end
    
        end else if(currentState === SUM_EQUAL_SIGNALS) begin
            if (counter === 5'd0) begin
                if (rouderOverflow === 1'b1) begin
                    nextState <= RE_NORMALIZE;
                end else begin
                    nextState <= IDLE;
                end
            end else begin
                nextState <= SUM_EQUAL_SIGNALS;
            end
        end else if (currentState === RE_NORMALIZE) begin
            nextState <= IDLE;

        /*Abaixo o caso da multiplicação:*/
        end else if(currentState === MULTIPLICATION) begin
            if (doneMultiplication === 1'b1) begin
                if (rouderOverflow === 1'b1) begin
                    nextState <= RE_NORMALIZE;
                end else begin
                    nextState <= IDLE;
                end
            end else begin
                nextState <= MULTIPLICATION;
            end
        end else if (currentState === RE_NORMALIZE) begin
            nextState <= IDLE;
        end
    end

    wire [63:0] distancer28toTwoComplement;
    wire [63:0] distancer27toTwoComplement;
    wire [63:0] smallAluResultInt;
   TwosComplementToInt toIntDistancer28 (.TwosComplementValue({{41{posFirst28posReferential[22]}}, posFirst28posReferential}), .result(distancer28toTwoComplement));
   TwosComplementToInt toIntDistancer27 (.TwosComplementValue({{41{posFirst27posReferential[22]}}, posFirst27posReferential}), .result(distancer27toTwoComplement));
   TwosComplementToInt toIntSmallAlu (.TwosComplementValue({{56{smallAluResult[7]}}, smallAluResult}), .result(smallAluResultInt));
    
endmodule