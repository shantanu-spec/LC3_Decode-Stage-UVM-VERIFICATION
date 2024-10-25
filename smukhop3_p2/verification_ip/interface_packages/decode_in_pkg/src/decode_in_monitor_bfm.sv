import decode_in_pkg::*;

interface decode_in_monitor_bfm(decode_in_if bus);
    tri clk;
    tri rst;
    bit [15:0] npc_in;
    bit enable_decode;
    bit [15:0] instr_dout;
    
    decode_in_monitor proxy;    
    event trigger;

    assign npc_in=bus.npc_in;
    assign instr_dout=bus.instr_dout;
    assign enable_decode=bus.enable_decode;
    assign clk=bus.clk;
    assign rst=bus.rst;

    
    task check_reset();
        @(bus.rst);
    endtask
  
    task read_bus(output bit[15:0] inst_dout, output bit[15:0] npc, output bit ed);
        @(posedge clk);
        inst_dout=instr_dout;
        npc=npc_in;   
        ed=enable_decode;
    endtask
    
endinterface