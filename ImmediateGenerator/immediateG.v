module immediateG (instruction, immediate);

    input [31:0] instruction;
    output [63:0] immediate;

    /* lb, lh, lw, lbu, lhu, addi, 
       slti, xori, ori, andi */
    wire [11:0] ITypeImmediate;

    /* sb, sh, sw */
    wire [11:0] SWTypeImmediate;

    /* beq, bne, blt, bge, bltu, bgeu */
    wire [11:0] BTypeImmediate;

    /* jal */
    wire [19:0] JTypeImmediate;

    /* lui, auipc    */
    wire [19:0] UTypeImmediate;

    /* jalr */
    wire [11:0] JALRTypeImmediate;

    /* flw */
    wire [11:0] FLWTypeImmediate;

    /* fsw */
    wire [11:0] FSWTypeImmediate;

    /* wires the setam o sinal dos diferentes tipos de immediate */
    wire [50:0] sign;
    wire [42:0] signJ;
    wire [31:0] signU;

    /* wires auxiliares de conexão */
    wire wire1, wire2, wire3, wire4, wire5, wire6, wire7, wire8;

    /* seta o tipo de immediate */
    wire [3:0] type;

    wire [63:0] mux4;
    wire [63:0] resAddSub;

    /* Estes sao os sinais para o sinal,
        Transforma para complemento de 2 */

    /* sinal geral */
    genvar i;
    generate
        for (i = 0; i < 51; i = i + 1) begin
            assign sign[i] = instruction[31];
        end
    endgenerate

   /* sinal para o tipo J */
   generate
        for (i = 0; i < 43; i = i + 1) begin
            assign signJ[i] = instruction[31];
        end
   endgenerate

    /* sinal para o tipo U */
    generate
        for (i = 0; i < 32; i = i + 1) begin
            assign signU[i] = instruction[31];
        end
    endgenerate

    /* seta os outputs dependendo das instrucoes */
    assign ITypeImmediate = instruction[31:20];
    assign SWTypeImmediate = {instruction[31:25], instruction[11:7]};
    assign BTypeImmediate = {instruction[31], instruction[7], instruction[30:25], instruction[11:8]};
    assign JTypeImmediate = {instruction[31], instruction[19:12], instruction[20], instruction[30:21]};
    assign UTypeImmediate = {instruction[31:12]};
    assign JALRTypeImmediate = instruction[31:20];
    assign FLWTypeImmediate = instruction[31:20];
    assign FSWTypeImmediate = {instruction [31:25], instruction[11:7]};
   
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

    /* reconhece se a instruca e lui */
     and (wire6, ~instruction[6], instruction[5], instruction[4], ~instruction[3],
                instruction[2], instruction[1], instruction[0]);

    and (wire7, ~instruction[6], ~instruction[5], ~instruction[4], ~instruction[3],
                instruction[2], instruction[1], instruction[0]);

    and (wire8, ~instruction[6], instruction[5], ~instruction[4], ~instruction[3],
                instruction[2], instruction[1], instruction[0]);
    
    or (type[3], wire8);
    or (type[2], wire3, wire5, wire6, wire7);
    or (type[1], wire2, wire4, wire6, wire7); 
    or (type[0], wire1, wire2, wire5, wire7);
 
    mux_7x1_64bit muxminus4 (.D({signJ, JTypeImmediate, 1'b0}), .C({sign, BTypeImmediate, 1'b0}), 
                             .F({sign, instruction[31], JALRTypeImmediate}), 
                             .E({signU, UTypeImmediate, 12'b0}), .S({type[2], type[1], type[0]}), .X({mux4}));
    Adder64b_mod Adder64b_mod (.A(mux4), .B(64'd4), .SUB(1'b1), .S(resAddSub), .COUT(overflow));

    /* mux para escolher output 
       se type[3:0] = 0000, sai o immediate do addi ou lw
       se type[3:0] = 0001, sai o immediate do sw
       se type[3:0] = 0010, sai o immediate do b 
       se type[3:0] = 0011, sai o immediate do j
       se type[3:0] = 0100, sai o immediate do u
       se type[3:0] = 0101, sai o immediate do JALR
       se type[3:0] = 0110, sai o immediate do LUI
       se type[3:0] = 0111, sai o immediate do FLW
       se type[3:0] = 1000, sai o immediate do FSW*/
    mux_8x1_64bit muxImmeadite (.A({sign, instruction[31], ITypeImmediate}), .B({sign, instruction[31], SWTypeImmediate}), 
                                .C(resAddSub), .D(resAddSub), .E(resAddSub), 
                                .F({sign, instruction[31], JALRTypeImmediate}), .G({signU, UTypeImmediate, 12'b0}),
                                .H({sign, instruction[31], FLWTypeImmediate}), .I({sign, instruction[31], FSWTypeImmediate}),
                                .S({type[3], type[2], type[1], type[0]}), .X(immediate));
   
endmodule