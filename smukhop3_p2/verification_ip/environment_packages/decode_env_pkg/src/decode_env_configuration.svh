//Extension of uvm_object
class decode_env_configuration extends uvm_object;

    `uvm_object_utils(decode_env_configuration)
//Instantiates and constructs agent configurations
	decode_in_configuration d_in_configuration;
	decode_out_configuration d_out_configuration;

    function new(string name = "");
        super.new(name);
        d_in_configuration=new("d_in_configuration");
        d_out_configuration=new("d_out_configuration");
    endfunction

//Initialize function: Receives parent path, interface names, and activity settings for all agents within the environment
    function void initialize(string parent_path, string interface_names[], uvm_active_passive_enum activity[]= {},bit enable_transaction_viewing,bit enable_coverage);
    //Calls agent config initialize function passing agent path, interface name, and activity
        d_in_configuration.initialize(activity[0],{parent_path, "/d_in_agent"},interface_names[0],enable_transaction_viewing,enable_coverage);
        uvm_config_db #(decode_in_configuration)::set(null, "*", "decode_in_configuration", d_in_configuration);
        //Calls agent config initialize function passing agent path, interface name, and activity
        d_out_configuration.initialize(activity[1],{parent_path, "/d_out_agent"},interface_names[1],enable_transaction_viewing);       
        uvm_config_db #(decode_out_configuration)::set(null, "*", "decode_out_configuration", d_out_configuration);   

        `uvm_info("DECODE_ENV_CONFIGURATION",convert2string(),UVM_MEDIUM)
    endfunction

    virtual function string convert2string();
        // return $sformatf("CONFIG SET| DECODE_AGENT_IN = ",$sformatf(d_in_configuration.convert2string)," || DECODE_AGENT_OUT = ",$sformatf(d_out_configuration.convert2string),"|\n");
        return $sformatf("CONFIG SET| DECODE_AGENT_IN = %s || DECODE_AGENT_OUT = %s\n",d_in_configuration.convert2string,d_out_configuration.convert2string);
    endfunction
    

endclass:decode_env_configuration