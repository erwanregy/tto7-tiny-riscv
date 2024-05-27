`ifndef CONTROL_SVH
`define CONTROL_SVH

typedef enum logic {
    Register_Read_Data_1 = 1'b0,
    Program_Counter = 1'b1
} alu_operand_1_source_t;

typedef enum logic {
    Register_Read_Data_2 = 1'b0 // ,
    // Immediate = 1'b1
} alu_operand_2_source_t;

localparam bit Immediate = 1;

typedef enum logic [1:0] {
    ALU = 2'd0,
    // Immediate = 2'd1,
    Memory = 2'd2,
    Program_Counter_Plus_4 = 2'd3
} register_write_data_source_t;

typedef struct packed {
    logic branch;
    alu_operand_1_source_t alu_operand_1_source;
    alu_operand_2_source_t alu_operand_2_source;
    alu_operation_t alu_operation;
    logic memory_write_enable;
    logic register_write_enable;
    register_write_data_source_t register_write_data_source;
} control_t;

`endif
