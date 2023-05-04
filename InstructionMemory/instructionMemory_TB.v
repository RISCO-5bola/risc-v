`timescale 1ns/100ps

/* 
    Testes feitos antes das condições iniciais do EP.
    Foi verificada a capacidade da instruction memory de retornar o valor adequado
    dependendo do valor do PC. Muito parecido com o que foi feito na Memoria de Dados.
*/

module testbench ();
    reg [63:0] PC;
    wire [31:0] instruction;

    InstructionMemory UUT (.PC(PC), .instruction(instruction));

    integer i, errors = 0, j;
    task Check ;
        input [31:0] expect;
        if (instruction !== expect) begin
                $display ("Error : PC: %d expect: %b got: %b", PC, expect, instruction);
                errors = errors + 1;
        end
    endtask

    initial begin
        /* Testa os resultados em uma Memoria de Instrucoes baseada em uma memoria
           hipotetica com posicao 0 valendo 32'b01000000000000000000000000110011,
           1 valendo 32'b00000000000000000010000010000011 e 2 valendo
           32'b00000000000000000000000001100011. O restante e nula */
        PC = 64'd0;
        #10
        Check(32'b00000100_00000010_00000001_00000000);
        PC = 64'd4;
        #10
        Check(32'b00000100_00000010_00000001_00000000);

        $display("Test finished. Erros: %d", errors);
    end
endmodule
