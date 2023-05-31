module mux_3x1_1bit_tb ();
    reg [1:0] S;
    reg A, B, C;
    
    integer errors = 0;

    task Check;
        input [1:0] expect;
        if (expect[1] != expect[0]) begin
            $display("Got %d, expected %d", expect[1], expect[0]);
            errors = errors + 1;
        end
    endtask

    mux_3x1_1bit UUT (.A(A), .B(B), .C(C), .X(X), .S(S));

    initial begin
       #10
       S <= 2'b00; 
       #10
       A <= 1'b1; B <= 1'b0; C <= 1'b1;
       #10

       $display("Test saida A");
       S <= 2'b00;
       #10
       Check({X, A});
       #10

       $display("Test saida B");
       S = 2'b01;
       #10
       Check({X, B});
       #10
       
       $display("Test saida C");
       S = 2'b10;
       #10
       Check({X, C});
       #10

       $display("Errors: %d", errors);
       $finish;
       
    end
endmodule