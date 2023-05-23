module ALU_Control (
    input ALUOp1,
    input ALUOp0,
    input [3:0] funct,
    input [6:0] opcode,
    output [3:0] operation
);
    wire A;
    wire B;
    wire isIType;
    wire intermediateResult;

    /* verifica se a operacao e do tipo I */ 
    and(isIType, ~opcode[6], ~opcode[5], opcode[4],
        ~opcode[3], ~opcode[2], opcode[1], opcode[0]);

    and (operation[3], ALUOp1, ~ALUOp1);
    and (A, ~ALUOp1, ALUOp0);
    and (B, ALUOp1, ~ALUOp0, funct[3]);

    or (intermediateResult, A, B);
    and (operation[2], intermediateResult, ~isIType);
    or (operation[1], ALUOp0, ~ALUOp1, ~funct[1]);
    and (operation[0], ALUOp1, funct[2], ~funct[0]);
endmodule
