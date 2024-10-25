// Extension of uvm_component
class decode_scoreboard extends uvm_component;
    `uvm_component_utils(decode_scoreboard)
    // Use uvm_analysis_imp_decl to create two analysis_exports
    `uvm_analysis_imp_decl(_expected)
    `uvm_analysis_imp_decl(_actual)

    uvm_analysis_imp_expected #(decode_out_transaction, decode_scoreboard) expected_export;
    uvm_analysis_imp_actual #(decode_out_transaction, decode_scoreboard) actual_export;

// Use a systemVerilog queue to store transactions received from expected analysis export
    decode_out_transaction trans_queue [$];
    decode_out_transaction expected_trans;

    int match_count=0;
    int mismatch_count=0;
    int nothing_to_compare_against_count=0;

    bit end_of_test_empty_check=1'b1;       
    bit wait_for_scoreboard_empty=1'b1;
    event entry_received;
    
    function new(string name = "decode_scoreboard", uvm_component parent = null);
        super.new(name, parent);
        // Retrieve an expected item from the queue
        trans_queue.push_back(expected_trans);

        expected_export = new("expected_export",this);
        actual_export = new("actual_export",this);        
    endfunction

    virtual function string compare_message(string report_h, decode_out_transaction trans_expected, decode_out_transaction trans_actual);
        return {report_h, "\n\n|             EXPECTED_TRANS: ", trans_expected.convert2string(),"\n|             ACTUAL_TRANS:   ",trans_actual.convert2string()};
    endfunction

    virtual task wait_for_scoreboard_drain();
        while(trans_queue.size() != 0)
            begin 
                @entry_received;
                void'(trans_queue.pop_front());
            end 
    endtask

    virtual function void write_actual(decode_out_transaction t);
        ->entry_received;        
        expected_trans = trans_queue.pop_front();
        if(!expected_trans) 
            begin 
                nothing_to_compare_against_count++;                
            end 
        else 
            begin 
                if(t.notNullInst)
                    begin
                        if(t.compare(expected_trans))
                            begin 
                                match_count++;
                                // Transaction match: send message using `uvm_info
                                `uvm_info($sformatf("SCOREBOARD_INFO.%s", this.get_full_name()), compare_message("MATCH! ", expected_trans, t), UVM_MEDIUM)
                            end 
                         else
                            begin 
                                mismatch_count++;
                                // Transaction mismatch: send message with `uvm_error
                                `uvm_error($sformatf("SCOREBOARD_INFO.%s", this.get_full_name()), compare_message("MISMATCH! ", expected_trans, t))
                            end 
                    end
            end 
    endfunction

    virtual function void write_expected(decode_out_transaction t);        
        trans_queue.push_back(t);        
    endfunction
        
    virtual function void check_phase(uvm_phase phase);
        super.check_phase(phase);
        if(end_of_test_empty_check && (trans_queue.size() != 0))
            begin 
                `uvm_error("SCOREBOARD","not empty");
            end
    endfunction

    virtual function void phase_ready_to_end(uvm_phase phase);
        super.phase_ready_to_end(phase);
        if(phase.get_name() == "run")
            begin 
                if(wait_for_scoreboard_empty)
                    begin 
                        phase.raise_objection(this, "Start");
                        fork
                            begin 
                                wait_for_scoreboard_drain();
                                phase.drop_objection(this, "End");
                            end 
                        join_none
                    end 
            end 
    endfunction

    virtual function string report_message(string rep_header, int rep_variables[]);
    
        return{$sformatf("| %s PREDICTED TRANSACTIONS = %d | #MATCHES = %d | #MISMATCHES = %d |", rep_header, rep_variables[0], rep_variables[1], rep_variables[2])};
    endfunction

    virtual function void report_phase(uvm_phase phase);   
    // Report results of count during report phase 
        string report_header = "SCOREBOARD_RESULTS: "; 
        int report_variables[] = {match_count+mismatch_count, match_count, mismatch_count};  
        super.report_phase(phase);
        `uvm_info($sformatf("SCOREBOARD_SUMMARY:%s", this.get_full_name()), report_message(report_header, report_variables), UVM_MEDIUM)
    endfunction
    
endclass