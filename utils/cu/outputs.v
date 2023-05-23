module outputs (
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
    wire WireState10;
    wire WireState11;
    wire WireState12;
    wire WireState13;

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

    //No state 9 atualmente, faremos um save do PC + 4 no RF[rd]
    // memtoreg on -> permite salvar o result alu no registrador; -> vale 0.
    //write register = padrão.
    //ALUSRCA = 0;
    //ALUSRCB1 = 0;
    //ALUSRCB0 = 1;
    //regwrite = 1
    and (WireState9, StateRegister[3], ~StateRegister[2],
                     ~StateRegister[1], StateRegister[0]);
    and (WireState10, StateRegister[3], ~StateRegister[2],
                     StateRegister[1], ~StateRegister[0]);
    and (WireState11, StateRegister[3], ~StateRegister[2],
                     StateRegister[1], StateRegister[0]);
    and (WireState12, StateRegister[3], StateRegister[2],
                     ~StateRegister[1], ~StateRegister[0]);
    and (WireState13, StateRegister[3], StateRegister[2],
                      ~StateRegister[1], StateRegister[0]);

    //MemtoReg
    //PCSourceO 00 ou 01
    //PCsource1 
    //ALUSRCA = 0 -> PC, 1 -> readData1;
    //ALUSRCB = 0 -> readData2, 1 -> 4 , 2 -> immediateGenerator;
    


    //State 10: PC = PC + {imm, 1'b0};
    //memtoreg = 0
    //PCwrite = 1
    //ALUSRCA = 0
    //ALUSRCB1 = 1
    //ALUSRCB0 = 0



    //State 11: RF[rd] = PC + imm,12'b0
    //ALUSRCA = 0
    //ALUSRCB1 = 1
    //ALUSRCB0 = 0
    //regwrite = 1


    //State 12: PC = RF[rd] + imm
    //ALUSRCA = 1
    //ALUSRCB1 = 1
    //ALUSRCB0 = 0
    //PCwrite = 1
    //memtoreg = 0

    or (PCWrite, WireState0, WireState10, WireState12);
    assign PCWriteCond = WireState8;
    or (IorD, WireState3, WireState5);
    or (MemRead, WireState0, WireState3, WireState9, WireState11, WireState12);
    assign MemWrite = WireState5;
    assign IRWrite = WireState0;
    assign MemtoReg = WireState4;
    assign PCSource1 = WireState9;
    or (PCSource0, WireState8, WireState10, WireState12);
    or (ALUOp1, WireState6, WireState13);
    assign ALUOp0 = WireState8;
    or (ALUSrcB1, WireState1, WireState2, WireState10, WireState11, WireState12, WireState13);
    or (ALUSrcB0, WireState0, WireState1, WireState9);
    or (ALUSrcA, WireState2, WireState6, WireState8, WireState12, WireState13);
    or (RegWrite, WireState4, WireState7, WireState9);
    assign RegDst = WireState7;

    
endmodule