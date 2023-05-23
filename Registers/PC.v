
module PC (
  clk, // sinal de clock
  load, // sinal de carga
  in_data, // entrada de dados
  out_data, // saída de dados
  reset
);
  parameter BITS = 64; // número de bits do registrador

  input clk, load, reset;
  input [BITS-1:0] in_data;
  output [BITS-1:0] out_data;

  initial begin
    register <= 64'd1023;
  end
  // número de bits do registrador

  reg [BITS-1:0] register; // registrador

  assign out_data = register; // saída dos dados registrados

  always @(posedge clk) begin
    if (reset == 1'b1) register <= 64'd1023;
    else if (load) // carga habilitada
      register <= in_data; // atualiza o valor do registrador
  end
endmodule
