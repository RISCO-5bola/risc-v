module mux_2x1_64bit (
    input [63:0] A, B,
    input S,
    output reg [63:0] X
);

always @ (*) 
    begin
        if (S == 1'b0)
            X <= A;
        else if (S == 1'b1)
            X <= B;
    end
endmodule