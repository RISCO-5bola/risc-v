module storage_choose (
    input [63:0] writeData,
    input [2:0] funct3,
    output [63:0] dataToBeWritten
);
    /* Sinais para escolher a saida dos mux */
    wire [1:0] mux0choose;
    wire [1:0] mux1choose;
    wire [1:0] mux2choose;

    /* Sinais auxiliares */
    wire sb;
    wire sh;
    wire sw;

    /* Detecta cada uma das instrucoes */
    and (sb, ~funct3[2], ~funct3[1], ~funct3[0]);
    and (sh, ~funct3[2], ~funct3[1], funct3[0]);
    and (sw, ~funct3[2], funct3[1], ~funct3[0]);

    /* mux para montar a saida */
    mux_3x1_32bit mux0s (.A(writeData[63:32]), .B(32'd0), .S(mux0choose), .X(dataToBeWritten[63:32]));
    mux_3x1_16bit mux1s (.A(writeData[31:16]), .B(16'd0), .S(mux1choose), .X(dataToBeWritten[31:16]));
    mux_3x1_8bit mux2s (.A(writeData[15:8]), .B(8'd0), .S(mux2choose), .X(dataToBeWritten[15:8]));
    assign dataToBeWritten[7:0] = writeData[7:0];

    /* Sinais [1] para escolher a saida dos mux sempre e 0 */
    assign mux0choose[1] = 1'b0;
    assign mux1choose[1] = 1'b0;
    assign mux2choose[1] = 1'b0;

    /* Sinais [0] para escolher a saida dos mux dependendo da instrucao */
    or (mux0choose[0], sb, sh, sw);
    or (mux1choose[0], sb, sh);
    assign mux2choose[0] = sb;
    
endmodule