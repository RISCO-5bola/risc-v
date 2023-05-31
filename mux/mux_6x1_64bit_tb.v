`timescale 1ns/1ns

module mux_6x1_64bit_tb;

    // Entradas
    reg [63:0] A, B, C, D, E, F;
    reg [2:0] S;

    wire [63:0] X;

    mux_6x1_64bit UUT (.A(A), .B(B), .C(C), .D(D), .E(E), .F(F), .S(S), .X(X));

    initial begin
        $monitor ("[%t] A = %d B = %d C = %d D = %d E = %d F = %d S = %d X = %d", 
                  $time, A, B, C, D, E, F, S, X);

        // Inicializar os inputs 
        S <= 3'd0; 
        A <= 64'd0; B <= 64'd0; C <= 64'd0;
        D <= 64'd0; E <= 64'd0; F <= 64'd0;
        #100

        // Teste 1:
        S <= 3'd0;
        A <= 64'd11; B <= 64'd22; C <= 64'd33;
        D <= 64'd44; E <= 64'd55; F <= 64'd66;  
        // Q = 11
        #20

        // Teste 2:
        S <= 3'd1;
        A <= 64'd11; B <= 64'd22; C <= 64'd33;
        D <= 64'd44; E <= 64'd55; F <= 64'd66;  
        // Q = 22
        #20

        // Teste 3: 
        S <= 3'd2;
        A <= 64'd11; B <= 64'd22; C <= 64'd33;
        D <= 64'd44; E <= 64'd55; F <= 64'd66;    
        // Q = 33
        #20

        // Teste 4: 
        S <= 3'd3;
        A <= 64'd11; B <= 64'd22; C <= 64'd33;
        D <= 64'd44; E <= 64'd55; F <= 64'd66;     
        // Q = 44
        #20

        // Teste 5: 
        S <= 3'd4;
        A <= 64'd11; B <= 64'd22; C <= 64'd33;
        D <= 64'd44; E <= 64'd55; F <= 64'd66;     
        // Q = 55
        #20

        // Teste 6: 
        S <= 3'd5;
        A <= 64'd11; B <= 64'd22; C <= 64'd33;
        D <= 64'd44; E <= 64'd55; F <= 64'd66;     
        // Q = 66
        #20;
    end
endmodule

