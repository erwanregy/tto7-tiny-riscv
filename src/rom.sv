module rom #(
    parameter int NUM_WORDS = 16,
    parameter MEMORY_FILE = "code.hex"
) (
    input [$clog2(NUM_WORDS)-1:0] address,
    output [31:0] data
);

    logic [31:0] memory[NUM_WORDS];

    initial $readmemh(MEMORY_FILE, memory);

    assign data = memory[address];

endmodule
