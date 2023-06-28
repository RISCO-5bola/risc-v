module floating_point_uc (
    /* inputs padroes para control unit */
    input clk,
    input reset,
    input start,

    /* input para escolher qual a operação a ser feita */
    input [1:0] operation,

    /* estado do restante da FPU */
    input rouderOverflow,
    input expDifferencePos, 
    input [7:0] smallAluResult,
    input signalFP1,
    input signalFP2,
    input posFirst27posReferential,
    input posFirst28posReferential,

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
                howMany <= 23'd0; 
                howManyToIncreaseOrDecrease <= 8'd0; 
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
                controlToMux01 <= ~expDifferencePos; 
                controlToMux02 <= 1'b0;
                controlToMux03 <= expDifferencePos; 
                controlToMux04 <= ~expDifferencePos;
                controlToMux05 <= 1'b0;
                IncreaseOrDecreaseEnable <= 1'b1;
                controlShiftRight <= smallAluResult;
                smallALUOperation <= 4'b0011;
                controlToIncreaseOrDecrease <= {2'd0, expDifferencePos, expDifferencePos};
                muxBControlSmall <= 1'b0;
                muxAControlSmall <= 1'b0;
                sum_sub <= 1'b0;
                isSum <= 1'b1;
                muxDataRegValor2 <= 1'b0;
                rightOrLeft <= ~expDifferencePos;
                howMany <= posFirst27posReferential; 
                howManyToIncreaseOrDecrease <= posFirst28posReferential; 
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
                controlShiftRight <= smallAluResult;
                smallALUOperation <= 4'b0011;
                controlToIncreaseOrDecrease <= {2'd0, expDifferencePos, expDifferencePos};
                muxBControlSmall <= 1'b0;
                muxAControlSmall <= 1'b0;
                sum_sub <= 1'b0;
                isSum <= 1'b1;
                muxDataRegValor2 <= 1'b0;
                rightOrLeft <= 1'b1;
                howMany <= 23'd1; 
                howManyToIncreaseOrDecrease <= 8'd1; 
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
        end else begin
            currentState <= nextState;
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
                if (signalFP1 === signalFP2)
                    begin
                    nextState <= SUM_EQUAL_SIGNALS;
                    end else begin
                    /* implementar outras somas */
                    nextState <= IDLE;
                    end
            end else begin
                /* implementar multiplicação */
                nextState <= IDLE;
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
        end
    end
endmodule