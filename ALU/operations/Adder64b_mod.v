/* Módulo responsável por adicionar dois números de 32 bits, A e B.
A soma sai na saída S e o carry out dela no COUT.
O sinal SUB, quando igual a 1, indica que será realizada uma operação de subtração (A - B)
Na subtração, é usado o complemento de 2, complementando B e somando 1 (diretamente no CIN da primeira soma)

Somador composto por 4 módulos de Carry Look-Ahead Adders de 8 bits cada, totalizando 32 bits.
*/

`include "CLAAdder8b_mod.v"

module Adder64b_mod (
    input signed [63:0] A, B,
    input SUB,
    output COUT,
    output signed [63:0] S
);
    wire [63:0] C;
    wire C1, C2, C3, C4, C5, C6, C7;

    /* XOR entre cada bit de B e o SUB, responsável por complementar B caso SUB = 1*/
    assign C = B ^ {64{SUB}};

    /* Sequencia de Carry Look-Ahead Adders de 8 bits, interligados de modo Ripple Carry */
    CLAAdder8b U7_0 (.A(A[7:0]), .B(C[7:0]), .CIN(SUB), .S(S[7:0]), .COUT(C1)); // Sinal SUB ligado diretamente no CIN, para somar 1 do 2's complement caso SUB = 1 
    CLAAdder8b U15_8 (.A(A[15:8]), .B(C[15:8]), .CIN(C1), .S(S[15:8]), .COUT(C2));
    CLAAdder8b U23_16 (.A(A[23:16]), .B(C[23:16]), .CIN(C2), .S(S[23:16]), .COUT(C3));
    CLAAdder8b U31_24 (.A(A[31:24]), .B(C[31:24]), .CIN(C3), .S(S[31:24]), .COUT(C4));
    CLAAdder8b U39_32 (.A(A[39:32]), .B(C[39:32]), .CIN(C4), .S(S[39:32]), .COUT(C5));
    CLAAdder8b U47_40 (.A(A[47:40]), .B(C[47:40]), .CIN(C5), .S(S[47:40]), .COUT(C6));
    CLAAdder8b U55_48 (.A(A[55:48]), .B(C[55:48]), .CIN(C6), .S(S[55:48]), .COUT(C7));
    CLAAdder8b U63_56 (.A(A[63:56]), .B(C[63:56]), .CIN(C7), .S(S[63:56]), .COUT(COUT));
        
endmodule