module nextState (
    input [3:0] StateRegister,
    output PCWrite, output PCWriteCond, output IorD,
    output MemRead, output MemWrite, output IRWrite,
    output MemtoReg, output PCSource1, output PCSource0,
    output ALUOp1,output ALUOp0, output ALUSrcB1,
    output ALUSrcB0, output ALUSrcA, output RegWrite,
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

    and (WireState0, ~StateRegister[3], ~StateRegister[2],
                     ~StateRegister[1], ~StateRegister[0]);
    and (WireState1, ~StateRegister[3], ~StateRegister[2],
                     ~StateRegister[1], StateRegister[0]);
    and (WireState2, ~StateRegister[3], ~StateRegister[2],
                     StateRegister[1], ~StateRegister[0]);
    and (WireState3, ~StateRegister[3], ~StateRegister[2],
                     StateRegister[1], StateRegister[0]);
    and (WireState4, ~StateRegister[3], StateRegister[2],
                     ~StateRegister[1], ~StateRegister[0]);
    and (WireState5, ~StateRegister[3], StateRegister[2],
                     ~StateRegister[1], StateRegister[0]);
    and (WireState6, ~StateRegister[3], StateRegister[2],
                     StateRegister[1], ~StateRegister[0]);
    and (WireState7, ~StateRegister[3], StateRegister[2],
                     StateRegister[1], StateRegister[0]);
    and (WireState8, StateRegister[3], ~StateRegister[2],
                     ~StateRegister[1], ~StateRegister[0]);
    and (WireState9, StateRegister[3], ~StateRegister[2],
                     ~StateRegister[1], StateRegister[0]);

    or (PCWrite, WireState0, WireState9);
    assign PCWriteCond = WireState8;
    or (IorD, WireState3, WireState5);
    or (MemRead, WireState0, WireState3);
    assign MemWrite = WireState5;
    assign IRWrite = WireState0;
    assign MemtoReg = WireState4;
    assign PCSource1 = WireState9;
    assign PCSource0 = WireState8;
    assign ALUOp1 = WireState6;
    assign ALUOp0 = WireState8;
    or (ALUSrcB1, WireState1, WireState2);
    or (ALUSrcB0, WireState0, WireState1);
    or (ALUSrcA, WireState2, WireState6, WireState8);
    or (RegWrite, WireState4, WireState);
    assign RegDst = WireState7;
    
endmodule
