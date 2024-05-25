module ram #(
    parameter int NUM_BYTES = 16
) (
    input clock,

    input [$clog2(NUM_BYTES)-1:0] address,

    input write_enable,
    input [31:0] write_data,

    output [31:0] read_data
);

    logic [31:0] memory[NUM_BYTES / 4];

    always_ff @(posedge clock)
        if (write_enable) begin
            memory[address/4] <= write_data;
            // memory[address]   <= write_data[31:24];
            // memory[address+1] <= write_data[23:16];
            // memory[address+2] <= write_data[15:8];
            // memory[address+3] <= write_data[7:0];
        end

    assign read_data = memory[address/4];
    // assign read_data[31:24] = memory[address];
    // assign read_data[23:16] = memory[address+1];
    // assign read_data[15:8]  = memory[address+2];
    // assign read_data[7:0]   = memory[address+3];

endmodule
