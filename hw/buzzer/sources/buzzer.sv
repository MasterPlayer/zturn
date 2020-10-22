`timescale 1ns / 1ps


module buzzer
    (
        input           clk                 ,

        input           resetn              , // inverse reset signal 

        input           enable              ,
        input[  1 : 0]  mode                ,
        input[ 31 : 0]  duration_on         ,
        input[ 31 : 0]  duration_off        ,

        output logic    buzzer_active       , 

        output logic BUZZER_OUT               // to output on board
    );

    // finite state machine : 
    typedef enum {
        IDLE_ST         , // no activity
        BEEP_ON_ST      , // enable led for duration interval
        BEEP_OFF_ST     ,  // disable led for duration interval
        WAIT_FOR_RELEASE 
    } fsm;

    fsm current_state = IDLE_ST;    

    logic [31:0] duration_on_cnt = '{default:0};
    logic [31:0] duration_off_cnt = '{default:0};

    always_ff @(posedge clk) begin : current_state_processing 
        if (!resetn)
            current_state <= IDLE_ST;
        else
            case (current_state) 
                IDLE_ST : 
                    if (enable) 
                        current_state <= BEEP_ON_ST;
                
                BEEP_ON_ST : 
                    case (mode) 
                        'b00 : 
                            if (duration_on_cnt == 0)
                                current_state <= WAIT_FOR_RELEASE;

                        'b01 :
                            if (duration_on_cnt == 32'b0)
                                current_state <= BEEP_OFF_ST;
    
                        'b10 : 
                            if (!enable)
                                current_state <= IDLE_ST;
                    endcase 

                BEEP_OFF_ST :
                    if (duration_off_cnt == 0)
                        if (!enable)
                            current_state <= IDLE_ST;
                        else
                            current_state <= BEEP_ON_ST;

                WAIT_FOR_RELEASE : 
                    if (!enable)
                        current_state <= IDLE_ST; 

            endcase
        end 

    always_comb begin : buzzer_active_processing 
        case (current_state)
            BEEP_ON_ST : 
                buzzer_active <= 1'b1;
            default : 
                buzzer_active <= 1'b0;
        endcase // current_state
    end 

    always_ff @(posedge clk) begin : duration_on_cnt_processing
        case (current_state) 

            BEEP_ON_ST : 
                if (mode == 'b00 | mode == 'b01) 
                    if (duration_on_cnt == 0)
                        duration_on_cnt <= duration_on;
                    else
                        duration_on_cnt <= duration_on_cnt - 1;
                else
                    duration_on_cnt <= duration_on;
              
            default : 
                duration_on_cnt <= duration_on;
        endcase // current_state            
    end 

    always_ff @(posedge clk) begin : duration_off_cnt_processing
        case (current_state)

            BEEP_OFF_ST : 
                if (duration_off == 0)
                    duration_off_cnt <= duration_off;
                else
                    duration_off_cnt <= duration_off_cnt - 1;

            default : 
                duration_off_cnt <= duration_off;
        endcase // current_state
    end 

    always_comb begin : buzzer_out_assignment 
        if (current_state == BEEP_ON_ST)
            BUZZER_OUT <= 1'b1;
        else
            BUZZER_OUT <= 1'b0;
    end 


endmodule : buzzer