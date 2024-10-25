class decode_in_agent extends uvm_agent;
    `uvm_component_utils(decode_in_agent)

    decode_in_configuration configuration;
    decode_in_driver driver;
    decode_in_monitor monitor;
    decode_in_coverage coverage;
    
    uvm_sequencer #(decode_in_transaction) sequencer;

    uvm_analysis_port #(decode_in_transaction) monitored_ap;

    function new(string name="", uvm_component parent=null);
        super.new(name,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(decode_in_configuration)::get(null,"*","decode_in_configuration",configuration))
            `uvm_error("decode_in_agent","configuration not registered")
        monitor=new("monitor",this);
        monitored_ap=new("monitored_ap",this);
        if(configuration.state==UVM_ACTIVE)
            begin
                  `uvm_info("AGENT", "decode_in_agent configured as ACTIVE MODE", UVM_LOW)
                driver=new("driver",this);
                sequencer=new("sequencer",this);
            end
            else
            begin
             `uvm_info("AGENT", "decode_in_agent configured as PASSIVE MODE", UVM_LOW)
            end
        if(configuration.enable_coverage)
            begin
                coverage=new("decode_in_coverage",this);
            end             
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        monitor.monitor_aport.connect(monitored_ap);
        if(configuration.enable_coverage) monitor.monitor_aport.connect(coverage.analysis_export);
        if(configuration.state==UVM_ACTIVE) driver.seq_item_port.connect(sequencer.seq_item_export);
    endfunction

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        `uvm_info("AGENT_IN:",configuration.convert2string(),UVM_MEDIUM) 
    endtask



endclass :decode_in_agent