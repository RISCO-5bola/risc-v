module MCNextState (
    input [1:0] currentState,
    input zero,
    input isRead, /* 1: read 0: write */
    input RorW, /* 1 if read or write */
    output [1:0] nextState
);
    /* States */
    wire IDLE, ACTIVE, READ, WRITE;

    wire wire0;
    wire wire1;
    wire wire2;
    wire wire3;
    wire wire4;

    /* Verify states */
    and(IDLE, ~currentState[1], ~currentState[0]);
    and(ACTIVE, ~currentState[1], currentState[0]);
    and(READ, currentState[1], ~currentState[0]);
    and(WRITE, currentState[1], currentState[0]);

    /* State IDLE + RorW */
    and (wire0, IDLE, RorW);

    /* State ACTIVE + read */
    and (wire1, ACTIVE, isRead);
    
    /* State ACTIVE + write */
    and (wire2, ACTIVE, ~isRead);

    /* State READ + ~zero */
    and (wire3, READ, ~zero);

    /* State WRITE + ~zero */
    and (wire4, WRITE, ~zero);

    /* set next state */
    or (nextState[1], wire1, wire2, wire3, wire4);
    or (nextState[0], wire0, wire2, wire4);
endmodule