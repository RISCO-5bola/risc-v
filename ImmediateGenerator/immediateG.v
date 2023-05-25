`include "./ImmediateGenerator/mux_6x1_64bit.v"
// `include "../ALU/operations/Adder64b_mod.v"
module immediateG (instruction, immediate);

    input [31:0] instruction;
    output [63:0] immediate;

    wire [11:0] ITypeImmediate; // LW, SW, ADDI, SUBI e JALR
    wire [11:0] SWTypeImmediate;
    wire [11:0] BTypeImmediate;
    wire [19:0] JTypeImmediate;
    wire [19:0] UTypeImmediate;
    wire [11:0] JALRTypeImmediate;

    wire [50:0] sign;
    wire [42:0] signJ;
    wire [31:0] signU;
    wire wire1, wire2, wire3, wire4, wire5;
    wire [2:0] type;
    wire [63:0] mux4;
    wire [63:0] resAddSub;

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
                   instruction[31], instruction[31], instruction[31]};

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
    assign JALRTypeImmediate = instruction[31:20];
   
    /* reconhece se a instrucao e sw */
    and (wire1, ~instruction[6], instruction[5], ~instruction[4], ~instruction[3],
               ~instruction[2], instruction[1], instruction[0]);

    /* reconhece se a instrucao e j */
    and (wire2, instruction[6], instruction[5], ~instruction[4], instruction[3],
               instruction[2], instruction[1], instruction[0]);

    /* reconhece se a instrucao e u */
    and (wire3, ~instruction[6], ~instruction[5], instruction[4], ~instruction[3],
               instruction[2], instruction[1], instruction[0]);

    /* reconhece se a instrucao e b */
     and (wire4, instruction[6], instruction[5], ~instruction[4], ~instruction[3],
               ~instruction[2], instruction[1], instruction[0]);

     /* reconhece se a instruca e jalr */
     and (wire5, instruction[6], instruction[5], ~instruction[4], ~instruction[3],
                instruction[2], instruction[1], instruction[0]);

    or (type[2], wire3, wire5);
    or (type[1], wire2, wire4); 
    or (type[0], wire1, wire2, wire5);
 
    mux_6x1_64bit muxminus4 (.D({signJ, JTypeImmediate, 1'b0}), .C({sign, BTypeImmediate, 1'b0}), .F({sign, instruction[31], JALRTypeImmediate}), 
                        .E({signU, UTypeImmediate, 12'b0}), .S({type[2], type[1], type[0]}), .X({mux4}));
    Adder64b_mod Adder64b_mod (.A(mux4), .B(64'd4), .SUB(1'b1), .S(resAddSub), .COUT(overflow));

    /* mux para escolher output 
       se type[2:0] = 000, sai o immediate do addi ou lw
       se type[2:0] = 001, sai o immediate do sw
       se type[2:0] = 010, sai o immediate do b 
       se type[2:0] = 011, sai o immediate do j
       se type[2:0] = 100, sai o immediate do u
       se type[2:0] = 101, sai o immediate do JALR*/
    mux_6x1_64bit muxImmeadite (.A({sign, instruction[31], ITypeImmediate}), .B({sign, instruction[31], SWTypeImmediate}), 
                                .C(resAddSub), .D(resAddSub), .E(resAddSub), 
                                .F({sign, instruction[31], JALRTypeImmediate}), .S({type[2], type[1], type[0]}), .X(immediate));
   
endmodule