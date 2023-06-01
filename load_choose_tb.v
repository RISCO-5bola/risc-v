module load_choose_tb ();
    reg [63:0] dataReadFromMemory;
    reg [6:0] opcode;
    reg [2:0] funct3;
    wire [63:0] writeDataReg;

    
    load_choose UUT(.dataReadFromMemory(dataReadFromMemory), .opcode(opcode),
                     .funct3(funct3), .writeDataReg(writeDataReg));
    
    integer errors = 0;
    
    task Check;
        input [127:0] expect;
        if (expect[127:64] !== expect[63:0]) begin
            $display("Got %b, expected %b", expect[127:64], expect[63:0]);
            errors = errors + 1;
        end
    endtask
    
    initial begin      
       $display("Teste lb positivo");
       dataReadFromMemory = 8'd2;
       opcode = 7'b0000011;
       funct3 = 3'b000;
       #10
       Check({writeDataReg, 32'b0, 16'b0, 8'b0, 8'd2});

       $display("Teste lb negativo");
       dataReadFromMemory = -8'd2;
       opcode = 7'b0000011;
       funct3 = 3'b000;
       #10
       Check({writeDataReg, -32'b1, -16'b1, -8'b1, -8'd2});

       $display("Teste lh positivo");
       dataReadFromMemory = 16'd4;
       opcode = 7'b0000011;
       funct3 = 3'b001;
       #10
       Check({writeDataReg, 32'b0, 16'b0, dataReadFromMemory[15:8], dataReadFromMemory[7:0]});

       $display("Teste lh negativo");
       dataReadFromMemory = -16'd4;
       opcode = 7'b0000011;
       funct3 = 3'b001;
       #10
       Check({writeDataReg, -32'b1, -16'b1, dataReadFromMemory[15:8], dataReadFromMemory[7:0]});
      

      $display("Teste lw positivo");
       dataReadFromMemory = 32'd8;
       opcode = 7'b0000011;
       funct3 = 3'b010;
       #10
       Check({writeDataReg, 32'b0, dataReadFromMemory[31:16], dataReadFromMemory[15:8], dataReadFromMemory[7:0]});

       $display("Teste lw negativo");
       dataReadFromMemory = -32'd8;
       opcode = 7'b0000011;
       funct3 = 3'b010;
       #10
       Check({writeDataReg, -32'b1, dataReadFromMemory[31:16], dataReadFromMemory[15:8], dataReadFromMemory[7:0]});

       $display("Teste lbu");
       dataReadFromMemory = 8'd16;
       opcode = 7'b0000011;
       funct3 = 3'b100;
       #10
       Check({writeDataReg, 32'b0, 16'b0, 8'b0, dataReadFromMemory[7:0]});

       $display("Teste lhu");
       dataReadFromMemory = 16'd32;
       opcode = 7'b0000011;
       funct3 = 3'b101;
       #10
       Check({writeDataReg, 32'b0, 16'b0, dataReadFromMemory[15:8], dataReadFromMemory[7:0]});

       $display("Errors: %d", errors);
       $finish;
       end
endmodule