`timescale 1ns / 1ps


module led_rgb #(
        parameter INVERSE_MODE = 1
    )(

        input clk                       ,

        input resetn                    , // inverse reset signal 

        input mode_r                    , // mode : 0 - const led on, 1 - led blinking
        input mode_g                    , // mode : 0 - const led on, 1 - led blinking
        input mode_b                    , // mode : 0 - const led on, 1 - led blinking

        input enable_r                  , // enable led red
        input enable_g                  , // enable led green
        input enable_b                  , // enable led blue

        input holded_r                  , // hold red led if enable is set to 0
        input holded_g                  , // hold green led if enable is set to 0
        input holded_b                  , // hold blue led if enable is set to 0

        input[31:0] duration_r          , // interval over two blinks of led. 
        input[31:0] duration_g          ,
        input[31:0] duration_b          ,

        output logic led_r_sts          , 
        output logic led_g_sts          ,
        output logic led_b_sts          ,

        output logic LED_R              , // to output on board
        output logic LED_G              ,
        output logic LED_B               
    );

    // finite state machine : 
    typedef enum {

        IDLE_ST         , // no activity
        HOLD_ON_ST      , // enable led for duration interval
        HOLD_OFF_ST     , // disable led for duration interval
        LED_ON_ST         // enable led constantly while enable is == 1
    } fsm;

    // fsms individually for each led 
    fsm current_state_led_r = IDLE_ST;
    fsm current_state_led_g = IDLE_ST;
    fsm current_state_led_b = IDLE_ST;

    // timers programmed individually for each led 
    logic[ 31 : 0] led_r_timer = '{default:0};
    logic[ 31 : 0] led_g_timer = '{default:0};
    logic[ 31 : 0] led_b_timer = '{default:0};

    /* fsm for red led blinker :
     */ 
    always_ff @(posedge clk) begin : current_state_led_r_processing 
        if (resetn == 0)
            current_state_led_r <= IDLE_ST;
        else

            case(current_state_led_r)
                IDLE_ST :
                    if (enable_r == 1)
                        if (mode_r == 1)
                            current_state_led_r <= HOLD_ON_ST;
                        else
                            current_state_led_r <= LED_ON_ST;

                HOLD_ON_ST :
                    if (led_r_timer >= duration_r)
                        current_state_led_r <= HOLD_OFF_ST;

                HOLD_OFF_ST :
                    if (led_r_timer >= duration_r)
                        if (holded_r == 1)
                            current_state_led_r <= HOLD_ON_ST;
                        else
                            current_state_led_r <= IDLE_ST;

                LED_ON_ST : 
                    if (enable_r == 0)
                        current_state_led_r <= IDLE_ST;

            endcase
    end 

    always_ff @(posedge clk) begin : current_state_led_g_processing 
        if (resetn == 0)
            current_state_led_g <= IDLE_ST;
        else

            case(current_state_led_g)
                IDLE_ST :
                    if (enable_g == 1)
                        if (mode_g == 1)
                            current_state_led_g <= HOLD_ON_ST;
                        else
                            current_state_led_g <= LED_ON_ST;

                HOLD_ON_ST :
                    if (led_g_timer >= duration_g)
                        current_state_led_g <= HOLD_OFF_ST;

                HOLD_OFF_ST :
                    if (led_g_timer >= duration_g)
                        if (holded_g == 1)
                            current_state_led_g <= HOLD_ON_ST;
                        else
                            current_state_led_g <= IDLE_ST;

                LED_ON_ST : 
                    if (enable_g == 0)
                        current_state_led_g <= IDLE_ST;

            endcase
    end 

    always_ff @(posedge clk) begin : current_state_led_b_processing 
        if (resetn == 0)
            current_state_led_b <= IDLE_ST;
        else

            case(current_state_led_b)
                IDLE_ST :
                    if (enable_b == 1)
                        if (mode_b == 1)
                            current_state_led_b <= HOLD_ON_ST;
                        else
                            current_state_led_b <= LED_ON_ST;

                HOLD_ON_ST :
                    if (led_b_timer >= duration_b)
                        current_state_led_b <= HOLD_OFF_ST;

                HOLD_OFF_ST :
                    if (led_b_timer >= duration_b)
                        if (holded_b == 1)
                            current_state_led_b <= HOLD_ON_ST;
                        else
                            current_state_led_b <= IDLE_ST;

                LED_ON_ST : 
                    if (enable_b == 0)
                        current_state_led_b <= IDLE_ST;


            endcase
    end 



    always_ff @(posedge clk) begin : led_r_timer_processing 
        if (resetn == 0)
            led_r_timer <= '{default:0};
        else
            case (current_state_led_r)
                IDLE_ST : 
                    led_r_timer <= '{default:0};

                HOLD_ON_ST : 
                    if (led_r_timer < duration_r)
                        led_r_timer <= led_r_timer + 1;
                    else
                        led_r_timer <= '{default:0};

                HOLD_OFF_ST: 
                    if (led_r_timer < duration_r)
                        led_r_timer <= led_r_timer + 1;
                    else
                        led_r_timer <= '{default:0};

                default :
                    led_r_timer <= '{default:0};

            endcase // current_state_led_r
    end 


    always_ff @(posedge clk) begin : led_g_timer_processing 
        if (resetn == 0)
            led_g_timer <= '{default:0};
        else
            case (current_state_led_g)
                IDLE_ST : 
                    led_g_timer <= '{default:0};

                HOLD_ON_ST : 
                    if (led_g_timer < duration_g)
                        led_g_timer <= led_g_timer + 1;
                    else
                        led_g_timer <= '{default:0};

                HOLD_OFF_ST: 
                    if (led_g_timer < duration_g)
                        led_g_timer <= led_g_timer + 1;
                    else
                        led_g_timer <= '{default:0};

                default :
                    led_g_timer <= '{default:0};

            endcase // current_state_led_r
    end 


    always_ff @(posedge clk) begin : led_b_timer_processing 
        if (resetn == 0)
            led_b_timer <= '{default:0};
        else
            case (current_state_led_b)
                IDLE_ST : 
                    led_b_timer <= '{default:0};

                HOLD_ON_ST : 
                    if (led_b_timer < duration_b)
                        led_b_timer <= led_b_timer + 1;
                    else
                        led_b_timer <= '{default:0};

                HOLD_OFF_ST: 
                    if (led_b_timer < duration_b)
                        led_b_timer <= led_b_timer + 1;
                    else
                        led_b_timer <= '{default:0};

                default :
                    led_b_timer <= '{default:0};

            endcase // current_state_led_r
    end 

    generate
        if (INVERSE_MODE == 0) 
            always_comb begin : led_assignment_direct
                if (current_state_led_r == HOLD_ON_ST || current_state_led_r == LED_ON_ST)
                    LED_R = 1'b1;
                else
                    LED_R = 1'b0;

                if (current_state_led_g == HOLD_ON_ST || current_state_led_g == LED_ON_ST)
                    LED_G = 1'b1;
                else
                    LED_G = 1'b0;

                if (current_state_led_b == HOLD_ON_ST || current_state_led_b == LED_ON_ST)
                    LED_B = 1'b1;
                else
                    LED_B = 1'b0;
            end 

        if (INVERSE_MODE == 1)
            always_comb begin : led_assignment_direct
                if (current_state_led_r == HOLD_ON_ST || current_state_led_r == LED_ON_ST)
                    LED_R = 1'b0;
                else
                    LED_R = 1'b1;

                if (current_state_led_g == HOLD_ON_ST || current_state_led_g == LED_ON_ST)
                    LED_G = 1'b0;
                else
                    LED_G = 1'b1;

                if (current_state_led_b == HOLD_ON_ST || current_state_led_b == LED_ON_ST)
                    LED_B = 1'b0;
                else
                    LED_B = 1'b1;
            end
    endgenerate


    always_comb begin : led_r_sts_processing 
        if (current_state_led_r == IDLE_ST)
            led_r_sts <= 1'b0;
        else
            led_r_sts <= 1'b1;
    end 

    always_comb begin : led_g_sts_processing 
        if (current_state_led_g == IDLE_ST)
            led_g_sts <= 1'b0;
        else
            led_g_sts <= 1'b1;
    end 

    always_comb begin : led_b_sts_processing 
        if (current_state_led_b == IDLE_ST)
            led_b_sts <= 1'b0;
        else
            led_b_sts <= 1'b1;
    end 


endmodule
