module mux_10x1_64bit_ALU (
    input [3:0] S,
    input [63:0] A, B, C, D, E, F, G, H, I, J,
    output reg [63:0] X
);
always @ (*) 
    begin
        if (S == 4'b0000)
            X <= A;
        else if (S == 4'b0001)
            X <= B;
        else if (S == 4'b0010)
            X <= C;
        else if (S == 4'b0011)
            X <= A;
        else if (S == 4'b0100)
            X <= E;
        else if (S == 4'b0101)
            X <= F;
        else if (S == 4'b0110)
            X <= G;
        else if (S == 4'b0111)
            X <= H;
        else if (S == 4'b1000)
            X <= I;
        else if (S == 4'b1001)
            X <= J;
    end
endmodule