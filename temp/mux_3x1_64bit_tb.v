`timescale 1ns/1ns

module mux_3x1_64bit_tb;

    // Entradas
    reg [63:0] A, B, C;
    reg [1:0] S;

    wire [63:0] X;

    mux_3x1_64bit UUT (.A(A), .B(B), .C(C), .S(S), .X(X));

    initial begin
        $monitor ("[%t] A = %d B = %d C = %d S = %d X = %d", 
                  $time, A, B, C, S, X);

        // Inicializar os inputs 
        S <= 2'd3; 
        A <=64'd0; B <=64'd0; C <=64'd0;
        #100

        // Teste 1:
        S <= 2'd0;
        A <=64'd11; B <=64'd22; C <=64'd33; 
        // Q = 11
        #20

        // Teste 2:
        S <= 2'd1;
        A <=64'd11; B <=64'd22; C <=64'd33;
        // Q = 22
        #20

        // Teste 3: 
        S <= 2'd2;
        A <=64'd11; B <=64'd22; C <=64'd33;
        // Q = 33
        #20

        $finish;
    end
endmodule

