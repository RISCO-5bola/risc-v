`include "./utils/cu/outputs.v"
`include "./utils/cu/next_state.v"
module ControlUnit (
    input [6:0] op, input clk, input reset,
    output PCWrite, output PCWriteCond, output IorD,
    output MemRead, output MemWrite, output IRWrite,
    output MemtoReg, output PCSource1, output PCSource0,
    output ALUOp1, output ALUOp0, output ALUSrcB1,
    output ALUSrcB0, output [1:0] ALUSrcA, output RegWrite,
    output RegDst, output [3:0] currentState
);  
    wire [3:0] NextState;
    reg [3:0] StateRegister;

    parameter STATE0 = 4'b0000;
    parameter STATE1 = 4'b0001;
    parameter STATE2 = 4'b0010;
    parameter STATE3 = 4'b0011;
    parameter STATE4 = 4'b0100;
    parameter STATE5 = 4'b0101;
    parameter STATE6 = 4'b0110;
    parameter STATE7 = 4'b0111;
    parameter STATE8 = 4'b1000;
    parameter STATE9 = 4'b1001;
    parameter STATE10 = 4'b1010;//estado JAL
    parameter STATE11 = 4'b1011;//estado U
    parameter STATE12 = 4'b1100;//estado JALR
    parameter STATE13 = 4'B1101;//tipo I
    parameter STATE14 = 4'B1110;//correcao tipo B
    parameter STATE15 = 4'B1111;//lui
    
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