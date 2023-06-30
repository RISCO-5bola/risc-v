module TwosComplementToInt (
    input signed [63:0] TwosComplementValue,
    output [63:0] result 
);
    //definir um wire para o mux, identificando qual valor deve ser o resultado
    wire isNegative;
    assign isNegative = TwosComplementValue[63];

    wire [63:0] complementedToSum;
    assign complementedToSum = ~TwosComplementValue;
    wire [63:0] ComplementedIntValue;
    //somar 1 devido a complementação
    
    ALU soma1 (.A(complementedToSum), .B(64'b1), .ALUOp(4'b0000), 
                  .result(ComplementedIntValue));

    mux_2x1_64bit muxA1 (.A(TwosComplementValue), .B(ComplementedIntValue), 
                         .S(isNegative), .X(result)); 

endmodule