module mux_2x1_8bit (
    input S,
    input [7:0] A, B,
    output reg [7:0] X
);

always @ (*) 
    begin
        if (S == 2'b00)
            X <= A;
        else if (S == 2'b01)
            X <= B;
    end
endmodule