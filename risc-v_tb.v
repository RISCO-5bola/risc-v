`timescale 1ns/1ns

module riscv_tb ();
    reg clk, reset;
    riscv UUT(.clk(clk), .reset(reset));

    initial begin
        clk = 0;
        reset = 0;
    end

    always #5 clk = ~clk;

    initial begin
        #2
        reset = 1'b1;
        #3
        reset = 1'b0;
        #4000
        $finish;
    end
endmodule