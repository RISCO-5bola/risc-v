module rounder_tb ();
    reg [22:0] mantissa;
    wire [22:0] mantissaRounded;
    wire notNormalized;

    rounder UUT (.mantissa(mantissa), .mantissaRounded(mantissaRounded),
                 .notNormalized(notNormalized));

    integer errors;

    task Check;
        input [23:0] expect;

        if (expect !== {mantissaRounded, notNormalized}) begin
            $display("Error! Expected %b, got %b", expect, {mantissaRounded, notNormalized});
            errors = errors + 1;
        end else begin
            $display("passed!\n");
        end
    endtask

    initial begin
        errors = 0;
        $display("Case 1...");
        mantissa = 23'b0101000100111000111_0000;
        #10
        Check(24'b010100010011100011100000);

        $display("Case 2...");
        mantissa = 23'b0101000100111000111_1000;
        #10
        Check(24'b010100010011100100000000);

        $display("Case 3...");
        mantissa = 23'b1111111111111111111_1000;
        #10
        Check(24'b000000000000000000000001);

        $display("Case 4...");
        mantissa = 23'b1111111111111111110_1000;
        #10
        Check(24'b111111111111111111000000);

        $display("Case 5...");
        mantissa = 23'b1111111111111111110_1010;
        #10
        Check(24'b111111111111111111100000);

        $display("Case 6...");
        mantissa = 23'b1111111111111111111_1010;
        #10
        Check(24'b000000000000000000000001);

        $display("Case 7...");
        mantissa = 23'b0101000100111000111_0010;
        #10
        Check(24'b010100010011100011100000);

        $display("Test finished with %d errors.", errors);
        $finish;
    end
    
endmodule