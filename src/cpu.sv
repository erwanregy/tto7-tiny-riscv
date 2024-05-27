`include "control.svh"

import control::*;

module cpu (
    input clock,
    input reset,

    // TEMP: Simple memory bus interface
    output [31:0] address,
    output write_enable,
    output [31:0] write_data,
    input [31:0] read_data

    // TODO: Wishbone memory bus interface?
);


    control_t control;


    // Branch/Jump Logic

    wire signed [31:0] immediate;

    wire [31:0] program_counter, program_counter_plus_4;

    branch_logic branch_logic (
        .branch(control.branch),
        .immediate,
        .program_counter,
        .program_counter_plus_4
    );


    // Instruction Memory

    wire [31:0] instruction;

    rom instruction_memory (
        .address(program_counter),
        .data(instruction)
    );


    // Register File

    wire [31:0] memory_read_data;

    wire signed [31:0] alu_result, register_read_data_1, register_read_data_2;

    logic signed [31:0] register_write_data;

    always_comb begin
        unique casez (control.register_write_data_source)
            ALU: begin
                register_write_data = alu_result;
            end
            Memory: begin
                register_write_data = memory_read_data;
            end
            Immediate: begin
                register_write_data = immediate;
            end
            Program_Counter_Plus_4: begin
                register_write_data = program_counter_plus_4;
            end
            default: begin
                register_write_data = 0;
            end
        endcase
    end

    register_file register_file (
        .clock,
        .reset,

        .write_enable(control.register_write_enable),
        .write_address(instruction[11:7]),
        .write_data(register_write_data),

        .read_address_1(instruction[19:15]),
        .read_address_2(instruction[24:20]),

        .read_data_1(register_read_data_1),
        .read_data_2(register_read_data_2)
    );


    // Instruction Decoder

    instruction_decoder instruction_decoder (
        .instruction,
        .alu_result(alu_result[0]),
        .control
    );


    // TODO: Immediate Generator

    immediate_generator immediate_generator (
        .instruction,
        .immediate
    );


    // ALU

    alu alu (
        .operation(control.alu_operation),

        .operand_1(control.alu_operand_1_source ? program_counter : register_read_data_1),
        .operand_2(control.alu_operand_2_source ? immediate : register_read_data_2),

        .result(alu_result)
    );


    // // Data Memory

    // ram data_memory (
    //     .clock,

    //     .address(alu_result),

    //     .write_enable(control.memory_write_enable),
    //     .write_data  (register_read_data_2),

    //     .read_data(memory_read_data)
    // );


    // TEMP: Simple memory bus interface

    assign address = alu_result;
    assign write_enable = control.memory_write_enable;
    assign write_data = register_read_data_2;


endmodule
