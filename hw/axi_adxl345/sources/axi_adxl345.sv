`timescale 1 ns / 1 ps



module axi_adxl345 #(
    parameter integer       C_S_AXI_LITE_DATA_WIDTH = 32   ,
    parameter integer       C_S_AXI_LITE_ADDR_WIDTH = 6    ,
    parameter         [6:0] DEVICE_ADDRESS          = 7'h53,
    parameter integer       REQUEST_INTERVAL        = 1000
) (
    input  logic                                   S_AXI_LITE_ACLK   ,
    input  logic                                   S_AXI_LITE_ARESETN,
    input  logic [    C_S_AXI_LITE_ADDR_WIDTH-1:0] S_AXI_LITE_AWADDR ,
    input  logic [                            2:0] S_AXI_LITE_AWPROT ,
    input  logic                                   S_AXI_LITE_AWVALID,
    output logic                                   S_AXI_LITE_AWREADY,
    input  logic [    C_S_AXI_LITE_DATA_WIDTH-1:0] S_AXI_LITE_WDATA  ,
    input  logic [(C_S_AXI_LITE_DATA_WIDTH/8)-1:0] S_AXI_LITE_WSTRB  ,
    input  logic                                   S_AXI_LITE_WVALID ,
    output logic                                   S_AXI_LITE_WREADY ,
    output logic [                            1:0] S_AXI_LITE_BRESP  ,
    output logic                                   S_AXI_LITE_BVALID ,
    input  logic                                   S_AXI_LITE_BREADY ,
    input  logic [    C_S_AXI_LITE_ADDR_WIDTH-1:0] S_AXI_LITE_ARADDR ,
    input  logic [                            2:0] S_AXI_LITE_ARPROT ,
    input  logic                                   S_AXI_LITE_ARVALID,
    output logic                                   S_AXI_LITE_ARREADY,
    output logic [    C_S_AXI_LITE_DATA_WIDTH-1:0] S_AXI_LITE_RDATA  ,
    output logic [                            1:0] S_AXI_LITE_RRESP  ,
    output logic                                   S_AXI_LITE_RVALID ,
    input  logic                                   S_AXI_LITE_RREADY ,
    
    output logic [                            7:0] M_AXIS_TDATA      ,
    output logic [                            0:0] M_AXIS_TKEEP      ,
    output logic [                            7:0] M_AXIS_TUSER      ,
    output logic                                   M_AXIS_TVALID     ,
    output logic                                   M_AXIS_TLAST      ,
    input  logic                                   M_AXIS_TREADY     ,

    input  logic [                            7:0] S_AXIS_TDATA      ,
    input  logic [                            0:0] S_AXIS_TKEEP      ,
    input  logic [                            7:0] S_AXIS_TUSER      ,
    input  logic                                   S_AXIS_TVALID     ,
    input  logic                                   S_AXIS_TLAST      ,
    output logic                                   S_AXIS_TREADY      
);

    logic [C_S_AXI_LITE_ADDR_WIDTH-1:0] axi_awaddr ;
    logic                               axi_awready;
    logic                               axi_wready ;
    logic [                        1:0] axi_bresp  ;
    logic                               axi_bvalid ;
    logic [C_S_AXI_LITE_ADDR_WIDTH-1:0] axi_araddr ;
    logic                               axi_arready;
    logic [C_S_AXI_LITE_DATA_WIDTH-1:0] axi_rdata  ;
    logic [                        1:0] axi_rresp  ;
    logic                               axi_rvalid ;


    localparam integer ADDR_LSB = (C_S_AXI_LITE_DATA_WIDTH/32) + 1;
    localparam integer OPT_MEM_ADDR_BITS = 3;
    localparam integer DATA_WIDTH = 8;
    localparam integer USER_WIDTH = 8;
    localparam ADDRESS_LIMIT = 'h39;

    logic [0:15][C_S_AXI_LITE_DATA_WIDTH-1:0] register = '{default:'{default:0}}   ;
    logic [0:15][3:0] need_update_reg = '{
        '{0, 0, 0, 0}, // 0x00
        '{0, 0, 0, 0}, // 0x04
        '{0, 0, 0, 0}, // 0x08
        '{0, 0, 0, 0}, // 0x0C
        '{0, 0, 0, 0}, // 0x10
        '{0, 0, 0, 0}, // 0x14
        '{0, 0, 0, 0}, // 0x18
        '{0, 0, 0, 0}, // 0x1C
        '{0, 0, 0, 0}, // 0x20
        '{0, 0, 0, 0}, // 0x24
        '{0, 0, 0, 0}, // 0x28
        '{0, 0, 0, 0}, // 0x2C
        '{0, 0, 0, 0}, // 0x30
        '{0, 0, 0, 0}, // 0x34
        '{0, 0, 0, 0}, // 0x38
        '{0, 0, 0, 0}  // 0x3C
        };

    logic [0:15][3:0] write_mask_register = '{
        '{0, 0, 0, 0}, // 0x00
        '{0, 0, 0, 0}, // 0x04
        '{0, 0, 0, 0}, // 0x08
        '{0, 0, 0, 0}, // 0x0C
        '{0, 0, 0, 0}, // 0x10
        '{0, 0, 0, 0}, // 0x14
        '{0, 0, 0, 0}, // 0x18
        '{1, 1, 1, 0}, // 0x1C
        '{1, 1, 1, 1}, // 0x20
        '{1, 1, 1, 1}, // 0x24
        '{0, 1, 1, 1}, // 0x28
        '{1, 1, 1, 1}, // 0x2C
        '{0, 0, 1, 0}, // 0x30
        '{0, 0, 0, 0}, // 0x34
        '{0, 0, 0, 1}, // 0x38
        '{0, 0, 0, 0}  // 0x3C
        };


    logic                               slv_reg_rden;
    logic                               slv_reg_wren;
    logic [C_S_AXI_LITE_DATA_WIDTH-1:0] reg_data_out;
    logic                               aw_en       ;

    integer byte_index;

    logic update_request = 1'b0;

    typedef enum {
        IDLE_ST              ,
        CHK_UPD_NEEDED_ST    ,
        SEND_WRITE_CMD_ST    ,
        INC_ADDR_ST          ,
        TX_READ_REQUEST_ST   ,
        AWAIT_RECEIVE_DATA_ST 
    } fsm;

    fsm         current_state      = IDLE_ST     ;
    logic [5:0] address            = '{default:0};
    logic       write_cmd_word_cnt = 1'b0        ;

    logic [$clog2(REQUEST_INTERVAL)-1:0] request_timer = '{default:0};

    logic [    DATA_WIDTH-1:0] out_din_data = '{default:0};
    logic [(DATA_WIDTH/8)-1:0] out_din_keep = '{default:0};
    logic [    USER_WIDTH-1:0] out_din_user = '{default:0};
    logic                      out_din_last = 1'b0        ;
    logic                      out_wren     = 1'b0        ;
    logic                      out_full                   ;
    logic                      out_awfull                 ;


    always_comb begin
        S_AXI_LITE_AWREADY = axi_awready;
        S_AXI_LITE_WREADY  = axi_wready;
        S_AXI_LITE_BRESP   = axi_bresp;
        S_AXI_LITE_BVALID  = axi_bvalid;
        S_AXI_LITE_ARREADY = axi_arready;
        S_AXI_LITE_RDATA   = axi_rdata;
        S_AXI_LITE_RRESP   = axi_rresp;
        S_AXI_LITE_RVALID  = axi_rvalid;

        S_AXIS_TREADY = 1'b1;

    end 




    always @( posedge S_AXI_LITE_ACLK ) begin : axi_awready_proc
        if (~S_AXI_LITE_ARESETN)
            axi_awready <= 1'b0;
        else    
            if (~axi_awready && S_AXI_LITE_AWVALID && S_AXI_LITE_WVALID && aw_en)
                axi_awready <= 1'b1;
            else 
                if (S_AXI_LITE_BREADY && axi_bvalid)
                    axi_awready <= 1'b0;
                else
                    axi_awready <= 1'b0;
    end       

    always @( posedge S_AXI_LITE_ACLK ) begin : aw_en_proc
        if (~S_AXI_LITE_ARESETN)
            aw_en <= 1'b1;
        else
            if (~axi_awready && S_AXI_LITE_AWVALID && S_AXI_LITE_WVALID && aw_en)
                aw_en <= 1'b0;
            else 
                if (S_AXI_LITE_BREADY && axi_bvalid)
                    aw_en <= 1'b1;
    end       

    always @( posedge S_AXI_LITE_ACLK ) begin : axi_awaddr_proc
        if (~S_AXI_LITE_ARESETN)
            axi_awaddr <= 0;
        else
            if (~axi_awready && S_AXI_LITE_AWVALID && S_AXI_LITE_WVALID && aw_en)
                axi_awaddr <= S_AXI_LITE_AWADDR;
    end       

    always @( posedge S_AXI_LITE_ACLK ) begin : axi_wready_proc
        if (~S_AXI_LITE_ARESETN)
            axi_wready <= 1'b0;
        else    
            if (~axi_wready && S_AXI_LITE_WVALID && S_AXI_LITE_AWVALID && aw_en )
                axi_wready <= 1'b1;
            else
                axi_wready <= 1'b0;
    end       

    always_comb begin 
        slv_reg_wren = axi_wready && S_AXI_LITE_WVALID && axi_awready && S_AXI_LITE_AWVALID;
    end

    generate 

        for (genvar reg_index = 0; reg_index < 15; reg_index++) begin 
    
            always @(posedge S_AXI_LITE_ACLK) begin : register_proc
                if (~S_AXI_LITE_ARESETN)
                    register[reg_index] <= 0;
                else
                    if (slv_reg_wren) begin 
                        if (axi_awaddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB] == reg_index) begin 
                            for ( byte_index = 0; byte_index <= (C_S_AXI_LITE_DATA_WIDTH/8)-1; byte_index = byte_index + 1 ) begin 
                                if ( S_AXI_LITE_WSTRB[byte_index] == 1 & write_mask_register[reg_index][byte_index]) begin 
                                    register[reg_index][(byte_index*8) +: 8] <= S_AXI_LITE_WDATA[(byte_index*8) +: 8];
                                end 
                            end 
                        end 
                    end else begin 
                        case (current_state) 
                            AWAIT_RECEIVE_DATA_ST : 
                                if (S_AXIS_TVALID) 
                                    if (address[5:2] == reg_index)  
                                        for ( byte_index = 0; byte_index <= 3; byte_index = byte_index + 1 ) begin
                                            if (byte_index == address[1:0])
                                                register[reg_index][(byte_index*8) +: 8] <= S_AXIS_TDATA;
                                        end 
    
                            default: 
                                register <= register;

                        endcase // current_state
                    end 
            end    

            always @(posedge S_AXI_LITE_ACLK) begin : need_update_reg_proc 
                if (~S_AXI_LITE_ARESETN)
                    register[reg_index] <= 0;
                else
                    if (slv_reg_wren)
                        if (axi_awaddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB] == reg_index)
                            for (byte_index = 0; byte_index <= (C_S_AXI_LITE_DATA_WIDTH/8)-1; byte_index = byte_index + 1)
                                if (S_AXI_LITE_WSTRB[byte_index])
                                    need_update_reg[reg_index][byte_index] <= write_mask_register[reg_index][byte_index];
            end    

        end 

    endgenerate

    always @( posedge S_AXI_LITE_ACLK ) begin : axi_bvalid_proc
        if (~S_AXI_LITE_ARESETN)
            axi_bvalid  <= 0;
        else
            if (axi_awready && S_AXI_LITE_AWVALID && ~axi_bvalid && axi_wready && S_AXI_LITE_WVALID)
                axi_bvalid <= 1'b1;
            else
                if (S_AXI_LITE_BREADY && axi_bvalid)
                    axi_bvalid <= 1'b0; 
    end   

    always @( posedge S_AXI_LITE_ACLK ) begin : axi_bresp_proc
        if (~S_AXI_LITE_ARESETN)
            axi_bresp   <= 2'b0;
        else
            if (axi_awready && S_AXI_LITE_AWVALID && ~axi_bvalid && axi_wready && S_AXI_LITE_WVALID)
                axi_bresp  <= 2'b0; // 'OKAY' response 
    end   

///////////////////////////////////////////// READ INTERFACE SIGNALS /////////////////////////////////////////////

    always @( posedge S_AXI_LITE_ACLK ) begin : axi_arready_proc
        if (~S_AXI_LITE_ARESETN)
            axi_arready <= 1'b0;
        else    
            if (~axi_arready && S_AXI_LITE_ARVALID)
                axi_arready <= 1'b1;
            else
                axi_arready <= 1'b0;
    end       

    always @( posedge S_AXI_LITE_ACLK ) begin : axi_araddr_proc
        if (~S_AXI_LITE_ARESETN)
            axi_araddr  <= 32'b0;
        else    
            if (~axi_arready && S_AXI_LITE_ARVALID)
                axi_araddr  <= S_AXI_LITE_ARADDR;
            
    end       

    always @( posedge S_AXI_LITE_ACLK ) begin : axi_rvalid_proc
        if (~S_AXI_LITE_ARESETN)
            axi_rvalid <= 0;
        else
            if (axi_arready && S_AXI_LITE_ARVALID && ~axi_rvalid)
                axi_rvalid <= 1'b1;
            else 
                if (axi_rvalid && S_AXI_LITE_RREADY)
                    axi_rvalid <= 1'b0;
    end    

    always @( posedge S_AXI_LITE_ACLK ) begin : axi_rresp_proc
        if (~S_AXI_LITE_ARESETN)
            axi_rresp  <= 0;
        else
            if (axi_arready && S_AXI_LITE_ARVALID && ~axi_rvalid)
                axi_rresp  <= 2'b0; // 'OKAY' response             
        
    end    

    always_comb begin 
        slv_reg_rden = axi_arready & S_AXI_LITE_ARVALID & ~axi_rvalid;
    end 

    always @(*) begin
        case ( axi_araddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB] )
            4'h0    : reg_data_out <= register[ 0];
            4'h1    : reg_data_out <= register[ 1];
            4'h2    : reg_data_out <= register[ 2];
            4'h3    : reg_data_out <= register[ 3];
            4'h4    : reg_data_out <= register[ 4];
            4'h5    : reg_data_out <= register[ 5];
            4'h6    : reg_data_out <= register[ 6];
            4'h7    : reg_data_out <= register[ 7];
            4'h8    : reg_data_out <= register[ 8];
            4'h9    : reg_data_out <= register[ 9];
            4'hA    : reg_data_out <= register[10];
            4'hB    : reg_data_out <= register[11];
            4'hC    : reg_data_out <= register[12];
            4'hD    : reg_data_out <= register[13];
            4'hE    : reg_data_out <= register[14];
            4'hF    : reg_data_out <= register[15];
            default : reg_data_out <= 0;
        endcase
    end

    always @( posedge S_AXI_LITE_ACLK ) begin
        if (~S_AXI_LITE_ARESETN)
            axi_rdata  <= 0;
        else 
            if (slv_reg_rden) 
                axi_rdata <= reg_data_out;     // register read data
    end    


////////////////////////////////////////////////////// INTERNAL LOGIC SIGNALS //////////////////////////////////////////////////////


    always_ff @(posedge S_AXI_LITE_ACLK) begin : write_cmd_word_cnt_proc
        if (~S_AXI_LITE_ARESETN)
            write_cmd_word_cnt <= 1'b0;
        else 
            case (current_state)
                SEND_WRITE_CMD_ST : 
                    if (~out_awfull)
                        write_cmd_word_cnt <= 1'b1;

                default : 
                    write_cmd_word_cnt <= 1'b0;

            endcase // current_state
    end 

    always_ff @(posedge S_AXI_LITE_ACLK) begin : current_state_proc 
        if (~S_AXI_LITE_ARESETN) 
            current_state <= IDLE_ST;
        else 
            case (current_state)

                IDLE_ST : 
                    if (update_request)
                        current_state <= CHK_UPD_NEEDED_ST;
                    else if (request_timer == REQUEST_INTERVAL-1)
                        current_state <= TX_READ_REQUEST_ST;


                CHK_UPD_NEEDED_ST : 
                    if (need_update_reg[address[5:2]][address[1:0]])
                        current_state <= SEND_WRITE_CMD_ST;
                    else 
                        current_state <= INC_ADDR_ST;


                SEND_WRITE_CMD_ST  : 
                    if (~out_awfull)
                       if (write_cmd_word_cnt)
                            current_state <= INC_ADDR_ST;

                INC_ADDR_ST  : 
                    if (address == ADDRESS_LIMIT) 
                        current_state <= IDLE_ST;
                    else 
                        current_state <= CHK_UPD_NEEDED_ST;

                TX_READ_REQUEST_ST : 
                    if (~out_awfull) 
                        current_state <= AWAIT_RECEIVE_DATA_ST;

                AWAIT_RECEIVE_DATA_ST : 
                    if (S_AXIS_TVALID & S_AXIS_TLAST)
                        current_state <= IDLE_ST;
                    else 
                        current_state <= current_state;

                default : 
                    current_state <= current_state;

            endcase // current_state

    end

    always_ff @(posedge S_AXI_LITE_ACLK) begin : address_proc 
        if (~S_AXI_LITE_ARESETN) 
            address  <= '{default:0};
        else 
            case (current_state)

                IDLE_ST : 
                    address <= '{default:0};

                INC_ADDR_ST : 
                    address <= address + 1;

                AWAIT_RECEIVE_DATA_ST : 
                    if (S_AXIS_TVALID)
                        address <= address + 1;

                default : 
                    address <= address;

            endcase // current_state
    end 

    generate 

        for (genvar reg_index = 0; reg_index < 15; reg_index++) begin 
    
            always @(posedge S_AXI_LITE_ACLK) begin : register_proc
                if (~S_AXI_LITE_ARESETN)
                    update_request <= 1'b0;
                else
                    if (slv_reg_wren) begin 
                        if (axi_awaddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB] == reg_index) begin 
                            for ( byte_index = 0; byte_index <= (C_S_AXI_LITE_DATA_WIDTH/8)-1; byte_index = byte_index + 1 ) begin 
                                if ( S_AXI_LITE_WSTRB[byte_index] == 1 & write_mask_register[reg_index][byte_index]) begin 
                                    update_request <= 1'b1;
                                end 
                            end 
                        end
                    end else begin 
                        case (current_state)
                            INC_ADDR_ST : 
                                if (address == ADDRESS_LIMIT)
                                    update_request <= 1'b0;
                            
                            default : 
                                update_request <= update_request;
                        endcase // current_state
                    end 
            end    
        end 

    endgenerate



    fifo_out_sync_tuser_xpm #(
        .DATA_WIDTH(DATA_WIDTH),
        .USER_WIDTH(USER_WIDTH),
        .MEMTYPE   ("block"   ),
        .DEPTH     (16        )
    ) fifo_out_sync_tuser_xpm_inst (
        .CLK          (S_AXI_LITE_ACLK    ),
        .RESET        (~S_AXI_LITE_ARESETN),
        .OUT_DIN_DATA (out_din_data       ),
        .OUT_DIN_KEEP (out_din_keep       ),
        .OUT_DIN_USER (out_din_user       ),
        .OUT_DIN_LAST (out_din_last       ),
        .OUT_WREN     (out_wren           ),
        .OUT_FULL     (out_full           ),
        .OUT_AWFULL   (out_awfull         ),
        .M_AXIS_TDATA (M_AXIS_TDATA       ),
        .M_AXIS_TKEEP (M_AXIS_TKEEP       ),
        .M_AXIS_TUSER (M_AXIS_TUSER       ),
        .M_AXIS_TVALID(M_AXIS_TVALID      ),
        .M_AXIS_TLAST (M_AXIS_TLAST       ),
        .M_AXIS_TREADY(M_AXIS_TREADY      )
    );

    always_comb begin 
        out_din_keep <= 1'b1;
    end 

    always_ff @(posedge S_AXI_LITE_ACLK) begin : out_din_data_proc
        case (current_state)
            SEND_WRITE_CMD_ST : 
                if (~write_cmd_word_cnt)
                    out_din_data <= 8'h01;
                else 
                    out_din_data <= {2'b00, address};

            TX_READ_REQUEST_ST : 
                out_din_data <= ADDRESS_LIMIT;

            default : 
                out_din_data <= out_din_data;

        endcase // current_state
    end 

    always_ff @(posedge S_AXI_LITE_ACLK) begin : out_wren_proc
        case (current_state)
            SEND_WRITE_CMD_ST : 
                if (~out_awfull) 
                    out_wren <= 1'b1;
                else 
                    out_wren <= 1'b0;

            TX_READ_REQUEST_ST: 
                if (~out_awfull) 
                    out_wren <= 1'b1;
                else 
                    out_wren <= 1'b0;

            default : 
                out_wren <= 1'b0;

        endcase // current_state
    end 

    always_ff @(posedge S_AXI_LITE_ACLK) begin : out_din_user_proc
        case (current_state)
            SEND_WRITE_CMD_ST : 
                out_din_user <= {DEVICE_ADDRESS, 1'b0};

            TX_READ_REQUEST_ST : 
                out_din_user <= {DEVICE_ADDRESS, 1'b1};

            default : 
                out_din_user <= '{default:0};
        endcase // current_state
    end 

    always_ff @(posedge S_AXI_LITE_ACLK) begin 
        case (current_state)
            SEND_WRITE_CMD_ST : 
                if (write_cmd_word_cnt)
                    out_din_last <= 1'b1;
                else 
                    out_din_last <= 1'b0;

            TX_READ_REQUEST_ST : 
                out_din_last <= 1'b1;

            default : 
                out_din_last <= 1'b0;

        endcase // current_state
    end 

    always_ff @(posedge S_AXI_LITE_ACLK) begin : request_timer_proc
        case (current_state)
            IDLE_ST : 
                if (request_timer < (REQUEST_INTERVAL-1))
                    request_timer <= request_timer + 1;
                else
                    request_timer <= request_timer;

            AWAIT_RECEIVE_DATA_ST : 
                request_timer <= '{default:0};

        endcase
    end 


endmodule
