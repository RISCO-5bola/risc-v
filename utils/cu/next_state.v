module next_state (
    input [6:0] op,
    input [3:0] state,
    output [3:0] ns
);
    wire wire0, wire1, wire2, wire3, wire4, wire5, wire6, wire7,
         wire8, wire9, wire10, wire11, wire12, wire13, wire14, wire15, wire16, wire17, wire18, wire19;

    /* tipo jal current state 1 para next state 9*/
    and (wire0, op[6], op[5], ~op[4], op[3], op[2], op[1], op[0], ~state[3], ~state[2], ~state[1], state[0]);

    /* tipo b current state 1 para next state 8*/
    and (wire1, op[6], op[5], ~op[4], ~op[3], ~op[2], op[1], op[0], ~state[3], ~state[2], ~state[1], state[0]);
    
    /* tipo b current state 8 para next state 14*/
    and (wire17, op[6], op[5], ~op[4], ~op[3], ~op[2], op[1], op[0], state[3], ~state[2], ~state[1], ~state[0]);

    /* tipo r current state 1 para next state 6*/
    and (wire2, ~op[6], op[5], op[4], ~op[2], op[1], op[0], ~state[3], ~state[2], ~state[1], state[0]);

    /* tipo sw current state 2 para next state 5*/
    and (wire3, ~op[6], op[5], ~op[4], ~op[3], ~op[2], op[1], op[0], ~state[3], ~state[2], state[1], ~state[0]);

    /* current state 3 para next state 4*/
    and (wire4, ~state[3], ~state[2], state[1], state[0]);

    /* current state 6 para next state 7*/
    and (wire5, ~state[3], state[2], state[1], ~state[0]);

    /* tipo lw current state 1 para next state 2 */
    and (wire6, ~op[6], ~op[5], ~op[4], ~op[3], ~op[2], op[1], op[0], ~state[3], ~state[2], ~state[1], state[0]);

    /* tipo sw current state 1 para next state 2 */
    and (wire7, ~op[6], op[5], ~op[4], ~op[3], ~op[2], op[1], op[0], ~state[3], ~state[2], ~state[1], state[0]);

    /* tipo lw current state 2 para next state 3 */
    and (wire8, ~op[6], ~op[5], ~op[4], ~op[3], ~op[2], op[1], op[0], ~state[3], ~state[2], state[1], ~state[0]);

    /* current state 0 para next state 1 */
    and (wire9, ~state[3], ~state[2], ~state[1], ~state[0]);

    /* tipo jal current state 9 para next state 10 */
    and (wire10, op[6], op[5], ~op[4], op[3], op[2], op[1], op[0], state[3], ~state[2], ~state[1], state[0]);

    /* tipo I-Jalr current state 9 para next state 12 */
    and (wire11, op[6], op[5], ~op[4], ~op[3], op[2], op[1], op[0], state[3], ~state[2], ~state[1], state[0]);

    /* tipo U-AUIPC current state 1 para next state 11 */
    and (wire12, ~op[6], ~op[5], op[4], ~op[3], op[2], op[1], op[0], ~state[3], ~state[2], ~state[1], state[0]);

    /* tipo I-Jalr current state 1 para next state 9*/
    and (wire13, op[6], op[5], ~op[4], ~op[3], op[2], op[1], op[0], ~state[3], ~state[2], ~state[1], state[0]);

    /* tipo I-addi current state 1 para next state 13 */
    and (wire14, ~op[6], ~op[5], op[4], ~op[2], op[1], op[0], ~state[3], ~state[2], ~state[1], state[0]);

    /* tipo I-addi current sate 13 para next state 7 */
    and (wire15, ~op[6], ~op[5], op[4], ~op[2], op[1], op[0], state[3], state[2], ~state[1], state[0]);

    /* tipo U-AUIPC current state 11 para next state 7 */
    and (wire16, ~op[6], ~op[5], op[4], ~op[3], op[2], op[1], op[0], state[3], ~state[2], state[1], state[0]);

    /* tipo U-LUI  current state 1 para next state 15*/
    and (wire18, ~op[6], op[5], op[4], ~op[3], op[2], op[1], op[0], ~state[3], ~state[2], ~state[1], state[0]);

    /* tipo U-LUI  current state 15 para next state 7*/
    and (wire19, ~op[6], op[5], op[4], ~op[3], op[2], op[1], op[0], state[3], state[2], state[1], state[0]);

    
    /* Extensao RV64I*/
    /* Foi tirado a verificacao do opcode[3] para o tipo R e tipo I */
    or (ns[3], wire0, wire1, wire10, wire11, wire12, wire13, wire14, wire17, wire18); 
    or (ns[2], wire2, wire3, wire4, wire5, wire11, wire15, wire14, wire16, wire17, wire18, wire19);
    or (ns[1], wire2, wire6, wire8, wire5, wire10, wire12, wire7, wire15, wire16, wire17, wire18, wire19);
    or (ns[0], wire9, wire8, wire3, wire5, wire0, wire12, wire13, wire14, wire15, wire16, wire18, wire19);
    
    
    

endmodule