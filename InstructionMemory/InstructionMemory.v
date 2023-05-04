`timescale 1ns/100ps

module InstructionMemory(
    input [63:0] PC,
    output [31:0] instruction
);
   reg [7:0] Memory [255:0];

   /*
    Memoria 64x32
    Neste caso, foi instanciado em bytes, por isso sao 256 posicoes
   */
   initial begin
     /* condicoes iniciais do datapath */
     Memory[0] = 8'b00000000;
     Memory[1] = 8'b00000001;
     Memory[2] = 8'b00000010;
     Memory[3] = 8'b00000100;
     Memory[4] = 8'b00000000;
     Memory[5] = 8'b00000001;
     Memory[6] = 8'b00000010;
     Memory[7] = 8'b00000100;
   end

   assign instruction = {Memory[PC+3], Memory[PC+2],
                         Memory[PC+1], Memory[PC+0]};
endmodule