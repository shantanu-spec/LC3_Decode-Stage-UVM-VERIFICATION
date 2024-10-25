// Extension of uvm_subscriber
class decode_predictor extends uvm_subscriber #(decode_in_transaction);
    `uvm_component_utils(decode_predictor)

    decode_out_transaction trans;    
    // Instantiates and constructs an analysis_port
    uvm_analysis_port #(decode_out_transaction) scbd_port;

    function new(string name="",uvm_component parent=null);
        super.new(name,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        scbd_port = new("scbd_port",this);
    endfunction

    virtual function void write(decode_in_transaction t);
        trans=new("trans");
        // Use decode_model function for prediction
        void'(decode_model(t.INSTR_DOUT,t.NPC_IN,trans.IR,trans.NPC_OUT,trans.E_control,trans.W_control,trans.Mem_control));     
        // Predicted result should be decode_out_transaction type   
        trans.set_op();
        // Broadcast predicted result through analysis port.
        scbd_port.write(trans);
    endfunction

endclass :decode_predictor