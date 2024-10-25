class decode_in_driver extends uvm_driver #(decode_in_transaction);
    `uvm_component_utils(decode_in_driver)
    virtual decode_in_driver_bfm driver_bfm;

    decode_in_transaction req;
    decode_in_transaction rsp;

    function new(string name="",uvm_component parent=null);
        super.new(name,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual decode_in_driver_bfm)::get(null,"*","decode_in_driver_bfm",driver_bfm))
        begin
                `uvm_error(get_type_name(),"Driver IN BFM not found")
        end
    endfunction

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        driver_bfm.check_reset();
        forever begin
               `uvm_info("DRIVER", "Requesting a transaction from the sequencer",UVM_MEDIUM)
            seq_item_port.get_next_item(req);
            driver_bfm.drive(req.INSTR_DOUT,req.NPC_IN,req.ED);
            `uvm_info("Decode In DRIVER",req.convert2string(),UVM_MEDIUM)
            rsp=new("rsp");
            rsp.set_id_info(req);
            rsp=req;
            seq_item_port.item_done(rsp);
            `uvm_info("Decode In DRIVER",$sformatf("Data driven Successfully"),UVM_MEDIUM)
        end
        
    endtask


endclass:decode_in_driver