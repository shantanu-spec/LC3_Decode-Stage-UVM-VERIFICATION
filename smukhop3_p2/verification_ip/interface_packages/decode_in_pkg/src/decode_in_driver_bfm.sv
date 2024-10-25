interface decode_in_driver_bfm(decode_in_if bus);
    
    reg enable_decode_reg=0;
    reg [15:0]instr_dout_reg=0;
    reg [15:0]npc_in_reg=0;
        
    assign bus.enable_decode=enable_decode_reg;
    assign bus.instr_dout=instr_dout_reg;
    assign bus.npc_in=npc_in_reg;
        
    task check_reset();
        @(bus.rst);
    endtask

    always@(posedge bus.rst)
    begin
        enable_decode_reg<=0; 
        instr_dout_reg<=0;
        npc_in_reg<=0;
    end

    
    task drive(input bit[15:0] instr_dout_i, input bit[15:0] npc_in_i, input bit enable_decode);
        @(posedge bus.clk);
        instr_dout_reg=instr_dout_i;
        npc_in_reg=npc_in_i;       
        enable_decode_reg=enable_decode;
    endtask
endinterface: decode_in_driver_bfm