/* ALU capaz de fazer operações de adição, subtração, or
   and, xor, set less than, set less than unsigned, shift left logical,
   shift right logical, shift right arithmetic, add word, sub word, 
   shift left logical word, shift right logical word, shift right arithmetic word,
   */
module ALU (
    input signed [63:0] A,
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
    wire [63:0] resXor;
    wire [63:0] resSLT;
    wire [63:0] resSLTU;
    wire [63:0] resShiftLeftLogical;
    wire [63:0] resShiftRightLogical;
    wire [63:0] resShiftRightArith;
    wire [31:0] resAddW;
    wire [31:0] resSubW;
    wire [31:0] resShiftLeftLogicalW;
    wire [31:0] resShiftRightLogicalW;
    wire [31:0] resShiftRightArithW;

    /* Verifica se deve ser uma instrucao de subtracao */
    wire isSub;
    wire wire1;
    wire wire2;
    wire wire3;
    wire wire4;
    /* verificar se e sub de fato */
    and (wire1, ALUOp[0], ALUOp[1]);
    /* verificar se e um slt */
    and (wire2, ALUOp[0], ALUOp[2]);
    /* verificar se e um sltu */
    and (wire3, ALUOp[1], ALUOp[2]);
    /* verifica se e um subw */
    and (wire4, ALUOp[3], ALUOp[1], ALUOp[0]);
    /* verificação da sub */
    or(isSub, wire1, wire2, wire3, wire4);

    /* pega a parte low dos operandos e separa para usar
       nas operacoes da extensao RV64I */
    wire signed [31:0] lowerA;
    wire signed [31:0] lowerB;

    assign lowerA = A[31:0];
    assign lowerB = B[31:0];

    /* set less than */
    assign resSLT = {63'd0, lesser_than};

    /* set less than unsigned */
    assign resSLTU = {63'd0, unsigned_lesser};

    /* shift left logical */
    assign resShiftLeftLogical = A << B[4:0];

    /* shift right logical */
    assign resShiftRightLogical = A >> B[4:0];

    /* shift right arithmetic */
    assign resShiftRightArith = A >>> B[4:0];

    /* add word */
    assign resAddW = lowerA + lowerB;

    /* sub word */
    assign resSubW = lowerA - lowerB;

    /* shift left logical word */
    assign resShiftLeftLogicalW = A[31:0] << B[3:0];

    /* shift right logical word */
    assign resShiftRightLogicalW = A[31:0] >> B[3:0];

    /* shift right arithmetic word */
    assign resShiftRightArithW = lowerA >>> B[3:0];

    /* Aqui sao calculados a soma, a subtracao, o and, xor e o or bitwise */
    Adder64b_mod Adder64b_mod (.A(A), .B(B), .SUB(isSub), .S(resAddSub), .COUT(overflow));
    andModule andmod (.A(A), .B(B), .result(resAnd));
    orModule ormod (.A(A), .B(B), .result(resOr));
    xorModule xormod (.A(A), .B(B), .result(resXor));
    
    /* De acordo com o ALUOp, e selecionado o resultado entre os 4 anteriores em um mux.
       Esse mux foi feito na forma estrutural
    */
    mux_15x1_64bit_ALU mux_15x1_64bit_ALU(.S(ALUOp), .A(resAddSub), .B(resAnd), .C(resOr),
            .D(resAddSub), .E(resXor), .F(resSLT), .G(resSLTU), .H(resShiftLeftLogical),
            .I(resShiftRightLogical), .J(resShiftRightArith),
            /* Essa repeticao absurda de sinais e para manter os sinais dos shifts */
            .K({resAddW[31],resAddW[31], resAddW[31], 
                resAddW[31], resAddW[31], resAddW[31], 
                resAddW[31], resAddW[31], resAddW[31], 
                resAddW[31], resAddW[31], resAddW[31], 
                resAddW[31], resAddW[31], resAddW[31], 
                resAddW[31], resAddW[31], resAddW[31], 
                resAddW[31], resAddW[31], resAddW[31], 
                resAddW[31], resAddW[31], resAddW[31], 
                resAddW[31], resAddW[31], resAddW[31], 
                resAddW[31], resAddW[31], resAddW[31],
                resAddW[31], resAddW[31], resAddW}),
            .L({resSubW[31],resSubW[31], resSubW[31], 
                resSubW[31], resSubW[31], resSubW[31], 
                resSubW[31], resSubW[31], resSubW[31], 
                resSubW[31], resSubW[31], resSubW[31], 
                resSubW[31], resSubW[31], resSubW[31], 
                resSubW[31], resSubW[31], resSubW[31], 
                resSubW[31], resSubW[31], resSubW[31], 
                resSubW[31], resSubW[31], resSubW[31], 
                resSubW[31], resSubW[31], resSubW[31], 
                resSubW[31], resSubW[31], resSubW[31],
                resSubW[31], resSubW[31], resSubW}),
            .M({resShiftLeftLogicalW[31], resShiftLeftLogicalW[31], resShiftLeftLogicalW[31], 
                resShiftLeftLogicalW[31], resShiftLeftLogicalW[31], resShiftLeftLogicalW[31], 
                resShiftLeftLogicalW[31], resShiftLeftLogicalW[31], resShiftLeftLogicalW[31], 
                resShiftLeftLogicalW[31], resShiftLeftLogicalW[31], resShiftLeftLogicalW[31], 
                resShiftLeftLogicalW[31], resShiftLeftLogicalW[31], resShiftLeftLogicalW[31], 
                resShiftLeftLogicalW[31], resShiftLeftLogicalW[31], resShiftLeftLogicalW[31], 
                resShiftLeftLogicalW[31], resShiftLeftLogicalW[31], resShiftLeftLogicalW[31], 
                resShiftLeftLogicalW[31], resShiftLeftLogicalW[31], resShiftLeftLogicalW[31], 
                resShiftLeftLogicalW[31], resShiftLeftLogicalW[31], resShiftLeftLogicalW[31], 
                resShiftLeftLogicalW[31], resShiftLeftLogicalW[31], resShiftLeftLogicalW[31],
                resShiftLeftLogicalW[31], resShiftLeftLogicalW[31], resShiftLeftLogicalW}),
                .N({32'd0, resShiftRightLogicalW}),
                .O({resShiftRightArithW[31], resShiftRightArithW[31], resShiftRightArithW[31], 
                resShiftRightArithW[31], resShiftRightArithW[31], resShiftRightArithW[31], 
                resShiftRightArithW[31], resShiftRightArithW[31], resShiftRightArithW[31], 
                resShiftRightArithW[31], resShiftRightArithW[31], resShiftRightArithW[31], 
                resShiftRightArithW[31], resShiftRightArithW[31], resShiftRightArithW[31], 
                resShiftRightArithW[31], resShiftRightArithW[31], resShiftRightArithW[31], 
                resShiftRightArithW[31], resShiftRightArithW[31], resShiftRightArithW[31], 
                resShiftRightArithW[31], resShiftRightArithW[31], resShiftRightArithW[31], 
                resShiftRightArithW[31], resShiftRightArithW[31], resShiftRightArithW[31], 
                resShiftRightArithW[31], resShiftRightArithW[31], resShiftRightArithW[31],
                resShiftRightArithW[31], resShiftRightArithW[31], resShiftRightArithW}),
            .X(result));
    
    /* Por ultimo, calcula-se se o resultado vale equal por meio de um nor com todos os bits do resultado.
       Esse valor e utilizado para a branch na instrucao beq */
    nor (equal,
    resAddSub[0],
    resAddSub[1],
    resAddSub[2],
    resAddSub[3],
    resAddSub[4],
    resAddSub[5],
    resAddSub[6],
    resAddSub[7],
    resAddSub[8],
    resAddSub[9],
    resAddSub[10],
    resAddSub[11],
    resAddSub[12],
    resAddSub[13],
    resAddSub[14],
    resAddSub[15],
    resAddSub[16],
    resAddSub[17],
    resAddSub[18],
    resAddSub[19],
    resAddSub[20],
    resAddSub[21],
    resAddSub[22],
    resAddSub[23],
    resAddSub[24],
    resAddSub[25],
    resAddSub[26],
    resAddSub[27],
    resAddSub[28],
    resAddSub[29],
    resAddSub[30],
    resAddSub[31],
    resAddSub[32],
    resAddSub[33],
    resAddSub[34],
    resAddSub[35],
    resAddSub[36],
    resAddSub[37],
    resAddSub[38],
    resAddSub[39],
    resAddSub[40],
    resAddSub[41],
    resAddSub[42],
    resAddSub[43],
    resAddSub[44],
    resAddSub[45],
    resAddSub[46],
    resAddSub[47],
    resAddSub[48],
    resAddSub[49],
    resAddSub[50],
    resAddSub[51],
    resAddSub[52],
    resAddSub[53],
    resAddSub[54],
    resAddSub[55],
    resAddSub[56],
    resAddSub[57],
    resAddSub[58],
    resAddSub[59],
    resAddSub[60],
    resAddSub[61],
    resAddSub[62],
    resAddSub[63]
    );

    assign not_equal = ~equal;

    // signed lesser & greater_or_equal:
    assign lesser_than = resAddSub[63];
    assign greater_or_equal = ~lesser_than;

    // unsigned lesser & greater_or_equal:
    assign unsigned_lesser = A < B ? 1'b1 : 1'b0;
    assign unsigned_greater_equal = ~unsigned_lesser;
endmodule
