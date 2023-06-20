`timescale  1ns / 100ps

module Adder64b_test ();
reg signed [63:0] A, B;
reg SUB;
wire signed [63:0] S;
wire COUT;

Adder64b_mod UUT (.A(A), .B(B), .SUB(SUB), .S(S), .COUT(COUT));

initial begin
        $monitor ("[%t] A = %d B = %d SUB = %d, S = %d, COUT = %d", 
                  $time, A, B, SUB, S, COUT);

        // Inicializar os inputs 
        SUB <= 0; 
        A <= 64'd0;
        B <= 64'd0;   
        #100

        // Teste 1: 5 + 4
        A <= 64'd5;
        B <= 64'd4;
        //resultado = 9
        #20

        // Teste 2: -11 + 9
        A <= -64'd11;
        B <= 64'd9;
        // resultado = -2
        #20

        // Teste 3: -110 - -33
        SUB <= 1;
        A <= -64'd110;
        B <= -64'd33;
        //resultado = -77
        #20

        // Teste 4: 53 - 47
        A <= 64'd53;
        B <= 64'd47;
        // resultado = 6
        #20

        $finish;
    end
endmodule