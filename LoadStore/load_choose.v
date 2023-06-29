module load_choose (
    input [63:0] dataReadFromMemory,
    input [6:0] opcode,
    input [2:0] funct3,
    output [63:0] writeDataReg
);

 wire [1:0] mux0;
 wire [1:0] mux1;
 wire [1:0] mux2;
 wire [1:0] muxSign;
 wire sign;
 wire isLType;

 /* wires auxiliares */
 wire wire1;
 wire wire2;
 wire wire3;
 wire wire4;
 wire wire5;
 wire wire6;
 wire wire7;
 wire wire8;

 /* Verifica se a instrucao e um load */
 and (isLType, ~opcode[6], ~opcode[5], ~opcode[4], ~opcode[3], ~opcode[2], opcode[1], opcode[0]);

 /* mux 32 bits HIGH do dado a ser escrito */
 mux_3x1_32bit mux_0 (.C({sign, sign, sign, sign, sign, sign, sign, sign, sign,
                         sign, sign, sign, sign, sign, sign, sign, sign, sign,
                         sign, sign, sign, sign, sign, sign, sign, sign, sign,
                         sign, sign, sign, sign, sign}),
                     .B(32'd0), .A(dataReadFromMemory[63:32]), .S(mux0), .X(writeDataReg[63:32]));
 /* mux 16 bits HIGH da parte LOW dado a ser escrito */
 mux_3x1_16bit mux_1 (.C({sign, sign, sign, sign, sign, sign, sign, sign, sign,
                         sign, sign, sign, sign, sign, sign, sign}),
                     .B(16'd0), .A(dataReadFromMemory[31:16]), .S(mux1), .X(writeDataReg[31:16]));
 /* mux 8 bits HIGH da parte LOW da parte LOW dado a ser escrito */
 mux_3x1_8bit mux_2 (.C({sign, sign, sign, sign, sign, sign, sign, sign}),
                     .B(8'd0), .A(dataReadFromMemory[15:8]), .S(mux2), .X(writeDataReg[15:8]));
 
 /* primeiros 8 bits do dado a ser escrito*/
 assign writeDataReg[7:0] = dataReadFromMemory[7:0];

 /* mux para setar o sign */
 mux_3x1_1bit mux_sign (.A(dataReadFromMemory[7]), .B(dataReadFromMemory[15]),
                        .C(dataReadFromMemory[31]), .S(muxSign), .X(sign));
 
 /* logica para cada um dos mux */
 /* muxSign */
 and (muxSign[1], ~funct3[2], funct3[1], ~funct3[0]);
 and (muxSign[0], ~funct3[2], ~funct3[1], funct3[0]);

 /* mux0 */
 and (wire1, isLType, ~funct3[2], ~funct3[1], ~funct3[0]);
 and (wire2, isLType, ~funct3[2], ~funct3[1], funct3[0]);
 and (wire3, isLType, ~funct3[2], funct3[1], ~funct3[0]);
 or (mux0[1], wire1, wire2, wire3);

 and (wire4, isLType, funct3[2], ~funct3[1], ~funct3[0]);
 and (wire5, isLType, funct3[2], ~funct3[1], funct3[0]);
 and (wire6, isLType, funct3[2], funct3[1], ~funct3[0]);
 or (mux0[0], wire4, wire5, wire6);

 /* mux1 */
 and (wire7, isLType, ~funct3[2], ~funct3[1], ~funct3[0]);
 and (wire8, isLType, ~funct3[2], ~funct3[1], funct3[0]);
 or (mux1[1], wire7, wire8);

 and (wire9, isLType, funct3[2], ~funct3[1], ~funct3[0]);
 and (wire10, isLType, funct3[2], ~funct3[1], funct3[0]);
 or (mux1[0], wire9, wire10);

 /* mux2 */
 and (mux2[1], isLType, ~funct3[2], ~funct3[1], ~funct3[0]);
 and (mux2[0], isLType, funct3[2], ~funct3[1], ~funct3[0]);
 
endmodule