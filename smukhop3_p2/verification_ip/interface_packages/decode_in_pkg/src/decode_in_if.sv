interface decode_in_if 
    (
    input wire clk,
    input wire rst,

/*clock, reset [1 bit]: 
•  Instr_dout [16 bits]:  this signal comes from Instruction memory and contains 
the instruction to be used to do the relevant operations in “Decode” state.  
•  npc_in[16 bits]: This corresponds to the npc value from the Fetch stage which 
needs to be passed along the pipeline to its final consuming block i.e. the Execute 
block. 
•  psr[3 bits]: The PSR values reflect the status (Negative, Zero, Positive) of the 
value written (or to be written in case write back to the register has not been 
issued yet) into the register by the most recent register varying instruction (ALU 
or Loads).  
•  enable_decode [1 bit]: When 1, this signal allows for the operation of the 
decode unit in normal mode where it creates the relevant control signals at the 
output based on the input from the Instruction Memory. If 0, the block stalls with 
no changes at the output.*/

    inout tri[15:0] instr_dout,
    inout tri[15:0] npc_in,
    inout tri enable_decode    
    );
    
endinterface:decode_in_if