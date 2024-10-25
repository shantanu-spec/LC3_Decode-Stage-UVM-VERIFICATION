class decode_out_agent extends uvm_agent;
    `uvm_component_utils(decode_out_agent)

    decode_out_configuration cfg;    
    decode_out_monitor monitor;     

    uvm_analysis_port #(decode_out_transaction) monitored_ap;

    function new(string name="", uvm_component parent=null);
        super.new(name,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(decode_out_configuration)::get(null,"*","decode_out_configuration",cfg))
            `uvm_error("decode_out_agent","configuration not registered")
        monitor=new("monitor",this);
        monitored_ap=new("monitored_ap",this);                           
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        monitor.monitor_aport.connect(monitored_ap);        
    endfunction

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        `uvm_info("Decode OUT AGENT",cfg.convert2string(),UVM_MEDIUM) 
    endtask



endclass:decode_out_agent