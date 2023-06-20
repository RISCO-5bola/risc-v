module mux_2x1_8bit_tb ();
    reg S;
    reg [7:0] A, B, C;
    wire [7:0] X;
    
    integer errors = 0;

    task Check;
        input [15:0] expect;
        if (expect[15:8] != expect[7:0]) begin
            $display("Got %d, expected %d", expect[15:8], expect[7:0]);
            errors = errors + 1;
        end
    endtask

    mux_2x1_8bit UUT (.A(A), .B(B), .X(X), .S(S));

    initial begin
       #10
       S <= 2'b00; 
       A <= 7'd1; B <= 7'd2; 
       
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

       $display("Errors: %d", errors);
       $finish;
       
    end
endmodule