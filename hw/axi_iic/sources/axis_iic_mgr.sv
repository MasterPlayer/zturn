`timescale 1ns / 1ps


module axis_iic_mgr #(
    parameter CLK_PERIOD     = 100000000,
    parameter CLK_I2C_PERIOD = 400000   ,
    parameter N_BYTES        = 32
) (
    input  logic                     clk              ,
    input  logic                     resetn           ,
    input  logic [             15:0] s_axis_cmd_tdata , // user presented as [15:8] - size in bytes, [7:1] - address, [0] - operation(read/!write)
    input  logic                     s_axis_cmd_tvalid,
    output logic                     s_axis_cmd_tready,
    input  logic [((N_BYTES*8)-1):0] s_axis_tdata     ,
    input  logic [      N_BYTES-1:0] s_axis_tkeep     ,
    input  logic                     s_axis_tvalid    ,
    output logic                     s_axis_tready    ,
    input  logic                     s_axis_tlast     ,
    output logic [((N_BYTES*8)-1):0] m_axis_tdata     ,
    output logic [      N_BYTES-1:0] m_axis_tkeep     ,
    output logic                     m_axis_tvalid    ,
    input  logic                     m_axis_tready    ,
    output logic                     m_axis_tlast     ,
    input  logic                     scl_i            ,
    input  logic                     sda_i            ,
    output logic                     scl_t            ,
    output logic                     sda_t
);



    localparam DIVIDER = (CLK_PERIOD/CLK_I2C_PERIOD); 
    localparam EVENT_PERIOD = (DIVIDER/4);


    logic reset ;

    always_comb begin : reset_assign_process
        reset <= !resetn;
    end 

    logic [(N_BYTES*8)-1:0] in_dout_data       ;
    logic [(N_BYTES*8)-1:0] in_dout_data_shft = '{default:0}  ;
    logic [    N_BYTES-1:0] in_dout_keep       ;
    logic [    N_BYTES-1:0] in_dout_keep_shft = '{default:0}  ;

    logic                   in_dout_last       ;
    logic                   in_dout_last_latched = 1'b0       ;
    logic                   in_rden      = 1'b0;
    logic                   d_in_rden      = 1'b0;
    logic                   in_empty           ;


    logic [(N_BYTES*8)-1:0] out_din_data  = '{default:0}  ;
    logic [(N_BYTES)-1:0]   out_din_keep  = '{default:0}  ;
    logic                   out_din_last  = 1'b0;
    logic                   out_wren      = 1'b0;
    logic                   out_full      ;
    logic                   out_awfull    ;


    typedef enum {
        IDLE_ST                 ,
        START_TRANSMISSION_ST   ,
        STOP_TRANSMISSION_ST    ,
        TX_ADDR_ST              ,

        WAIT_ACK_ST             ,
        READ_ST                 ,
        WAIT_RD_ACK_ST          ,
        WRITE_ST                ,
        WAIT_WR_ACK_ST          ,
        RD_STOP_ST               
    } fsm;

    fsm current_state = IDLE_ST;

    logic [$clog2(N_BYTES*8)-1:0] bit_cnt       = '{default : 0};
    logic [  $clog2(N_BYTES)-1:0] word_byte_cnt = '{default:0}  ;

    logic [7:0] rd_byte_reg = '{default:0};

    (* dont_touch = "true" *)logic i2c_clk = 1'b0          ;
    (* dont_touch = "true" *)logic bus_i2c_clk = 1'b0;

    logic                     i2c_clk_assertion   = 1'b0        ;
    logic                     i2c_clk_deassertion = 1'b0        ;
    logic [($clog2(DIVIDER))-1:0] divider_counter     = '{default:0};

    logic has_slave_ack = 1'b0;

    logic [15:0] cmd_din         ;
    logic        cmd_wren        ;
    logic        cmd_full        ;
    logic [15:0] cmd_dout        ;
    logic        cmd_rden  = 1'b0;
    logic        cmd_empty       ;

    /**/
    always_comb begin : cmd_assertion 
        cmd_din <= s_axis_cmd_tdata;
        cmd_wren <= s_axis_cmd_tvalid & !cmd_full;
        s_axis_cmd_tready <= !(cmd_full);
    end 

    fifo_cmd_sync_xpm #(
        .DATA_WIDTH(16           ),
        .MEMTYPE   ("distributed"),
        .DEPTH     (16           )
    ) fifo_cmd_sync_xpm_inst (
        .CLK  (clk             ),
        .RESET(reset           ),
        .DIN  (cmd_din         ),
        .WREN (cmd_wren        ),
        .FULL (cmd_full        ),
        .DOUT (cmd_dout        ),
        .RDEN (cmd_rden        ),
        .EMPTY(cmd_empty       )
    );


    always_ff @(posedge clk) begin : cmd_rden_processing
        if (reset)
            cmd_rden <= 1'b0;
        else
            if (i2c_clk_assertion)
                case (current_state)
                        STOP_TRANSMISSION_ST :
                            cmd_rden <= 1'b1;

                        default : 
                            cmd_rden <= 1'b0;
                endcase
            else
                cmd_rden <= 1'b0;
    end                     


    /* clock divider counter for division input clock*/
    always_ff @(posedge clk) begin : divider_counter_processing 
        if (divider_counter < (DIVIDER-1))
            divider_counter <= divider_counter + 1;
        else
            divider_counter <= '{default:0};
    end 

    /*clock for i2c logic for data on bus*/
    always_ff @(posedge clk) begin : i2c_clk_processing 
        if (divider_counter == (EVENT_PERIOD-1))
            i2c_clk <= 1'b1;
        else if (divider_counter == (EVENT_PERIOD*3))
            i2c_clk <= 1'b0;
    end 

    /*assertion event flaq for i2c_clk*/
    always_ff @(posedge clk) begin : i2c_clk_assertion_processing 
        if (divider_counter == EVENT_PERIOD-1)
            i2c_clk_assertion <= 1'b1;
        else
            i2c_clk_assertion <= 1'b0;
    end 

    /*deassertion event flaq for i2c_clk*/
    always_ff @(posedge clk) begin : i2c_clk_deassertion_processing 
        if (divider_counter == (EVENT_PERIOD*3)-1)
            i2c_clk_deassertion <= 1'b1;
        else
            i2c_clk_deassertion <= 1'b0;
    end 

    /*for i2c bus signal*/
    always_ff @(posedge clk) begin : bus_i2c_clk_processing 
        if (divider_counter == (EVENT_PERIOD * 2))
            bus_i2c_clk <= 1'b1;
        else if (divider_counter == DIVIDER-1)
            bus_i2c_clk <= 1'b0;
    end 

    /*fsm
    * All transmissions over states must be sets according with i2c_clk_assertion 
    * in other case fsm must wait asserion this signal
    */
    always_ff @(posedge clk) begin : fsm_processing
        if (reset)
            current_state <= IDLE_ST;
        else
            if (i2c_clk_assertion)
                case (current_state)
                    IDLE_ST : 
                        if (!cmd_empty)
                            if (!cmd_dout[0]) begin 
                                if (!in_empty)
                                    // if commanq queue isnt empty and data queue isnt empty and cmd = WRITE
                                    current_state <= START_TRANSMISSION_ST;
                            end else
                                // perform reading operation
                                current_state <= START_TRANSMISSION_ST;

                    /*establish START for I2C transaction*/
                    START_TRANSMISSION_ST : 
                        current_state <= TX_ADDR_ST;

                    /*Transmission address + command operation*/
                    TX_ADDR_ST : 
                        if (bit_cnt == 0)
                            // current_state <= IDLE_ST;
                            current_state <= WAIT_ACK_ST;

                    /*transmit STOP flaq on i2c bus*/
                    STOP_TRANSMISSION_ST : 
                        current_state <= IDLE_ST;

                    /*WAIT ACK signal from slave after WRITE ADDRESS operation*/
                    /*ACK = '0' from slave on SDA bus */
                    /*if no ACK then exit*/
                    /*NO_ACK = line SDA is '1' state*/
                    WAIT_ACK_ST :
                        if (has_slave_ack) 
                            if (cmd_dout[0])
                                current_state <= READ_ST; // go to reading data from slave device
                            else
                                current_state <= WRITE_ST; // go to write data to slave
                        else
                            current_state <= STOP_TRANSMISSION_ST; // abort transaction, maybe i must signalize about this event and release input fifo for 1 packet, if i sending data to slave

                    READ_ST : 
                        if (bit_cnt == 0)
                            current_state <= WAIT_RD_ACK_ST;

                    WAIT_RD_ACK_ST :
                        if (!rd_byte_reg)
                            current_state <= STOP_TRANSMISSION_ST;
                        else
                            current_state <= READ_ST;

                    WRITE_ST : 
                        if (bit_cnt == 0)
                            current_state <= WAIT_WR_ACK_ST;

                    WAIT_WR_ACK_ST : 
                        if (has_slave_ack)
                            if (!in_dout_keep_shft[0])
                                if (in_dout_last_latched)
                                    current_state <= STOP_TRANSMISSION_ST;
                                else
                                    current_state <= WRITE_ST;
                            else
                                current_state <= WRITE_ST;
                        else
                            current_state <= STOP_TRANSMISSION_ST;


                    RD_STOP_ST : 
                        current_state <= IDLE_ST;

                    default:
                        current_state <= IDLE_ST; 

                endcase

    end 

    always_ff @(posedge clk) begin : sda_t_processing 
        if (reset) 
            sda_t <= 1'b1;
        else
            if (i2c_clk_assertion)
                case (current_state)
                    IDLE_ST : 
                        if (!cmd_empty)
                            if (!cmd_dout[0]) begin 
                                if (!in_empty)
                                    sda_t <= 1'b0;
                            end else
                                sda_t <= 1'b0;

                    START_TRANSMISSION_ST :
                        sda_t <= cmd_dout[bit_cnt];

                    STOP_TRANSMISSION_ST : 
                        sda_t <= 1'b1;

                    TX_ADDR_ST : 
                        if (bit_cnt)
                            sda_t <= cmd_dout[bit_cnt-1];
                        else
                            sda_t <= 1'b1;

                    WAIT_ACK_ST :
                        if (has_slave_ack) // if device presented
                            if (!cmd_dout[0]) // if op = WRITE
                                sda_t <= in_dout_data[bit_cnt];    
                            else
                                sda_t <= 1'b1; // for write operation

                    WRITE_ST : 
                        if (bit_cnt != 0)
                            sda_t <= in_dout_data_shft[bit_cnt-1];
                        else
                            sda_t <= 1'b1;

                    WAIT_WR_ACK_ST : 
                        if (has_slave_ack)
                            if (!in_dout_keep_shft[0])
                                if (in_dout_last_latched)
                                    sda_t <= 1'b0;
                                else
                                    sda_t <= in_dout_data_shft[bit_cnt];
                            else
                                sda_t <= in_dout_data_shft[bit_cnt];
                        else
                            sda_t <= 1'b0;

                    READ_ST : 
                        if (bit_cnt)
                            sda_t <= 1'b1;
                        else
                            if (rd_byte_reg == 1)
                                sda_t <= 1'b1;
                            else
                                sda_t <= 1'b0;

                    WAIT_RD_ACK_ST:
                        if (rd_byte_reg == 0)
                            sda_t <= 1'b0;
                        else
                            sda_t <= 1'b1;

                    default : 
                        sda_t <= 1'b1;

                endcase
    end 

    always_ff @(posedge clk) begin : scl_t_processing 
        case (current_state)
            START_TRANSMISSION_ST : 
                /*START transaction on I2C bus must be started if i2c clk deasserted*/
                if (i2c_clk_deassertion) 
                    scl_t <= 1'b0;

            /*Transmit STOP state : SCL must be asserted if deassert i2c clk*/
            STOP_TRANSMISSION_ST : 
                if (i2c_clk_deassertion)
                    scl_t <= 1'b1;


            TX_ADDR_ST : 
                scl_t <= bus_i2c_clk;

            WAIT_ACK_ST : 
                scl_t <= bus_i2c_clk;

            WRITE_ST : 
                scl_t <= bus_i2c_clk;

            WAIT_WR_ACK_ST :
                scl_t <= bus_i2c_clk;

            READ_ST :
                scl_t <= bus_i2c_clk;


            WAIT_RD_ACK_ST :
                scl_t <= bus_i2c_clk;

            RD_STOP_ST : 
                if (i2c_clk_deassertion)
                    scl_t <= 1'b1;

            default : 
                scl_t <= 1'b1;

            endcase 
    end  



    always_ff @(posedge clk) begin : has_slave_ack_processing 
        if (reset)
            has_slave_ack <= 1'b0;
        else
            case (current_state)
                WAIT_ACK_ST : 
                    if (scl_i)
                        if (!sda_i)
                            has_slave_ack <= 1'b1;
                        else
                            has_slave_ack <= 1'b0;
                
                WAIT_WR_ACK_ST :
                    if (scl_i) 
                        if (!sda_i) 
                            has_slave_ack <= 1'b1;
                        else
                            has_slave_ack <= 1'b0;


                default : 
                    has_slave_ack <= 1'b0;

            endcase // current_state
    end



    always_ff @(posedge clk) begin : bit_cnt_processing 
        if (reset) 
            bit_cnt <= 'h7;
        else
            if (i2c_clk_assertion)
                case (current_state)

                    IDLE_ST : 
                        bit_cnt <= 7;
                    
                    TX_ADDR_ST :
                        if (bit_cnt != 0)
                            bit_cnt <= bit_cnt - 1;
                        else
                            bit_cnt <= 7;

                    WRITE_ST : 
                        if (bit_cnt != 0)
                            bit_cnt <= bit_cnt - 1;
                        else
                            bit_cnt <= 7;

                    READ_ST : 
                        if (bit_cnt != 0)
                            bit_cnt <= bit_cnt - 1;
                        else
                            bit_cnt <= 7;

                    default : 
                        bit_cnt <= bit_cnt;

                endcase
    end 



    always_ff @(posedge clk) begin : in_dout_data_shft_processing 
        case (current_state)
            IDLE_ST : 
                in_dout_data_shft <= in_dout_data; // assertion shifting register

            WRITE_ST : 
                if (bit_cnt == 0) 
                    if (i2c_clk_assertion)
                        in_dout_data_shft[((N_BYTES-1)*8)-1:0] <= in_dout_data_shft[(N_BYTES*8)-1:8];

            WAIT_WR_ACK_ST : 
                if (d_in_rden)
                    in_dout_data_shft <= in_dout_data;

            default : 
                in_dout_data_shft <= in_dout_data_shft;

        endcase // current_state
    end 



    always_ff @(posedge clk) begin : in_dout_keep_shft_processing 
        case (current_state) 
            IDLE_ST : 
                 // in_dout_keep_shft[N_BYTES-1 : 0] <= {1'b0 , in_dout_keep[N_BYTES-1:1]};
                 in_dout_keep_shft <= in_dout_keep;

            WRITE_ST : 
                if (bit_cnt == 0) 
                    if (i2c_clk_assertion)
                        in_dout_keep_shft[N_BYTES-1 : 0] <= {1'b0 , in_dout_keep_shft[N_BYTES-1:1]};


            WAIT_WR_ACK_ST : 
                if (d_in_rden)
                    if (!in_dout_last_latched)
                        in_dout_keep_shft <= in_dout_keep;


            default : 
                in_dout_keep_shft <= in_dout_keep_shft;

            endcase
    end 


    /*Переделать, надо брать команды откуда-то извне, а не с шины данных*/
    always_ff @(posedge clk) begin : rd_byte_reg_processing 
        if (i2c_clk_assertion)
            case (current_state)
                WAIT_ACK_ST : 
                    rd_byte_reg <= cmd_dout[15:8];

                READ_ST : 
                    if (bit_cnt == 0)
                        rd_byte_reg <= rd_byte_reg - 1;

                default : 
                    rd_byte_reg <= rd_byte_reg;

            endcase 
    end 



    fifo_in_sync_xpm #(
        .DATA_WIDTH((N_BYTES*8)  ),
        .MEMTYPE   ("distributed"),
        .DEPTH     (16           )
    ) fifo_in_sync_xpm_inst (
        .CLK          (clk          ),
        .RESET        (reset        ),
        
        .S_AXIS_TDATA (s_axis_tdata ),
        .S_AXIS_TKEEP (s_axis_tkeep ),
        .S_AXIS_TVALID(s_axis_tvalid),
        .S_AXIS_TLAST (s_axis_tlast ),
        .S_AXIS_TREADY(s_axis_tready),
        
        .IN_DOUT_DATA (in_dout_data ),
        .IN_DOUT_KEEP (in_dout_keep ),
        .IN_DOUT_LAST (in_dout_last ),
        .IN_RDEN      (in_rden      ),
        .IN_EMPTY     (in_empty     )
    );



    always_ff @(posedge clk) begin : in_dout_last_latched_processing 
        if (i2c_clk_assertion)
            case (current_state) 

                IDLE_ST : 
                    in_dout_last_latched <= in_dout_last;

                WAIT_WR_ACK_ST : 
                    if (has_slave_ack)
                        in_dout_last_latched <= in_dout_last;

                default : 
                    in_dout_last_latched <= in_dout_last_latched;

            endcase
    end 



    always_comb begin : in_rden_assertion 
        case (current_state) 
            WAIT_WR_ACK_ST : 
                if (!in_dout_keep_shft[0] & i2c_clk_deassertion)
                    in_rden <= 1'b1;
                else
                    in_rden <= 1'b0;
            default : in_rden <= 1'b0;
        endcase
    end 



    /*for correct reading from input fifo we must delay in_rden signal for assign in_dout_data_shft, in_dout_keep_shft*/
    always_ff @(posedge clk) begin : d_in_rden_processing 
        d_in_rden <= in_rden;
    end 


    fifo_out_sync_xpm #(
        .DATA_WIDTH((N_BYTES*8)),
        .MEMTYPE   ("distributed"  ),
        .DEPTH     (16       )
    ) fifo_out_sync_xpm_inst (
        .CLK          (clk          ),
        .RESET        (reset        ),

        .OUT_DIN_DATA (out_din_data ),
        .OUT_DIN_KEEP (out_din_keep ),
        .OUT_DIN_LAST (out_din_last ),
        .OUT_WREN     (out_wren     ),
        .OUT_FULL     (out_full     ),
        .OUT_AWFULL   (out_awfull   ),
        
        .M_AXIS_TDATA (m_axis_tdata ),
        .M_AXIS_TKEEP (m_axis_tkeep ),
        .M_AXIS_TVALID(m_axis_tvalid),
        .M_AXIS_TLAST (m_axis_tlast ),
        .M_AXIS_TREADY(m_axis_tready)
    );

    always_ff @(posedge clk) begin : word_byte_cnt_processing
        if (reset)
            word_byte_cnt <= '{default:0};
        else
            if (i2c_clk_assertion)
                case (current_state)                    
                    WAIT_RD_ACK_ST : 
                        if (word_byte_cnt < N_BYTES-1)
                            word_byte_cnt <= word_byte_cnt + 1;
                        else
                            word_byte_cnt <= '{default:0};
                    
                    default : 
                        word_byte_cnt <= word_byte_cnt;
                
                endcase
    end  

    always_ff @(posedge clk) begin : out_din_data_processing 
        if (reset)
            out_din_data <= '{default:0};
        else
            if (i2c_clk_deassertion) 
                case (current_state)
                    READ_ST : 
                        out_din_data <= {out_din_data[(N_BYTES*8)-2:0], sda_i};

                    default  : 
                        out_din_data <= out_din_data;

                endcase
    end 

    always_ff @(posedge clk) begin : out_din_keep_processing 
        if (reset) 
            out_din_keep <= '{default:0};
        else
            if (i2c_clk_assertion)
                case (current_state)
                    READ_ST : 
                        if (bit_cnt == 0)
                            out_din_keep <= {out_din_keep[N_BYTES-2:0], 1'b1};

                    default : 
                        out_din_keep <= out_din_keep;

                endcase 
    end 

    always_ff @(posedge clk) begin : out_din_last_processing 
        if (reset)
            out_din_last <= 1'b0;
        else
            if (i2c_clk_assertion) 
                case (current_state)
                    WAIT_RD_ACK_ST : 
                        if (!rd_byte_reg)
                            out_din_last <= 1'b1;
                        else
                            out_din_last <= 1'b0;

                    default : 
                        out_din_last <= out_din_last;

                endcase
    end 

    always_ff @(posedge clk) begin : out_wren_processing 
        if (reset)
            out_wren <= 1'b0;
        else
            if (i2c_clk_assertion)
                case (current_state)
                    WAIT_RD_ACK_ST : 
                        if (!rd_byte_reg)
                            out_wren <= 1'b1;
                        else    
                            if (word_byte_cnt == N_BYTES-1)
                                out_wren <= 1'b1;
                            else
                                out_wren <= 1'b0;
                    
                    default :
                        out_wren <= 1'b0;
                
                endcase

            else
                out_wren <= 1'b0;
    end 




endmodule : axis_iic_mgr
