module IncreaseOrDecrease(
    input [7:0] valor1,
    input clk,
    input [7:0] howManyToIncreaseOrDecrease,
    output [7:0] result,
    input [3:0] ALUOp, //0000 para soma, 0011 para subtração 
    input enable //enable adicionados
);
    
    // initial begin
    //     $dumpfile("IncreaseOrDecrease.vcd");
    //     $dumpvars(0, IncreaseOrDecrease);
    // end
    
    wire [63:0] resultado1;
    wire [63:0] entrada_64b;
    wire [63:0] valueToIncreaseOrDecrease;
    //preencher de zeros antes de somar ou subtrair
    assign entrada_64b[7:0] = valor1;
    assign entrada_64b[63:8] = 56'b0;
    assign valueToIncreaseOrDecrease[7:0] = howManyToIncreaseOrDecrease;
    assign valueToIncreaseOrDecrease[63:8] = 56'b0;
  
    ALU IncreaseOrDescreaseALU (.A(entrada_64b), .B(valueToIncreaseOrDecrease), .ALUOp(ALUOp), 
                                .result(resultado1));

    mux_2x1_8bit mux1 (.A(valor1), .B(resultado1[7:0]), .S(enable), .X(result));

endmodule