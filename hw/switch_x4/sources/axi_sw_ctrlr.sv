
module axi_sw_ctrlr (
    input               aclk   ,
    input               aresetn,
    input        [ 3:0] awaddr ,
    input        [ 2:0] awprot , // not used
    input               awvalid,
    output logic        awready,
    input        [31:0] wdata  ,
    input        [ 3:0] wstrb  , // not used
    input               wvalid ,
    output logic        wready ,
    output logic [ 1:0] bresp  ,
    output logic        bvalid ,
    input               bready ,
    input        [ 3:0] araddr ,
    input        [ 2:0] arprot ,
    input               arvalid,
    output logic        arready,
    output logic [31:0] rdata  ,
    output logic [ 1:0] rresp  ,
    output logic        rvalid ,
    input               rready ,
    output logic        IRQ    ,
    input        [ 3:0] SW
);


    logic enable_irq;

    logic [3:0] sw_mask     ;
    logic [3:0] sw_event_ack;
    logic [3:0] sw_event    ;
    logic [3:0] sw_state    ;

    logic [3:0] sw_f        ;

    switch_ctrlr_x4_s_axi_lite_if switch_ctrlr_x4_s_axi_lite_if_inst (
        .aclk        (aclk        ),
        .aresetn     (aresetn     ),
        .awaddr      (awaddr      ),
        .awprot      (awprot      ),
        .awvalid     (awvalid     ),
        .awready     (awready     ),
        .wdata       (wdata       ),
        .wstrb       (wstrb       ),
        .wvalid      (wvalid      ),
        .wready      (wready      ),
        .bresp       (bresp       ),
        .bvalid      (bvalid      ),
        .bready      (bready      ),
        .araddr      (araddr      ),
        .arprot      (arprot      ),
        .arvalid     (arvalid     ),
        .arready     (arready     ),
        .rdata       (rdata       ),
        .rresp       (rresp       ),
        .rvalid      (rvalid      ),
        .rready      (rready      ),
        
        .enable_irq  (enable_irq  ),
        .sw_mask     (sw_mask     ),
        .sw_event_ack(sw_event_ack),
        .sw_event    (sw_event    ),
        .sw_state    (sw_state    )
    );


    sw_ctrlr_x4 sw_ctrlr_x4_inst (
        .clk         (aclk        ),
        .resetn      (aresetn     ),
        .enable_irq  (enable_irq  ),
        .sw_mask     (sw_mask     ),
        .sw_event_ack(sw_event_ack),
        .sw_event    (sw_event    ),
        .sw_state    (sw_state    ),
        .irq         (IRQ         ),
        .SW          (sw_f        )
    );



    switch_ctrlr_x4_filter switch_ctrlr_x4_filter_inst (
        .clk   (aclk   ),
        .resetn(aresetn),
        .sw    (SW     ),
        .SW_F  (sw_f   )
    );


endmodule