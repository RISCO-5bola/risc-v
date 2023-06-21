module mux_2x1_24bit (
    input S,
    input [23:0] A, B,
    output reg [23:0] X
);

always @ (*) 
    begin
        if (S == 1'b0)
            X <= A;
        else if (S == 1'b1)
            X <= B;
    end
endmodule