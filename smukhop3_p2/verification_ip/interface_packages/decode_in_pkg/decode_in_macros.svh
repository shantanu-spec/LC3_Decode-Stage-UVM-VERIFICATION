
typedef enum logic[3:0]{
    ADD = 4'b0001,
    AND = 4'b0101,
    NOT = 4'b1001,
    LD = 4'b0010,
    LDR = 4'b0110,
    LDI = 4'b1010,
    LEA = 4'b1110,
    ST = 4'b0011,
    STR = 4'b0111,
    STI = 4'b1011,
    BR = 4'b0000,
    JMP = 4'b1100
} opcode;

// typedef enum bit[2:0]{
//     NEG = 3'b100,
//     ZERO = 3'b010,
//     POS = 3'b001
// } psr_val;