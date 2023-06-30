module BigALU (
    input isSum,
    input sum_sub,
    input reset,
    input clk,
    input muxDataRegValor2,
    input wire [27:0] valor1,
    input wire [27:0] valor2,
    output finishedMult,
    output reg [63:0] result
    );

    // initial begin
    //             $dumpfile("wave.vcd");
    //             $dumpvars(0, BigALU);
    //         end
    
    wire [63:0] resultFromAdder;
    wire [63:0] input1Adder;
    wire [63:0] input2Adder;
    wire [63:0] fromMux03ToRegValor2;
    wire [63:0] outputFromShiftRight;

    wire [63:0] outputAdder1;
    wire [63:0] outputAdder2;

    wire sumValor1orZero;

    reg [63:0] regValor2;

    mux_2x1_64bit mux01BigAlu(.A({36'd0, valor1}), .B(64'd0), .S(sumValor1orZero), .X(input1Adder));
    mux_2x1_64bit mux02BigAlu(.A(regValor2), .B(fromRegResult), .S(~isSum), .X(input2Adder));
    mux_2x1_64bit mux03BigAlu(.A({36'd0, valor2}), .B(outputFromShiftRight), .S(muxDataRegValor2), .X(fromMux03ToRegValor2));

    Adder64b_mod adderAdd (.A(input1Adder), .B(input2Adder), .SUB(sum_sub), .S(outputAdder1));
    Adder64b_mod adderSub (.A(input2Adder), .B(input1Adder), .SUB(sum_sub), .S(outputAdder2));
    
    assign resultFromAdder = sum_sub ? outputAdder2 : outputAdder1;

    /* wire para retroalimentar o circuito com o resultado atual */
    wire [63:0] fromRegResult;
    assign fromRegResult = result;

    /* na multiplicacao, retroalimentação com B shiftado
       quando B[0] == 1, soma result + A
       quando B[0] == 0, soma result + 0 */
    assign outputFromShiftRight = regValor2 >> 1'b1;

    and (sumValor1orZero, (~|regValor2) | ~regValor2[0], ~isSum);
    
    assign finishedMult = ~| regValor2;

    /* atualiza o resultado a cada clock */
    always @(posedge clk) begin
        regValor2 <= fromMux03ToRegValor2;
        if (reset) begin
            result <= 64'd0;
        end else if (~finishedMult) begin
            result <= resultFromAdder;
        end
    end
endmodule