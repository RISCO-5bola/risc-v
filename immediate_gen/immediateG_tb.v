`timescale 1ns / 100 ps

module immediateG_tb();
    reg [31:0]inst_tb;
    wire [63:0] imm_tb;

    immediateG uut (.inst(inst_tb), .imm(imm_tb));

    initial begin
       
        //CASO DEFAULT 
        inst_tb = 32'b0;
        #20 /*Intervalo setado para garantir que os bits foram comunicados*/
        $display("CASO DEFAULT");
        $display("Immediate = %b\n", imm_tb);
        if(imm_tb == 64'b0)
            $display("OK\n"); 
        else
            $display("Erro");
        #20

        //BEQ
        inst_tb = 32'b0000111111111111111111110_1100011;
        #20
        $display ("\nCASO BEQ");
        $display("Immediate = %b\n", imm_tb);
        if(imm_tb == {52'b0, 12'b000001111111})
            $display("OK\n");
        else
            $display("Erro");
        //LW
        inst_tb = 32'b0101010101010111111111111_0000011;
        #20
        $display("\nCASO LW");
        $display("Immediate = %b\n", imm_tb);
        if(imm_tb == {52'b0, 12'b010101010101})
            $display("OK\n");
        else
            $display("Erro");

        //SW
        inst_tb = 32'b0101010111111111111110101_0100011;
        #20
        $display("\nCASO SW");
        $display("Immediate = %b\n", imm_tb);
        if(imm_tb == {52'b0, 12'b010101010101})
            $display("OK\n");
        else
            $display("Erro");

        //J                                           
        inst_tb = 32'b1_00111100_1_0011111100_00000_1101111;
        #20
        $display("\nCASO J");
        $display("Immediate = %b\n", imm_tb);
        if(imm_tb == {42'b0, 20'b1_0011111100_1_00111100})
            $display("OK\n");
        else
            $display("Erro");
        $finish; 
    end
endmodule
