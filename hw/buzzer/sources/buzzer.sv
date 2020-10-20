`timescale 1ns / 1ps


module buzzer #(
        parameter INVERSE_MODE = 1
    )(

        input           clk                 ,

        input           resetn              , // inverse reset signal 

        input           enable              ,
        input[  1 : 0]  mode                ,
        input[ 31 : 0]  duration_on         ,
        input[ 31 : 0]  duration_off        ,


        output logic LED_R_STS          , 
        output logic LED_G_STS          ,
        output logic LED_B_STS          ,

        output logic BUZZER_OUT         , // to output on board
    );

    // finite state machine : 
    typedef enum {
        IDLE_ST         , // no activity
        HOLD_ON_ST      , // enable led for duration interval
        HOLD_OFF_ST     , // disable led for duration interval
        LED_ON_ST         // enable led constantly while enable is == 1
    } fsm;


endmodule : buzzer