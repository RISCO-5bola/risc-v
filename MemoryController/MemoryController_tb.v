module MemoryController_tb ();
    reg [63:0] write_data;
    reg [19:0] address;
    reg [2:0] operation;
    reg clk;
    wire status;
    wire mem_read;
    wire mem_write;
    wire [19:0] addressToRorW;
    wire [63:0] data;

    MemoryController UUT (.address(address), .operation(operation), .clk(clk), .status(status),
                          .mem_read(mem_read), .mem_write(mem_write), .addressToRorW(addressToRorW),
                          .data(data), .write_data(write_data));
    
    integer errors;
    task Check ;
        input [63:0] expect;
        if (data !== expect) begin
                $display ("Error! expect: %b got: %b", expect, data);
                errors = errors + 1;
        end
    endtask

    initial begin
        errors = 0;
        clk = 0;
    end

    always #5 clk = ~clk;

    initial begin
        /* test read-byte operation */
        address = 20'd40;
        operation = 3'b100;
        #35
        Check(64'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx10000000);

        /* test read-half operation */
        address = 20'd32;
        operation = 3'b011;
        #35
        Check(64'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx0100000010000000);

        /* test read-word operation */
        address = 20'd40;
        operation = 3'b010;
        #70
        Check(64'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx10010000101000001100000010000000);
        
        /* test read-double worrd operation */
        address = 20'd32;
        operation = 3'b001;
        #120
        Check(64'b0000000100000010000001000000100000010000001000000100000010000000);

        /* write */
        write_data = 64'b1111000100000010000001111000100001011000001110110100000010111010;
        address = 20'd32;
        operation = 3'b111;
        #120

        address = 20'd32;
        operation = 3'b001;
        #120
        Check(64'b1111000100000010000001111000100001011000001110110100000010111010);
        #1000
        $display("Test finished with %d errors.", errors);
        $finish;
    end
endmodule