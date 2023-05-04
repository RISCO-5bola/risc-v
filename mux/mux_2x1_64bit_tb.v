`timescale 1ns/1ns

module mux_2x1_64bit_tb;

    // Entradas
    reg [63:0] A, B;
    reg S;

    wire [63:0] X;

    mux_2x1_64bit UUT (.A(A), .B(B), .S(S), .X(X));

    initial begin
        $monitor ("[%t] A = %d, B = %d, S = %d, X = %d", 
                  $time, A, B, S, X);

        // Inicializar os inputs 
        S <= 1'd0; 
        A <= 64'd0; 
        B <= 64'd0; 
        #100

        // Teste 1:
        S <= 1'd0;
        A <= 64'd11; 
        B <= 64'd22;
        // Q = 11
        #20

        // Teste 2:
        S <= 1'd1;
        A <= 64'd11; 
        B <= 64'd22;   
        // Q = 22
        #20

        // Teste 3: 
        S <= 1'd0;
        A <= 64'd33;
        B <= 64'd44;   
        // Q = 33
        #20

        // Teste 4: 
        S <= 1'd1;
        A <= 64'd33; 
        B <= 64'd44;
        // Q = 44 
        #20

        // Teste 5: 
        S <= 1'd0;
        A <= 64'd55; 
        B <= 64'd66;     
        // Q = 55
        #20

        // Teste 6: 
        S <= 1'd1;
        A <= 64'd55; 
        B <= 64'd66;     
        // Q = 66
        #20

        $finish;
    end
endmodule

