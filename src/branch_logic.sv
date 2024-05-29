module branch_logic #(
    parameter int ADDRESS_WIDTH = 32
) (
    input clock,
    input reset,
    input branch,
    input [31:0] immediate,
    output logic [ADDRESS_WIDTH-1:0] program_counter,
    output [ADDRESS_WIDTH-1:0] program_counter_plus_4
);

    wire signed [ADDRESS_WIDTH-1:0] relative_address = ADDRESS_WIDTH'(immediate << 1);  // TESTME: Is this correct?

    assign program_counter_plus_4 = program_counter + 4;

    always_ff @(posedge clock, posedge reset)
        if (reset) begin
            program_counter <= 0;
        end else begin
            if (branch) begin
                program_counter <= program_counter + relative_address;
            end else begin
                program_counter <= program_counter_plus_4;
            end
        end

endmodule
