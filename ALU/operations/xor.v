/* modulo que faz um xor entre dois
   numeros de 64 bits */

module xorModule (
    input [63:0] A,
    input [63:0] B,
    output [63:0] result
);
    xor (result[0], A[0], B[0]);
    xor (result[1], A[1], B[1]);
    xor (result[2], A[2], B[2]);
    xor (result[3], A[3], B[3]);
    xor (result[4], A[4], B[4]);
    xor (result[5], A[5], B[5]);
    xor (result[6], A[6], B[6]);
    xor (result[7], A[7], B[7]);
    xor (result[8], A[8], B[8]);
    xor (result[9], A[9], B[9]);
    xor (result[10], A[10], B[10]);
    xor (result[11], A[11], B[11]);
    xor (result[12], A[12], B[12]);
    xor (result[13], A[13], B[13]);
    xor (result[14], A[14], B[14]);
    xor (result[15], A[15], B[15]);
    xor (result[16], A[16], B[16]);
    xor (result[17], A[17], B[17]);
    xor (result[18], A[18], B[18]);
    xor (result[19], A[19], B[19]);
    xor (result[20], A[20], B[20]);
    xor (result[21], A[21], B[21]);
    xor (result[22], A[22], B[22]);
    xor (result[23], A[23], B[23]);
    xor (result[24], A[24], B[24]);
    xor (result[25], A[25], B[25]);
    xor (result[26], A[26], B[26]);
    xor (result[27], A[27], B[27]);
    xor (result[28], A[28], B[28]);
    xor (result[29], A[29], B[29]);
    xor (result[30], A[30], B[30]);
    xor (result[31], A[31], B[31]);
    xor (result[32], A[32], B[32]);
    xor (result[33], A[33], B[33]);
    xor (result[34], A[34], B[34]);
    xor (result[35], A[35], B[35]);
    xor (result[36], A[36], B[36]);
    xor (result[37], A[37], B[37]);
    xor (result[38], A[38], B[38]);
    xor (result[39], A[39], B[39]);
    xor (result[40], A[40], B[40]);
    xor (result[41], A[41], B[41]);
    xor (result[42], A[42], B[42]);
    xor (result[43], A[43], B[43]);
    xor (result[44], A[44], B[44]);
    xor (result[45], A[45], B[45]);
    xor (result[46], A[46], B[46]);
    xor (result[47], A[47], B[47]);
    xor (result[48], A[48], B[48]);
    xor (result[49], A[49], B[49]);
    xor (result[50], A[50], B[50]);
    xor (result[51], A[51], B[51]);
    xor (result[52], A[52], B[52]);
    xor (result[53], A[53], B[53]);
    xor (result[54], A[54], B[54]);
    xor (result[55], A[55], B[55]);
    xor (result[56], A[56], B[56]);
    xor (result[57], A[57], B[57]);
    xor (result[58], A[58], B[58]);
    xor (result[59], A[59], B[59]);
    xor (result[60], A[60], B[60]);
    xor (result[61], A[61], B[61]);
    xor (result[62], A[62], B[62]);
    xor (result[63], A[63], B[63]);
endmodule