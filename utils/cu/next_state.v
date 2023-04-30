module next_state (
    input [5:0] op,
    input [3:0] state,
    output [3:0] ns
);
    wire wire0, wire1, wire3, wire4, wire5, wire6, wire7, wire8, 
         wire9, wire10, wire11, wire12, wire13, wire14, wire15;    
   
    and (wire0, ~op[5], ~op[4], ~op[3], ~op[2], op[1], ~op[0], ~state[3], ~state[2], ~state[2], state);
    and (wire1, ~op[5], ~op[4], ~op[3], op[2], ~op[1], ~op[0], ~state[3], ~state[2], ~state[2], state);
    or (ns[3], wire0, wire1);

    and (wire2, ~op[5], ~op[4], ~op[3], ~op[2], ~op[1], ~op[0], ~state[3], ~state[2], ~state[2], state);
    and (wire3, op[5], ~op[4], op[3], ~op[2], op[1], op[0], ~state[3], ~state[2], state[2], ~state);
    and (wire4, ~state[3], ~state[2], state[2], state);
    and (wire5, ~state[3], state[2], state[2], ~state); 
    or (ns[2], wire2, wire3, wire4, wire5);

    and (wire6, ~op[5], ~op[4], ~op[3], ~op[2], ~op[1], ~op[0], ~state[3], ~state[2], ~state[2], state);
    and (wire7, op[5], ~op[4], ~op[3], ~op[2], op[1], op[0], ~state[3], ~state[2], ~state[2], state);
    and (wire8, op[5], ~op[4], op[3], ~op[2], op[1], op[0], ~state[3], ~state[2], ~state[2], state);
    and (wire9, op[5], ~op[4], ~op[3], ~op[2], op[1], op[0], ~state[3], ~state[2], state[2], ~state);
    and (wire10, ~state[3], state[2], state[2], ~state); 
    or (ns[1], wire6, wire7, wire8, wire9, wire10);

    and (wire11, ~state[3], ~state[2], ~state[2], ~state);
    and (wire12, op[5], ~op[4], ~op[3], ~op[2], op[1], op[0], ~state[3], ~state[2], state[2], ~state);
    and (wire13, op[5], ~op[4], op[3], ~op[2], op[1], op[0], ~state[3], ~state[2], state[2], ~state);
    and (wire14, ~state[3], state[2], state[2], ~state);
    and (wire15, ~op[5], ~op[4], ~op[3], ~op[2], op[1], ~op[0], ~state[3], ~state[2], ~state[2], state); 
    or (ns[0], wire11, wire12, wire13, wire14, wire15);
    
endmodule