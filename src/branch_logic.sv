module branch_logic (
    input branch,
    input [31:0] immediate,
    output logic [31:0] program_counter,
    output program_counter_plus_4
);

    wire signed [31:0] relative_address = (immediate << 1);

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
