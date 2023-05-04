module data_memory(input clk,      
                   input mem_read,
                   input mem_write,
                   input [7:0] endereco, //saida da ula
                   input [63:0] write_data, //data out b
                   output reg [63:0] read_data // write data
                   );
   reg [7:0] endereco_atual;
   reg [7:0] Memory [255:0];

   /*
    Memoria 64x32
    Neste caso, foi instanciado em bytes, por isso sao 256 posicoes
   */
   initial begin
     /* condicoes iniciais do datapath */
     /* soh ilustrativo */
     Memory[0] = 8'd0;
     Memory[1] = 8'd0;
     Memory[2] = 8'd0;
     Memory[3] = 8'd0;
     Memory[4] = 8'd0;
     Memory[5] = 8'd0;
     Memory[6] = 8'd0;
     Memory[7] = 8'd8;
     
     Memory[8] = 8'd0;
     Memory[9] = 8'd0;
     Memory[10] = 8'd0;
     Memory[11] = 8'd0;
     Memory[12] = 8'd0;
     Memory[13] = 8'd0;
     Memory[14] = 8'd0;
     Memory[15] = 8'd6;
     
     Memory[16] = 8'd0;
     Memory[17] = 8'd0;
     Memory[18] = 8'd0;
     Memory[19] = 8'd0;
     Memory[20] = 8'd0;
     Memory[21] = 8'd0;
     Memory[22] = 8'd0;
     Memory[23] = 8'd16;
   end
   
   //  assincrono
   always @(posedge clk, endereco, mem_write) begin
        endereco_atual = endereco;

        if (mem_read == 1) begin //read_data = Memory[atual:atual+7]
          read_data = {Memory[endereco_atual], Memory[endereco_atual + 1], 
                       Memory[endereco_atual + 2], Memory[endereco_atual + 3],
                       Memory[endereco_atual + 4], Memory[endereco_atual + 5], 
                       Memory[endereco_atual + 6], Memory[endereco_atual + 7]};  
        end
   end  
   
   // sincrono
   always @(posedge clk, mem_write) begin
        endereco_atual <= endereco[7:0];
        
        if (mem_write == 1) begin
          Memory[endereco_atual + 7] <= write_data[7:0];
          Memory[endereco_atual + 6] <= write_data[15:8];
          Memory[endereco_atual + 5] <= write_data[23:16];
          Memory[endereco_atual + 4] <= write_data[31:24];
          Memory[endereco_atual + 3] <= write_data[39:32];
          Memory[endereco_atual + 2] <= write_data[47:40];
          Memory[endereco_atual + 1] <= write_data[55:48];
          Memory[endereco_atual] <= write_data[63:56];
        end
   end      
endmodule