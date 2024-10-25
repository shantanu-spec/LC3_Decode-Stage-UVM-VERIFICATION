
add wave -noupdate -expand /uvm_root/uvm_test_top/environment/d_in_agent/monitor/txn_stream
add wave -noupdate -expand /uvm_root/uvm_test_top/environment/d_out_agent/monitor/txn_stream

add wave -noupdate /hdl_top/bus/clk
add wave -noupdate /hdl_top/bus/rst
add wave -noupdate /hdl_top/bus/enable_decode
add wave -noupdate /hdl_top/bus/instr_dout
add wave -noupdate /hdl_top/bus/npc_in


add wave -noupdate /hdl_top/bus_o/IR
add wave -noupdate /hdl_top/bus_o/npc_out
add wave -noupdate /hdl_top/bus_o/Mem_control
add wave -noupdate /hdl_top/bus_o/E_control
add wave -noupdate /hdl_top/bus_o/W_control