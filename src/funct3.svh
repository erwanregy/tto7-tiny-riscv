package funct3;

    enum logic [2:0] {
        Add_Or_Sub = 3'b000,
        Shift_Left_Logical = 3'b001,
        Set_Less_Than = 3'b010,
        Set_Less_Than_Unsigned = 3'b011,
        Xor = 3'b100,
        Shift_Right = 3'b101,
        Or = 3'b110,
        And = 3'b111
    } ALU_funct3;

    enum logic [2:0] {
        Byte = 3'b000,
        Halfword = 3'b001,
        Word = 3'b010,
        Unsigned_Byte = 3'b100,
        Unsigned_Halfword = 3'b101
    } Memory_funct3;

    enum logic [2:0] {
        If_Equal = 3'b000,
        If_Not_Equal = 3'b001,
        If_Less_Than = 3'b100,
        If_Greater_Than_Or_Equal = 3'b101,
        If_Less_Than_Unsigned = 3'b110,
        If_Greater_Than_Or_Equal_Unsigned = 3'b111
    } Branch_funct3;

    enum logic [2:0] {
        ENV = 3'b000,
        CSRRW = 3'b001,
        CSRRS = 3'b010,
        CSRRC = 3'b011,
        CSRRWI = 3'b101,
        CSRRSS = 3'b110,
        CSRRCI = 3'b111
    } System_funct3;

endpackage
