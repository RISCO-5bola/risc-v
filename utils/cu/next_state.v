module next_state (
    input [6:0] op,
    input [3:0] state,
    output [3:0] ns
);
    wire wire0, wire1, wire3, wire4, wire5, wire6, wire7, wire8, 
         wire9, wire10, wire11, wire12, wire13, wire14, wire15;    
    
    and (wire0, op[6], op[5], ~op[4], op[3], op[2], op[1], op[0], ~state[3], ~state[2], ~state[1], state[0]);
    and (wire1, op[6], op[5], ~op[4], ~op[3], ~op[2], op[1], op[0], ~state[3], ~state[2], ~state[1], state[0]);
    or (ns[3], wire0, wire1);

    and (wire2, ~op[6], op[5], op[4], ~op[3], ~op[2], op[1], op[0], ~state[3], ~state[2], ~state[1], state[0]);
    and (wire3, ~op[6], op[5], ~op[4], ~op[3], ~op[2], op[1], op[0], ~state[3], ~state[2], state[1], ~state[0]);
    and (wire4, ~state[3], ~state[2], state[1], state[0]);
    and (wire5, ~state[3], state[2], state[1], ~state[0]); 
    or (ns[2], wire2, wire3, wire4, wire5);

    and (wire6, ~op[6], op[5], op[4], ~op[3], ~op[2], op[1], op[0], ~state[3], ~state[2], ~state[1], state[0]);
    and (wire7, ~op[6], ~op[5], ~op[4], ~op[3], ~op[2], op[1], op[0], ~state[3], ~state[2], ~state[1], state[0]);
    and (wire8, ~op[6], op[5], ~op[4], ~op[3], ~op[2], op[1], op[0], ~state[3], ~state[2], ~state[1], state[0]);
    and (wire9, ~op[6], ~op[5], ~op[4], ~op[3], ~op[2], op[1], op[0], ~state[3], ~state[2], state[1], ~state[0]);
    and (wire10, ~state[3], state[2], state[1], ~state[0]); 
    or (ns[1], wire6, wire7, wire8, wire9, wire10);

    and (wire11, ~state[3], ~state[2], ~state[1], ~state[0]);
    and (wire12, ~op[6], ~op[5], ~op[4], ~op[3], ~op[2], op[1], op[0], ~state[3], ~state[2], state[1], ~state[0]);
    and (wire13, ~op[6], op[5], ~op[4], ~op[3], ~op[2], op[1], op[0], ~state[3], ~state[2], state[1], ~state[0]);
    and (wire14, ~state[3], state[2], state[1], ~state[0]);
    and (wire15, op[6], op[5], ~op[4], op[3], op[2], op[1], op[0], ~state[3], ~state[2], ~state[1], state[0]); 
    or (ns[0], wire11, wire12, wire13, wire14, wire15);
    
endmodule