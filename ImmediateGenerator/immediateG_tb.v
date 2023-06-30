module immediateG_tb ();
    reg [31:0] instruction;
    wire signed [63:0] immediate;

    immediateG UUT(.instruction(instruction), .immediate(immediate));

    integer errors = 0;

    task Check;
        input [127:0] expect;
        if (expect[127:64] != expect[63:0]) begin
            $display("Got %b \nexpected %b", expect[127:64], expect[63:0]);
            errors = errors + 1;
        end
    endtask

    /* funcionando */
    initial begin
        #10
        /* addi -> imm = 2*/
        $display("Imm (addi) valor positivo");
        instruction = 32'b000000000010_00000_000_00000_0010011;        
        #10
        Check({immediate, 64'd2});

        /* addi -> imm = -2*/
        $display("Imm (addi) valor negativo");
        instruction = 32'b111111111110_00000_000_00000_0010011;
        #10
        Check({immediate, -64'd2});
        
        /* lw -> imm = 4*/
        $display("lw valor positivo");
        instruction = 32'b000000000100_00000_010_00000_0000011;
        #10
        Check({immediate, 64'd4});
            
        /* lw -> imm = -4*/
        $display("lw valor negativo");
        instruction = 32'b111111111100_00000_010_00000_0000011;
        #10
        Check({immediate, -64'd4});

        /* sw -> imm = 8*/
        $display("sw valor positivo");
        instruction = 32'b0000000_00000_00000_010_01000_0100011;
        #10
        Check({immediate, 64'd8});
            
        /* sw -> imm = -8*/
        $display("sw valor negativo");
        instruction = 32'b1111111_00000_00000_010_11000_0100011;
        #10
        Check({immediate, -64'd8});

        /* b -> imm = 16*/
        $display("b valor positivo");
        instruction = 32'b0000000_00000_00000_000_1000_0_1100011;
        #10
        Check({immediate, 64'd12}); // para o tipo b se diminui em 2, então fica 12

        /* b -> imm = -16*/
        $display("b valor negativo");
        instruction = 32'b1111111_00000_00000_000_1000_1_1100011;
        #10
        Check({immediate, -64'd20}); // novamente se diminui dois entao fica -20

        /* jal -> imm = 32*/
        $display("jal valor positivo");
        instruction = 32'b0_0000010000_0_00000000_00000_1101111;
        #10
        Check({immediate, 64'd28}); // aqui também se diminui 4 então fica 28
            
        /* jal -> imm = -32*/
        $display("jal valor negativo");
        instruction = 32'b1_1111110000_1_11111111_00000_1101111;
        #10
        Check({immediate, -64'd36}); // diminui 4 e fica -36

        /* u -> imm = 4096*/ 
        $display("u valor positivo");
        instruction = 32'b00000000000000000001_00000_0010111;
        #10
        Check({immediate, 64'd4092}); // diminui 4 e fica 4092

        /* u -> imm = -4096*/
        $display("u valor negativo");
        instruction = 32'b11111111111111111111_00000_0010111;
        #10
        Check({immediate, -64'd4100}); // diminui 4 e fica -4100

        /* jalr -> imm = -64*/
        $display("jalr valor negativo");
        instruction = 32'b111111000000_00000_000_00000_1100111;
        #10
        Check({immediate, -64'd64});
            
        /* jalr -> imm = 64*/
        $display("jalr valor positivo");
        instruction = 32'b000001000000_00000_000_00000_1100111;
        #10
        Check({immediate, 64'd64});

        /* flw -> imm = 128*/
        $display("flw valor positivo");
        instruction = 32'b000010000000_00000_000_00000_0000111;
        #10
        Check({immediate, 64'd128});

        /* flw -> imm = -128*/
        $display("flw valor negativo");
        instruction = 32'b111110000000_00000_000_00000_0000111;
        #10
        Check({immediate, -64'd128});
 
        /* fsw -> imm = 256*/
        $display("fsw valor positivo");
        instruction = 32'b0001000_00000_00000_000_00000_0000111;
        #10
        
        /* fsw -> imm = -256*/
        $display("fsw valor negativo");
        instruction = 32'b1111000_00000_00000_000_00000_0000111;
        #10
        $display("Errors: %d", errors);
        $finish;
            
    end
endmodule