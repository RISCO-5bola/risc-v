module mux_2x1_64bit_S2 (
    input [63:0] A, B,
    input [1:0] S,
    output reg [63:0] X
);

always @ (*) 
    begin
        if (S == 2'b00)
            X <= A;
        else if (S == 2'b11)
            X <= B;
        else // 2'b10
            X <= B;
    end
endmodule