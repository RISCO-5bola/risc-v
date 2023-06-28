/* modulo que faz um or entre dois numeros 
   de 64 bits */

module orModule (
    input [63:0] A,
    input [63:0] B,
    output [63:0] result
);
    or (result[0], A[0], B[0]);
    or (result[1], A[1], B[1]);
    or (result[2], A[2], B[2]);
    or (result[3], A[3], B[3]);
    or (result[4], A[4], B[4]);
    or (result[5], A[5], B[5]);
    or (result[6], A[6], B[6]);
    or (result[7], A[7], B[7]);
    or (result[8], A[8], B[8]);
    or (result[9], A[9], B[9]);
    or (result[10], A[10], B[10]);
    or (result[11], A[11], B[11]);
    or (result[12], A[12], B[12]);
    or (result[13], A[13], B[13]);
    or (result[14], A[14], B[14]);
    or (result[15], A[15], B[15]);
    or (result[16], A[16], B[16]);
    or (result[17], A[17], B[17]);
    or (result[18], A[18], B[18]);
    or (result[19], A[19], B[19]);
    or (result[20], A[20], B[20]);
    or (result[21], A[21], B[21]);
    or (result[22], A[22], B[22]);
    or (result[23], A[23], B[23]);
    or (result[24], A[24], B[24]);
    or (result[25], A[25], B[25]);
    or (result[26], A[26], B[26]);
    or (result[27], A[27], B[27]);
    or (result[28], A[28], B[28]);
    or (result[29], A[29], B[29]);
    or (result[30], A[30], B[30]);
    or (result[31], A[31], B[31]);
    or (result[32], A[32], B[32]);
    or (result[33], A[33], B[33]);
    or (result[34], A[34], B[34]);
    or (result[35], A[35], B[35]);
    or (result[36], A[36], B[36]);
    or (result[37], A[37], B[37]);
    or (result[38], A[38], B[38]);
    or (result[39], A[39], B[39]);
    or (result[40], A[40], B[40]);
    or (result[41], A[41], B[41]);
    or (result[42], A[42], B[42]);
    or (result[43], A[43], B[43]);
    or (result[44], A[44], B[44]);
    or (result[45], A[45], B[45]);
    or (result[46], A[46], B[46]);
    or (result[47], A[47], B[47]);
    or (result[48], A[48], B[48]);
    or (result[49], A[49], B[49]);
    or (result[50], A[50], B[50]);
    or (result[51], A[51], B[51]);
    or (result[52], A[52], B[52]);
    or (result[53], A[53], B[53]);
    or (result[54], A[54], B[54]);
    or (result[55], A[55], B[55]);
    or (result[56], A[56], B[56]);
    or (result[57], A[57], B[57]);
    or (result[58], A[58], B[58]);
    or (result[59], A[59], B[59]);
    or (result[60], A[60], B[60]);
    or (result[61], A[61], B[61]);
    or (result[62], A[62], B[62]);
    or (result[63], A[63], B[63]);
endmodule