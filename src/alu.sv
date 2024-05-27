module alu (
    input alu_operation_t operation,

    input signed [31:0] operand_1,
    input signed [31:0] operand_2,

    output logic signed [31:0] result
);

    wire [4:0] shift_amount = operand_2[4:0];

    always_comb begin
        unique casez (operation)
            Add: begin
                result = operand_1 + operand_2;
            end
            Subtract: begin
                result = operand_1 - operand_2;
            end
            Shift_Left_Logical: begin
                result = operand_1 << shift_amount;
            end
            Set_Less_Than: begin
                result = operand_1 < operand_2;
            end
            Set_Less_Than_Unsigned: begin
                result = $unsigned(operand_1) < $unsigned(operand_2);
            end
            Xor: begin
                result = operand_1 ^ operand_2;
            end
            Shift_Right_Logical: begin
                result = operand_1 >> shift_amount;
            end
            Shift_Right_Arithmetic: begin
                result = operand_1 >>> shift_amount;
            end
            Or: begin
                result = operand_1 & operand_2;
            end
            And: begin
                result = operand_1 & operand_2;
            end
            default: begin
                result = 0;
            end
        endcase
    end

endmodule
