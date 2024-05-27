`include "opcodes.svh"
`include "funct3.svh"
`include "control.svh"
`include "alu_operations.svh"

module instruction_decoder (
    input [31:0] instruction,
    input alu_result,
    output control_t control
);

    localparam bit False = 0;
    localparam bit True = 1;


    opcode_t opcode;
    assign opcode = instruction[6:0];

    wire [2:0] funct3 = instruction[14:12];

    wire [6:0] funct7 = instruction[31:25];

    operation_t operation;


    always_comb begin
        control   = 0;
        operation = invalid;
        unique casez (opcode)
            Load_Upper_Immediate: begin
                control.register_write_enable = True;
                control.register_write_data_source = Immediate;
                operation = lui;
            end
            Add_Upper_Immediate_To_Program_Counter: begin
                control.register_write_enable = True;
                control.alu_operand_1_source = Program_Counter;
                control.alu_operand_2_source = Immediate;
                control.alu_operation = Add;
                control.register_write_enable = True;
                control.register_write_data_source = ALU;
                operation = auipc;
            end
            Jump_And_Link: begin
                control.alu_operand_1_source = Program_Counter;
                control.alu_operand_2_source = Immediate;
                control.alu_operation = Add;
                control.register_write_enable = True;
                control.register_write_data_source = Program_Counter_Plus_4;
                operation = jal;
            end
            Jump_And_Link_Register: begin
                control.alu_operand_2_source = Immediate;
                control.alu_operation = Add;
                control.register_write_enable = True;
                control.register_write_data_source = Program_Counter_Plus_4;
                operation = jalr;
            end
            Branch: begin
                unique casez (funct3)
                    `IF_EQUAL: begin
                        control.alu_operation = Subtract;
                        control.branch = (alu_result == 0);
                        operation = beq;
                    end
                    `IF_NOT_EQUAL: begin
                        control.alu_operation = Subtract;
                        control.branch = (alu_result != 0);
                        operation = bne;
                    end
                    `IF_LESS_THAN: begin
                        control.alu_operation = Set_Less_Than;
                        control.branch = (alu_result == True);
                        operation = blt;
                    end
                    `IF_GREATER_THAN_OR_EQUAL: begin
                        control.alu_operation = Set_Less_Than;
                        control.branch = (alu_result == False);
                        operation = bge;
                    end
                    `IF_LESS_THAN_UNSIGNED: begin
                        control.alu_operation = Set_Less_Than_Unsigned;
                        control.branch = (alu_result == True);
                        operation = bltu;
                    end
                    `IF_GREATER_THAN_OR_EQUAL_UNSIGNED: begin
                        control.alu_operation = Set_Less_Than_Unsigned;
                        control.branch = (alu_result == False);
                        operation = bgeu;
                    end
                    default: begin
                        control.alu_operation = Invalid;
                        control.branch = False;
                        operation = invalid;
                    end
                endcase
            end
            Memory_Access: begin
                // TODO: funct3 - byte, halfword, and that stuff
                control.alu_operand_2_source = Immediate;
                control.alu_operation = Add;
                if (opcode == Load) begin
                    control.register_write_enable = True;
                    control.register_write_data_source = Memory;
                end
                if (opcode == Store) begin
                    control.memory_write_enable = True;
                end
                unique casez (funct3)
                    `BYTE: begin
                        operation = (opcode == Load) ? lb : sb;
                    end
                    `HALFWORD: begin
                        operation = (opcode == Load) ? lh : sh;
                    end
                    `WORD: begin
                        operation = (opcode == Load) ? lw : sw;
                    end
                    `UNSIGNED_BYTE: begin
                        operation = (opcode == Load) ? lbu : invalid;
                    end
                    `UNSIGNED_HALFWORD: begin
                        operation = (opcode == Load) ? lhu : invalid;
                    end
                    default: begin
                        operation = invalid;
                    end
                endcase
            end
            Arithmetic: begin
                control.register_write_enable = True;
                if (opcode == Immediate_Arithmetic) begin
                    control.alu_operand_2_source = Immediate;
                end
                unique casez (funct3)
                    `ADD_OR_SUBTRACT: begin
                        if (opcode == Immediate_Arithmetic) begin
                            control.alu_operation = Add;
                            operation = addi;
                        end else begin
                            if (funct7[5] == 0) begin
                                control.alu_operation = Add;
                                operation = add;
                            end else begin
                                control.alu_operation = Subtract;
                                operation = sub;
                            end
                        end
                    end
                    `SHIFT_LEFT_LOGICAL: begin
                        control.alu_operation = Shift_Left_Logical;
                        operation = (opcode == Immediate_Arithmetic) ? slli : sll;
                    end
                    `SET_LESS_THAN_UNSIGNED: begin
                        control.alu_operation = Set_Less_Than_Unsigned;
                        operation = (opcode == Immediate_Arithmetic) ? slti : slt;
                    end
                    `XOR: begin
                        control.alu_operation = Xor;
                        operation = (opcode == Immediate_Arithmetic) ? xori : xor_;
                    end
                    `SHIFT_RIGHT: begin
                        if (funct7[5] == 0) begin
                            control.alu_operation = Shift_Right_Logical;
                            operation = (opcode == Immediate_Arithmetic) ? srli : srl;
                        end else begin
                            control.alu_operation = Shift_Right_Arithmetic;
                            operation = (opcode == Immediate_Arithmetic) ? srai : sra;
                        end
                    end
                    `OR: begin
                        control.alu_operation = Or;
                        operation = (opcode == Immediate_Arithmetic) ? ori : or_;
                    end
                    `AND: begin
                        control.alu_operation = And;
                        operation = (opcode == Immediate_Arithmetic) ? andi : and_;
                    end
                    default: begin
                        control.alu_operation = Invalid;
                        operation = invalid;
                    end
                endcase
            end
            Fence: begin
                // TODO
            end
            System: begin
                // TODO
            end
            default: begin
                control   = 0;
                operation = invalid;
            end
        endcase
    end

endmodule
