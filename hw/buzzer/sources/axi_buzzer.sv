
module axi_buzzer (
    input                    aclk          ,
    input                    aresetn       ,

    input   [  3 : 0 ]       awaddr        ,
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

    input   [  3 : 0 ]       araddr        ,
    input   [  2 : 0 ]       arprot        ,
    input                    arvalid       ,
    output logic             arready       ,

    output logic  [ 31 : 0 ] rdata         ,
    output logic  [  1 : 0 ] rresp         ,
    output logic             rvalid        ,
    input                    rready        ,

    output logic BUZZER_OUT               // to output on board


);


    logic           resetn              ;

    logic           enable              ;
    logic[  1 : 0]  mode                ;
    logic[ 31 : 0]  duration_on         ;
    logic[ 31 : 0]  duration_off        ;

    logic           buzzer_active       ;


    buzzer_s_axi_lite_if buzzer_s_axi_lite_if_inst (
        .aclk          (aclk   ),
        .aresetn       (aresetn),

        .awaddr        (awaddr ),
        .awprot        (awprot ),
        .awvalid       (awvalid),
        .awready       (awready),

        .wdata         (wdata  ),
        .wstrb         (wstrb  ),
        .wvalid        (wvalid ),
        .wready        (wready ),

        .bresp         (bresp  ),
        .bvalid        (bvalid ),
        .bready        (bready ),

        .araddr        (araddr ),
        .arprot        (arprot ),
        .arvalid       (arvalid),
        .arready       (arready),

        .rdata         (rdata  ),
        .rresp         (rresp  ),
        .rvalid        (rvalid ),
        .rready        (rready ),

        .buzzer_active (buzzer_active),

        .resetn        (resetn      ),
        .enable        (enable      ),
        .mode          (mode        ),
        .duration_on   (duration_on ),
        .duration_off  (duration_off) 

    );



    buzzer buzzer_inst(
        .clk          (aclk        ),
        .resetn       (resetn      ), // inverse reset signal 
        .buzzer_active(buzzer_active),
        .enable       (enable      ),
        .mode         (mode        ),
        .duration_on  (duration_on ),
        .duration_off (duration_off),
        .BUZZER_OUT   (BUZZER_OUT  )// to output on board
    );


endmodule