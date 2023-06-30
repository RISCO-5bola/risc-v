module ControlUnit (
    input [6:0] op, input clk, input reset,
    output PCWrite, output PCWriteCond, output IorD,
    output MemRead, output MemWrite, output IRWrite,
    output MemtoReg, output PCSource1, output PCSource0,
    output ALUOp1, output ALUOp0, output ALUSrcB1,
    output ALUSrcB0, output [1:0] ALUSrcA, output RegWrite,
    output RegDst, output [3:0] currentState,

    /* extensão RV-32F */
    input doneFP,
    output startFP,
    output [1:0] opFP,
    output fpuReset
);  
    wire [4:0] NextState;
    reg [4:0] StateRegister;
    
    parameter STATE0 = 5'b00000;
    parameter STATE1 = 5'b00001;
    parameter STATE2 = 5'b00010;
    parameter STATE3 = 5'b00011;
    parameter STATE4 = 5'b00100;
    parameter STATE5 = 5'b00101;
    parameter STATE6 = 5'b00110;
    parameter STATE7 = 5'b00111;
    parameter STATE8 = 5'b01000;
    parameter STATE9 = 5'b01001;
    parameter STATE10 = 5'b01010;
    parameter STATE11 = 5'b01011;
    parameter STATE12 = 5'b01100;
    parameter STATE13 = 5'B01101;
    parameter STATE14 = 5'B01110;
    parameter STATE15 = 5'B01111;
    
    initial begin
        StateRegister <= STATE0;
    end

    /* calculates the next state */
    next_state next_state0 (.op(op), .state(StateRegister), .ns(NextState));

    /* sets the outputs based on the current state */
    outputs outputs (.StateRegister(StateRegister), .PCWrite(PCWrite), 
                     .PCWriteCond(PCWriteCond), .IorD(IorD),
                     .MemRead(MemRead), .MemWrite(MemWrite),
                     .IRWrite(IRWrite), .MemtoReg(MemtoReg),
                     .PCSource1(PCSource1), .PCSource0(PCSource0),
                     .ALUOp1(ALUOp1), .ALUOp0(ALUOp0), .ALUSrcB1(ALUSrcB1),
                     .ALUSrcB0(ALUSrcB0), .ALUSrcA(ALUSrcA),
                     .RegWrite(RegWrite), .RegDst(RegDst));

    /* sets the state register to the next state */
    always @(posedge clk) begin
        if (reset == 1'b1) StateRegister <= STATE0;
        else StateRegister <= NextState;
    end

    assign currentState = StateRegister;
endmodule