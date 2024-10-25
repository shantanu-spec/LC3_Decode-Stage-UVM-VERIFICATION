class decode_in_configuration extends uvm_object;
    `uvm_object_utils(decode_in_configuration)

    //BFM handles are instantiated
  virtual decode_in_monitor_bfm monitor_bfm;
  virtual decode_in_driver_bfm driver_bfm;
    
    uvm_active_passive_enum state;
    bit enable_coverage;
    bit enable_transaction_viewing;

    function new(string name="");
        super.new(name);
    endfunction

    virtual function void initialize(uvm_active_passive_enum activity,string agent_path, string interface_name,bit enable_transaction_viewing, bit enable_coverage);
        if(!uvm_config_db #(virtual decode_in_driver_bfm)::get(null,"*","decode_in_driver_bfm",driver_bfm))
            begin
                `uvm_error(get_full_name(),{"DRIVER_BFM VIRTUAL INTERFACE NOT SET CORRECTLY"})
            end
        if(!uvm_config_db #(virtual decode_in_monitor_bfm)::get(null,"*","decode_in_monitor_bfm",monitor_bfm))
            begin
                `uvm_error(get_full_name(),{"MONITOR BFM VIRTUAL INTERFACE"})
            end       
           `uvm_info("CFG",$sformatf("AGENT: '%s' is using interface  %s has the following parameters: ", agent_path, interface_name, ),UVM_DEBUG)   
        state=activity;
        enable_coverage=enable_coverage;
        enable_transaction_viewing=enable_transaction_viewing; 
    endfunction

  

    virtual function string convert2string();
        return $sformatf("\n    MONITOR BFM: %p\n    DRIVER BFM: %p\n    MODE: %s\n    ENABLE COVERAGE: %s\n    ENABLE TRANSACTION VIEWING: %s\n", monitor_bfm, driver_bfm, (state?"ACTIVE":"PASSIVE"), (enable_coverage?"ON":"OFF"), (enable_transaction_viewing?"ON":"OFF"));
    endfunction
    
endclass :decode_in_configuration