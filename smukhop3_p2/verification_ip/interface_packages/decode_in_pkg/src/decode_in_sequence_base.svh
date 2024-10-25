class decode_in_sequence_base extends uvm_sequence#(.REQ(decode_in_transaction), .RSP(decode_in_transaction));

//THis is the base sequence class which other type of sequences can inherit
//Stimulus flow including sequence item, sequence base and random sequence
      decode_in_transaction req;
      decode_in_transaction rsp;


  // configuration variables
      function new(string name="decode_in_sequence_base"); 
        super.new(name);
      endfunction

  endclass  