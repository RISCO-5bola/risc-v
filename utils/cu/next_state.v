module next_state (
    input [5:0] op,
    input s3, s2, s1, s0,
    output ns0, ns1, ns2, ns3
);
    wire wire0, wire1, wire3, wire4, wire5, wire6, wire7, wire8, 
         wire9, wire10, wire11, wire12, wire13, wire14, wire15;    
   
    and (wire0, ~op[5], ~op[4], ~op[3], ~op[2], op[1], ~op[0], ~s3, ~s2, ~s1, s0);
    and (wire1, ~op[5], ~op[4], ~op[3], op[2], ~op[1], ~op[0], ~s3, ~s2, ~s1, s0);
    or (ns3, wire0, wire1);

    and (wire2, ~op[5], ~op[4], ~op[3], ~op[2], ~op[1], ~op[0], ~s3, ~s2, ~s1, s0);
    and (wire3, op[5], ~op[4], op[3], ~op[2], op[1], op[0], ~s3, ~s2, s1, ~s0);
    and (wire4, ~s3, ~s2, s1, s0);
    and (wire5, ~s3, s2, s1, ~s0); 
    or (ns2, wire2, wire3, wire4, wire5);

    and (wire6, ~op[5], ~op[4], ~op[3], ~op[2], ~op[1], ~op[0], ~s3, ~s2, ~s1, s0);
    and (wire7, op[5], ~op[4], ~op[3], ~op[2], op[1], op[0], ~s3, ~s2, ~s1, s0);
    and (wire8, op[5], ~op[4], op[3], ~op[2], op[1], op[0], ~s3, ~s2, ~s1, s0);
    and (wire9, op[5], ~op[4], ~op[3], ~op[2], op[1], op[0], ~s3, ~s2, s1, ~s0);
    and (wire10, ~s3, s2, s1, ~s0); 
    or (ns1, wire6, wire7, wire8, wire9, wire10);

    and (wire11, ~s3, ~s2, ~s1, ~s0);
    and (wire12, op[5], ~op[4], ~op[3], ~op[2], op[1], op[0], ~s3, ~s2, s1, ~s0);
    and (wire13, op[5], ~op[4], op[3], ~op[2], op[1], op[0], ~s3, ~s2, s1, ~s0);
    and (wire14, ~s3, s2, s1, ~s0);
    and (wire15, ~op[5], ~op[4], ~op[3], ~op[2], op[1], ~op[0], ~s3, ~s2, ~s1, s0); 
    or (ns0, wire11, wire12, wire13, wire14, wire15);
    
endmodule
