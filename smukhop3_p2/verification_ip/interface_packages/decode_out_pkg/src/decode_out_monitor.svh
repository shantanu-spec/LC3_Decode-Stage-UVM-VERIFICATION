class decode_out_monitor extends uvm_monitor;
    `uvm_component_utils(decode_out_monitor)
    
    int transaction_viewing_stream;
    decode_out_configuration cfg;
    decode_out_transaction trans;    
    int trans_count;

    uvm_analysis_port #(decode_out_transaction) monitor_aport;

    virtual decode_out_monitor_bfm monitor_bfm;

    function new(string name="",uvm_component parent=null);
        super.new(name,parent);
    endfunction

    virtual function void set_proxy();
        monitor_bfm.proxy=this;
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db #(virtual decode_out_monitor_bfm)::get(null,"*","decode_out_monitor_bfm",monitor_bfm))
            begin
                `uvm_error("FATAL","MONITOR_OUT BFM is not registered")
            end
        monitor_aport = new("monitor_aport",this);        
        if(!uvm_config_db #(decode_out_configuration)::get(this,"*","decode_out_configuration",cfg))
            begin
                `uvm_error("FATAL","Configuration object not registered for decode_out")
            end   
        trans=new("trans");     
        set_proxy();
        trans_count=0;
    endfunction

    virtual function void start_of_simulation_phase(uvm_phase phase);
        super.start_of_simulation_phase(phase);

                transaction_viewing_stream=$create_transaction_stream({"..",get_full_name(),".","txn_stream"});
 
    endfunction

    virtual task run_phase(uvm_phase phase);
        monitor_bfm.check_reset();             
        forever begin
            trans.start_time=$time;
            monitor_bfm.read_bus(trans.IR,trans.E_control, trans.NPC_OUT, trans.Mem_control, trans.W_control, trans.ED);
            trans.end_time=$time; 
            trans.set_op();
            trans_count++;
            add_wave(trans);
            $display("");                         
             `uvm_info("DECODE OUT MONITOR",trans.convert2string(),UVM_MEDIUM);
                                    
        end
    endtask

    virtual function void add_wave(decode_out_transaction t);

            t.add_to_wave(transaction_viewing_stream);

        monitor_aport.write(t);        
    endfunction

endclass