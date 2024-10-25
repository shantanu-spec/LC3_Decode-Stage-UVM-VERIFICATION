// Extension of uvm_env
class decode_environment extends uvm_env;
    `uvm_component_utils(decode_environment)

//Instantiates and constructs agents, predictor, scoreboard
    decode_env_configuration envconfig;
    decode_predictor d_predictor;
    decode_scoreboard d_scoreboard;

    decode_in_agent d_in_agent;
    decode_out_agent d_out_agent; 

    function new(string name="",uvm_component parent = null);
        super.new(name,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
     super.build_phase(phase);
        d_in_agent=new("d_in_agent",this);
        d_out_agent=new("d_out_agent",this);        
        d_predictor=new("d_predictor",this);        
        d_scoreboard=new("d_scoreboard",this);                
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);  
        //Decode_in agent to predictor      
        d_in_agent.monitored_ap.connect(d_predictor.analysis_export);
        // Decode_out agent to scoreboard
        d_out_agent.monitored_ap.connect(d_scoreboard.actual_export);
        //Predictor to scoreboard
        d_predictor.scbd_port.connect(d_scoreboard.expected_export);       
    endfunction
endclass:decode_environment