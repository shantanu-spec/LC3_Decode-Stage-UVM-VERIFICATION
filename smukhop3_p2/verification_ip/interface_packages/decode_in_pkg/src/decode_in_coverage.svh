class decode_in_coverage extends uvm_subscriber #(.T(decode_in_transaction));
    `uvm_component_utils(decode_in_coverage) //registering to factory

    T trans;


covergroup decodetrans_cov;
    instr_cov: coverpoint trans.IR[15:12]{
         bins add_bin = {4'b0001}; //1
         bins and_bin = {4'b0101}; //5
         bins not_bin = {4'b1001}; //9
         bins ld_bin  = {4'b0010}; //2
         bins ldr_bin = {4'b0110}; //6
         bins ldi_bin = {4'b1010}; //10
         bins lea_bin = {4'b1110}; //14
         bins st_bin  = {4'b0011}; //3
         bins str_bin = {4'b0111}; //7
         bins sti_bin = {4'b1011}; //11
         bins jmp_bin = {4'b1100}; //12
         bins br_bin  = {4'b0000}; //0
   }

endgroup: decodetrans_cov


    function new(string name = "", uvm_component parent=null);
        super.new(name,parent);
        trans=new("trans");
        decodetrans_cov = new;
        // counter = 0;
    endfunction

    virtual function void write(T t);
    //    `uvm_info("COVERAGE", {"Transaction received: ", t.convert2string()}, UVM_MEDIUM)
    //    counter += 1;
    //    `uvm_info("COVERAGE", $sformatf("Number of transactions received: %d", counter), UVM_MEDIUM)

        trans=t;
        decodetrans_cov.sample();
    endfunction

endclass:decode_in_coverage