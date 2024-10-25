class decode_in_random_sequence  extends decode_in_sequence_base;
    `uvm_object_utils(decode_in_random_sequence)

     int count;  

    function new(string name="");
        super.new(name);
    endfunction

    virtual task body();
        req=new("req"); 
        // `uvm_info("SEQUENCE", "Requesting to send transaction to driver",UVM_MEDIUM)       
        repeat(50) begin
            count++;
            $display("");
            $display("Transactions Count = %3d",count);
            start_item(req);
            assert(req.randomize());
            finish_item(req);
            get_response(rsp);
        end        
    endtask

endclass