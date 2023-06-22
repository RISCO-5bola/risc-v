module mux_2x1_28bit_tb ();
    reg S;
    reg [28:0] A, B;
    wire [28:0] X;
    
    integer errors = 0;

    task Check;
        input [56:0] expect;
        if (expect[56:28] != expect[27:0]) begin
            $display("Got %d, expected %d", expect[56:28], expect[27:0]);
            errors = errors + 1;
        end
    endtask

    mux_2x1_28bit UUT (.A(A), .B(B), .X(X), .S(S));

    initial begin
       #10
       S <= 2'b00; 
       A <= 7'd1; B <= 7'd2; 
       
       #10

       $display("Test saida A");
       S <= 2'b0;
       #10
       Check({X, A});
       #10

       $display("Test saida B");
       S = 2'b1;
       #10
       Check({X, B});
       #10

       $display("Errors: %d", errors);
       $finish;
       
    end
endmodule