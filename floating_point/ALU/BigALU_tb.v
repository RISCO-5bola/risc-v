module BigALU_tb ();
    reg isSum;
    reg sum_sub;
    reg reset;
    reg clk;
    reg muxDataRegValor2;
    reg [27:0] valor1;
    reg [27:0] valor2;
    wire finishedMult;
    wire [28:0] result;

    BigALU UUT(.isSum(isSum), .sum_sub(sum_sub), .reset, .clk(clk),
               .muxDataRegValor2(muxDataRegValor2), .valor1(valor1),
               .valor2(valor2), .finishedMult(finishedMult), .result(result));

    integer errors;

    task Check;
        input [28:0] check;
        if (check !== result) begin
            $display("Error ocurred! Expected %b, got %b", check, result);
            errors = errors + 1;
        end
    endtask

    initial begin
        clk = 1'b0;
        errors = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        /* teste soma - genérica */
        isSum = 1'b1;
        sum_sub = 1'b0;
        reset = 1'b0;
        muxDataRegValor2 = 1'b0;
        valor1 = 28'd30;
        valor2 = 28'd12;

        #20
        Check(29'd42);

        isSum = 1'b1;
        sum_sub = 1'b1;
        reset = 1'b0;
        muxDataRegValor2 = 1'b0;
        valor1 = 28'd30;
        valor2 = 28'd12;

        #20
        Check(29'd18);

        /* teste multiplicacao - teste genérico */
        isSum = 1'b0;
        sum_sub = 1'b0;
        
        valor1 = 28'b1000_0000_0000_0000_0000_0000_0000;
        valor2 = 28'b1010_0000_0000_0000_0000_0000_0000;
        reset = 1'b1;
        muxDataRegValor2 = 1'b0;
        #10
        reset = 1'b0;
        muxDataRegValor2 = 1'b1;
        #280
        Check(29'b01010000000000000000000000000);

        /* primeiro boss dos testes 3.34543*0.38 */
        isSum = 1'b0;
        sum_sub = 1'b0;
        
        valor1 = 28'b1101011000011011100001100000;
        valor2 = 28'b0001100001010001111010111000;
        reset = 1'b1;
        muxDataRegValor2 = 1'b0;
        #10
        reset = 1'b0;
        muxDataRegValor2 = 1'b1;
        #280
        Check(29'b10100010101110001100000111011);

        /* boss final dos testes 0.38*3.34543 */
        isSum = 1'b0;
        sum_sub = 1'b0;
        
        valor1 = 28'b0001100001010001111010111000;
        valor2 = 28'b1101011000011011100001100000;
        reset = 1'b1;
        muxDataRegValor2 = 1'b0;
        #10
        reset = 1'b0;
        muxDataRegValor2 = 1'b1;
        #280
        Check(29'b00010100010101110001100000111);

        $display("Test finished with %d errors", errors);
        $finish;
    end
    
endmodule