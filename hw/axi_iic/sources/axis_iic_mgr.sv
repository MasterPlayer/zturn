`timescale 1ns / 1ps


module axis_iic_mgr #(
    parameter                       N_BYTES        = 32
    ) (
    input                            clk          ,
    input                            resetn       ,
    input                            clk_i2c      ,
    input        [((N_BYTES*8)-1):0] s_axis_tdata ,
    input        [      N_BYTES-1:0] s_axis_tkeep ,
    input        [              7:0] s_axis_tuser ,
    input                            s_axis_tvalid,
    output                           s_axis_tready,
    input                            s_axis_tlast ,
    output logic [((N_BYTES*8)-1):0] m_axis_tdata ,
    output logic [      N_BYTES-1:0] m_axis_tkeep ,
    output logic                     m_axis_tvalid,
    input                            m_axis_tready,
    output logic                     m_axis_tlast ,

    input                            SCL_I        ,
    input                            SDA_I        ,
    output logic                     SCL_T        ,
    output logic                     SDA_T        
);

    logic reset ;


    logic [0:0] cmd_din   = 1'b1;
    logic       cmd_wren  = 1'b0;
    logic       cmd_full        ;
    logic [0:0] cmd_dout        ;
    logic       cmd_rden  = 1'b0;
    logic       cmd_empty       ;

    logic [(N_BYTES*8)-1:0] in_dout_data       ;
    logic [    N_BYTES-1:0] in_dout_keep       ;
    logic [            7:0] in_dout_user       ;
    logic                   in_dout_last       ;
    logic                   in_rden      = 1'b0;
    logic                   in_empty           ;

    typedef enum {
        IDLE_ST                 ,
        START_TRANSMISSION_ST   ,
        TX_ADDR                 ,
        WAIT_ACK    
    } fsm;

    fsm current_state = IDLE_ST;

    logic[$clog2(N_BYTES*8)-1:0] bit_cnt = '{default : 0};


    always_ff @(posedge clk_i2c) begin : current_state_processing 
        if (reset) 
            current_state <= IDLE_ST;
        else
            case (current_state)
                IDLE_ST : 
                    if (!cmd_empty)
                        current_state <= START_TRANSMISSION_ST;

                START_TRANSMISSION_ST : 
                    current_state <= TX_ADDR;


                TX_ADDR :
                    if (bit_cnt == 0)
                        current_state <= WAIT_ACK;


                WAIT_ACK : 
                    current_state <= current_state;


            endcase

    end 

    always_ff @(posedge clk_i2c) begin : bit_cnt_processing 
        case (current_state) 

            TX_ADDR : 
                if (bit_cnt != 0)
                    bit_cnt <= bit_cnt - 1;

            default :
                bit_cnt <= 7;
        endcase // current_state
    end 


    always_comb begin : cmd_fifo_assign
        
        cmd_din <= 1'b1;
        cmd_wren <= s_axis_tvalid & s_axis_tlast;
        reset        <= !resetn;

    end 

    always_ff @(posedge clk_i2c) begin : iic_signal_definition 
        case (current_state) 
            IDLE_ST : 
                if (!cmd_empty)
                    // SDA_I <= 1'b0;
                    SDA_T <= 1'b0;
                else
                    // SDA_I <= 1'b1;
                    SDA_T <= 1'b1;

            START_TRANSMISSION_ST : 
                SDA_T <= 1'b0;

            TX_ADDR : 
                // SDA_I <= in_dout_user[bit_cnt];
                SDA_T <= in_dout_user[bit_cnt];

            default : 
                SDA_T <= 1'b1;
        endcase

    end 

    always_comb begin: iic_scl_processing 
        case (current_state) 
            IDLE_ST : 
                SCL_T <= 1'b1;

            START_TRANSMISSION_ST : 
                SCL_T <= 1'b1;

            TX_ADDR : 
                SCL_T <= clk_i2c;

            default :
                SCL_T <= 1'b1;

        endcase // current_state
    end 


    fifo_cmd_async_xpm #(
        .DATA_WIDTH(1            ),
        .CDC_SYNC  (4            ),
        .MEMTYPE   ("distributed"),
        .DEPTH     (16           )
    ) fifo_cmd_async_xpm_inst (
        .CLK_WR  (clk      ),
        .RESET_WR(reset    ),
        .CLK_RD  (clk_i2c  ),
        
        .DIN     (cmd_din  ),
        .WREN    (cmd_wren ),
        .FULL    (cmd_full ),
        .DOUT    (cmd_dout ),
        .RDEN    (cmd_rden ),
        .EMPTY   (cmd_empty)
    );



    fifo_in_async_user_xpm #(
        .CDC_SYNC  (4            ),
        .DATA_WIDTH(N_BYTES*8    ),
        .USER_WIDTH(8            ),
        .MEMTYPE   ("distributed"),
        .DEPTH     (16           )
    ) fifo_in_async_user_xpm_inst (
        .S_AXIS_CLK   (clk          ),
        .S_AXIS_RESET (reset        ),
        .M_AXIS_CLK   (clk_i2c      ),
        
        .S_AXIS_TDATA (s_axis_tdata ),
        .S_AXIS_TKEEP (s_axis_tkeep ),
        .S_AXIS_TUSER (s_axis_tuser ),
        .S_AXIS_TVALID(s_axis_tvalid),
        .S_AXIS_TREADY(s_axis_tready),
        .S_AXIS_TLAST (s_axis_tlast ),
        
        .IN_DOUT_DATA (in_dout_data ),
        .IN_DOUT_KEEP (in_dout_keep ),
        .IN_DOUT_USER (in_dout_user ),
        .IN_DOUT_LAST (in_dout_last ),
        .IN_RDEN      (in_rden      ),
        .IN_EMPTY     (in_empty     )
    );


endmodule : axis_iic_mgr
