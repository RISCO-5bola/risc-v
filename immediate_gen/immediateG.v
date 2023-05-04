module immediateG(
    input [31:0] inst,     /*Instrucao de 32 bits*/
    output reg [63:0] imm   /*Gera um immediate de 12 bits*/    
);

    wire beq, lw, sw, j;
    
    // BEQ
    and (beq, inst[6], inst[5], ~inst[4], ~inst[3], ~inst[2], inst[1], inst[0]);
    // LW
    and (lw, ~inst[6], ~inst[5], ~inst[4], ~inst[3], ~inst[2], inst[1], inst[0]);
    // SW
    and (sw, ~inst[6], inst[5], ~inst[4], ~inst[3], ~inst[2], inst[1], inst[0]);
    // J
    and (j, inst[6], inst[5], ~inst[4], inst[3], inst[2], inst[1], inst[0]);

    always @ (*) 
        begin
            if (beq)
                imm <= {52'd0, inst[31], inst[7], inst[30:25], inst[11:8]};
            else if (lw)
                imm <= {52'd0, inst[31:20]};
            else if (sw)
                imm <= {52'd0, inst[31:25], inst[11:7]};
            else if (j)
                imm <= {42'd0, inst[31], inst[21:12], inst[22], inst[30:23]};
            else
                imm <= 64'b0;
        end

endmodule
