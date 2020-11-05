`timescale 1ns / 1ps


module axis_iic_mgr #(
    parameter CLK_PERIOD     = 100000000,
    parameter CLK_I2C_PERIOD = 400000   ,
    parameter N_BYTES        = 32
) (
    input                            clk              ,
    input                            resetn           ,
    
    input        [             15:0] s_axis_cmd_tdata , // user presented as [15:8] - size in bytes, [7:1] - address, [0] - operation(read/!write)
    input                            s_axis_cmd_tvalid,
    output logic                     s_axis_cmd_tready,

    input        [((N_BYTES*8)-1):0] s_axis_tdata     ,
    input        [      N_BYTES-1:0] s_axis_tkeep     ,
    // input        [             15:0] s_axis_tuser     , // user presented as [15:8] - size in bytes, [7:1] - address, [0] - operation(read/!write)
    input                            s_axis_tvalid    ,
    output                           s_axis_tready    ,
    input                            s_axis_tlast     ,
    output logic [((N_BYTES*8)-1):0] m_axis_tdata     ,
    output logic [      N_BYTES-1:0] m_axis_tkeep     ,
    output logic                     m_axis_tvalid    ,
    input                            m_axis_tready    ,
    output logic                     m_axis_tlast     ,
    input                            SCL_I            ,
    input                            SDA_I            ,
    output logic                     SCL_T            ,
    output logic                     SDA_T
);

    logic reset ;

    always_comb begin : reset_assign_process
        reset <= !resetn;
    end 

    logic [(N_BYTES*8)-1:0] in_dout_data       ;
    logic [(N_BYTES*8)-1:0] in_dout_data_shft = '{default:0}  ;
    logic [    N_BYTES-1:0] in_dout_keep       ;
    logic [    N_BYTES-1:0] in_dout_keep_shft = '{default:0}  ;
    // logic [           15:0] in_dout_user       ;
    logic                   in_dout_last       ;
    logic                   in_rden      = 1'b0;
    logic                   in_empty           ;

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
        RD_STOP_ST              ,

        STUB_ST                 
    } fsm;

    fsm current_state = IDLE_ST;

    logic [((N_BYTES*8)-1):0 ] data_rx = {default:0};

    logic[$clog2(N_BYTES*8)-1:0] bit_cnt = '{default : 0};
    logic[7:0] rd_byte_reg = '{default:0};


    parameter DIVIDER = CLK_PERIOD/CLK_I2C_PERIOD; 
    parameter EVENT_PERIOD = DIVIDER/4;

    logic i2c_clk = 1'b0;
    logic bus_i2c_clk = 1'b0;

    logic i2c_clk_assertion = 1'b0;
    logic i2c_clk_deassertion = 1'b0;
    logic[$clog2(DIVIDER)-1 : 0] divider_counter = '{default:0};


    logic[15:0]cmd_din  ;
    logic cmd_wren;
    logic cmd_full;
    logic[15:0]cmd_dout ;
    logic cmd_rden = 1'b0;
    logic cmd_empty;

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
        .DIN  (s_axis_cmd_tdata),
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
        if (divider_counter < DIVIDER-1)
            divider_counter <= divider_counter + 1;
        else
            divider_counter <= '{default:0};
    end 

    /*clock for i2c logic for data on bus*/
    always_ff @(posedge clk) begin : i2c_clk_processing 
        if (divider_counter == EVENT_PERIOD-1)
            i2c_clk <= 1'b1;
        else if (divider_counter == EVENT_PERIOD*3)
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
                            current_state <= IDLE_ST;
                            // current_state <= WAIT_ACK_ST;

                    /*transmit STOP flaq on i2c bus*/
                    STOP_TRANSMISSION_ST : 
                        current_state <= IDLE_ST;

                    /*WAIT ACK signal from slave after WRITE ADDRESS operation*/
                    /*ACK = '0' from slave on SDA bus */
                    /*if no ACK then exit*/
                    WAIT_ACK_ST :
                        current_state <= STUB_ST;
                        // if (cmd_dout[0])
                        //     current_state <= READ_ST;
                        // else
                        //     current_state <= WRITE_ST;

                    READ_ST : 
                        if (bit_cnt == 0)
                            current_state <= WAIT_RD_ACK_ST;

                    WAIT_RD_ACK_ST :
                        if (!rd_byte_reg)
                            current_state <= RD_STOP_ST;
                        else
                            current_state <= READ_ST;

                    WRITE_ST : 
                        if (bit_cnt == 0)
                            current_state <= WAIT_WR_ACK_ST;

                    WAIT_WR_ACK_ST : 
                        if (in_dout_keep_shft[0])
                            if (in_dout_last)
                                current_state <= IDLE_ST;
                            else
                                current_state <= WRITE_ST;
                        else
                            current_state <= WRITE_ST;

                    RD_STOP_ST : 
                        current_state <= IDLE_ST;

                    default:
                        current_state <= STUB_ST; 

                endcase

    end 

    always_ff @(posedge clk) begin : SDA_T_processing 
        if (reset) 
            SDA_T <= 1'b1;
        else
            if (i2c_clk_assertion)
                case (current_state)
                    IDLE_ST : 
                        if (!cmd_empty)
                            if (!cmd_dout[0]) begin 
                                if (!in_empty)
                                    SDA_T <= 1'b0;
                            end else
                                SDA_T <= 1'b0;
                    // IDLE_ST : 
                    //     if (!cmd_empty)
                    //         SDA_T <= 1'b0;


                    START_TRANSMISSION_ST :
                        SDA_T <= cmd_dout[bit_cnt];

                    STOP_TRANSMISSION_ST : 
                        SDA_T <= 1'b1;

                    TX_ADDR_ST : 
                        if (bit_cnt)
                            SDA_T <= cmd_dout[bit_cnt-1];
                        else
                            SDA_T <= 1'b1;

                    WAIT_ACK_ST :
                        SDA_T <= 1'b1;

                    WRITE_ST : 
                        if (bit_cnt != 0)
                            SDA_T <= in_dout_data_shft[bit_cnt];
                        else
                            SDA_T <= 1'b1;

                    READ_ST : 
                        if (bit_cnt != 0)
                            SDA_T <= 1'b1;
                        else
                            SDA_T <= 1'b0;

                    WAIT_RD_ACK_ST:
                        SDA_T <= 1'b1; 

                    default : 
                        SDA_T <= 1'b1;

                endcase
    end 

    always_ff @(posedge clk) begin : SCL_T_processing 
        case (current_state)
            START_TRANSMISSION_ST : 
                /*START transaction on I2C bus must be started if i2c clk deasserted*/
                if (i2c_clk_deassertion) 
                    SCL_T <= 1'b0;

            /*Transmit STOP state : SCL must be asserted if deassert i2c clk*/
            STOP_TRANSMISSION_ST : 
                if (i2c_clk_deassertion)
                    SCL_T <= 1'b1;


            TX_ADDR_ST : 
                SCL_T <= bus_i2c_clk;

            WAIT_ACK_ST : 
                SCL_T <= bus_i2c_clk;

            STUB_ST: 
                SCL_T <= 1'b0;

            WRITE_ST : 
                SCL_T <= bus_i2c_clk;

            WAIT_WR_ACK_ST :
                if (in_dout_keep_shft[0])
                    SCL_T <= bus_i2c_clk;
                else
                    if (bus_i2c_clk) 
                        SCL_T <= 1'b1;
                    else
                        SCL_T <= SCL_T;

            READ_ST :
                SCL_T <= bus_i2c_clk;


            WAIT_RD_ACK_ST :
                SCL_T <= bus_i2c_clk;

            RD_STOP_ST : 
                if (i2c_clk_deassertion)
                    SCL_T <= 1'b1;

            default : 
                SCL_T <= 1'b1;

            endcase 
    end  

    always_ff @(posedge clk) begin : data_rx_processing 
        if (reset) 
            data_rx <= '{default:0};
        else
            if (i2c_clk_deassertion)
                case (current_state) 
                    READ_ST :
                        data_rx <= {data_rx[(N_BYTES*8)-2:0], SDA_I};
                    
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

                    // WRITE_ST : 
                    //     if (bit_cnt != 0) 
                    //         bit_cnt <= bit_cnt - 1;
                    //     else
                    //         bit_cnt <= 7;

                    // READ_ST : 
                    //     if (bit_cnt != 0)
                    //         bit_cnt <= bit_cnt - 1;
                    //     else
                    //         bit_cnt <= 7;


                endcase
    end 

    always_ff @(posedge clk) begin : in_dout_data_shft_processing 
        if (i2c_clk_assertion)
            case (current_state) 
                IDLE_ST : 
                    in_dout_data_shft <= in_dout_data;

                WRITE_ST : 
                    if (bit_cnt == 0)
                        in_dout_data_shft[((N_BYTES-1)*8)-1:0] <= in_dout_data_shft[(N_BYTES*8)-1:8];

            endcase // current_state
    end 

    /**/
    always_ff @(posedge clk) begin : in_dout_keep_shft_processing 
        if (i2c_clk_assertion)
            case (current_state) 
                WAIT_ACK_ST : 
                    in_dout_keep_shft <= in_dout_keep;

                WRITE_ST : 
                    if (bit_cnt == 0) 
                        in_dout_keep_shft[N_BYTES-1 : 0] <= {1'b0 , in_dout_keep_shft[N_BYTES-1:1]};

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

            endcase 
    end 


    fifo_in_sync_xpm #(
        .DATA_WIDTH (N_BYTES*8),
        .MEMTYPE    ("block"),
        .DEPTH      (16     )
    ) fifo_in_sync_xpm_inst (
        .CLK             (clk          ),
        .RESET           (reset        ),

        .S_AXIS_TDATA    (s_axis_tdata ),
        .S_AXIS_TKEEP    (s_axis_tkeep ),
        .S_AXIS_TVALID   (s_axis_tvalid),
        .S_AXIS_TLAST    (s_axis_tlast ),
        .S_AXIS_TREADY   (s_axis_tready),

        .IN_DOUT_DATA    (in_dout_data ),
        .IN_DOUT_KEEP    (in_dout_keep ),
        .IN_DOUT_LAST    (in_dout_last ),
        .IN_RDEN         (in_rden      ),
        .IN_EMPTY        (in_empty     )
    );

    always_ff @(posedge clk) begin : in_rden_processing
        if (reset)
            in_rden <= 1'b0;
        else
            if (i2c_clk_assertion)
                case (current_state)
                        WAIT_WR_ACK_ST : 
                            if (bit_cnt == 0)
                                in_rden <= 1'b1;

                        default : 
                            in_rden <= 1'b0;
                endcase
    end                     

    // fifo_in_sync_user_xpm #(
    //     .DATA_WIDTH(N_BYTES*8),
    //     .USER_WIDTH(16        ),
    //     .MEMTYPE   ("distributed"),
    //     .DEPTH     (16     )
    // ) fifo_in_sync_user_xpm_inst (
    //     .CLK          (clk          ),
    //     .RESET        (reset        ),
        
    //     .S_AXIS_TDATA (s_axis_tdata ),
    //     .S_AXIS_TKEEP (s_axis_tkeep ),
    //     .S_AXIS_TUSER (s_axis_tuser ),
    //     .S_AXIS_TVALID(s_axis_tvalid),
    //     .S_AXIS_TREADY(s_axis_tready),
    //     .S_AXIS_TLAST (s_axis_tlast ),
        
    //     .IN_DOUT_DATA (in_dout_data ),
    //     .IN_DOUT_KEEP (in_dout_keep ),
    //     .IN_DOUT_USER (in_dout_user ),
    //     .IN_DOUT_LAST (in_dout_last ),
    //     .IN_RDEN      (in_rden      ),
    //     .IN_EMPTY     (in_empty     )
    // );

    // genvar i;
    // generate
    //     for (i = 0; i < N_BYTES; i = i+1) begin
    //         assign in_dout_data_sig[((N_BYTES*8)-1)-(i*8):(((N_BYTES-1)*8) - (i*8))] = in_dout_data[((i+1)*8)-1:(i*8)];
    //     end 
    // endgenerate

endmodule : axis_iic_mgr
