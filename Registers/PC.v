`timescale 1ns/100ps
module PC(datain, dataout, enable, reset, clk);
    input [63:0] datain;       /*dados de entrada*/
    input clk, enable, reset;  /*sinais de controle*/
    output reg [63:0] dataout; /*dados de saida*/
    initial begin
        dataout = 64'd0;       /*inicializando a saida como zero*/
    end
    always @(posedge clk) begin
        if(reset == 1'b1) dataout = 64'd0;       /*reset ligado na subida do clock: a saida eh zerada*/
        else begin
            if(enable == 1'b1) dataout = datain; /*seta o valor da saida com a palavra de entrada*/
        end
    end
endmodule
