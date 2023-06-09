`timescale 1ns/1ns

module reg_parametrizado_tb;

    // Entradas
    reg [63:0] in_data;
    reg load, clk;

    wire [63:0] out_data;

    reg_parametrizado UUT (.in_data(in_data), .out_data(out_data), .load(load), .clk(clk));

    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end

    initial begin
        $monitor ("[%t] clk = %d in_data = %d out_data = %d load = %d", 
                  $time, clk, in_data, out_data, load);

        // Inicializar os inputs 
        load <= 0; 
        in_data <= 64'd0;  
        #100

        // Teste 1: 5
        load <= 1;
        in_data <= 64'd5;       

        // Teste 2: 11
        in_data <= 64'd11;        
        #20

        // Teste 3: 111
        in_data <= 64'd111;
        #20

        // Teste 4: 53
        in_data <= 64'd53;
        #20

        $finish;
    end
endmodule

