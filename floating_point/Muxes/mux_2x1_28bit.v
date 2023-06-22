module mux_2x1_28bit (
    input S,
    input [27:0] A, B,
    output reg [27:0] X
);

always @ (*) 
    begin
        if (S == 1'b0)
            X <= A;
        else if (S == 1'b1)
            X <= B;
    end
endmodule