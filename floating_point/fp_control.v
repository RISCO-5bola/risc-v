module fp_control(
    input signed [7:0] exponentDifference, 
    input [22:0] bigALUOut, roundOut,
    input clk,
    input OPCode;
    output signed [7:0] shiftRight,
    output mux1, mux2, mux3, mux4, 
           shiftLeftOrRight, incrementOrDecrement, round
);  

    /* OPCode:
       0000 = soma
        */
    wire wire0;

    /* manda diferenca dos expoente unsigned para o shift right */
    assign shiftRight = exponentDifference[8] ? -exponentDifference : exponentDifference;

    /* manda o sinal para o mux1, mux3 e mux4 
       para escolher o menor expoente */
    nand (wire0, exponentDifference[8], 1'b1);
    assign mux1 = wire0;
    assign mux3 = wire0;
    assign mux4 = ~wire0;

    assign mux2 = 1'b0;

    xnor (wire1, [22:0]bigALUOut, [22:0] roundOut);


endmodule