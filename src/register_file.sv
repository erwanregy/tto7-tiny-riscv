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

    logic [31:0] registers[32];

    always_ff @(posedge clock, posedge reset)
        if (reset) begin
            // for (int i = 1; i < 32; ++i) begin
            //     registers[i] <= 0;
            // end
            registers[0] <= 0;
            registers[2] <= 0;
        end else begin
            if (write_address != 0 && write_enable) begin
                registers[write_address] <= write_data;
            end
        end

    assign read_data_1 = registers[read_address_1];
    assign read_data_2 = registers[read_address_2];

endmodule
