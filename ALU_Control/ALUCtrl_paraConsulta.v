module ALU_Control (
    input ALUOp1,
    input ALUOp0,
    input [4:0] funct,
    input [6:0] opcode,
    output [3:0] operation
);
    /*
     Operations:
     0000: add
     0001: and
     0010: or
     0011: sub
     
     implementar
     0100: xor
     0101: slt
     0110: sltiu (unsigned)



     adicionar outras
     */

     /*
        Falta reconhecer instrucoes slli, srli, srai, 
        sll, srl, sra, fence, ecall e ebreak
     */
    wire auipc;
    wire jal;
    wire jalr;
    wire btype;
    wire load;
    wire storage;
    wire addi;
    wire addR;
    wire subR;
    wire slti;
    wire slt;
    wire sltiu;
    wire sltu;
    wire xori;
    wire xorR;
    wire ori;
    wire orR;
    wire andi;
    wire andR;

    and (instrucao, opcode[6], opcode[5], opcode[4], opcode[3], opcode[2], opcode[1], opcode[0]);

    /* verifica AUIPC 0010111*/
    and (auipc, ~opcode[6], ~opcode[5], opcode[4], ~opcode[3], opcode[2], opcode[1], opcode[0]);

    /* verifica JAL 1101111 */
    and (jal, opcode[6], opcode[5], ~opcode[4], opcode[3], opcode[2], opcode[1], opcode[0]);
    
    /* verifica JALR 1100111 */
    and (jalr, opcode[6], opcode[5], ~opcode[4], ~opcode[3], opcode[2], opcode[1], opcode[0]);

    /* verifica tipo B 1100011 */
    and (btype, opcode[6], opcode[5], ~opcode[4], ~opcode[3], ~opcode[2], opcode[1], opcode[0]);
    
    /* verifica load 0000011 */
    and (load, ~opcode[6], ~opcode[5], ~opcode[4], ~opcode[3], ~opcode[2], opcode[1], opcode[0]);

    /* verifica storage 0100011 */
    and (storage, ~opcode[6], opcode[5], ~opcode[4], ~opcode[3], ~opcode[2], opcode[1], opcode[0]);
    
    /* verifica addi 0010011 + 000*/
    and (addi, ~opcode[6], ~opcode[5], opcode[4], ~opcode[3], ~opcode[2], opcode[1], opcode[0],
               ~funct[2], ~funct[1], ~funct[0]);
    
    /* verifica addR 0110011  + 00000*/
    and (addR, ~opcode[6], opcode[5], opcode[4], ~opcode[3], ~opcode[2], opcode[1], opcode[0],
               ~funct[4], ~funct[3], ~funct[2], ~funct[1], ~funct[0]);
    
    /* verifica subR 0110011 + 10000 */
    and (subR, ~opcode[6], opcode[5], opcode[4], ~opcode[3], ~opcode[2], opcode[1], opcode[0],
               funct[4], ~funct[3], ~funct[2], ~funct[1], ~funct[0]);

    /* verifica xori 0010011 + 100*/
    and (xori, ~opcode[6], ~opcode[5], opcode[4], ~opcode[3], ~opcode[2], opcode[1], opcode[0],
               funct[2], ~funct[1], ~funct[0]);
    
    /* verifica xor 0110011  + 0100*/
    and (xorR, ~opcode[6], opcode[5], opcode[4], ~opcode[3], ~opcode[2], opcode[1], opcode[0],
               ~funct[3], funct[2], ~funct[1], ~funct[0]);
    
    /* verifica slti 0010011 + 010 */
    and (slti, ~opcode[6], ~opcode[5], opcode[4], ~opcode[3], ~opcode[2], opcode[1], opcode[0],
               ~funct[2], funct[1], ~funct[0]);
    
    /* verifica slt 0110011 + 010 */
    and (slt, ~opcode[6], opcode[5], opcode[4], ~opcode[3], ~opcode[2], opcode[1], opcode[0],
               ~funct[3], ~funct[2], funct[1], ~funct[0]);

    /* verifica sltiu 0010011 + 011 */
    and (sltiu, ~opcode[6], ~opcode[5], opcode[4], ~opcode[3], ~opcode[2], opcode[1], opcode[0],
               ~funct[2], funct[1], funct[0]);
    
    /* verifica sltu 0110011 + 011 */
    and (sltu, ~opcode[6], opcode[5], opcode[4], ~opcode[3], ~opcode[2], opcode[1], opcode[0],
               ~funct[3], ~funct[2], funct[1], funct[0]);

    /* verifica ori 0010011 + 110*/
    and (ori, ~opcode[6], ~opcode[5], opcode[4], ~opcode[3], ~opcode[2], opcode[1], opcode[0],
               funct[2], funct[1], ~funct[0]);
    
    /* verifica or 0110011 + 0110*/
    and (orR, ~opcode[6], opcode[5], opcode[4], ~opcode[3], ~opcode[2], opcode[1], opcode[0],
               ~funct[3], funct[2], funct[1], ~funct[0]);

    /* verifica andi 0010011 + 111*/
    and (andi, ~opcode[6], ~opcode[5], opcode[4], ~opcode[3], ~opcode[2], opcode[1], opcode[0],
               funct[2], funct[1], funct[0]);
    
    /* verifica andR 0110011 + 0111*/
    and (andR, ~opcode[6], opcode[5], opcode[4], ~opcode[3], ~opcode[2], opcode[1], opcode[0],
               ~funct[3], funct[2], funct[1], funct[0]);

    /*
        Seta output da operacao
    */
    assign operation[3] = 0;
    or (operation[2], slti, sltiu, xori, slt, sltu, xorR);
    or (operation[1], btype, sltiu, ori, sub, orR);
    or (operation[0], btype, slti, andi, sub, slt, sltu, andR);
endmodule
