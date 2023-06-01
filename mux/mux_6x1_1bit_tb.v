module mux_6x1_64bit_tb ();
    reg [2:0] funct3;
    reg BEQ, BNE, BLT, BGE, BLTU, BGEU;
    wire selectedFlag;
    
    integer errors = 0;

    task Check;
        input [1:0] expect;
        if (expect[1] != expect[0]) begin
            $display("Got %d, expected %d", expect[1], expect[0]);
            errors = errors + 1;
        end
    endtask

    mux_6x1_1bit UUT (.BEQ(BEQ), .BNE(BNE), .BLT(BLT), .BGE(BGE), .BLTU(BLTU), 
                        .BGEU(BGEU), .selectedFlag(selectedFlag), .funct3(funct3));

    initial begin
       #10
       funct3 <= 3'b000; 
       BEQ <= 1'b1; BNE <= 1'b1; BLT <= 1'b1; 
       BGE <= 1'b1; BLTU <= 1'b1; BGEU <= 1'b1;
       
       #10

       $display("Test saida BEQ");
       funct3 <= 3'b000;
       #10
       Check({selectedFlag, 1'b1});
       #10

       $display("Test saida BNE");
       funct3 = 3'b001;
       #10
       Check({selectedFlag, 1'b1});
       #10

       $display("Test saida BLT");
       funct3 = 3'b100;
       #10
       Check({selectedFlag, 1'b1});
       #10

       $display("Test saida BGE");
       funct3 = 3'b101;
       #10
       Check({selectedFlag, 1'b1});
       #10

       $display("Test saida BLTU");
       funct3 = 3'b110;
       #10
       Check({selectedFlag, 1'b1});
       #10

       $display("Test saida BGEU");
       funct3 = 3'b111;
       #10
       Check({selectedFlag, 1'b1});
       #10

       $display("Errors: %d", errors);
       $finish;
       
    end
endmodule