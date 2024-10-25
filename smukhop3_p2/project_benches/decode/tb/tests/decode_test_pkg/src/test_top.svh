import decode_test_pkg::*;

class test_top extends uvm_test;

  `uvm_component_utils(test_top)
 
  decode_in_random_sequence rand_seq;
  decode_env_configuration configuration;
  decode_environment d_environment;

 //actitvity setting
  uvm_active_passive_enum interface_activities[] = {UVM_ACTIVE, UVM_PASSIVE};

//parent path
  string environment_path = "test_top/environment/";
 //interface names
  string interface_names[] = {"decode_in", "decode_out"};


  bit enable_coverage = 1;
  bit enable_transaction_viewing = 1;

  function new(string name = "", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    begin   
        super.build_phase(phase);

        rand_seq=new("rand_seq");       
         `uvm_info("TEST TOP", "Random Sequence Instantiated", UVM_MEDIUM)   
              
        configuration=new("configuration");
        d_environment=new("environment",this);
        //sends config initialize function passing agent path, interface name, and activity:Environment configuration initialize call performed in test class build phase.
        configuration.initialize( environment_path,interface_names,interface_activities, enable_transaction_viewing,enable_coverage);          
    end
  endfunction 
  
  virtual task run_phase(uvm_phase phase);
  // `uvm_info("TEST TOP", "Start run_phase", UVM_MEDIUM)
    phase.raise_objection(this, "Objection raised by test_top!");
  // `uvm_info("TEST TOP", "Objection Raised!", UVM_MEDIUM)
  //runs 50 random transactions
    rand_seq.start(d_environment.d_in_agent.sequencer);
    #10ns;
   phase.drop_objection(this, "Objection Dropped by test_top!");
  endtask

endclass: test_top