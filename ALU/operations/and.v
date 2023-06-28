/* modulo que faz comparação and entre dois numeros
   entre 64 bits */

module andModule (
    input [63:0] A,
    input [63:0] B,
    output [63:0] result
);
    and (result[0], A[0], B[0]);
    and (result[1], A[1], B[1]);
    and (result[2], A[2], B[2]);
    and (result[3], A[3], B[3]);
    and (result[4], A[4], B[4]);
    and (result[5], A[5], B[5]);
    and (result[6], A[6], B[6]);
    and (result[7], A[7], B[7]);
    and (result[8], A[8], B[8]);
    and (result[9], A[9], B[9]);
    and (result[10], A[10], B[10]);
    and (result[11], A[11], B[11]);
    and (result[12], A[12], B[12]);
    and (result[13], A[13], B[13]);
    and (result[14], A[14], B[14]);
    and (result[15], A[15], B[15]);
    and (result[16], A[16], B[16]);
    and (result[17], A[17], B[17]);
    and (result[18], A[18], B[18]);
    and (result[19], A[19], B[19]);
    and (result[20], A[20], B[20]);
    and (result[21], A[21], B[21]);
    and (result[22], A[22], B[22]);
    and (result[23], A[23], B[23]);
    and (result[24], A[24], B[24]);
    and (result[25], A[25], B[25]);
    and (result[26], A[26], B[26]);
    and (result[27], A[27], B[27]);
    and (result[28], A[28], B[28]);
    and (result[29], A[29], B[29]);
    and (result[30], A[30], B[30]);
    and (result[31], A[31], B[31]);
    and (result[32], A[32], B[32]);
    and (result[33], A[33], B[33]);
    and (result[34], A[34], B[34]);
    and (result[35], A[35], B[35]);
    and (result[36], A[36], B[36]);
    and (result[37], A[37], B[37]);
    and (result[38], A[38], B[38]);
    and (result[39], A[39], B[39]);
    and (result[40], A[40], B[40]);
    and (result[41], A[41], B[41]);
    and (result[42], A[42], B[42]);
    and (result[43], A[43], B[43]);
    and (result[44], A[44], B[44]);
    and (result[45], A[45], B[45]);
    and (result[46], A[46], B[46]);
    and (result[47], A[47], B[47]);
    and (result[48], A[48], B[48]);
    and (result[49], A[49], B[49]);
    and (result[50], A[50], B[50]);
    and (result[51], A[51], B[51]);
    and (result[52], A[52], B[52]);
    and (result[53], A[53], B[53]);
    and (result[54], A[54], B[54]);
    and (result[55], A[55], B[55]);
    and (result[56], A[56], B[56]);
    and (result[57], A[57], B[57]);
    and (result[58], A[58], B[58]);
    and (result[59], A[59], B[59]);
    and (result[60], A[60], B[60]);
    and (result[61], A[61], B[61]);
    and (result[62], A[62], B[62]);
    and (result[63], A[63], B[63]);

endmodule