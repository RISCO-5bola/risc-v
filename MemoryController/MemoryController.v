module MemoryController (
    input [19:0] address,
    input [2:0] operation,
    input clk,
    input [63:0] write_data,
    output status,
    output mem_read,
    output mem_write,
    output [19:0] addressToRorW,
    output [63:0] data
);

    initial begin
        $dumpfile("wave.vcd");

        $dumpvars(0, MemoryController);

    end
/*
    Behavior information
*/
    parameter NOP    = 3'b000;
    parameter READ_D = 3'b001;
    parameter READ_W = 3'b010;
    parameter READ_H = 3'b011;
    parameter READ_B = 3'b100;
    parameter WRITE  = 3'b111;
    
    parameter USELESS1 = 3'b101;
    parameter USELESS2 = 3'b110;

    /*
        Operation:
            -> 000: NOP (No Operation)

            -> 001: READ_D
            -> 010: READ_W
            -> 011: READ_H
            -> 100: READ_B

            -> 111: WRITE
    */
    /*
        Status:
            1 -> Processor has to wait
            0 -> Processor can keep going
    */
/* States */
// parameter IDLE   = 2'b00;
// parameter ACTIVE = 2'b01;
// parameter READ   = 2'b10;
// parameter WRITE  = 2'b11;

/* Register num of wait clocks */
    reg [15:0] waitClks;
/* Change num of wait clocks */
    wire active;

/* Verify if it is a read/write operation */
    wire isRead;
    wire RorW;
    wire wire1;
    wire wire2;
    wire wire3;
    wire wire4;

/* Byte sized registers for output */
    reg [7:0] reg7to0;
    reg [7:0] reg15to8;
    reg [7:0] reg23to16;
    reg [7:0] reg31to24;
    reg [7:0] reg39to32;
    reg [7:0] reg47to40;
    reg [7:0] reg55to48;
    reg [7:0] reg63to56;

/* Data that comes from the memory */
    wire [7:0] readFromMemory;

/* Data that will be written to memory */
    reg [63:0] toBeWrittenMemory;
    reg [7:0] dataToBeWritten;

/* Stores current state */
    reg [1:0] currentState;
/* Stores next state */
    wire [1:0] nextState;

/* Verify if counter is 0 */
    nor (zero, waitClks[15], waitClks[14], waitClks[13], waitClks[12], waitClks[11], 
               waitClks[10], waitClks[9], waitClks[8], waitClks[7], waitClks[6],
               waitClks[5], waitClks[4], waitClks[3], waitClks[2], waitClks[1], waitClks[0]);

    initial begin
        currentState = 2'b00;
    end

    always @(posedge clk) begin
        /* Set the wait clocks depending on the operation */
        /* Only if ACTIVE state is up */
        if (active) begin 
            if (operation === NOP) begin
                waitClks <= 16'd0;
            end

            /* wait clocks for read */
            else if (operation === READ_D) begin
                waitClks <= 16'd8;
            end else if (operation === READ_W) begin
                waitClks <= 16'd4;
            end else if (operation === READ_H) begin
                waitClks <= 16'd2;
            end else if (operation === READ_B) begin
                waitClks <= 16'd1;

            /* wait clocks for write */
            end else if (operation === WRITE) begin
                waitClks <= 16'd8;
                toBeWrittenMemory <= write_data;
            end

            /* useless cases */
            else if (operation === USELESS1) begin
                waitClks <= 16'd0;
            end else if (operation === USELESS2) begin
                waitClks <= 16'd0;
            end
        end else begin
            waitClks <= waitClks - 1;
        end

        /* set output reg */
        if (waitClks === 16'd1) begin
            reg7to0 <= readFromMemory;
            dataToBeWritten <= toBeWrittenMemory[7:0];
        end if (waitClks === 16'd2) begin
            reg15to8 <= readFromMemory;
            dataToBeWritten <= toBeWrittenMemory[15:8];
        end if (waitClks === 16'd3) begin
            reg23to16 <= readFromMemory;
            dataToBeWritten <= toBeWrittenMemory[23:16];
        end if (waitClks === 16'd4) begin
            reg31to24 <= readFromMemory;
            dataToBeWritten <= toBeWrittenMemory[31:24];
        end if (waitClks === 16'd5) begin
            reg39to32 <= readFromMemory;
            dataToBeWritten <= toBeWrittenMemory[39:32];
        end if (waitClks === 16'd6) begin
            reg47to40 <= readFromMemory;
            dataToBeWritten <= toBeWrittenMemory[47:40];
        end if (waitClks === 16'd7) begin
            reg55to48 <= readFromMemory;
            dataToBeWritten <= toBeWrittenMemory[55:48];
        end if (waitClks === 16'd8) begin
            reg63to56 <= readFromMemory;
            dataToBeWritten <= toBeWrittenMemory[63:56];
        end else begin
        end

        /* sets currentState */
        currentState <= nextState;
    end

    /* block for mux of which data must be written */
    always @(*) begin
        if (waitClks === 16'd1) begin
            dataToBeWritten <= toBeWrittenMemory[7:0];
        end if (waitClks === 16'd2) begin
            dataToBeWritten <= toBeWrittenMemory[15:8];
        end if (waitClks === 16'd3) begin
            dataToBeWritten <= toBeWrittenMemory[23:16];
        end if (waitClks === 16'd4) begin
            dataToBeWritten <= toBeWrittenMemory[31:24];
        end if (waitClks === 16'd5) begin
            dataToBeWritten <= toBeWrittenMemory[39:32];
        end if (waitClks === 16'd6) begin
            dataToBeWritten <= toBeWrittenMemory[47:40];
        end if (waitClks === 16'd7) begin
            dataToBeWritten <= toBeWrittenMemory[55:48];
        end if (waitClks === 16'd8) begin
            dataToBeWritten <= toBeWrittenMemory[63:56];
        end else begin
        end
    end

    /* 
        Set address to read based on counter

        Example, address to read is 0 with READ_B
        
        The following addresses will be read:
            3 -> 2 -> 1 -> 0
    */
    assign addressToRorW = address + waitClks - 1;

    /* assign if operation is read */
    and(wire1, ~operation[2], ~operation[1], operation[0]);
    and(wire2, ~operation[2], operation[1], ~operation[0]);
    and(wire3, ~operation[2], operation[1], operation[0]);
    and(wire4, operation[2], ~operation[1], ~operation[0]);

    or(isRead, wire1, wire2, wire3, wire4);
    or (RorW, operation[2], operation[1], operation[0]);

    /* set output read from memory */
    assign data = {reg63to56, reg55to48, reg47to40, reg39to32,
                   reg31to24, reg23to16, reg15to8, reg7to0};
    /*
        Finite State Machine
    */
    MCOutput MCOutput (.currentState(currentState), .mem_read(mem_read),
                       .mem_write(mem_write), .active(active), .status(status));
    MCNextState MCNextState(.currentState(currentState), .zero(zero), .RorW(RorW), .isRead(isRead), .nextState(nextState));

    /* Instantiate memory */
    Memory Memory (.clk(clk), .mem_read(mem_read), .mem_write(mem_write), .endereco(addressToRorW), .write_data(dataToBeWritten), .read_data(readFromMemory));
endmodule