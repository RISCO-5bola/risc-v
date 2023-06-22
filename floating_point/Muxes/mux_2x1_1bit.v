module mux_2x1_1bit (
    input A, B,
    input S,
    output reg X
);

always @ (*) 
    begin
        if (S == 1'b0)
            X <= A;
        else if (S == 1'b1)
            X <= B;
    end
endmodule