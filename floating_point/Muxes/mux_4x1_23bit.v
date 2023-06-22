module mux_4x1_23bit (
    input [3:0] S,
    input [22:0] A, B, C, D,
    output reg [22:0] X
);

always @ (*) 
    begin
        if (S == 4'b0001)
            X <= A;
        else if (S == 4'b0010)
            X <= B;
        else if (S == 4'b0100)
            X <= C;
        else
            X <= D;
    end
endmodule