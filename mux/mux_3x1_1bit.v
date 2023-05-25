module mux_3x1_1bit (
    input [1:0] S,
    input A, B, C,
    output reg X
);

always @ (*) 
    begin
        if (S == 2'b00)
            X <= A;
        else if (S == 2'b01)
            X <= B;
        else if (S == 2'b10)
            X <= C;
    end
endmodule