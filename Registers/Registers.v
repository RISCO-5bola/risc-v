/*

Módulo: RegisterFile - serve de banco de registradores, totalmente parametrizável.
Parametros:
Q -> reflete a quantidade de registradores parametrizados incluidos

Este módulo é fortemente inspirado na implementação do grupo 40
*/

module RegisterFile (
    input [4:0] readRegister1,
    input [4:0] readRegister2,
    input [4:0] writeRegister, //SELECTOR
    input [63:0] writeData, 
    input regWrite, //ENABLE
    input clk,
    output [63:0] readData1,
    output [63:0] readData2
);

    wire [63:0] registerOut [31: 0]; //Q+1 registradores
    reg [31:0] write_enabler;
    integer i;

    initial begin
    write_enabler <= 32'b0; //inicia todos os wires
    end

    always @ (*) begin
        for(i = 0; i < 32; i = i + 1)
            write_enabler[i] <= 1'b0;
        if(regWrite == 1'b1) write_enabler[writeRegister] <= 1'b1;
    end

    //Criação do registrador de valor constante 0:
    reg_parametrizado R0 (.in_data(64'b0), .out_data(registerOut[0]), .load(1'b1), .clk(clk));

    //Todos os demais registradores do banco:
    genvar j;
    generate
        for(j = 1; j < 32; j = j+1) begin
            reg_parametrizado xI (.in_data(writeData), .out_data(registerOut[j]), .load(write_enabler[j]), .clk(clk));
        end
    endgenerate

    //Realizar o assign em todos os datas respectivos:
    assign readData1 = registerOut[readRegister1];
    assign readData2 = registerOut[readRegister2];

endmodule