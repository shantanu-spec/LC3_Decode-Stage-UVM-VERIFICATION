import decode_out_pkg::*;

interface decode_out_monitor_bfm(decode_out_if bus);
    tri clk;
    tri rst;
    bit [15:0] npc_out;    
    bit [15:0] ir;
    bit [5:0] E_control;
    bit [1:0] W_control;
    bit Mem_control;
    bit ed;
    bit ed_delayed;

    decode_out_monitor proxy;    
    event trigger;

    assign npc_out=bus.npc_out;
    assign ir=bus.IR;
    assign E_control=bus.E_control;
    assign W_control=bus.W_control;
    assign Mem_control=bus.Mem_control;
    assign clk=bus.clk;
    assign rst=bus.rst;
    assign ed=bus.enable_decode_delayed;

    always@(posedge clk)
    begin
        ed_delayed<=ed;
    end
        
    task check_reset();
        @(bus.rst);
    endtask
  
    task read_bus(output bit[15:0] ir_pin, output bit[5:0] E_control_out, output bit[15:0] npc, output bit Mem_control_out, output bit[1:0] W_control_out, output bit e_delayed);
        @(posedge clk);
        e_delayed=ed_delayed;
        if(ed_delayed)
        begin
            ir_pin=ir;
            E_control_out=E_control;
            npc=npc_out;
            Mem_control_out=Mem_control;
            W_control_out=W_control;            
        end        
    endtask
    
endinterface