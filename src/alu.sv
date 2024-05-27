`include "alu_operations.svh"

// import alu_operations::*;

module alu (
    input alu_operations::alu_operation_t operation,

    input signed [31:0] operand_1,
    input signed [31:0] operand_2,

    output logic signed [31:0] result
);

    wire [4:0] shift_amount = operand_2[4:0];

    always_comb begin
        unique casez (operation)
            alu_operations::Add: begin
                result = operand_1 + operand_2;
            end
            alu_operations::Subtract: begin
                result = operand_1 - operand_2;
            end
            alu_operations::Shift_Left_Logical: begin
                result = operand_1 << shift_amount;
            end
            alu_operations::Set_Less_Than: begin
                result = operand_1 < operand_2;
            end
            alu_operations::Set_Less_Than_Unsigned: begin
                result = $unsigned(operand_1) < $unsigned(operand_2);
            end
            alu_operations::Xor: begin
                result = operand_1 ^ operand_2;
            end
            alu_operations::Shift_Right_Logical: begin
                result = operand_1 >> shift_amount;
            end
            alu_operations::Shift_Right_Arithmetic: begin
                result = operand_1 >>> shift_amount;
            end
            alu_operations::Or: begin
                result = operand_1 & operand_2;
            end
            alu_operations::And: begin
                result = operand_1 & operand_2;
            end
            default: begin
                result = 0;
            end
        endcase
    end

endmodule
