module mux6x1_1b(BEQ, BNE, BLT, BGE, BLTU, BGEU, funct3, selectedFlag);
 
input BEQ, BNE, BLT, BGE, BLTU, BGEU;
input [2:0] funct3;
output selectedFlag;

wire isBEQ, isBNE, isBLT, isBGE, isBLTU, isBGEU;

and (isBEQ, ~funct3[2], ~funct3[1], ~funct3[0], BEQ);
and (isBNE, ~funct3[2], ~funct3[1], funct3[0], BNE);
and (isBLT, funct3[2], ~funct3[1], ~funct3[0], BLT);
and (isBGE, funct3[2], ~funct3[1], funct3[0], BGE);
and (isBLTU, funct3[2], funct3[1], ~funct3[0], BLTU);
and (isBGEU, funct3[2], funct3[1], funct3[0], BGEU);

or (selectedFlag, isBEQ, isBNE, isBLT, isBGE, isBLTU, isBGEU);
endmodule