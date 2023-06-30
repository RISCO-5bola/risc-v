/* 0 - right
   1 - left */
module shiftLeftOrRight(
input [63:0]mantissaToShift,
output [26:0] shifted,
input [22:0] howMany,
input rightOrLeft
);

    /*initial begin
         $dumpfile("ShiftLeftOrRight.vcd");
         $dumpvars(0, shiftLeftOrRight);
    end*/
wire [63:0] rightShifted;
wire [63:0] leftShifted;
wire [63:0] transient;
wire [63:0] saidaMux;
assign transient = mantissaToShift;

assign rightShifted = mantissaToShift >> howMany;
assign leftShifted = transient << howMany;

mux_2x1_28bit muxA(.A(rightShifted),.B(leftShifted), .S(rightOrLeft),.X(saidaMux));
assign shifted = saidaMux[27:1];

endmodule