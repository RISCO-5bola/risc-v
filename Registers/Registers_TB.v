`timescale 1ns/100ps
module Registers_tb () ;
    reg [4:0] readRegister1;
    reg [4:0] readRegister2;
    reg [4:0] writeRegister;
    reg [63:0] writeData;
    reg regWrite;
    reg clk;
    wire [63:0] readData1;
    wire [63:0] readData2;

    RegisterFile UUT (.readRegister1(readRegister1), .readRegister2(readRegister2), .writeRegister(writeRegister), 
                    .writeData(writeData), .regWrite(regWrite), .clk(clk), .readData1(readData1), .readData2(readData2));

    integer errors = 0;
    task Check ;
        input [63:0] expect1;
        input [63:0] expect2;

        if (readData1 !== expect1 || readData2 !== expect2) begin
                $display ("Error:\n readRegister1: %d\n readRegister2: %d\n expect1: %b\n got: %b\n expect2: %b\n got: %b", 
                readRegister1, readRegister2, expect1, readData1, expect2, readData2);
                errors = errors + 1;
        end
    endtask

        initial clk = 1'b0;
        always #5 clk = ~clk;

        initial begin
        /* nao deixa nenhum registrador ser escrito */
        regWrite = 1'b0;

        /* testa a leitura dos dois registradores
           1 e 2 */
        readRegister1 = 5'd1;
        readRegister2 = 5'd2;
        #10
        Check(64'dx, 64'dx);

        /* escreve nos dois primeiros registradores */
        regWrite = 1'b1;
        writeRegister = 5'd1;
        writeData = 64'd1;
        #10
        regWrite = 1'b1;
        writeRegister = 5'd2;
        writeData = 64'd1;
        #10
        /* verifica se a escrita foi um sucesso
           testando os dois primeiros registradores,
           infere-se que o restante esta correto */
        regWrite = 1'b0;
        Check(64'd1, 64'd1);

        $display (" Test ended , %2d errors ", errors );
        $finish;
        end
endmodule