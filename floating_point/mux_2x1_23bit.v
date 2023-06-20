module mux_2x1_23bit (
    input S,
    input [22:0] A, B,
    output reg [22:0] X
);

always @ (*) 
    begin
        if (S == 1'b0)
            X <= A;
        else if (S == 1'b1)
            X <= B;
    end
endmodule