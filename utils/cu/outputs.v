module outputs (
    input [4:0] StateRegister,
    output PCWrite, output PCWriteCond, output IorD,
    output MemRead, output MemWrite, output IRWrite,
    output MemtoReg, output PCSource1, output PCSource0,
    output ALUOp1,output ALUOp0, output ALUSrcB1,
    output ALUSrcB0, output [1:0] ALUSrcA, output RegWrite,
    output RegDst
);
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
    wire WireState14;
    wire WireState15;

    /* vai para o state 1 */
    and (WireState0, ~StateRegister[4], ~StateRegister[3], ~StateRegister[2],
                     ~StateRegister[1], ~StateRegister[0]);

    /* vai para os states 2(lw, sw), 6(r), 8(b), 
       9(jal, I-jalr), 13(I-addi), 15(U-lui) */                     
    and (WireState1, ~StateRegister[4], ~StateRegister[3], ~StateRegister[2],
                     ~StateRegister[1], StateRegister[0]);

    /* vai para os states 3(lw) e 5(sw) */                     
    and (WireState2, ~StateRegister[4], ~StateRegister[3], ~StateRegister[2],
                     StateRegister[1], ~StateRegister[0]);

    /* vai para o state 4 */                     
    and (WireState3, ~StateRegister[4], ~StateRegister[3], ~StateRegister[2],
                     StateRegister[1], StateRegister[0]);
           
    and (WireState4, ~StateRegister[4], ~StateRegister[3], StateRegister[2],
                     ~StateRegister[1], ~StateRegister[0]);
    and (WireState5, ~StateRegister[4], ~StateRegister[3], StateRegister[2],
                     ~StateRegister[1], StateRegister[0]);

    /* vai para o state 7 */                     
    and (WireState6, ~StateRegister[4], ~StateRegister[3], StateRegister[2],
                     StateRegister[1], ~StateRegister[0]);
    
    and (WireState7, ~StateRegister[4], ~StateRegister[3], StateRegister[2],
                     StateRegister[1], StateRegister[0]);
    
    /* vai para o state 14(b) */
    and (WireState8, ~StateRegister[4], StateRegister[3], ~StateRegister[2],
                     ~StateRegister[1], ~StateRegister[0]);

    /* vai par o state 10(jal) e 12(I-jalr) */                     
    and (WireState9, ~StateRegister[4], StateRegister[3], ~StateRegister[2],
                     ~StateRegister[1], StateRegister[0]);
                     
    and (WireState10, ~StateRegister[4], StateRegister[3], ~StateRegister[2],
                     StateRegister[1], ~StateRegister[0]);

    /* vai para o state 7(u-auipc) */                     
    and (WireState11, ~StateRegister[4], StateRegister[3], ~StateRegister[2],
                     StateRegister[1], StateRegister[0]);
    and (WireState12, ~StateRegister[4], StateRegister[3], StateRegister[2],
                     ~StateRegister[1], ~StateRegister[0]);
    and (WireState13, ~StateRegister[4], StateRegister[3], StateRegister[2],
                      ~StateRegister[1], StateRegister[0]);
    and (WireState14, ~StateRegister[4], StateRegister[3], StateRegister[2],
                      StateRegister[1], ~StateRegister[0]);

    /* vai para o state 7(u-lui) */                      
    and (WireState15, ~StateRegister[4], StateRegister[3], StateRegister[2],
                      StateRegister[1], StateRegister[0]);

    /* seta o PCWrite nos estados 0, 10 e 12 */
    or (PCWrite, WireState0, WireState10, WireState12);

    /* seta o PCWriteCond no estado 14 */
    assign PCWriteCond = WireState14;

    /* seta o IorD nos estados 3 e 5 */
    or (IorD, WireState3, WireState5);

    /* seta o MemRead nos estados 0, 3, 9, 11, 12 e 15 */
    or (MemRead, WireState0, WireState3, WireState9, WireState11, WireState12, WireState15);
    
    /* seta o MemWrite no estado 5 */
    assign MemWrite = WireState5;

    /* seta o IRWrite no estado 0 */
    assign IRWrite = WireState0;

    /* seta o MemReg no estado 4 */
    assign MemtoReg = WireState4;

    /* seta o PCSource1 no estado 9 */
    assign PCSource1 = WireState9;

    /* seta o PCSource0 no estado 14 */
    assign PCSource0 = WireState14;

    /* seta o ALUOp1 nos estados 6 e 13 */
    or (ALUOp1, WireState6, WireState13);

    /* seta o ALUOp0 no estado 8 */
    assign ALUOp0 = WireState8;

    /* seta o ALUSrcB1 nos estados 1, 2, 8, 9, 10, 11, 12, 13 e 15 */
    or (ALUSrcB1, WireState2, WireState1, WireState10, WireState8, WireState9, WireState11, WireState12, WireState13, WireState15);

    /* seta o ALUSrcB0 nos estados 0, 1 e 9 */
    or (ALUSrcB0, WireState0, WireState1, WireState9);

    /* seta o ALUSrcA[1] no estado 15 */
    assign ALUSrcA[1] = WireState15;

    /* seta o ALUSrcA[0] nos estados 2, 6, 12, 13 e 14 */
    or (ALUSrcA[0], WireState2, WireState6, WireState14, WireState12, WireState13);

    /* seta o RegWrite nos estados 4, 7 e 9 */
    or (RegWrite, WireState4, WireState7, WireState9);

    /* seta o RegDst no estado 7 */
    assign RegDst = WireState7;

endmodule