module ControlUnit_tb ();
    reg [6:0] op;
    reg clk;
    wire PCWrite;
    wire PCWriteCond;
    wire IorD;
    wire MemRead;
    wire MemWrite;
    wire IRWrite;
    wire MemtoReg;
    wire PCSource1;
    wire PCSource0;
    wire ALUOp1;
    wire ALUOp0;
    wire ALUSrcB1;
    wire ALUSrcB0;
    wire [1:0] ALUSrcA;
    wire RegWrite;
    wire RegDst;
    
    ControlUnit UUT(.op(op), .PCWrite(PCWrite), .PCWriteCond(PCWriteCond), .IorD(IorD),
                     .MemRead(MemRead), .MemWrite(MemWrite), .IRWrite(IRWrite),
                     .MemtoReg(MemtoReg), .PCSource1(PCSource1), .PCSource0(PCSource0),
                     .ALUOp1(ALUOp1), .ALUOp0(ALUOp0), .ALUSrcB1(ALUSrcB1),
                     .ALUSrcB0(ALUSrcB0), .ALUSrcA({ALUSrcA[1], ALUSrcA[0]}), .RegWrite(RegWrite),
                     .RegDst(RegDst), .clk(clk));
    
    parameter State0  = 17'b1001_0100_0000_1000_0;
    parameter State1  = 17'b0000_0000_0001_1000_0;
    parameter State2  = 17'b0000_0000_0001_0010_0;
    parameter State3  = 17'b0011_0000_0000_0000_0;
    parameter State4  = 17'b0000_0010_0000_0001_0;
    parameter State5  = 17'b0010_1000_0000_0000_0;
    parameter State6  = 17'b0000_0000_0100_0010_0;
    parameter State7  = 17'b0000_0000_0000_0001_1;
    parameter State8  = 17'b0000_0000_0011_0000_0;
    parameter State9  = 17'b0001_0001_0001_1001_0;
    parameter State10 = 17'b1000_0000_0001_0000_0;
    parameter State11 = 17'b0001_0000_0001_0000_0;
    parameter State12 = 17'b1001_0000_0001_0010_0;
    parameter State13 = 17'b0000_0000_0101_0010_0;
    parameter State14 = 17'b0100_0000_1000_0010_0;
    parameter State15 = 17'b0001_0000_0001_0100_0;


    integer errors;

    initial begin
        errors = 0;
        clk = 0;
        forever clk = #5 ~clk;
    end
    
    task Check;
        input [33:0] expect;
        if (expect[33:17] !== expect[16:0]) begin
            $display("Got %b, expected %b", expect[33:17], expect[16:0]);
            errors = errors + 1;
        end
    endtask
    initial begin       
       $display("Tipo R");
       op = 7'b0110011;
       #10
       /* estado 1 */
       Check({PCWrite, PCWriteCond, IorD, MemRead,
              MemWrite, IRWrite, MemtoReg, PCSource1,
              PCSource0, ALUOp1, ALUOp0, ALUSrcB1, ALUSrcB0,
              ALUSrcA[1], ALUSrcA[0], RegWrite, RegDst, State1});
       #10
       /* estado 6 */
       Check({PCWrite, PCWriteCond, IorD, MemRead,
              MemWrite, IRWrite, MemtoReg, PCSource1,
              PCSource0, ALUOp1, ALUOp0, ALUSrcB1, ALUSrcB0,
              ALUSrcA[1], ALUSrcA[0], RegWrite, RegDst, State6});
       #10
       /* estado 7 */
       Check({PCWrite, PCWriteCond, IorD, MemRead,
              MemWrite, IRWrite, MemtoReg, PCSource1,
              PCSource0, ALUOp1, ALUOp0, ALUSrcB1, ALUSrcB0,
              ALUSrcA[1], ALUSrcA[0], RegWrite, RegDst, State7});
       #10
       /* estado 0 */
       Check({PCWrite, PCWriteCond, IorD, MemRead,
              MemWrite, IRWrite, MemtoReg, PCSource1,
              PCSource0, ALUOp1, ALUOp0, ALUSrcB1, ALUSrcB0,
              ALUSrcA[1], ALUSrcA[0], RegWrite, RegDst, State0});
       
       $display("Tipo jal");
       op = 7'b1101111;
       #10
       /* estado 1 */
       Check({PCWrite, PCWriteCond, IorD, MemRead,
              MemWrite, IRWrite, MemtoReg, PCSource1,
              PCSource0, ALUOp1, ALUOp0, ALUSrcB1, ALUSrcB0,
              ALUSrcA[1], ALUSrcA[0], RegWrite, RegDst, State1});
       #10
       /* estado 9 */
       Check({PCWrite, PCWriteCond, IorD, MemRead,
              MemWrite, IRWrite, MemtoReg, PCSource1,
              PCSource0, ALUOp1, ALUOp0, ALUSrcB1, ALUSrcB0,
              ALUSrcA[1], ALUSrcA[0], RegWrite, RegDst, State9});
       #10
       /* estado 10 */
       Check({PCWrite, PCWriteCond, IorD, MemRead,
              MemWrite, IRWrite, MemtoReg, PCSource1,
              PCSource0, ALUOp1, ALUOp0, ALUSrcB1, ALUSrcB0,
              ALUSrcA[1], ALUSrcA[0], RegWrite, RegDst, State10});
       #10
       /* estado 0 */
       Check({PCWrite, PCWriteCond, IorD, MemRead,
              MemWrite, IRWrite, MemtoReg, PCSource1,
              PCSource0, ALUOp1, ALUOp0, ALUSrcB1, ALUSrcB0,
              ALUSrcA[1], ALUSrcA[0], RegWrite, RegDst, State0});
       
       $display("Tipo beq");
       op = 7'b1100011;
       #10
       /* estado 1 */
       Check({PCWrite, PCWriteCond, IorD, MemRead,
              MemWrite, IRWrite, MemtoReg, PCSource1,
              PCSource0, ALUOp1, ALUOp0, ALUSrcB1, ALUSrcB0,
              ALUSrcA[1], ALUSrcA[0], RegWrite, RegDst, State1});
       #10
       /* estado 8 */
       Check({PCWrite, PCWriteCond, IorD, MemRead,
              MemWrite, IRWrite, MemtoReg, PCSource1,
              PCSource0, ALUOp1, ALUOp0, ALUSrcB1, ALUSrcB0,
              ALUSrcA[1], ALUSrcA[0], RegWrite, RegDst, State8});
       #10
       /* estado 14 */
       Check({PCWrite, PCWriteCond, IorD, MemRead,
              MemWrite, IRWrite, MemtoReg, PCSource1,
              PCSource0, ALUOp1, ALUOp0, ALUSrcB1, ALUSrcB0,
              ALUSrcA[1], ALUSrcA[0], RegWrite, RegDst, State14});
       #10
       /* estado 0 */
       Check({PCWrite, PCWriteCond, IorD, MemRead,
              MemWrite, IRWrite, MemtoReg, PCSource1,
              PCSource0, ALUOp1, ALUOp0, ALUSrcB1, ALUSrcB0,
              ALUSrcA[1], ALUSrcA[0], RegWrite, RegDst, State0});
       
       $display("Tipo lw");
       op = 7'b0000011;
       #10
       /* estado 1 */
       Check({PCWrite, PCWriteCond, IorD, MemRead,
              MemWrite, IRWrite, MemtoReg, PCSource1,
              PCSource0, ALUOp1, ALUOp0, ALUSrcB1, ALUSrcB0,
              ALUSrcA[1], ALUSrcA[0], RegWrite, RegDst, State1});
       #10
       /* estado 2 */
       Check({PCWrite, PCWriteCond, IorD, MemRead,
              MemWrite, IRWrite, MemtoReg, PCSource1,
              PCSource0, ALUOp1, ALUOp0, ALUSrcB1, ALUSrcB0,
              ALUSrcA[1], ALUSrcA[0], RegWrite, RegDst, State2});
       #10
       /* estado 3 */
       Check({PCWrite, PCWriteCond, IorD, MemRead,
              MemWrite, IRWrite, MemtoReg, PCSource1,
              PCSource0, ALUOp1, ALUOp0, ALUSrcB1, ALUSrcB0,
              ALUSrcA[1], ALUSrcA[0], RegWrite, RegDst, State3});
       #10
       /* estado 4 */
       Check({PCWrite, PCWriteCond, IorD, MemRead,
              MemWrite, IRWrite, MemtoReg, PCSource1,
              PCSource0, ALUOp1, ALUOp0, ALUSrcB1, ALUSrcB0,
              ALUSrcA[1], ALUSrcA[0], RegWrite, RegDst, State4});
       #10
       /* estado 0 */
       Check({PCWrite, PCWriteCond, IorD, MemRead,
              MemWrite, IRWrite, MemtoReg, PCSource1,
              PCSource0, ALUOp1, ALUOp0, ALUSrcB1, ALUSrcB0,
              ALUSrcA[1], ALUSrcA[0], RegWrite, RegDst, State0});
       
       $display("Tipo sw");
       op = 7'b0100011;
       #10
       /* estado 1 */
       Check({PCWrite, PCWriteCond, IorD, MemRead,
              MemWrite, IRWrite, MemtoReg, PCSource1,
              PCSource0, ALUOp1, ALUOp0, ALUSrcB1, ALUSrcB0,
              ALUSrcA[1], ALUSrcA[0], RegWrite, RegDst, State1});
       #10
       /* estado 2 */
       Check({PCWrite, PCWriteCond, IorD, MemRead,
              MemWrite, IRWrite, MemtoReg, PCSource1,
              PCSource0, ALUOp1, ALUOp0, ALUSrcB1, ALUSrcB0,
              ALUSrcA[1], ALUSrcA[0], RegWrite, RegDst, State2});
       #10
       /* estado 5 */
       Check({PCWrite, PCWriteCond, IorD, MemRead,
              MemWrite, IRWrite, MemtoReg, PCSource1,
              PCSource0, ALUOp1, ALUOp0, ALUSrcB1, ALUSrcB0,
              ALUSrcA[1], ALUSrcA[0], RegWrite, RegDst, State5});
       #10
       /* estado 0 */
       Check({PCWrite, PCWriteCond, IorD, MemRead,
              MemWrite, IRWrite, MemtoReg, PCSource1,
              PCSource0, ALUOp1, ALUOp0, ALUSrcB1, ALUSrcB0,
              ALUSrcA[1], ALUSrcA[0], RegWrite, RegDst, State0});

       $display("Tipo I-Jalr");
       op = 7'b1100111;
       #10
       /* estado 1 */
       Check({PCWrite, PCWriteCond, IorD, MemRead,
              MemWrite, IRWrite, MemtoReg, PCSource1,
              PCSource0, ALUOp1, ALUOp0, ALUSrcB1, ALUSrcB0,
              ALUSrcA[1], ALUSrcA[0], RegWrite, RegDst, State1});
       #10
       /* estado 9 */
       Check({PCWrite, PCWriteCond, IorD, MemRead,
              MemWrite, IRWrite, MemtoReg, PCSource1,
              PCSource0, ALUOp1, ALUOp0, ALUSrcB1, ALUSrcB0,
              ALUSrcA[1], ALUSrcA[0], RegWrite, RegDst, State9});
       #10
       /* estado 12 */
       Check({PCWrite, PCWriteCond, IorD, MemRead,
              MemWrite, IRWrite, MemtoReg, PCSource1,
              PCSource0, ALUOp1, ALUOp0, ALUSrcB1, ALUSrcB0,
              ALUSrcA[1], ALUSrcA[0], RegWrite, RegDst, State12});
       #10
       /* estado 0 */
       Check({PCWrite, PCWriteCond, IorD, MemRead,
              MemWrite, IRWrite, MemtoReg, PCSource1,
              PCSource0, ALUOp1, ALUOp0, ALUSrcB1, ALUSrcB0,
              ALUSrcA[1], ALUSrcA[0], RegWrite, RegDst, State0});

       $display("Tipo U-AUIPC");
       op = 7'b0010111;
       #10
       /* estado 1 */
       Check({PCWrite, PCWriteCond, IorD, MemRead,
              MemWrite, IRWrite, MemtoReg, PCSource1,
              PCSource0, ALUOp1, ALUOp0, ALUSrcB1, ALUSrcB0,
              ALUSrcA[1], ALUSrcA[0], RegWrite, RegDst, State1});
       #10
       /* estado 11 */
       Check({PCWrite, PCWriteCond, IorD, MemRead,
              MemWrite, IRWrite, MemtoReg, PCSource1,
              PCSource0, ALUOp1, ALUOp0, ALUSrcB1, ALUSrcB0,
              ALUSrcA[1], ALUSrcA[0], RegWrite, RegDst, State11});
       #10
       /* estado 7 */
       Check({PCWrite, PCWriteCond, IorD, MemRead,
              MemWrite, IRWrite, MemtoReg, PCSource1,
              PCSource0, ALUOp1, ALUOp0, ALUSrcB1, ALUSrcB0,
              ALUSrcA[1], ALUSrcA[0], RegWrite, RegDst, State7});
       #10
       /* estado 0 */
       Check({PCWrite, PCWriteCond, IorD, MemRead,
              MemWrite, IRWrite, MemtoReg, PCSource1,
              PCSource0, ALUOp1, ALUOp0, ALUSrcB1, ALUSrcB0,
              ALUSrcA[1], ALUSrcA[0], RegWrite, RegDst, State0});

       $display("Tipo I-addi");
       op = 7'b001x011;
       #10
       /* estado 1 */
       Check({PCWrite, PCWriteCond, IorD, MemRead,
              MemWrite, IRWrite, MemtoReg, PCSource1,
              PCSource0, ALUOp1, ALUOp0, ALUSrcB1, ALUSrcB0,
              ALUSrcA[1], ALUSrcA[0], RegWrite, RegDst, State1});
       #10
       /* estado 13 */
       Check({PCWrite, PCWriteCond, IorD, MemRead,
              MemWrite, IRWrite, MemtoReg, PCSource1,
              PCSource0, ALUOp1, ALUOp0, ALUSrcB1, ALUSrcB0,
              ALUSrcA[1], ALUSrcA[0], RegWrite, RegDst, State13});
       #10
       /* estado 7 */
       Check({PCWrite, PCWriteCond, IorD, MemRead,
              MemWrite, IRWrite, MemtoReg, PCSource1,
              PCSource0, ALUOp1, ALUOp0, ALUSrcB1, ALUSrcB0,
              ALUSrcA[1], ALUSrcA[0], RegWrite, RegDst, State7});
       #10
       /* estado 0 */
       Check({PCWrite, PCWriteCond, IorD, MemRead,
              MemWrite, IRWrite, MemtoReg, PCSource1,
              PCSource0, ALUOp1, ALUOp0, ALUSrcB1, ALUSrcB0,
              ALUSrcA[1], ALUSrcA[0], RegWrite, RegDst, State0});

       $display("Tipo U-LUI");
       op = 7'b0110111;
       #10
       /* estado 1 */
       Check({PCWrite, PCWriteCond, IorD, MemRead,
              MemWrite, IRWrite, MemtoReg, PCSource1,
              PCSource0, ALUOp1, ALUOp0, ALUSrcB1, ALUSrcB0,
              ALUSrcA[1], ALUSrcA[0], RegWrite, RegDst, State1});
       #10
       /* estado 15 */
       Check({PCWrite, PCWriteCond, IorD, MemRead,
              MemWrite, IRWrite, MemtoReg, PCSource1,
              PCSource0, ALUOp1, ALUOp0, ALUSrcB1, ALUSrcB0,
              ALUSrcA[1], ALUSrcA[0], RegWrite, RegDst, State15});
       #10
       /* estado 7 */
       Check({PCWrite, PCWriteCond, IorD, MemRead,
              MemWrite, IRWrite, MemtoReg, PCSource1,
              PCSource0, ALUOp1, ALUOp0, ALUSrcB1, ALUSrcB0,
              ALUSrcA[1], ALUSrcA[0], RegWrite, RegDst, State7});
       #10
       /* estado 0 */
       Check({PCWrite, PCWriteCond, IorD, MemRead,
              MemWrite, IRWrite, MemtoReg, PCSource1,
              PCSource0, ALUOp1, ALUOp0, ALUSrcB1, ALUSrcB0,
              ALUSrcA[1], ALUSrcA[0], RegWrite, RegDst, State0});

       $display("Errors: %d", errors);
       $finish;
       end
endmodule