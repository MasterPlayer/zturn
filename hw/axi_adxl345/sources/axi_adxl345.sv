// 0x00   0  DEVID          R    11100101  Device ID 
// 0x1D  29  THRESH_TAP     R/W  00000000  Tap threshold 
// 0x1E  30  OFSX           R/W  00000000  X-axis offset 
// 0x1F  31  OFSY           R/W  00000000  Y-axis offset 
// 0x20  32  OFSZ           R/W  00000000  Z-axis offset 
// 0x21  33  DUR            R/W  00000000  Tap duration 
// 0x22  34  LATENT         R/W  00000000  Tap latency 
// 0x23  35  WINDOW         R/W  00000000  Tap window 
// 0x24  36  THRESH_ACT     R/W  00000000  Activity threshold 
// 0x25  37  THRESH_INACT   R/W  00000000  Inactivity threshold 
// 0x26  38  TIME_INACT     R/W  00000000  Inactivity time 
// 0x27  39  ACT_INACT_CTL  R/W  00000000  Axis enable control for activity and inactivity detection 
// 0x28  40  THRESH_FF      R/W  00000000  Free-fall threshold 
// 0x29  41  TIME_FF        R/W  00000000  Free-fall time 
// 0x2A  42  TAP_AXES       R/W  00000000  Axis control for single tap/double tap 
// 0x2B  43  ACT_TAP_STATUS R    00000000  Source of single tap/double tap 
// 0x2C  44  BW_RATE        R/W  00001010  Data rate and power mode control 
// 0x2D  45  POWER_CTL      R/W  00000000  Power-saving features control 
// 0x2E  46  INT_ENABLE     R/W  00000000  Interrupt enable control 
// 0x2F  47  INT_MAP        R/W  00000000  Interrupt mapping control 
// 0x30  48  INT_SOURCE     R    00000010  Source of interrupts 
// 0x31  49  DATA_FORMAT    R/W  00000000  Data format control 
// 0x32  50  DATAX0         R    00000000  X-Axis Data 0 
// 0x33  51  DATAX1         R    00000000  X-Axis Data 1 
// 0x34  52  DATAY0         R    00000000  Y-Axis Data 0 
// 0x35  53  DATAY1         R    00000000  Y-Axis Data 1 
// 0x36  54  DATAZ0         R    00000000  Z-Axis Data 0 
// 0x37  55  DATAZ1         R    00000000  Z-Axis Data 1 
// 0x38  56  FIFO_CTL       R/W  00000000  FIFO control 
// 0x39  57  FIFO_STATUS    R    00000000  FIFO status 
// [31:24] [23:16] [15: 8] [ 7: 0]
//    0x03    0x02    0x01    0x00 
//    0x07    0x06    0x05    0x04 
//    0x0B    0x0A    0x09    0x08 
//    0x0F    0x0E    0x0D    0x0C 
//    0x13    0x12    0x11    0x10 
//    0x17    0x16    0x15    0x14 
//    0x1B    0x1A    0x19    0x18 
//    0x1F    0x1E    0x1D    0x1C 
//    0x23    0x22    0x21    0x20 
//    0x27    0x26    0x25    0x24 
//    0x2B    0x2A    0x29    0x28 
//    0x2F    0x2E    0x2D    0x2C 
//    0x33    0x32    0x31    0x30 
//    0x37    0x36    0x35    0x34 
//    0x3B    0x3A    0x39    0x38 
//    0x3F    0x3E    0x3D    0x3C 

`timescale 1 ns / 1 ps

module axi_adxl345 #(
    parameter DEFAULT_REQUEST_INTERVAL = 10000,
    parameter DEFAULT_BW_RATE          = 10   ,
    parameter DEFAULT_I2C_ADDRESS      = 8'hA6 
) (
    input                            aclk         ,
    input                            aresetn      ,
    input        [              5:0] awaddr       ,
    input        [              2:0] awprot       ,
    input                            awvalid      ,
    output logic                     awready      ,
    input        [             31:0] wdata        ,
    input        [              3:0] wstrb        ,
    input                            wvalid       ,
    output logic                     wready       ,
    output logic [              1:0] bresp        ,
    output logic                     bvalid       ,
    input                            bready       ,
    input        [              5:0] araddr       ,
    input        [              2:0] arprot       ,
    input                            arvalid      ,
    output logic                     arready      ,
    output logic [             31:0] rdata        ,
    output logic [              1:0] rresp        ,
    output logic                     rvalid       ,
    input                            rready        
);

    localparam integer ADDR_LSB = 2;
    localparam integer ADDR_OPT = 3;

    logic [15:0][3:0][7:0] register;


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
                    'h00 : rdata <= register[0];
                    'h01 : rdata <= register[1];
                    'h02 : rdata <= register[2];
                    'h03 : rdata <= register[3];
                    'h04 : rdata <= register[4];
                    'h05 : rdata <= register[5];
                    'h06 : rdata <= register[6];
                    'h07 : rdata <= register[7];
                    'h08 : rdata <= register[8];
                    'h09 : rdata <= register[9];
                    'h0A : rdata <= register[10];
                    'h0B : rdata <= register[11];
                    default : rdata <= rdata;
                endcase // araddr
    end 

    always_ff @(posedge aclk) begin : rresp_processing 
        if (!aresetn) 
            rresp <= '{default:0};
        else
            if (arvalid & arready & ~rvalid)
                case (araddr[(ADDR_OPT + ADDR_LSB) : ADDR_LSB])
                    'h00 : rresp <= '{default:0};
                    'h01 : rresp <= '{default:0};
                    'h02 : rresp <= '{default:0};
                    'h03 : rresp <= '{default:0};
                    'h04 : rresp <= '{default:0};
                    'h05 : rresp <= '{default:0};
                    'h06 : rresp <= '{default:0};
                    'h07 : rresp <= '{default:0};
                    'h08 : rresp <= '{default:0};
                    'h09 : rresp <= '{default:0};
                    'h0A : rresp <= '{default:0};
                    'h0B : rresp <= '{default:0};
                    default : rresp <= 'b10;
                endcase; // araddr
    end                     

    always_ff @(posedge aclk) begin : bresp_processing
        if (!aresetn)
            bresp <= '{default:0};
        else
            if (awvalid & awready & wvalid & wready & ~bvalid)
                if (awaddr[(ADDR_OPT + ADDR_LSB) : ADDR_LSB] >= 0 | awaddr[(ADDR_OPT + ADDR_LSB) : ADDR_LSB] <= 63 )
                    bresp <= '{default:0};
                else
                    bresp <= 'b10;
    end

    logic [3:0][7:0] wdata_signal;

    always_comb begin 
        wdata_signal <= wdata;
    end 

/*********************************** REGISTER ASSIGNMENT PART **********************************/
    generate
       
        for (genvar index = 0; index < 4; index++) begin : GEN_OFFT
            always_ff @(posedge aclk) begin : reg_0_processing
                if (!aresetn) 
                    register[0] <= '{default:0};
                else
                    if (awvalid & awready & wvalid & wready)
                        if (awaddr[(ADDR_OPT + ADDR_LSB) : ADDR_LSB] == 'h00) begin
                            if (wstrb[index])
                                register[0][index][7:0] <= wdata_signal[index][7:0];
                        end 
            end 
        end 
    
    endgenerate

/*************************************** FUNCTIONAL PART ***************************************/



endmodule