module BigALU_control (
    input sumOrMultiplication,
    input clk,
    input endMultiplication,
    output loadRegA,
    output loadRegB,
    output muxA,
    output muxB,
    output muxC,
    output [3:0] AluOp
);
    wire initialLoad;
    assign initialLoad = 1;

    assign loadRegA = xor(~endMultiplication , initialLoad);
    assign loadRegB = xor(~endMultiplication , initialLoad);
    //por hora, apenas deixar para somar.
    assign AluOp = 4'b0000;
    assign 


endmodule