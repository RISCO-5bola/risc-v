module ALU_Control (
    input ALUOp1,
    input ALUOp0,
    input [4:0] funct,
    input [3:0] currentState,
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
     0111: shift left logical
     1000: shift right logical
     1001: shift right arithmetical



     adicionar outras
     */

    /* A operacao a ser feita pela ALU depende do 
       estado atual da Unidade de Controle e da operacao sendo
       feita.*/

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

    /* reconhece shift */
    wire slli;
    wire srli;
    wire srai;
    wire sll;
    wire srl;
    wire sra;
        
    wire WireState0;    
    wire WireState1;    
    wire WireState2;
    wire WireState3;    
    wire WireState4;    
    wire WireState5;    
    wire WireState6;    
    wire WireState7;
    wire WireState8;    
    wire WireState9;
    wire WireState10;
    wire WireState11;
    wire WireState12;
    wire WireState13;

    /* wires auxiliares */
    wire wire1;
    wire wire2;
    wire wire3;
    wire wire4;
    wire wire5;
    wire wire6;
    wire wire7;
    wire wire8;
    wire wire9;
    wire wire10;
    wire wire11;
    wire wire12;
    wire wire13;
    wire wire14;
    wire wire15;
    wire realizarSub;
    wire realizarOr;
    wire realizarAnd;
    wire realizarXor;
    wire realizarSlt;
    wire realizarSltu;
    wire realizarShiftLeftLogical;
    wire realizarShiftRightLogical;
    wire realizarShiftRightArith;

    // and (WireState0, ~currentState[3], ~currentState[2],
    //                  ~currentState[1], ~currentState[0]);
    // and (WireState1, ~currentState[3], ~currentState[2],
    //                  ~currentState[1], currentState[0]);
    // and (WireState2, ~currentState[3], ~currentState[2],
    //                  currentState[1], ~currentState[0]);
    // and (WireState3, ~currentState[3], ~currentState[2],
    //                  currentState[1], currentState[0]);
    // and (WireState4, ~currentState[3], currentState[2],
    //                  ~currentState[1], ~currentState[0]);
    // and (WireState5, ~currentState[3], currentState[2],
    //                  ~currentState[1], currentState[0]);
    and (WireState6, ~currentState[3], currentState[2],
                     currentState[1], ~currentState[0]);
    // and (WireState7, ~currentState[3], currentState[2],
    //                  currentState[1], currentState[0]);
    // and (WireState8, currentState[3], ~currentState[2],
    //                  ~currentState[1], ~currentState[0]);
    // and (WireState9, currentState[3], ~currentState[2],
    //                  ~currentState[1], currentState[0]);
    // and (WireState10, currentState[3], ~currentState[2],
    //                  currentState[1], ~currentState[0]);
    // and (WireState11, currentState[3], ~currentState[2],
    //                  currentState[1], currentState[0]);
    // and (WireState12, currentState[3], currentState[2],
    //                  ~currentState[1], ~currentState[0]);
    and (WireState13, currentState[3], currentState[2],
                      ~currentState[1], currentState[0]);
    and (WireState14, currentState[3], currentState[2],
                      currentState[1], ~currentState[0]);


    /* Reconhece instrucoes */
    
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

    /* verifica slli 0010011 + 001*/
    and (slli, ~opcode[6], ~opcode[5], opcode[4], ~opcode[3], ~opcode[2], opcode[1], opcode[0],
               ~funct[2], ~funct[1], funct[0]);

    /* verifica srli 0010011 + 0x101 */
    and (srli, ~opcode[6], ~opcode[5], opcode[4], ~opcode[3], ~opcode[2], opcode[1], opcode[0],
               ~funct[4], funct[2], ~funct[1], funct[0]);
    
    /* verifica srai 0010011 + 1x101*/
    and (srai, ~opcode[6], ~opcode[5], opcode[4], ~opcode[3], ~opcode[2], opcode[1], opcode[0],
               funct[4], funct[2], ~funct[1], funct[0]);
    
    /* verifica sll 0110011 + 001 */
    and (sll, opcode[6], ~opcode[5], opcode[4], ~opcode[3], ~opcode[2], opcode[1], opcode[0],
              ~funct[2], ~funct[1], funct[0]);
    
    /* verifica srl 0110011 + 0x101*/
    and (srl, opcode[6], ~opcode[5], opcode[4], ~opcode[3], ~opcode[2], opcode[1], opcode[0],
              ~funct[3], funct[2], ~funct[1], funct[0]);
    
    /* verifica sra 0110011 + 1x101 */
    and (sra, opcode[6], ~opcode[5], opcode[4], ~opcode[3], ~opcode[2], opcode[1], opcode[0],
              funct[3], funct[2], ~funct[1], funct[0]);
    
    /*
        Seta output da operacao
    */
    /* realizar sub */
    and (realizarSub, subR, WireState6);
    /* realizar xor */
    and (wire1, xori, WireState13);
    and (wire2, xorR, WireState6);
    or (realizarXor, wire1, wire2);
    /* realizar slt */
    and (wire3, slti, WireState13);
    and (wire4, slt, WireState6);
    or (realizarSlt, wire3, wire4);
    /* Realizar sltu */
    and (wire5, sltiu, WireState13);
    and (wire6, sltu, WireState6);
    or (realizarSltu, wire5, wire6);
    /* Realizar or */
    and (wire7, ori, WireState13);
    and (wire8, orR, WireState6);
    or (realizarOr, wire7, wire8);
    /* Realizar and */
    and (wire9, andi, WireState13);
    and (wire10, andR, WireState6);
    or (realizarAnd, wire9, wire10);

    /* Realizar shift left logical */
    and (wire11, slli, WireState13);
    and (wire12, sll, WireState6);
    or (realizarShiftLeftLogical, wire11, wire12);

    /* realizar shift right logical */
    and (wire13, srli, WireState13);
    and (wire14, srl, WireState6);
    or (realizarShiftRightLogical, wire13, wire14);

    /* realizar shift right arithmetical */
    and (wire15, srai, WireState13);
    and (wire16, sra, WireState6);
    or (realizarShiftRightArith, wire15, wire16);

    or (operation[3], realizarShiftRightLogical, realizarShiftRightArith);
    or (operation[2], realizarXor, realizarSlt, realizarSltu, realizarShiftLeftLogical);
    or (operation[1], WireState14, realizarSub, realizarSltu, realizarOr, realizarShiftLeftLogical);
    or (operation[0], WireState14, realizarSub, realizarSlt, realizarAnd, realizarShiftLeftLogical, realizarShiftRightArith);
endmodule
