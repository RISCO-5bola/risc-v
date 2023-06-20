`timescale 1ns/100ps

module testbench ();
    reg [63:0] A;
    reg [63:0] B;
    reg [3:0] ALUOp;

    wire [63:0] result;
    
    ALU UUT (.A(A), .B(B), .ALUOp(ALUOp), .result(result));

    integer i, errors = 0;
    task Check ;
        input [63:0] expect;
        if (result !== expect) begin
                $display ("Error : A: %b B: %b expect: %b got: %b", A, B, expect, result);
                errors = errors + 1;
        end
    endtask

    initial begin
        
        A = 64'd10;
        B = 64'd10;
        ALUOp = 4'b0010;
        #100
        Check(64'd20);

        A = 64'd30;
        B = 64'd10;
        ALUOp = 4'b0010;
        #100
        Check(64'd40);

        A = 64'd30;
        B = 64'd10;
        ALUOp = 4'b0110;
        #100
        Check(64'd20);

        A = 64'b0000000000111111111100;
        B = 64'b0000000000000000000111;
        ALUOp = 4'b0000;
        #100
        Check(64'b0000000000000000000100);

        A = 64'b0000000000111111111100;
        B = 64'b0000000000000000000111;
        ALUOp = 4'b0001;
        #100
        Check(64'b0000000000111111111111);

        $display("Test finished. Erros: %d", errors);
    end
endmodule