`timescale 1 ns / 1 ps

module switch_ctrlr_x4_s_axi_lite_if (
    input               aclk,
    input               aresetn,
    input        [ 3:0] awaddr,
    input        [ 2:0] awprot,       // not used
    input               awvalid,
    output logic        awready,
    input        [31:0] wdata,
    input        [ 3:0] wstrb,        // not used
    input               wvalid,
    output logic        wready,
    output logic [ 1:0] bresp,
    output logic        bvalid,
    input               bready,
    input        [ 3:0] araddr,
    input        [ 2:0] arprot,
    input               arvalid,
    output logic        arready,
    output logic [31:0] rdata,
    output logic [ 1:0] rresp,
    output logic        rvalid,
    input               rready,

    output logic        enable_irq,

    output logic [ 3:0] sw_mask,
    output logic [ 3:0] sw_event_ack,
    input        [ 3:0] sw_event,
    input        [ 3:0] sw_state
);

    localparam integer ADDR_LSB = 2;
    localparam integer ADDR_OPT = 1;
    localparam integer REGISTER_CNT = 4;

    logic [31:0]reg_0 = '{default:0};
    logic [31:0]reg_1 = '{default:0};
    logic [31:0]reg_2 = '{default:0};
    logic [31:0]reg_3 = '{default:0};

    logic aw_en = 1'b1;


    always_comb begin : user_logic_assignment_group
        enable_irq      <= reg_0[0];
        sw_mask[3:0]    <= reg_2[3:0];
    end 

    always_comb begin : from_usr_logic_assignment_group 
        reg_1 [3:0] <= sw_state;
        reg_3 [3:0] <= sw_event[3:0];
    end 

    /**/
    always_ff @(posedge aclk) begin : aw_en_processing 
        if (!aresetn) 
            aw_en <= 1'b1;
        else
            if (!awready & awvalid & wvalid & aw_en)
                aw_en <= 1'b0;
            else
                if (bready & bvalid)
                    aw_en <= 1'b1;
    end 

    /**/
    always_ff @(posedge aclk) begin : awready_processing 
        if (!aresetn)
            awready <= 1'b0;
        else
            if (!awready & awvalid & wvalid & aw_en)
                awready <= 1'b1;
            else 
                awready <= 1'b0;
    end 



    always_ff @(posedge aclk) begin : wready_processing 
        if (!aresetn)
            wready <= 1'b0;
        else
            if (!wready & wvalid & awvalid & aw_en)
                wready <= 1'b1;
            else
                wready <= 1'b0;

    end 



    always_ff @(posedge aclk) begin : bvalid_processing
        if (!aresetn)
            bvalid <= 1'b0;
        else
            // if (awvalid & awready & wvalid & wready & ~bvalid)
            if (wvalid & wready & awvalid & awready & ~bvalid)
                bvalid <= 1'b1;
            else
                if (bvalid & bready)
                    bvalid <= 1'b0;

    end 



    always_ff @(posedge aclk) begin : arready_processing 
        if (!aresetn)
            arready <= 1'b0;
        else
            if (!arready & arvalid)
                arready <= 1'b1;
            else
                arready <= 1'b0;
            
    end



    always_ff @(posedge aclk) begin : rvalid_processing
        if (!aresetn)
            rvalid <= 1'b0;
        else
            if (arvalid & arready & ~rvalid)
                rvalid <= 1'b1;
            else 
                if (rvalid & rready)
                    rvalid <= 1'b0;

    end 


    always_ff @(posedge aclk) begin : rdata_processing 
        if (!aresetn)
            rdata <= '{default:0};
        else
            if (arvalid & arready & ~rvalid)
                case (araddr[(ADDR_OPT + ADDR_LSB) : ADDR_LSB]) 
                    'h0 : rdata <= reg_0;
                    'h1 : rdata <= reg_1;
                    'h2 : rdata <= reg_2;
                    'h3 : rdata <= reg_3;
                    default : rdata <= rdata;
                endcase // araddr
    end 



    always_ff @(posedge aclk) begin : rresp_processing 
        if (!aresetn) 
            rresp <= '{default:0};
        else
            if (arvalid & arready & ~rvalid)
                case (araddr[(ADDR_OPT + ADDR_LSB) : ADDR_LSB])
                    'h0 : rresp <= '{default:0};
                    'h1 : rresp <= '{default:0};
                    'h2 : rresp <= '{default:0};
                    'h3 : rresp <= '{default:0};
                    default : rresp <= 'b10;
                endcase; // araddr
    end                     



    always_ff @(posedge aclk) begin : bresp_processing
        if (!aresetn)
            bresp <= '{default:0};
        else
            if (awvalid & awready & wvalid & wready & ~bvalid)
                if (awaddr >= 0 | awaddr <= (REGISTER_CNT-1) )
                    bresp <= '{default:0};
                else
                    bresp <= 'b10;
    end


    /*done*/
    always_ff @(posedge aclk) begin : reg_0_processing 
        if (!aresetn)
        begin  
            reg_0[15:0] <= 'b0;
            reg_0[31:17] <= 'b0;
        end 

        else
            if (awvalid & awready & wvalid & wready)
                if (awaddr[(ADDR_OPT + ADDR_LSB) : ADDR_LSB] == 'h00)
                begin
                    reg_0[0] <= wdata[0];
                end 
        end 

    /*done*/
    always_ff @(posedge aclk) begin : reg_2_processing 
        if (!aresetn)
            reg_2 <= 'b0;
        else
            if (awvalid & awready & wvalid & wready)
                if (awaddr[(ADDR_OPT + ADDR_LSB) : ADDR_LSB] == 'h02)
                    reg_2[3:0] <= wdata[3:0];
        end 

    always_ff @(posedge aclk) begin : sw_event_ack_processing
        if (!aresetn) 
            sw_event_ack <= '{default:0};
        else
            if (awvalid & awready & wvalid & wready)
                if (awaddr[(ADDR_OPT + ADDR_LSB) : ADDR_LSB] == 'h03)
                    sw_event_ack[3:0] <= wdata[3:0];
                else
                    sw_event_ack[3:0] <= '{default:0};
            else
                sw_event_ack[3:0] <= '{default:0}; 
    end 

endmodule
