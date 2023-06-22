module defineSignal_tb ();
    reg signed [7:0] exponentDifference;
    reg signalFirst, signalSecond, sumOrMultiplication;
    reg [22:0] mantissaFirst, mantissaSecond;
    wire signalResult;

    defineSignal UUT (.exponentDifference(exponentDifference), .signalFirst(signalFirst),
                      .signalSecond(signalSecond), .sumOrMultiplication(sumOrMultiplication),
                      .mantissaFirst(mantissaFirst), .mantissaSecond(mantissaSecond),
                      .signalResult(signalResult));

    integer errors = 0;

    task Check;
        input expect;

        if (expect !== signalResult) begin
            $display("Error! Expected %b, got %b", expect, signalResult);
            errors = errors + 1;
        end else begin
            $display("Passed!\n");
        end
    endtask

    initial begin
        //testes simples: multiplicacao
        #10
        $display("Teste 1");
        //1 - sinais 1 em ambos
        exponentDifference = 8'd5;
        signalFirst = 1'b1;
        signalSecond = 1'b1;
        mantissaFirst = 23'd50;
        mantissaSecond = 23'd100;
        sumOrMultiplication = 1'b1;
        #10
        Check(1'b0);
        $display("Teste 2");
        //2 - sinais diferentes
        exponentDifference = 8'd5;
        signalFirst = 1'b0;
        signalSecond = 1'b1;
        mantissaFirst = 23'd50;
        mantissaSecond = 23'd100;
        sumOrMultiplication = 1'b1;
        #10
        Check(1'b1);

        //testes com somas:
        $display("Teste 3");
        //1 - somando dois valores com sinal positivo
        exponentDifference = 8'd5;
        signalFirst = 1'b0;
        signalSecond = 1'b0;
        mantissaFirst = 23'd50;
        mantissaSecond = 23'd100;
        sumOrMultiplication = 1'b0;
        #10
        Check(1'b0);
        $display("Teste 4");
        //2 - somando dois valores com sinais negativos
        exponentDifference = 8'd5;
        signalFirst = 1'b1;
        signalSecond = 1'b1;
        mantissaFirst = 23'd50;
        mantissaSecond = 23'd100;
        sumOrMultiplication = 1'b0;
        #10
        Check(1'b1);
        $display("Teste 5");
        //somando dois valores com sinais distintos
        //3 - expoentes iguais e m2 > m1
        exponentDifference = 8'd0;
        signalFirst = 1'b1;
        signalSecond = 1'b0;
        mantissaFirst = 23'd50;
        mantissaSecond = 23'd100;
        sumOrMultiplication = 1'b0;
        #10
        Check(1'b0);
        $display("Teste 6");
        //4 - expoentes iguais e m1 > m2
        exponentDifference = 8'd0;
        signalFirst = 1'b1;
        signalSecond = 1'b0;
        mantissaFirst = 23'd150;
        mantissaSecond = 23'd100 ;
        sumOrMultiplication = 1'b0;
        #10
        Check(1'b1);

        $display("Teste 7");
        //4 - expoentes diferentes - o primeiro é maior que o segundo
        exponentDifference = 8'd5;
        signalFirst = 1'b0;
        signalSecond = 1'b1;
        mantissaFirst = 23'd50;
        mantissaSecond = 23'd100;
        sumOrMultiplication = 1'b0;
        #10
        Check(1'b0);
        $display("Teste 8");
        //5 - expoentes diferentes - o segundo é maior que o primeiro
        exponentDifference = -8'd4;
        signalFirst = 1'b0;
        signalSecond = 1'b1;
        mantissaFirst = 23'd50;
        mantissaSecond = 23'd100;
        sumOrMultiplication = 1'b0;
        #10
        Check(1'b1);

        $display("Teste 9");
        //6 - diferentes sinais, msm xp, mesma mantissa -> vish man
        exponentDifference = 8'd0;
        signalFirst = 1'b0;
        signalSecond = 1'b1;
        mantissaFirst = 23'd100;
        mantissaSecond = 23'd100;
        sumOrMultiplication = 1'b0;
        #10
        Check(1'b0);

        $display("Test finished with %d errors.", errors);
        $finish;
    end
    
endmodule