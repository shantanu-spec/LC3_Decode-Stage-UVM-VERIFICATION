interface decode_out_if 
    ( 
    input wire clk,
    input wire rst,
    input wire enable_decode_delayed,
    inout tri [15:0] IR,
    inout tri [15:0] npc_out,
    inout tri Mem_control,
    inout tri [1:0]W_control,
    inout tri [5:0]E_control
    );
    
endinterface :decode_out_if