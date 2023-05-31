module mux_7x1_64bit_tb ();
    reg [2:0] S;
    reg [63:0] A, B, C, D, E, F, G;
    wire [63:0] X;
    
    integer errors = 0;

    task Check;
        input [127:0] expect;
        if (expect[127:64] != expect[63:0]) begin
            $display("Got %d, expected %d", expect[127:64], expect[63:0]);
            errors = errors + 1;
        end
    endtask

    mux_7x1_64bit UUT (.A(A), .B(B), .C(C), .D(D), .E(E), .F(F), 
                            .G(G), .X(X), .S(S));

    initial begin
       #10
       S <= 3'b000; 
       #10
       A <= 64'd1; B <= 64'd2; C <= 64'd3; D <= 64'd4; 
       E <= 64'd5; F <= 64'd6; G <= 64'd7; 
       
       #10

       $display("Test saida A");
       S <= 3'b000;
       #10
       Check({X, A});
       #10

       $display("Test saida B");
       S = 3'b001;
       #10
       Check({X, B});
       #10
       
       $display("Test saida C");
       S = 3'b010;
       #10
       Check({X, C});
       #10

       $display("Test saida D");
       S = 3'b1011;
       #10
       Check({X, A});
       #10

       $display("Test saida E");
       S = 4'b0100;
       #10
       Check({X, E});
       #10

       $display("Test saida F");
       S = 3'b101;
       #10
       Check({X, F});
       #10

       $display("Test saida G");
       S = 3'b110;
       #10
       Check({X, G});
       #10

       $display("Errors: %d", errors);
       $finish;
       
    end
endmodule