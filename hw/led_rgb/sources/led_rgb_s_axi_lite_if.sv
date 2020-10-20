`timescale 1 ns / 1 ps

module led_rgb_s_axi_lite_if (
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

    // connection signal group to user logic

    output logic             user_resetn              , // inverse reset signal 

    output logic             mode_r                    , // mode : 0 - const led on, 1 - led blinking
    output logic             mode_g                    , // mode : 0 - const led on, 1 - led blinking
    output logic             mode_b                    , // mode : 0 - const led on, 1 - led blinking

    output logic             enable_r                  , // enable led red
    output logic             enable_g                  , // enable led green
    output logic             enable_b                  , // enable led blue

    output logic             holded_r                  , // hold red led if enable is set to 0
    output logic             holded_g                  , // hold green led if enable is set to 0
    output logic             holded_b                  , // hold blue led if enable is set to 0

    output logic            [31:0] duration_r          , // interval over two blinks of led. 
    output logic            [31:0] duration_g          ,
    output logic            [31:0] duration_b          ,

    input                   LED_R_STS          , 
    input                   LED_G_STS          ,
    input                   LED_B_STS           

);

    localparam integer ADDR_LSB = 2;
    localparam integer ADDR_OPT = 2;

    logic [31:0]reg_0 = '{default:0};
    logic [31:0]reg_1 = '{default:0};
    logic [31:0]reg_2 = '{default:0};
    logic [31:0]reg_3 = '{default:0};
    logic [31:0]reg_4 = '{default:0};
    logic [31:0]reg_5 = '{default:0};
    logic [31:0]reg_6 = '{default:0};

    logic aw_en = 1'b1;


    always_comb begin : user_logic_assignment_group
        user_resetn <= reg_0[0];
        mode_r      <= reg_1[0];
        enable_r    <= reg_1[1];
        holded_r    <= reg_1[2];
        duration_r  <= reg_2;
        
        mode_g      <= reg_3[0];
        enable_g    <= reg_3[1];
        holded_g    <= reg_3[2];
        duration_g  <= reg_4;
        
        mode_b      <= reg_5[0];
        enable_b    <= reg_5[1];
        holded_b    <= reg_5[2];
        duration_b  <= reg_6;
    end 



    always_comb begin : from_user_logic_assignment 
        reg_0[1] <= LED_R_STS;
        reg_0[2] <= LED_G_STS;
        reg_0[3] <= LED_B_STS;
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
                    'h4 : rdata <= reg_4;
                    'h5 : rdata <= reg_5;
                    'h6 : rdata <= reg_6;
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
                    'h4 : rresp <= '{default:0};
                    'h5 : rresp <= '{default:0};
                    'h6 : rresp <= '{default:0};
                    default : rresp <= 'b10;
                endcase; // araddr
    end                     



    always_ff @(posedge aclk) begin : bresp_processing
        if (!aresetn)
            bresp <= '{default:0};
        else
            if (awvalid & awready & wvalid & wready & ~bvalid)
                if (awaddr >= 0 | awaddr <= 6 )
                    bresp <= '{default:0};
                else
                    bresp <= 'b10;
    end


    /*done*/
    always_ff @(posedge aclk) begin : reg_0_processing 
        if (!aresetn)
            reg_0 <= 'b0;
        else
            if (awvalid & awready & wvalid & wready)
                if (awaddr[(ADDR_OPT + ADDR_LSB) : ADDR_LSB] == 'h00)
                begin
                    reg_0[31:4] <= wdata[31:4];
                    reg_0[0] <= wdata[0];
                end 
        end 


    /*done*/
    always_ff @(posedge aclk) begin : reg_1_processing 
        if (!aresetn)
            reg_1 <= 'b0;
        else
            if (awvalid & awready & wvalid & wready)
                if (awaddr[(ADDR_OPT + ADDR_LSB) : ADDR_LSB] == 'h01)
                    reg_1[31:0] <= wdata[31:0];
        end 


    /*done*/
    always_ff @(posedge aclk) begin : reg_2_processing 
        if (!aresetn)
            reg_2 <= 'b0;
        else
            if (awvalid & awready & wvalid & wready)
                if (awaddr[(ADDR_OPT + ADDR_LSB) : ADDR_LSB] == 'h02)
                    reg_2 <= wdata;
        end 


    /*done*/
    always_ff @(posedge aclk) begin : reg_3_processing 
        if (!aresetn)
            reg_3 <= 'b0;
        else
            if (awvalid & awready & wvalid & wready)
                if (awaddr[(ADDR_OPT + ADDR_LSB) : ADDR_LSB] == 'h03)
                    reg_3 <= wdata;
        end 


    /*done*/
    always_ff @(posedge aclk) begin : reg_4_processing 
        if (!aresetn)
            reg_4 <= 'b0;
        else
            if (awvalid & awready & wvalid & wready)
                if (awaddr[(ADDR_OPT + ADDR_LSB) : ADDR_LSB] == 'h04)
                    reg_4 <= wdata;
        end 


    /*done*/
    always_ff @(posedge aclk) begin : reg_5_processing 
        if (!aresetn)
            reg_5 <= 'b0;
        else
            if (awvalid & awready & wvalid & wready)
                if (awaddr[(ADDR_OPT + ADDR_LSB) : ADDR_LSB] == 'h05)
                    reg_5 <= wdata;
        end 


    /*done*/
    always_ff @(posedge aclk) begin : reg_6_processing 
        if (!aresetn)
            reg_6 <= 'b0;
        else
            if (awvalid & awready & wvalid & wready)
                if (awaddr[(ADDR_OPT + ADDR_LSB) : ADDR_LSB] == 'h06)
                    reg_6 <= wdata;
        end 



endmodule
