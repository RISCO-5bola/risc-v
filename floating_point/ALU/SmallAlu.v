module SmallAlu(
    input [7:0] valor1, valor2,
    input clk,
    output [7:0] result,
    input [3:0] ALUOp, //0000 para soma, 0011 para subtração 
    input muxA, muxB, loadReg
);

    initial begin
        $dumpfile("SmallAlu.vcd");
        $dumpvars(0, SmallAlu);
    end
    
    wire [63:0] complemento;
    wire [63:0] resultado;
    wire [63:0] resultado1;
    wire [63:0] muxAResult, muxBResult;
    assign complemento = 64'd127;
    wire [63:0] valor1_64b, valor2_64b;

    //preencher de zeros antes de somar ou subtrair
    assign valor1_64b[7:0] = valor1;
    assign valor2_64b[7:0] = valor2;
    assign valor1_64b[63:8] = 56'b0;
    assign valor2_64b[63:8] = 56'b0;
    
    //MULTIPLICACAO:
    //no primeiro ciclo, somar o expoente1 e o expoente2, salva no reg interno;
    //no segundo ciclo, soma o valor da operação anterior ao complemento;

    //SOMA:
    //subtrai o primeiro do segundo e fornece o resultado.

    mux_2x1_64bit muxA1 (.A(valor1_64b), .B(complemento), 
                         .S(muxA), .X(muxAResult)); 

    mux_2x1_64bit muxB1 (.A(valor2_64b), .B(resultado), 
                         .S(muxB), .X(muxBResult));

    ALU small1 (.A(muxBResult), .B(muxAResult), .ALUOp(ALUOp), 
                  .result(resultado1));

    reg_parametrizado_64b regSmallALUInterno (.clk(clk), .load(loadReg), .in_data(resultado1), 
                                   .out_data(resultado));

    assign result = resultado[7:0];

endmodule