
module axi_led_rgb #(
    parameter INVERSE_MODE = 1
)(
    input                    aclk          ,
    input                    aresetn       ,

    input   [  4 : 0 ]       awaddr        ,
    input   [  2 : 0 ]       awprot        , // not used
    input                    awvalid       ,
    output logic             awready       ,

    input   [ 31 : 0 ]       wdata         ,
    input   [  3 : 0 ]       wstrb         , // not used
    input                    wvalid        ,
    output logic             wready        ,

    output logic  [  1 : 0 ] bresp         ,
    output logic             bvalid        ,
    input                    bready        ,

    input   [  4 : 0 ]       araddr        ,
    input   [  2 : 0 ]       arprot        ,
    input                    arvalid       ,
    output logic             arready       ,

    output logic  [ 31 : 0 ] rdata         ,
    output logic  [  1 : 0 ] rresp         ,
    output logic             rvalid        ,
    input                    rready        ,
    output logic             LED_R         , // to output on board
    output logic             LED_G         ,
    output logic             LED_B          
);


    logic user_resetn           ;

    logic mode_r                ;
    logic mode_g                ;
    logic mode_b                ;

    logic enable_r              ;
    logic enable_g              ;
    logic enable_b              ;

    logic holded_r              ;
    logic holded_g              ;
    logic holded_b              ;

    logic [31:0] duration_r     ;
    logic [31:0] duration_g     ;
    logic [31:0] duration_b     ;

    logic led_r_sts             ;
    logic led_g_sts             ;
    logic led_b_sts             ;

    led_rgb_s_axi_lite_if  led_rgb_s_axi_lite_if_inst (
        .aclk         (aclk)    ,
        .aresetn      (aresetn) ,

        .awaddr       (awaddr)  ,
        .awprot       (awprot)  , // not used
        .awvalid      (awvalid) ,
        .awready      (awready) ,

        .wdata        (wdata)   ,
        .wstrb        (wstrb)   , // not used
        .wvalid       (wvalid)  ,
        .wready       (wready)  ,

        .bresp        (bresp)   ,
        .bvalid       (bvalid)  ,
        .bready       (bready)  ,

        .araddr       (araddr)  ,
        .arprot       (arprot)  ,
        .arvalid      (arvalid) ,
        .arready      (arready) ,

        .rdata        (rdata)   ,
        .rresp        (rresp)   ,
        .rvalid       (rvalid)  ,
        .rready       (rready)  ,

        .user_resetn  (user_resetn),

        .mode_r       (mode_r),
        .mode_g       (mode_g),
        .mode_b       (mode_b),

        .enable_r     (enable_r),
        .enable_g     (enable_g),
        .enable_b     (enable_b),

        .holded_r     (holded_r),
        .holded_g     (holded_g),
        .holded_b     (holded_b),

        .duration_r   (duration_r),
        .duration_g   (duration_g),
        .duration_b   (duration_b),

        .led_r_sts    (led_r_sts),
        .led_g_sts    (led_g_sts),
        .led_b_sts    (led_b_sts) 

    );


    led_rgb #(
        INVERSE_MODE 
    )led_rgb_inst
    (

        .clk        (aclk),

        .resetn     (user_resetn),

        .mode_r     (mode_r),
        .mode_g     (mode_g),
        .mode_b     (mode_b),

        .enable_r   (enable_r),
        .enable_g   (enable_g),
        .enable_b   (enable_b),

        .holded_r   (holded_r),
        .holded_g   (holded_g),
        .holded_b   (holded_b),

        .duration_r (duration_r),
        .duration_g (duration_g),
        .duration_b (duration_b),

        .led_r_sts  (led_r_sts),
        .led_g_sts  (led_g_sts),
        .led_b_sts  (led_b_sts),

        .LED_R      (LED_R)             , // to output on board
        .LED_G      (LED_G)             ,
        .LED_B      (LED_B)              
    );



endmodule