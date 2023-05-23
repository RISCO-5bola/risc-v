`include "./ImmediateGenerator/mux_6x1_64bit.v"
module immediateG (instruction, immediate);
    input [31:0] instruction;
    output [63:0] immediate;

    wire [11:0] ITypeImmediate; // LW, SW, ADDI, SUBI e JALR
    wire [11:0] SWTypeImmediate;
    wire [11:0] BTypeImmediate;
    wire [19:0] JTypeImmediate;
    wire [19:0] UTypeImmediate;

    wire [50:0] sign;
    wire [43:0] signJ;
    wire [31:0] signU;
    wire wire1, wire2, wire3, wire4, wire5, wire6, wireU;
    wire [2:0] type;

    /* Estes sao os sinais para o sinal,
        Transforma para complemento de 2 */
    assign sign = {instruction[31], instruction[31], instruction[31], instruction[31], instruction[31],
                   instruction[31], instruction[31], instruction[31], instruction[31], instruction[31],
                   instruction[31], instruction[31], instruction[31], instruction[31], instruction[31],
                   instruction[31], instruction[31], instruction[31], instruction[31], instruction[31],
                   instruction[31], instruction[31], instruction[31], instruction[31], instruction[31],
                   instruction[31], instruction[31], instruction[31], instruction[31], instruction[31],
                   instruction[31], instruction[31], instruction[31], instruction[31], instruction[31],
                   instruction[31], instruction[31], instruction[31], instruction[31], instruction[31],
                   instruction[31], instruction[31], instruction[31], instruction[31], instruction[31],
                   instruction[31], instruction[31], instruction[31], instruction[31], instruction[31],
                   instruction[31]};

   assign signJ = {instruction[31], instruction[31], instruction[31], instruction[31], instruction[31],
                   instruction[31], instruction[31], instruction[31], instruction[31], instruction[31],
                   instruction[31], instruction[31], instruction[31], instruction[31], instruction[31],
                   instruction[31], instruction[31], instruction[31], instruction[31], instruction[31],
                   instruction[31], instruction[31], instruction[31], instruction[31], instruction[31],
                   instruction[31], instruction[31], instruction[31], instruction[31], instruction[31],
                   instruction[31], instruction[31], instruction[31], instruction[31], instruction[31],
                   instruction[31], instruction[31], instruction[31], instruction[31], instruction[31],
                   instruction[31], instruction[31], instruction[31], instruction[31]};

    assign signU = {instruction[31], instruction[31], instruction[31], instruction[31], instruction[31],
                    instruction[31], instruction[31], instruction[31], instruction[31], instruction[31],
                    instruction[31], instruction[31], instruction[31], instruction[31], instruction[31],
                    instruction[31], instruction[31], instruction[31], instruction[31], instruction[31],
                    instruction[31], instruction[31], instruction[31], instruction[31], instruction[31],
                    instruction[31], instruction[31], instruction[31], instruction[31], instruction[31],
                    instruction[31], instruction[31]};

    /* seta os outputs dependendo das instrucoes */
    assign ITypeImmediate = instruction[31:20];
    assign SWTypeImmediate = {instruction[31:25], instruction[11:7]};
    assign BTypeImmediate = {instruction[31], instruction[7], instruction[30:25], instruction[11:8]};
    assign JTypeImmediate = {instruction[31], instruction[19:12], instruction[20], instruction[30:21]};
    assign UTypeImmediate = {instruction[31:12]};

    /* reconhece se a instrucao e lw */
    and (wire1, ~instruction[6], ~instruction[5], ~instruction[4], ~instruction[3],
               ~instruction[2], instruction[1], instruction[0]);

    /* reconhece se a instrucao e addi */
    and (wire2, ~instruction[6], ~instruction[5], instruction[4], ~instruction[3],
               ~instruction[2], instruction[1], instruction[0]);

    /* reconhece se a instrucao e sw */
    nand (wire3, ~instruction[6], instruction[5], ~instruction[4], ~instruction[3],
               ~instruction[2], instruction[1], instruction[0]);

    /* reconhece se a instrucao e j */
    and (wire4, instruction[6], instruction[5], ~instruction[4], instruction[3],
               instruction[2], instruction[1], instruction[0]);

    /* reconhece se a instrucao e U*/
    and (wireU, ~instruction[6], ~instruction[5], instruction[4], ~instruction[3],
               instruction[2], instruction[1], instruction[0]);

    /* se a instrucao for addi ou lw nao importa porque as duas instrucoes tem o 
       immediate na mesma posicao da instrucao, entao se qualquer um deles for 1
       o nand retorna um 0 e esse sera o valor de type[0] se a instrucao for de
       sw, o and retornara 1 e o valor de type[0] sera 1 */
    nor (wire5, wire1, wire2, wire3);
    or (type[0], wire4, wire5);

    assign type[2] = wireU;

    /* reconhece se a instrucao e b e coloca em type[2]*/
    and (wire6, instruction[6], instruction[5], ~instruction[4], ~instruction[3],
               ~instruction[2], instruction[1], instruction[0]);
    or (type[1], wire4, wire6);

    /* mux para escolher output 
       se type[2:0] = 000, sai o immediate do addi ou lw
       se type[2:0] = 001, sai o immediate do sw
       se type[2:0] = 010, sai o immediate do b 
       se type[2:0] = 011, sai o immediate do j
       se type[2:0] = 100, sai o immediate do u*/
    mux_6x1_64bit muxImmeadite (.A({sign, instruction[31], ITypeImmediate}), .B({sign, instruction[31], SWTypeImmediate}), 
                                .C({sign, BTypeImmediate, 1'b0}), .D({signJ[43:1], JTypeImmediate, 1'b0}), .E({signU, UTypeImmediate, 12'b0}), 
                                .S({type[2], type[1], type[0]}), .X(immediate));
endmodule