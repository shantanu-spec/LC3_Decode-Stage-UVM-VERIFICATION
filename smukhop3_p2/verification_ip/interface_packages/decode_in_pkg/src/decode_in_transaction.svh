// //Operation instruction
// typedef enum logic [3:0] {
//     //ALU operations
//     ADD = 4'b0001,
//     AND = 4'b0101,
//     NOT = 4'b1001,
//     //Memory operations
//     LD  = 4'b0010,
//     LDR = 4'b0110,
//     LDI = 4'b1010,
//     LEA = 4'b1110,
//     ST  = 4'b0011,
//     STR = 4'b0111,
//     STI = 4'b1011,
//     BR  = 4'b0000,
//     JMP = 4'b1100
// } instr_t; -->Shifted to macros

//Enum psr to store the  
// typedef enum logic [2:0] {
//     NEG  = 3'b100,   //Negative value psr[2]=1
//     ZERO = 3'b010,   //Zero value psr[1]= 1
//     POS  = 3'b001    //Positive value psr[0]]=1
// } psr_t;


class decode_in_transaction extends uvm_sequence_item;
    `uvm_object_utils(decode_in_transaction)

   
    int transaction_view_h;   

    bit clk;
    bit reset;

    randc opcode IR;
    rand bit[2:0] DR;
    rand bit[2:0] SR1;
    rand bit[2:0] SR2;
    rand bit[2:0] SR;
    rand bit[4:0] IMM5;
    rand bit[2:0] BASER;
    rand bit[5:0] PCOFFSET6;
    rand bit[8:0] PCOFFSET9;
    rand bit[15:0] NPC_IN;
    // rand psr_val PSR;
    rand bit IR5;
    rand bit [2:0] NZP;
    bit [15:0] INSTR_DOUT;
    bit ED; 

    time            start_time;
    time            end_time;

    static int inst_count=0;

    bit notNullInst=0;

    constraint PC_val{
        NPC_IN>16'h3000;
    }

    constraint nzp_val{
        NZP > 3'b000; //nzp is 000 only at reset
    }
    
    function new(string name="");
        super.new(name); 
    endfunction 

    function string printInstr();
        string result="";
        case(IR)
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
            default: begin
                `uvm_fatal("TRANSACTION:", "Invalid instruction type!")
            end
        endcase
        return result;
    endfunction

    function void post_randomize();    
        ED=1; 
        case(IR)
            ADD:begin
                    if(IR5) INSTR_DOUT={IR,DR,SR1,IR5,IMM5};
                    else INSTR_DOUT={IR,DR,SR1,IR5,2'b00,SR2};
                end
            AND:begin
                    if(IR5) INSTR_DOUT={IR,DR,SR1,IR5,IMM5};
                    else INSTR_DOUT={IR,DR,SR1,IR5,2'b00,SR2};
                end
            NOT:begin
                    INSTR_DOUT={IR,DR,SR1,6'b111111};
                end
            LD:begin
                    INSTR_DOUT={IR,DR,PCOFFSET9};
                end
            LDR:begin
                    INSTR_DOUT={IR,DR,BASER,PCOFFSET6};
                end
            LDI:begin
                    INSTR_DOUT={IR,DR,PCOFFSET9};
                end
            LEA:begin
                    INSTR_DOUT={IR,DR,PCOFFSET9};
                end
            ST:begin
                    INSTR_DOUT={IR,SR,PCOFFSET9};
                end
            STR:begin
                    INSTR_DOUT={IR,SR,BASER,PCOFFSET6};
                end
            STI:begin
                    INSTR_DOUT={IR,SR,PCOFFSET9};
                end
            BR: begin 
                    INSTR_DOUT={IR,NZP,PCOFFSET9};
                end
            JMP:begin
                    INSTR_DOUT={IR,3'b000,BASER,6'b000000};
                end
            default: $error("INVALID INSTRUCTION");
        endcase
    endfunction

    virtual function void set_op(); 
        $cast(IR,INSTR_DOUT[15:12]);                     
        if(INSTR_DOUT!=0) notNullInst=1;        
        case(IR)
            ADD, AND:begin
                    DR=INSTR_DOUT[11:9];
                    SR1=INSTR_DOUT[8:6];
                    IR5=INSTR_DOUT[5];
                    if(IR5) begin
                        IMM5=INSTR_DOUT[4:0];
                    end else begin
                        SR2=INSTR_DOUT[3:0];
                    end
                end
            NOT:begin
                    DR=INSTR_DOUT[11:9];
                    SR1=INSTR_DOUT[8:6]; 
                end
            LD,LDI,LEA: begin
                    DR=INSTR_DOUT[11:9];
                    PCOFFSET9=INSTR_DOUT[8:0];
                end
            LDR:begin
                    DR=INSTR_DOUT[11:9];
                    BASER=INSTR_DOUT[8:6];
                    PCOFFSET6=INSTR_DOUT[5:0];
                end             
            ST,STI: begin
                    SR=INSTR_DOUT[11:9];
                    PCOFFSET9=INSTR_DOUT[8:0];
                end
            STR:begin
                    SR=INSTR_DOUT[11:9];
                    BASER=INSTR_DOUT[8:6];
                    PCOFFSET6=INSTR_DOUT[5:0];
                end 
            BR:begin
                    NZP=INSTR_DOUT[11:9];
                    PCOFFSET9=INSTR_DOUT[8:0];
               end
            JMP:begin
                    BASER=INSTR_DOUT[8:6];
               end
        endcase
    endfunction

    virtual function string convert2string();
        return $sformatf("| NPC_IN = 0x%x | INSTR_DOUT = 0x%x | %s  ",NPC_IN,INSTR_DOUT,printInstr());
    endfunction

    virtual function void add_to_wave(int transaction_viewing_stream_h);
        if(notNullInst&&inst_count<=49)
        begin
            inst_count++;
            transaction_view_h = $begin_transaction(transaction_viewing_stream_h,"transaction",start_time);        
            $add_attribute( transaction_view_h, NPC_IN, "npc_in" );
            $add_attribute( transaction_view_h, INSTR_DOUT, "instr_dout" ); 
            $add_attribute(transaction_view_h, IR, "OPTYPE" );
            $add_attribute(transaction_view_h, inst_count, "Count(HEX)" );
            $add_attribute( transaction_view_h, ED, "enable_decode" );
            $end_transaction(transaction_view_h,end_time);
            $free_transaction(transaction_view_h);
        end        
    endfunction

endclass