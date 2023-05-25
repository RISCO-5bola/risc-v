module mux_3x1_64bit_ALU (
    input [3:0] S,
    input [63:0] A, B, C,
    output reg [63:0] X
);
always @ (*) 
    begin
        if (S == 4'b0000)
            X <= A;
        else if (S == 4'b0011)
            X <= A;
        else if (S == 4'b0001)
            X <= B;
        else if (S == 4'b0010)
            X <= C;
    end
endmodule