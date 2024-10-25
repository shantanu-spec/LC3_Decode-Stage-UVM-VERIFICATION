class decode_out_transaction extends uvm_sequence_item;
    `uvm_object_utils(decode_out_transaction)

    time start_time, end_time;
    int transaction_view_h;

    bit clk;
    bit reset;

    opcode Itype;
    bit[2:0] DR;
    bit[2:0] SR1;
    bit[2:0] SR2;
    bit[2:0] SR;
    bit[4:0] IMM5;
    bit[2:0] BASER;
    bit[5:0] PCOFFSET6;
    bit[8:0] PCOFFSET9;      
    bit IR5;
    bit [2:0] NZP;

    bit [15:0] IR;   
    bit[15:0] NPC_OUT;  
    bit[5:0] E_control;  
    bit[1:0] W_control;
    bit Mem_control;
    bit ED;

    static int inst_count=0;

    bit notNullInst=0;

    constraint PC_val{
        NPC_OUT>16'h3000;
    }

    constraint nzp_val{
        NZP!=3'b000;
    }
    
    function new(string name="");
        super.new(name);
    endfunction 

    function string printInstr();
        string result="";
        case(Itype)
            ADD:begin
                    if(IR5) result=$sformatf(" Type = ADD | DR = %x | SR1 = %x | IMM5 = %x |", DR, SR1, IMM5);
                    else result=$sformatf(" Type = ADD | DR = %x | SR1 = %x | SR2 = %x |", DR, SR1, SR2);
                end
            AND:begin
                    if(IR5) result=$sformatf(" Type = AND | DR = %x | SR1 = %x | IMM5 = %x |", DR, SR1, IMM5);
                    else result=$sformatf(" Type = AND | DR = %x | SR1 = %x | SR2 = %x |", DR, SR1, SR2);
                end
            NOT:begin
                    result=$sformatf(" Type = NOT | DR= %x | SR1 = %x |", DR, SR1);
                end
            LD:begin
                    result=$sformatf(" Type = LD  | DR= %x | PCOFFSET = %x |", DR, PCOFFSET9);
                end
            LDR:begin
                    result=$sformatf(" Type = LDR | DR = %x | BaseR = %x | PCOFFSET = %x |", DR, BASER, PCOFFSET6);
                end
            LDI:begin
                    result=$sformatf(" Type = LDI | DR = %x | PCOFFSET = %x |", DR, PCOFFSET9);
                end
            LEA:begin
                    result=$sformatf(" Type = LEA | DR = %x | PCOFFSET = %x |", DR, PCOFFSET9);
                end
            ST:begin
                    result=$sformatf(" Type = ST  | SR = %x | PCOFFSET = %x |", SR, PCOFFSET9);
                end
            STR:begin
                    result=$sformatf(" Type = STR | SR = %x | BaseR = %x | PCOFFSET = %x |", SR, BASER, PCOFFSET6);
                end
            STI:begin
                    result=$sformatf(" Type = STI | SR = %x | PCOFFSET = %x |", SR, PCOFFSET9);
                end
            BR:begin
                    result=$sformatf(" Type = BR  | NZP = %x | PCOFFSET = %x |", NZP, PCOFFSET9);
                end
            JMP:begin
                    result=$sformatf(" Type = JMP | BaseR = %x |",BASER);
                end
        endcase
        return result;
    endfunction   

    virtual function void set_op();             
        $cast(Itype,IR[15:12]);
        if(IR!=0) notNullInst=1;        
        case(Itype)
            ADD, AND:begin
                    DR=IR[11:9];
                    SR1=IR[8:6];
                    IR5=IR[5];
                    if(IR5) begin
                        IMM5=IR[4:0];
                    end else begin
                        SR2=IR[3:0];
                    end
                end
            NOT:begin
                    DR=IR[11:9];
                    SR1=IR[8:6]; 
                end
            LD,LDI,LEA: begin
                    DR=IR[11:9];
                    PCOFFSET9=IR[8:0];
                end
            LDR:begin
                    DR=IR[11:9];
                    BASER=IR[8:6];
                    PCOFFSET6=IR[5:0];
                end             
            ST,STI: begin
                    SR=IR[11:9];
                    PCOFFSET9=IR[8:0];
                end
            STR:begin
                    SR=IR[11:9];
                    BASER=IR[8:6];
                    PCOFFSET6=IR[5:0];
                end 
            BR:begin
                    NZP=IR[11:9];
                    PCOFFSET9=IR[8:0];
               end
            JMP:begin
                    BASER=IR[8:6];
               end
        endcase
    endfunction

    virtual function string convert2string();
        return $sformatf("| NPC_OUT = 0x%x | IR = 0x%x | %s  ",NPC_OUT,IR,printInstr());
    endfunction

    virtual function bit compare(decode_out_transaction trans);
        bit flag=0;
        if( this.IR==trans.IR && this.NPC_OUT==trans.NPC_OUT && this.E_control==trans.E_control && this.W_control==trans.W_control && this.Mem_control==trans.Mem_control ) flag=1;
        return flag;    
    endfunction


    virtual function void add_to_wave(int transaction_viewing_stream_h);
        if(notNullInst)
        begin
            inst_count++;
            transaction_view_h = $begin_transaction(transaction_viewing_stream_h,"transaction",start_time);        
            $add_attribute( transaction_view_h, NPC_OUT, "NPC_OUT" );
            $add_attribute( transaction_view_h, IR, "IR" ); 
            $add_attribute( transaction_view_h, Itype, "Op_Type" );             
            $add_attribute(transaction_view_h, inst_count, "Count(HEX)" );  
            $add_attribute( transaction_view_h, ED, "enable_decode_delayed" );          
            $end_transaction(transaction_view_h,end_time);
            $free_transaction(transaction_view_h);
        end        
    endfunction

endclass