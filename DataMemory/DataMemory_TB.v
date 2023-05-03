`timescale 1ns/1ns

module testbench ();
    reg clk;
    reg mem_read;
    reg mem_write;
    reg [7:0] endereco;
    reg [63:0] write_data;
    wire [63:0] read_data;

    data_memory UUT (.clk(clk), .mem_read(mem_read), .mem_write(mem_write), .endereco(endereco), .write_data(write_data), .read_data(read_data));

    // quando da write, ele ve se deu certo usando o read em seguida
    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end

    initial begin
        $monitor ("[%t] mem_write = %d endereco = %d write_data = %d, read_data = %d", 
                  $time, mem_write, endereco, write_data, read_data);

        // output 8
        mem_read <= 1'b1;
        mem_write <= 1'b0;
        endereco <= 8'd0;
        write_data <= 64'd0;

        #20

        // output 6
        endereco <= 8'd8;
        #20

        // output 16
        endereco <= 8'd16;
        #20

        mem_write <= 1'b1;
        #20


        // write 1
        endereco <= 8'd24;
        write_data <= 64'd11;
        #20

        // write 2
        endereco <= 8'd16;
        write_data <= 64'd22;
        #20

        mem_write <= 1'b0;
        #20

        // output 11
        endereco <= 8'd24;
        write_data <= 64'd0;
        #20

        // output 22
        endereco <= 8'd16;
        write_data <= 64'd0;
        #20

        $finish;

    end

endmodule