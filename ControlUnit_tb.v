module control_unit_tb ();
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
    wire ALUSrcA;
    wire RegWrite;
    wire RegDst;
    
    control_unit UUT(.op(op), .PCWrite(PCWrite), .PCWriteCond(PCWriteCond), .IorD(IorD),
                     .MemRead(MemRead), .MemWrite(MemWrite), .IRWrite(IRWrite),
                     .MemtoReg(MemtoReg), .PCSource1(PCSource1), .PCSource0(PCSource0),
                     .ALUOp1(ALUOp1), .ALUOp0(ALUOp0), .ALUSrcB1(ALUSrcB1),
                     .ALUSrcB0(ALUSrcB0), .ALUSrcA(ALUSrcA), .RegWrite(RegWrite),
                     .RegDst(RegDst), .clk(clk));
    
    parameter State0 = 16'b1001_0100_0000_1000;
    parameter State1 = 16'b0000_0000_0001_1000;
    parameter State2 = 16'b0000_0000_0001_0100;
    parameter State3 = 16'b0011_0000_0000_0000;
    parameter State4 = 16'b0000_0010_0000_0010;
    parameter State5 = 16'b0010_1000_0000_0000;
    parameter State6 = 16'b0000_0000_0100_0100;
    parameter State7 = 16'b0000_0000_0000_0011;
    parameter State8 = 16'b0100_0000_1010_0100;
    parameter State9 = 16'b1000_0001_0000_0000;
    parameter State10 = 16'b0;
    parameter State11 = 16'b0;
    parameter State12 = 16'b0;
    parameter State13 = 16'b0000_0000_0101_0100;

    integer errors;

    initial begin
        errors = 0;
        clk = 0;
        forever clk = #5 ~clk;
    end
    
    task Check;
        input [31:0] expect;
        if (expect[31:16] !== expect[15:0]) begin
            $display("Got %b, expected %b", expect[31:16], expect[15:0]);
            errors = errors + 1;
        end
    endtask
    initial begin       
       // add - R-type
       $display("Tipo R");
       op = 7'b0110011;
       #5
       Check({PCWrite, PCWriteCond, IorD, MemRead,
              MemWrite, IRWrite, MemtoReg, PCSource1,
              PCSource0, ALUOp1, ALUOp0, ALUSrcB1, ALUSrcB0,
              ALUSrcA, RegWrite, RegDst, State0});
       #10
       Check({PCWrite, PCWriteCond, IorD, MemRead,
              MemWrite, IRWrite, MemtoReg, PCSource1,
              PCSource0, ALUOp1, ALUOp0, ALUSrcB1, ALUSrcB0,
              ALUSrcA, RegWrite, RegDst, State1});
       #10
       Check({PCWrite, PCWriteCond, IorD, MemRead,
              MemWrite, IRWrite, MemtoReg, PCSource1,
              PCSource0, ALUOp1, ALUOp0, ALUSrcB1, ALUSrcB0,
              ALUSrcA, RegWrite, RegDst, State6});
       #10
       Check({PCWrite, PCWriteCond, IorD, MemRead,
              MemWrite, IRWrite, MemtoReg, PCSource1,
              PCSource0, ALUOp1, ALUOp0, ALUSrcB1, ALUSrcB0,
              ALUSrcA, RegWrite, RegDst, State7});
       #10
       Check({PCWrite, PCWriteCond, IorD, MemRead,
              MemWrite, IRWrite, MemtoReg, PCSource1,
              PCSource0, ALUOp1, ALUOp0, ALUSrcB1, ALUSrcB0,
              ALUSrcA, RegWrite, RegDst, State0});
       
       // jal
       $display("Tipo jal");
       op = 7'b1101111;
       #10
       Check({PCWrite, PCWriteCond, IorD, MemRead,
              MemWrite, IRWrite, MemtoReg, PCSource1,
              PCSource0, ALUOp1, ALUOp0, ALUSrcB1, ALUSrcB0,
              ALUSrcA, RegWrite, RegDst, State1});
       #10
       Check({PCWrite, PCWriteCond, IorD, MemRead,
              MemWrite, IRWrite, MemtoReg, PCSource1,
              PCSource0, ALUOp1, ALUOp0, ALUSrcB1, ALUSrcB0,
              ALUSrcA, RegWrite, RegDst, State9});
       #10
       Check({PCWrite, PCWriteCond, IorD, MemRead,
              MemWrite, IRWrite, MemtoReg, PCSource1,
              PCSource0, ALUOp1, ALUOp0, ALUSrcB1, ALUSrcB0,
              ALUSrcA, RegWrite, RegDst, State0});
       
       // beq
       $display("Tipo beq");
       op = 7'b1100011;

       #10
       Check({PCWrite, PCWriteCond, IorD, MemRead,
              MemWrite, IRWrite, MemtoReg, PCSource1,
              PCSource0, ALUOp1, ALUOp0, ALUSrcB1, ALUSrcB0,
              ALUSrcA, RegWrite, RegDst, State1});
       #10
       Check({PCWrite, PCWriteCond, IorD, MemRead,
              MemWrite, IRWrite, MemtoReg, PCSource1,
              PCSource0, ALUOp1, ALUOp0, ALUSrcB1, ALUSrcB0,
              ALUSrcA, RegWrite, RegDst, State8});
       #10
       Check({PCWrite, PCWriteCond, IorD, MemRead,
              MemWrite, IRWrite, MemtoReg, PCSource1,
              PCSource0, ALUOp1, ALUOp0, ALUSrcB1, ALUSrcB0,
              ALUSrcA, RegWrite, RegDst, State0});
       
       // lw
       $display("Tipo lw");
       op = 7'b0000011;

       #10
       Check({PCWrite, PCWriteCond, IorD, MemRead,
              MemWrite, IRWrite, MemtoReg, PCSource1,
              PCSource0, ALUOp1, ALUOp0, ALUSrcB1, ALUSrcB0,
              ALUSrcA, RegWrite, RegDst, State1});
       #10
       Check({PCWrite, PCWriteCond, IorD, MemRead,
              MemWrite, IRWrite, MemtoReg, PCSource1,
              PCSource0, ALUOp1, ALUOp0, ALUSrcB1, ALUSrcB0,
              ALUSrcA, RegWrite, RegDst, State2});
       #10
       Check({PCWrite, PCWriteCond, IorD, MemRead,
              MemWrite, IRWrite, MemtoReg, PCSource1,
              PCSource0, ALUOp1, ALUOp0, ALUSrcB1, ALUSrcB0,
              ALUSrcA, RegWrite, RegDst, State3});
       #10
       Check({PCWrite, PCWriteCond, IorD, MemRead,
              MemWrite, IRWrite, MemtoReg, PCSource1,
              PCSource0, ALUOp1, ALUOp0, ALUSrcB1, ALUSrcB0,
              ALUSrcA, RegWrite, RegDst, State4});
       #10
       Check({PCWrite, PCWriteCond, IorD, MemRead,
              MemWrite, IRWrite, MemtoReg, PCSource1,
              PCSource0, ALUOp1, ALUOp0, ALUSrcB1, ALUSrcB0,
              ALUSrcA, RegWrite, RegDst, State0});
       
       // sw
       $display("Tipo sw");
       op = 7'b0100011;

       #10
       Check({PCWrite, PCWriteCond, IorD, MemRead,
              MemWrite, IRWrite, MemtoReg, PCSource1,
              PCSource0, ALUOp1, ALUOp0, ALUSrcB1, ALUSrcB0,
              ALUSrcA, RegWrite, RegDst, State1});
       #10
       Check({PCWrite, PCWriteCond, IorD, MemRead,
              MemWrite, IRWrite, MemtoReg, PCSource1,
              PCSource0, ALUOp1, ALUOp0, ALUSrcB1, ALUSrcB0,
              ALUSrcA, RegWrite, RegDst, State2});
       #10
       Check({PCWrite, PCWriteCond, IorD, MemRead,
              MemWrite, IRWrite, MemtoReg, PCSource1,
              PCSource0, ALUOp1, ALUOp0, ALUSrcB1, ALUSrcB0,
              ALUSrcA, RegWrite, RegDst, State5});
       #10
       Check({PCWrite, PCWriteCond, IorD, MemRead,
              MemWrite, IRWrite, MemtoReg, PCSource1,
              PCSource0, ALUOp1, ALUOp0, ALUSrcB1, ALUSrcB0,
              ALUSrcA, RegWrite, RegDst, State0});

       // I-addi
       $display("Tipo I-addi/andi");
       op = 7'b0010011;

       #10
       Check({PCWrite, PCWriteCond, IorD, MemRead,
              MemWrite, IRWrite, MemtoReg, PCSource1,
              PCSource0, ALUOp1, ALUOp0, ALUSrcB1, ALUSrcB0,
              ALUSrcA, RegWrite, RegDst, State1});
       #10
       Check({PCWrite, PCWriteCond, IorD, MemRead,
              MemWrite, IRWrite, MemtoReg, PCSource1,
              PCSource0, ALUOp1, ALUOp0, ALUSrcB1, ALUSrcB0,
              ALUSrcA, RegWrite, RegDst, State13});
       #10
       Check({PCWrite, PCWriteCond, IorD, MemRead,
              MemWrite, IRWrite, MemtoReg, PCSource1,
              PCSource0, ALUOp1, ALUOp0, ALUSrcB1, ALUSrcB0,
              ALUSrcA, RegWrite, RegDst, State7});
       #10
       Check({PCWrite, PCWriteCond, IorD, MemRead,
              MemWrite, IRWrite, MemtoReg, PCSource1,
              PCSource0, ALUOp1, ALUOp0, ALUSrcB1, ALUSrcB0,
              ALUSrcA, RegWrite, RegDst, State0});

       $display("Errors: %d", errors);
       $finish;
       end
endmodule