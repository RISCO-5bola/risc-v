module and_tb ();
    reg [63:0] A, B;
    wire [63:0] result;
    
    integer errors = 0;

    task Check;
        input [127:0] expect;
        if (expect[127:64] != expect[63:0]) begin
            $display("Got %d, expected %d", expect[127:64], expect[63:0]);
            errors = errors + 1;
        end
    endtask

    andModule UUT (.A(A), .B(B), .result(result));

    initial begin
       #10
       /* and entre d123 e d456 */
       $display("Test 0");
       A = 63'd123;
       B = 63'd456;
       #10
       Check({result, 64'd72});
       #10

       /* and entre -d1111 e d2222 */
       $display("Test 1");
       A = -63'd1111;
       B = 63'd2222;
       #10
       Check({result, 64'd2216});
       #10

       /* and entre -3333 e -4444 */
       $display("Test 2");
       A = -63'd3333;
       B = -63'd4444;
       #10
       Check({result, -64'd7520});

       $display("Errors: %d", errors);
       $finish;
       
    end
endmodule