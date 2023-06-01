module storage_choose_tb ();
    reg [63:0] writeData;
    reg [2:0] funct3;
    wire [63:0] dataToBeWritten;

    
    storage_choose UUT(.writeData(writeData), .funct3(funct3), 
                        .dataToBeWritten(dataToBeWritten));
    
    integer errors = 0;
    task Check;
        input [127:0] expect;
        if (expect[127:64] !== expect[63:0]) begin
            $display("Got %d, expected %d", expect[127:64], expect[63:0]);
            errors = errors + 1;
        end
    endtask
    
    initial begin      
       $display("Teste sb positivo");
       writeData = 8'd2;
       funct3 = 3'b000;
       #10
       Check({dataToBeWritten, 32'b0, 16'b0, 8'b0, 8'd2});

       $display("Teste sb negativo");
       writeData = -8'd2;
       funct3 = 3'b000;
       #10
       Check({dataToBeWritten, 32'd0, 16'd0, 8'd0, writeData[7:0]});

       $display("Teste sh positivo");
       writeData = 16'd4;
       funct3 = 3'b001;
       #10
       Check({dataToBeWritten, 32'b0, 16'b0, writeData[15:8], writeData[7:0]});

       $display("Teste sh negativo");
       writeData = -16'd4;
       funct3 = 3'b001;
       #10
       Check({dataToBeWritten, 32'd0, 16'd0, writeData[15:8], writeData[7:0]});

       $display("Teste sw positivo");
       writeData = 32'd8;
       funct3 = 3'b010;
       #10
       Check({dataToBeWritten, 32'b0, writeData[31:16], writeData[15:8], writeData[7:0]});

       $display("Teste sw negativo");
       writeData = -32'd8;
       funct3 = 3'b010;
       #10
       Check({dataToBeWritten, 32'd0, writeData[31:16], writeData[15:8], writeData[7:0]});

       $display("Errors: %d", errors);
       $finish;
       end
endmodule