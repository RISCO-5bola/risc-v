`include "./ALU/operations/and.v"
`include "./ALU/operations/Adder64b_mod.v"
`include "./ALU/operations/or.v"
`include "./ALU/mux_3x1_64bit_ALU.v"

module ALU (
    input [63:0] A,
    input [63:0] B,
    input [3:0] ALUOp,
    output [63:0] result,
    output equal,
    output not_equal,
    output lesser_than,
    output greater_or_equal,
    output unsigned_lesser,
    output unsigned_greater_equal
);
    wire [63:0] resAddSub;
    wire overflow;
    wire [63:0] resAnd;
    wire [63:0] resOr;
    
    /* Aqui sao calculados a soma, a subtracao, o and e o or bitwise */
    Adder64b_mod Adder64b_mod (.A(A), .B(B), .SUB(ALUOp[2]), .S(resAddSub), .COUT(overflow));
    andModule andmod (.A(A), .B(B), .result(resAnd));
    orModule ormod (.A(A), .B(B), .result(resOr));
    
    /* De acordo com o ALUOp, e selecionado o resultado entre os 4 anteriores em um mux.
       Esse mux foi feito na forma estrutural
    */
    mux_3x1_64bit_ALU mux_3x1_64bit_ALU(.S(ALUOp), .A(resAddSub), .B(resAnd), .C(resOr), .X(result));
    
    /* Por ultimo, calcula-se se o resultado vale equal por meio de um nor com todos os bits do resultado.
       Esse valor e utilizado para a branch na instrucao beq */
    nor (equal,
    result[0],
    result[1],
    result[2],
    result[3],
    result[4],
    result[5],
    result[6],
    result[7],
    result[8],
    result[9],
    result[10],
    result[11],
    result[12],
    result[13],
    result[14],
    result[15],
    result[16],
    result[17],
    result[18],
    result[19],
    result[20],
    result[21],
    result[22],
    result[23],
    result[24],
    result[25],
    result[26],
    result[27],
    result[28],
    result[29],
    result[30],
    result[31],
    result[32],
    result[33],
    result[34],
    result[35],
    result[36],
    result[37],
    result[38],
    result[39],
    result[40],
    result[41],
    result[42],
    result[43],
    result[44],
    result[45],
    result[46],
    result[47],
    result[48],
    result[49],
    result[50],
    result[51],
    result[52],
    result[53],
    result[54],
    result[55],
    result[56],
    result[57],
    result[58],
    result[59],
    result[60],
    result[61],
    result[62],
    result[63]
    );

    assign not_equal = ~equal;

    // signed lesser & greater_or_equal:
    assign lesser_than = result[63];
    assign greater_or_equal = ~lesser_than;

    // unsigned lesser & greater_or_equal:

    assign unsigned_lesser = A < B ? 1'b1 : 1'b0;
    assign unsigned_greater_equal = ~unsigned_lesser;
endmodule
