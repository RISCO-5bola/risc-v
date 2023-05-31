module mux_7x1_64bit (
    input [2:0] S,
    input [63:0] A, B, C, D, E, F, G,
    output reg [63:0] X
);

always @ (*) 
    begin
        if (S == 3'b000)
            X <= A;
        else if (S == 3'b001)
            X <= B;
        else if (S == 3'b010)
            X <= C;
        else if (S == 3'b011)
            X <= D;
        else if (S == 3'b100)
            X <= E;
        else if (S == 3'b101)
            X <= F;
        else if (S == 3'b110)
            X <= G;
    end
endmodule