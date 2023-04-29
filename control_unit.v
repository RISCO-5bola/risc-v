module control_unit (
    input [5:0] op, input clk,
    output PCWrite, output PCWriteCond, output IorD,
    output MemRead, output MemWrite, output IRWrite,
    output MemtoReg, output PCSource1, output PCSource0,
    output ALUOp1,output ALUOp0, output ALUSrcB1,
    output ALUSrcB0, output ALUSrcA, output RegWrite,
    output RegDst
);
    wire [3:0] NextState;
    reg StateRegister[3:0];

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

    initial begin
        StateRegister <= STATE0;
    end

    /* calculates the next state */
    // assign

    /* sets the state register to the next state */
    always @(posedge clk) begin
        StateRegister <= NextState;
    end

    /* sets the outputs based on the current state */
    // assign

endmodule