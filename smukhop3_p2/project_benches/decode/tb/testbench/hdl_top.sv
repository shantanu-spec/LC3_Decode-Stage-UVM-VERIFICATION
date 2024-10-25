import uvm_pkg::*;
`include "uvm_macros.svh"

module hdl_top();
    
    bit clk;
    bit rst=1'b1;  
    tri enable_decode;
    tri [15:0] instr_dout;
    tri [15:0] npc_in; 

    tri [15:0] IR;
    tri [15:0] npc_out;

    tri Mem_control;
    tri [1:0] W_control;
    tri [5:0] E_control;

   //decode in package
    decode_in_if bus(.clk(clk), .rst(rst), .enable_decode(enable_decode), .instr_dout(instr_dout), .npc_in(npc_in));
    decode_in_monitor_bfm monitor_bfm(bus);
    decode_in_driver_bfm driver_bfm(bus);
   

    decode_out_if bus_o(.clk(clk),.rst(rst),.enable_decode_delayed(enable_decode),.IR(IR),.npc_out(npc_out),.Mem_control(Mem_control),.W_control(W_control),.E_control(E_control));
    decode_out_monitor_bfm monitor_out_bfm(bus_o);
      //Instantiate DUT
    Decode decode_DUT (
        .clock(bus.clk),
        .reset(bus.rst),
        .enable_decode(bus.enable_decode),
        .dout(bus.instr_dout),
        .E_Control(bus_o.E_control),
        .npc_in(bus.npc_in),
        .Mem_Control(bus_o.Mem_control),
        .W_Control(bus_o.W_control),
        .IR(bus_o.IR),
        .npc_out(bus_o.npc_out)
    );
    
    // Clock generator
    initial begin :clk_gen
    clk = 1'b0;
    forever #5 clk = ~clk;    
    end:clk_gen

    initial begin :rst_gen
        #22ns rst = ~rst;
    end:rst_gen

    initial begin

            //monitor_bfm retriving its configuration using uvm_config_db
        uvm_config_db#(virtual decode_in_monitor_bfm)::set(null, "*", "decode_in_monitor_bfm", monitor_bfm);
            //driver_bfm retriving its configuration using uvm_config_db
        uvm_config_db#(virtual decode_in_driver_bfm)::set(null, "*", "decode_in_driver_bfm", driver_bfm);
            //monitor_out retriving its configuration using uvm_config_db
        uvm_config_db#(virtual decode_out_monitor_bfm)::set(null, "*", "decode_out_monitor_bfm", monitor_out_bfm);
    end

endmodule:hdl_top