module MCOutput (
    input [1:0] currentState,
    output mem_read,
    output mem_write,
    output active,
    output status
); 
    /* States */
    // parameter IDLE   = 2'b00;
    // parameter ACTIVE = 2'b01;
    // parameter READ   = 2'b10;s
    // parameter WRITE  = 2'b11;

    /* States */
    wire IDLE, ACTIVE, READ, WRITE;

    /* Verify states */
    and(IDLE, ~currentState[1], ~currentState[0]);
    and(ACTIVE, ~currentState[1], currentState[0]);
    and(READ, currentState[1], ~currentState[0]);
    and(WRITE, currentState[1], currentState[0]);

    /* Set outputs */
    assign mem_read = READ;
    assign mem_write = WRITE;
    assign active =  ACTIVE;
    or (status, READ, WRITE);
endmodule