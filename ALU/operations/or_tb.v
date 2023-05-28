module or_tb ();
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

    orModule UUT (.A(A), .B(B), .result(result));

    initial begin
       #10
       $display("Test 0");
       A = 63'd123;
       B = 63'd456;
       #10
       Check({result, 64'd507});
       #10

       $display("Test 1");
       A = -63'd1111;
       B = 63'd2222;
       #10
       Check({result, -64'd1105});
       #10

       $display("Test 2");
       A = -63'd3333;
       B = -63'd4444;
       #10
       Check({result, -64'd257});
       #10

       $display("Errors: %d", errors);
       $finish;
       
    end
endmodule