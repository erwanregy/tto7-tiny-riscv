`include "opcodes.svh"

module immediate_generator (
    input [31:0] instruction,
    output logic signed [31:0] immediate
);

    opcode_t opcode;
    assign opcode = instruction[6:0];

    enum {
        R_Type,
        I_Type,
        S_Type,
        B_Type,
        U_Type,
        J_Type
    } instruction_format;

    always_comb begin
        unique casez (opcode)
            Load, Immediate_Arithmetic, Jump_And_Link_Register: begin
                instruction_format = I_Type;
            end
            Store: begin
                instruction_format = S_Type;
            end
            Branch: begin
                instruction_format = B_Type;
            end
            Add_Upper_Immediate_To_Program_Counter, Load_Upper_Immediate: begin
                instruction_format = U_Type;
            end
            Jump_And_Link: begin
                instruction_format = J_Type;
            end
            default: begin
                instruction_format = R_Type;  // FIXME: Is this always true?
            end
        endcase
    end

    always_comb begin
        unique casez (instruction_format)
            I_Type: begin
                immediate = $signed(instruction[31:20]);
            end
            S_Type: begin
                immediate = $signed({instruction[31:25], instruction[11:7]});
            end
            B_Type: begin
                immediate = $signed({instruction[31], instruction[7], instruction[30:25],
                                     instruction[11:8]});
            end
            U_Type: begin
                immediate = {instruction[31:12], 12'b0};
            end
            J_Type: begin
                immediate = $signed(
                    {
                        instruction[31],
                        instruction[19:12],
                        instruction[20],
                        instruction[30:21],
                        1'b0
                    }
                );
            end
            default: begin
                immediate = 0;
            end
        endcase
    end

endmodule
