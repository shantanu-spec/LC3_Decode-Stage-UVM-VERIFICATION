class decode_in_monitor extends uvm_monitor;
    `uvm_component_utils(decode_in_monitor) //registering to factory
    
    
    decode_in_configuration configuration;
    decode_in_transaction trans;    
    int trans_count;

    int transaction_viewing_stream;
    uvm_analysis_port #(decode_in_transaction) monitor_aport;

    virtual decode_in_monitor_bfm monitor_bfm;

    function new(string name="",uvm_component parent=null);
        super.new(name,parent);
    endfunction

    virtual function void set_proxy();
        monitor_bfm.proxy=this;
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db #(virtual decode_in_monitor_bfm)::get(null,"*","decode_in_monitor_bfm",monitor_bfm))
            begin
                `uvm_error("FATAL","monitor BFM is not registered")
            end
        monitor_aport = new("monitor_aport",this);        
        if(!uvm_config_db #(decode_in_configuration)::get(this,"*","decode_in_configuration",configuration))
            begin
                `uvm_error("FATAL","Configuration object not registered")
            end   
        trans=new("trans");     
        set_proxy();
        trans_count=0;
    endfunction

   

    virtual task run_phase(uvm_phase phase);
        monitor_bfm.check_reset();
        forever begin
            trans.start_time=$time;
            monitor_bfm.read_bus(trans.INSTR_DOUT,trans.NPC_IN,trans.ED);
            trans.end_time=$time; 
            trans.set_op();
            trans_count++;
            add_wave(trans);
            $display("");                         
             `uvm_info("Decode In MONITOR",trans.convert2string(),UVM_MEDIUM);                      
        end
    endtask

    virtual function void add_wave(decode_in_transaction t);
           t.add_to_wave(transaction_viewing_stream);

        monitor_aport.write(t);        
    endfunction
    
 virtual function void start_of_simulation_phase(uvm_phase phase);
        super.start_of_simulation_phase(phase);
              transaction_viewing_stream=$create_transaction_stream({"..",get_full_name(),".","txn_stream"});
   
    endfunction
endclass