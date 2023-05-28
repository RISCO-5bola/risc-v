`timescale 1ns / 100ps

module CLAAdder8b_TB ();
reg [7:0] A, B, correctS;
reg [8:0] Sum; 
reg CIN, correctCOUT;
wire COUT;
wire [7:0] S;
integer errors, i , j;

task Check;
    input [7:0] xpectS;
    input xpectCOUT;
    begin
    if (S != xpectS) begin 
        $display ("Error A: %8b, B: %8b, expected %8b, got S: %8b", A, B, xpectS, S);
        errors = errors + 1;
    end
    if (COUT != xpectCOUT) begin 
        $display ("Error A: %8b, B: %8b, expected %b, got COUT: %b", A, B, xpectCOUT, COUT);
        errors = errors + 1;
    end
    end
endtask

// módulo testado
CLAAdder8b UUT (.A(A), .B(B), .CIN(CIN), .S(S), .COUT(COUT));

initial begin 
    errors = 0;
    CIN = 1; 
    for (i = 0; i < 256; i = i + 1)
        for (j = 0; j < 256; j = j + 1) begin
            A = i;
            B = j;
            Sum = A + B + CIN;
            correctS = Sum[7:0]; 
            correctCOUT = S[8]; 
            #10;
            Check (correctS, correctCOUT);
        end
    $display ("Finished, got %2d errors", errors);
end


endmodule