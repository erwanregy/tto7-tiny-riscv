`ifndef FUNCT3_SVH
`define FUNCT3_SVH

// ALU
`define ADD_OR_SUBTRACT 3'b000
`define SHIFT_LEFT_LOGICAL 3'b001
`define SET_LESS_THAN 3'b010
`define SET_LESS_THAN_UNSIGNED 3'b011
`define XOR 3'b100
`define SHIFT_RIGHT 3'b101
`define OR 3'b110
`define AND 3'b111

// Memory
`define BYTE 3'b000
`define HALFWORD 3'b001
`define WORD 3'b010
`define UNSIGNED_BYTE 3'b100
`define UNSIGNED_HALFWORD 3'b101

// Branch
`define IF_EQUAL 3'b000
`define IF_NOT_EQUAL 3'b001
`define IF_LESS_THAN 3'b100
`define IF_GREATER_THAN_OR_EQUAL 3'b101
`define IF_LESS_THAN_UNSIGNED 3'b110
`define IF_GREATER_THAN_OR_EQUAL_UNSIGNED 3'b111

// System
`define ENV 3'b000
`define CSRRW 3'b001
`define CSRRS 3'b010
`define CSRRC 3'b011
`define CSRRWI 3'b101
`define CSRRSS 3'b110
`define CSRRCI 3'b111

`endif
