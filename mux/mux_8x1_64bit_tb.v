module mux_8x1_64bit_tb ();
    reg [3:0] S;
    reg [63:0] A, B, C, D, E, F, G, H, I;
    wire [63:0] X;
    
    integer errors = 0;

    task Check;
        input [127:0] expect;
        if (expect[127:64] != expect[63:0]) begin
            $display("Got %d, expected %d", expect[127:64], expect[63:0]);
            errors = errors + 1;
        end
    endtask

    mux_8x1_64bit UUT (.A(A), .B(B), .C(C), .D(D), .E(E), .F(F), 
                       .G(G),, .H(H), .I(I), .X(X), .S(S));

    initial begin
       #10
       S <= 4'b0000; 
       #10
       A <= 64'd1; B <= 64'd2; C <= 64'd3; D <= 64'd4; 
       E <= 64'd5; F <= 64'd6; G <= 64'd7; H <= 64'd8; 
       I <= 64'd9; 
       
       #10

       $display("Test saida A");
       S <= 4'b0000;
       #10
       Check({X, A});
       #10

       $display("Test saida B");
       S = 4'b0001;
       #10
       Check({X, B});
       #10
       
       $display("Test saida C");
       S = 4'b0010;
       #10
       Check({X, C});
       #10

       $display("Test saida D");
       S = 4'b0011;
       #10
       Check({X, D});
       #10

       $display("Test saida E");
       S = 4'b0100;
       #10
       Check({X, E});
       #10

       $display("Test saida F");
       S = 4'b0101;
       #10
       Check({X, F});
       #10

       $display("Test saida G");
       S = 4'b0110;
       #10
       Check({X, G});
       #10

       $display("Test saida H");
       S = 4'b0111;
       #10
       Check({X, G});
       #10

       $display("Test saida I");
       S = 4'b1000;
       #10
       Check({X, G});
       #10

       $display("Errors: %d", errors);
       $finish;
       
    end
endmodule