module outputs (
    input [3:0] StateRegister,
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
    and (WireState0, ~StateRegister[3], ~StateRegister[2],
                     ~StateRegister[1], ~StateRegister[0]);

    /* vai para os states 2(lw, sw), 6(r), 8(b), 
       9(jal, I-jalr), 13(I-addi), 15(U-lui) */                     
    and (WireState1, ~StateRegister[3], ~StateRegister[2],
                     ~StateRegister[1], StateRegister[0]);

    /* vai para os states 3(lw) e 5(sw) */                     
    and (WireState2, ~StateRegister[3], ~StateRegister[2],
                     StateRegister[1], ~StateRegister[0]);

    /* vai para o state 4 */                     
    and (WireState3, ~StateRegister[3], ~StateRegister[2],
                     StateRegister[1], StateRegister[0]);
           
    and (WireState4, ~StateRegister[3], StateRegister[2],
                     ~StateRegister[1], ~StateRegister[0]);
    and (WireState5, ~StateRegister[3], StateRegister[2],
                     ~StateRegister[1], StateRegister[0]);

    /* vai para o state 7 */                     
    and (WireState6, ~StateRegister[3], StateRegister[2],
                     StateRegister[1], ~StateRegister[0]);
    
    and (WireState7, ~StateRegister[3], StateRegister[2],
                     StateRegister[1], StateRegister[0]);
    
    /* vai para o state 14(b) */
    and (WireState8, StateRegister[3], ~StateRegister[2],
                     ~StateRegister[1], ~StateRegister[0]);

    /* vai par o state 10(jal) e 12(I-jalr) */                     
    and (WireState9, StateRegister[3], ~StateRegister[2],
                     ~StateRegister[1], StateRegister[0]);
                     
    and (WireState10, StateRegister[3], ~StateRegister[2],
                     StateRegister[1], ~StateRegister[0]);

    /* vai para o state 7(u-auipc) */                     
    and (WireState11, StateRegister[3], ~StateRegister[2],
                     StateRegister[1], StateRegister[0]);
    and (WireState12, StateRegister[3], StateRegister[2],
                     ~StateRegister[1], ~StateRegister[0]);
    and (WireState13, StateRegister[3], StateRegister[2],
                      ~StateRegister[1], StateRegister[0]);
    and (WireState14, StateRegister[3], StateRegister[2],
                      StateRegister[1], ~StateRegister[0]);

    /* vai para o state 7(u-lui) */                      
    and (WireState15, StateRegister[3], StateRegister[2],
                      StateRegister[1], StateRegister[0]);

    or (PCWrite, WireState0, WireState10, WireState12);
    assign PCWriteCond = WireState14;
    or (IorD, WireState3, WireState5);
    or (MemRead, WireState0, WireState3, WireState9, WireState11, WireState12, WireState15);
    assign MemWrite = WireState5;
    assign IRWrite = WireState0;
    assign MemtoReg = WireState4;
    assign PCSource1 = WireState9;
    assign PCSource0 = WireState14;
    or (ALUOp1, WireState6, WireState13);
    assign ALUOp0 = WireState8;
    or (ALUSrcB1, WireState2, WireState1, WireState10, WireState8, WireState9, WireState11, WireState12, WireState13, WireState15);
    or (ALUSrcB0, WireState0, WireState1, WireState9);
    assign ALUSrcA[1] = WireState15;
    or (ALUSrcA[0], WireState2, WireState6, WireState14, WireState12, WireState13);
    or (RegWrite, WireState4, WireState7, WireState9);
    assign RegDst = WireState7;

    
endmodule