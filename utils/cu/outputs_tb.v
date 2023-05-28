module outputs_tb ();
    reg [3:0] StateRegister;
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
    
    integer errors = 0;

    task Check;
        input [1:0] expect;
        
        if (expect[1] != expect[0]) begin
            $display("Got %b, expected %b", expect[1], expect[0]);
            errors = errors + 1;
        end
    endtask

    outputs UUT (.StateRegister(StateRegister), .PCWrite(PCWrite), .PCWriteCond(PCWriteCond), .IorD(IorD),
                 .MemRead(MemRead), .MemWrite(MemWrite), .IRWrite(IRWrite),
                 .MemtoReg(MemtoReg), .PCSource1(PCSource1), .PCSource0(PCSource0),
                 .ALUOp1(ALUOp1),.ALUOp0(ALUOp0), .ALUSrcB1(ALUSrcB1),
                 .ALUSrcB0(ALUSrcB0), .ALUSrcA({ALUSrcA[1], ALUSrcA[0]}), .RegWrite(RegWrite),
                 .RegDst(RegDst));

    initial begin

       // Estado 0
       StateRegister = 4'd0;
       #5
       $display("Test State 0");
       Check({PCWrite, 1'b1});
       Check({PCWriteCond, 1'b0});
       Check({IorD, 1'b0});
       Check({MemRead, 1'b1});
       Check({MemWrite, 1'b0});
       Check({IRWrite, 1'b1});
       Check({MemtoReg, 1'b0});
       Check({PCSource1, 1'b0});
       Check({PCSource0, 1'b0});
       Check({ALUOp1, 1'b0});
       Check({ALUOp0, 1'b0});
       Check({ALUSrcB1, 1'b0});
       Check({ALUSrcB0, 1'b1});
       Check({ALUSrcA[1], 1'b0});
       Check({ALUSrcA[0], 1'b0});
       Check({RegWrite, 1'b0});
       Check({RegDst, 1'b0});
   
       // Estado 1
       #5
       StateRegister = 4'd1;
       #5
       $display("Test State 1");
       Check({PCWrite, 1'b0});
       Check({PCWriteCond, 1'b0});
       Check({IorD, 1'b0});
       Check({MemRead, 1'b0});
       Check({MemWrite, 1'b0});
       Check({IRWrite, 1'b0});
       Check({MemtoReg, 1'b0});
       Check({PCSource1, 1'b0});
       Check({PCSource0, 1'b0});
       Check({ALUOp1, 1'b0});
       Check({ALUOp0, 1'b0});
       Check({ALUSrcB1, 1'b1});
       Check({ALUSrcB0, 1'b1});
       Check({ALUSrcA[1], 1'b0});
       Check({ALUSrcA[0], 1'b0});
       Check({RegWrite, 1'b0});
       Check({RegDst, 1'b0});
     
       // Estado 2
       #5
       StateRegister = 4'd2;
       #5
       $display("Test State 2");
       Check({PCWrite, 1'b0});
       Check({PCWriteCond, 1'b0});
       Check({IorD, 1'b0});
       Check({MemRead, 1'b0});
       Check({MemWrite, 1'b0});
       Check({IRWrite, 1'b0});
       Check({MemtoReg, 1'b0});
       Check({PCSource1, 1'b0});
       Check({PCSource0, 1'b0});
       Check({ALUOp1, 1'b0});
       Check({ALUOp0, 1'b0});
       Check({ALUSrcB1, 1'b1});
       Check({ALUSrcB0, 1'b0});
       Check({ALUSrcA[1], 1'b0});
       Check({ALUSrcA[0], 1'b1});
       Check({RegWrite, 1'b0});
       Check({RegDst, 1'b0});
      
       // Estado 3
       #5
       StateRegister = 4'd3;
       #5
       $display("Test State 3");
       Check({PCWrite, 1'b0});
       Check({PCWriteCond, 1'b0});
       Check({IorD, 1'b1});
       Check({MemRead, 1'b1});
       Check({MemWrite, 1'b0});
       Check({IRWrite, 1'b0});
       Check({MemtoReg, 1'b0});
       Check({PCSource1, 1'b0});
       Check({PCSource0, 1'b0});
       Check({ALUOp1, 1'b0});
       Check({ALUOp0, 1'b0});
       Check({ALUSrcB1, 1'b0});
       Check({ALUSrcB0, 1'b0});
       Check({ALUSrcA[1], 1'b0});
       Check({ALUSrcA[0], 1'b0});
       Check({RegWrite, 1'b0});
       Check({RegDst, 1'b0});
    
       // Estado 4
       #5
       StateRegister = 4'd4;
       #5
       $display("Test State 4");
       Check({PCWrite, 1'b0});
       Check({PCWriteCond, 1'b0});
       Check({IorD, 1'b0});
       Check({MemRead, 1'b0});
       Check({MemWrite, 1'b0});
       Check({IRWrite, 1'b0});
       Check({MemtoReg, 1'b1});
       Check({PCSource1, 1'b0});
       Check({PCSource0, 1'b0});
       Check({ALUOp1, 1'b0});
       Check({ALUOp0, 1'b0});
       Check({ALUSrcB1, 1'b0});
       Check({ALUSrcB0, 1'b0});
       Check({ALUSrcA[1], 1'b0});
       Check({ALUSrcA[0], 1'b0});
       Check({RegWrite, 1'b1});
       Check({RegDst, 1'b0});
     
       // Estado 5
       #5
       StateRegister = 4'd5;
       #5
       $display("Test State 5");
       Check({PCWrite, 1'b0});
       Check({PCWriteCond, 1'b0});
       Check({IorD, 1'b1});
       Check({MemRead, 1'b0});
       Check({MemWrite, 1'b1});
       Check({IRWrite, 1'b0});
       Check({MemtoReg, 1'b0});
       Check({PCSource1, 1'b0});
       Check({PCSource0, 1'b0});
       Check({ALUOp1, 1'b0});
       Check({ALUOp0, 1'b0});
       Check({ALUSrcB1, 1'b0});
       Check({ALUSrcB0, 1'b0});
       Check({ALUSrcA[1], 1'b0});
       Check({ALUSrcA[0], 1'b0});
       Check({RegWrite, 1'b0});
       Check({RegDst, 1'b0});
     
       // Estado 6
       #5
       StateRegister = 4'd6;
       #5
       $display("Test State 6");
       Check({PCWrite, 1'b0});
       Check({PCWriteCond, 1'b0});
       Check({IorD, 1'b0});
       Check({MemRead, 1'b0});
       Check({MemWrite, 1'b0});
       Check({IRWrite, 1'b0});
       Check({MemtoReg, 1'b0});
       Check({PCSource1, 1'b0});
       Check({PCSource0, 1'b0});
       Check({ALUOp1, 1'b1});
       Check({ALUOp0, 1'b0});
       Check({ALUSrcB1, 1'b0});
       Check({ALUSrcB0, 1'b0});
       Check({ALUSrcA[1], 1'b0});
       Check({ALUSrcA[0], 1'b1});
       Check({RegWrite, 1'b0});
       Check({RegDst, 1'b0});
    
       // Estado 7
       #5
       StateRegister = 4'd7;
       #5
       $display("Test State 7");
       Check({PCWrite, 1'b0});
       Check({PCWriteCond, 1'b0});
       Check({IorD, 1'b0});
       Check({MemRead, 1'b0});
       Check({MemWrite, 1'b0});
       Check({IRWrite, 1'b0});
       Check({MemtoReg, 1'b0});
       Check({PCSource1, 1'b0});
       Check({PCSource0, 1'b0});
       Check({ALUOp1, 1'b0});
       Check({ALUOp0, 1'b0});
       Check({ALUSrcB1, 1'b0});
       Check({ALUSrcB0, 1'b0});
       Check({ALUSrcA[1], 1'b0});
       Check({ALUSrcA[0], 1'b0});
       Check({RegWrite, 1'b1});
       Check({RegDst, 1'b1});
     
       // Estado 8
       #5
       StateRegister = 4'd8;
       #5
       $display("Test State 8");
       Check({PCWrite, 1'b0});
       Check({PCWriteCond, 1'b0});
       Check({IorD, 1'b0});
       Check({MemRead, 1'b0});
       Check({MemWrite, 1'b0});
       Check({IRWrite, 1'b0});
       Check({MemtoReg, 1'b0});
       Check({PCSource1, 1'b0});
       Check({PCSource0, 1'b0});
       Check({ALUOp1, 1'b0});
       Check({ALUOp0, 1'b1});
       Check({ALUSrcB1, 1'b1});
       Check({ALUSrcB0, 1'b0});
       Check({ALUSrcA[1], 1'b0});
       Check({ALUSrcA[0], 1'b0});
       Check({RegWrite, 1'b0});
       Check({RegDst, 1'b0});
      
       // Estado 9
       #5
       StateRegister = 4'd9;
       #5
       $display("Test State 9");
       Check({PCWrite, 1'b0});
       Check({PCWriteCond, 1'b0});
       Check({IorD, 1'b0});
       Check({MemRead, 1'b1});
       Check({MemWrite, 1'b0});
       Check({IRWrite, 1'b0});
       Check({MemtoReg, 1'b0});
       Check({PCSource1, 1'b1});
       Check({PCSource0, 1'b0});
       Check({ALUOp1, 1'b0});
       Check({ALUOp0, 1'b0}); 
       Check({ALUSrcB1, 1'b1});
       Check({ALUSrcB0, 1'b1});
       Check({ALUSrcA[1], 1'b0});
       Check({ALUSrcA[0], 1'b0});
       Check({RegWrite, 1'b1});
       Check({RegDst, 1'b0});
      
       // Estado 10
       #5
       StateRegister = 4'd10;
       #5
       $display("Test State 10");
       Check({PCWrite, 1'b1});
       Check({PCWriteCond, 1'b0});
       Check({IorD, 1'b0});
       Check({MemRead, 1'b0});
       Check({MemWrite, 1'b0});
       Check({IRWrite, 1'b0});
       Check({MemtoReg, 1'b0});
       Check({PCSource1, 1'b0});
       Check({PCSource0, 1'b0});
       Check({ALUOp1, 1'b0});
       Check({ALUOp0, 1'b0});
       Check({ALUSrcB1, 1'b1}); 
       Check({ALUSrcB0, 1'b0});
       Check({ALUSrcA[1], 1'b0});
       Check({ALUSrcA[0], 1'b0});
       Check({RegWrite, 1'b0});
       Check({RegDst, 1'b0});
       
       // Estado 11
       #5
       StateRegister = 4'd11;
       #5
       $display("Test State 11");
       Check({PCWrite, 1'b0});
       Check({PCWriteCond, 1'b0});
       Check({IorD, 1'b0});
       Check({MemRead, 1'b1});
       Check({MemWrite, 1'b0});
       Check({IRWrite, 1'b0});
       Check({MemtoReg, 1'b0});
       Check({PCSource1, 1'b0});
       Check({PCSource0, 1'b0});
       Check({ALUOp1, 1'b0});
       Check({ALUOp0, 1'b0});
       Check({ALUSrcB1, 1'b1}); 
       Check({ALUSrcB0, 1'b0});
       Check({ALUSrcA[1], 1'b0});
       Check({ALUSrcA[0], 1'b0});
       Check({RegWrite, 1'b0});
       Check({RegDst, 1'b0});
       
       // Estado 12
       #5
       StateRegister = 4'd12;
       #5
       $display("Test State 12");
       Check({PCWrite, 1'b1});
       Check({PCWriteCond, 1'b0});
       Check({IorD, 1'b0});
       Check({MemRead, 1'b1}); 
       Check({MemWrite, 1'b0});
       Check({IRWrite, 1'b0});
       Check({MemtoReg, 1'b0});
       Check({PCSource1, 1'b0});
       Check({PCSource0, 1'b0});
       Check({ALUOp1, 1'b0});
       Check({ALUOp0, 1'b0});
       Check({ALUSrcB1, 1'b1}); 
       Check({ALUSrcB0, 1'b0});
       Check({ALUSrcA[1], 1'b0});
       Check({ALUSrcA[0], 1'b1});
       Check({RegWrite, 1'b0});
       Check({RegDst, 1'b0});
       
       // Estado 13
       #5
       StateRegister = 4'd13;
       #5
       $display("Test State 13");
       Check({PCWrite, 1'b0});
       Check({PCWriteCond, 1'b0});
       Check({IorD, 1'b0});
       Check({MemRead, 1'b0});
       Check({MemWrite, 1'b0});
       Check({IRWrite, 1'b0});
       Check({MemtoReg, 1'b0});
       Check({PCSource1, 1'b0});
       Check({PCSource0, 1'b0});
       Check({ALUOp1, 1'b1});
       Check({ALUOp0, 1'b0});
       Check({ALUSrcB1, 1'b1}); 
       Check({ALUSrcB0, 1'b0});
       Check({ALUSrcA[1], 1'b0});
       Check({ALUSrcA[0], 1'b1});
       Check({RegWrite, 1'b0});
       Check({RegDst, 1'b0});
       
       // Estado 14
       #5
       StateRegister = 4'd14;
       #5
       $display("Test State 14");
       Check({PCWrite, 1'b0});
       Check({PCWriteCond, 1'b1});
       Check({IorD, 1'b0});
       Check({MemRead, 1'b0});
       Check({MemWrite, 1'b0});
       Check({IRWrite, 1'b0});
       Check({MemtoReg, 1'b0});
       Check({PCSource1, 1'b0});
       Check({PCSource0, 1'b1});
       Check({ALUOp1, 1'b0});
       Check({ALUOp0, 1'b0});
       Check({ALUSrcB1, 1'b0}); 
       Check({ALUSrcB0, 1'b0});
       Check({ALUSrcA[1], 1'b0});
       Check({ALUSrcA[0], 1'b1});
       Check({RegWrite, 1'b0});
       Check({RegDst, 1'b0});
       
       // Estado 15
       #5
       StateRegister = 4'd15;
       #5
       $display("Test State 15");
       Check({PCWrite, 1'b0});
       Check({PCWriteCond, 1'b0});
       Check({IorD, 1'b0});
       Check({MemRead, 1'b1});
       Check({MemWrite, 1'b0});
       Check({IRWrite, 1'b0});
       Check({MemtoReg, 1'b0});
       Check({PCSource1, 1'b0});
       Check({PCSource0, 1'b0});
       Check({ALUOp1, 1'b0});
       Check({ALUOp0, 1'b0});
       Check({ALUSrcB1, 1'b1}); 
       Check({ALUSrcB0, 1'b0});
       Check({ALUSrcA[1], 1'b1});
       Check({ALUSrcA[0], 1'b0});
       Check({RegWrite, 1'b0});
       Check({RegDst, 1'b0});

       $display ("Errors: %d", errors);
       $finish;
       
    end
endmodule