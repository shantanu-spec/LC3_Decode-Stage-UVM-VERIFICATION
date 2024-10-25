class decode_out_configuration extends uvm_object;
    `uvm_object_utils(decode_out_configuration)
    //BFM handles are instantiated
    virtual decode_out_monitor_bfm monitor_out_bfm;
    
    uvm_active_passive_enum state_out;
    bit enable_transaction_viewing;

    function new(string name="");
        super.new(name);
    endfunction

    function void initialize(uvm_active_passive_enum activity,string agent_path, string interface_name,bit enable_transaction_viewing);   
        if(!uvm_config_db #(virtual decode_out_monitor_bfm)::get(null,"*","decode_out_monitor_bfm",monitor_out_bfm))
            begin
                `uvm_error(get_full_name(),{"monitor bfm virtual interface not set"})
            end                       
             `uvm_info("CFG", $sformatf("The agent at '%s' is using interface named %s has the following parameters: ", agent_path, interface_name, ),
              UVM_DEBUG)

    state_out = activity;
    enable_transaction_viewing = enable_transaction_viewing;
    endfunction

    virtual function string convert2string();
       return $sformatf("\n    MONITOR BFM: %p\n    Active/Passive: %s\n    Enable Transaction Viewing: %s\n", monitor_out_bfm, (state_out?"ACTIVE":"PASSIVE"), (enable_transaction_viewing?"ON":"OFF"));
    endfunction
    
endclass: decode_out_configuration