module register_file (
    input clock,
    input reset,

    input write_enable,
    input [4:0] write_address,
    input [31:0] write_data,

    input [4:0] read_address_1,
    input [4:0] read_address_2,

    output [31:0] read_data_1,
    output [31:0] read_data_2
);

    logic [31:0] write_registers[1:31];

    always_ff @(posedge clock, posedge reset)
        if (reset) begin
            // for (int i = 1; i < 32; ++i) begin
            //     write_registers[i] <= 0;
            // end
            write_registers[2] <= 0;
        end else begin
            if (write_enable) begin
                write_registers[write_address] <= write_data;
            end
        end

    wire [31:0] registers[32];

    assign registers[0] = 0;
    assign registers[1:31] = write_registers;

    assign read_data_1 = registers[read_address_1];
    assign read_data_2 = registers[read_address_2];

endmodule
