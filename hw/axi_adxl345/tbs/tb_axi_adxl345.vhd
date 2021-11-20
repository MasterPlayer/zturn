library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
    use ieee.std_logic_unsigned.all;
    use ieee.std_logic_arith.all;

entity tb_axi_adxl345 is 
end tb_axi_adxl345;



architecture tb_axi_adxl345_arch of tb_axi_adxl345 is 

    constant N_BYTES            :           integer     := 4                                    ;

    constant clock_period   :           time                                          := 10 ns              ;

    signal i                :           integer                                       := 0                  ;


    --component axi_adxl345 
    --    generic (
    --        DEFAULT_REQUEST_INTERVAL : integer := 10000     ;
    --        DEFAULT_BW_RATE          : integer := 10        ;
    --        DEFAULT_I2C_ADDRESS      : std_logic_Vector ( 7 downto  0)  := x"A6"  
    --    ); 
    --    port (
    --        aclk      : in    std_logic                             ;
    --        aresetn   : in    std_logic                             ;
    --        awaddr    : in    std_logic_vector (  5 downto 0 )      ;
    --        awprot    : in    std_logic_vector (  2 downto 0 )      ;
    --        awvalid   : in    std_logic                             ;
    --        awready   : out   std_logic                             ;
    --        wdata     : in    std_logic_vector ( 31 downto 0 )      ;
    --        wstrb     : in    std_logic_vector (  3 downto 0 )      ;
    --        wvalid    : in    std_logic                             ;
    --        wready    : out   std_logic                             ;
    --        bresp     : out   std_logic_vector (  1 downto 0 )      ;
    --        bvalid    : out   std_logic                             ;
    --        bready    : in    std_logic                             ;
    --        araddr    : in    std_logic_vector (  5 downto 0 )      ;
    --        arprot    : in    std_logic_vector (  2 downto 0 )      ;
    --        arvalid   : in    std_logic                             ;
    --        arready   : out   std_logic                             ;
    --        rdata     : out   std_logic_vector ( 31 downto 0 )      ;
    --        rresp     : out   std_logic_vector (  1 downto 0 )      ;
    --        rvalid    : out   std_logic                             ;
    --        rready    : in    std_logic                      
    --    );
    --end component;

    signal  clk       :       std_logic                        := '0'               ;
    signal  reset     :       std_logic                        := '1'               ;
    --signal  awaddr    :       std_logic_vector (  5 downto 0 ) := (others => '0')   ;
    --signal  awprot    :       std_logic_vector (  2 downto 0 ) := (others => '0')   ;
    --signal  awvalid   :       std_logic                        := '0'               ;
    --signal  awready   :       std_logic                                             ;
    --signal  wdata     :       std_logic_vector ( 31 downto 0 ) := (others => '0')   ;
    --signal  wstrb     :       std_logic_vector (  3 downto 0 ) := (others => '0')   ;
    --signal  wvalid    :       std_logic                        := '0'               ;
    --signal  wready    :       std_logic                                             ;
    --signal  bresp     :       std_logic_vector (  1 downto 0 )                      ;
    --signal  bvalid    :       std_logic                                             ;
    --signal  bready    :       std_logic                        := '0'               ;
    --signal  araddr    :       std_logic_vector (  5 downto 0 ) := (others => '0')   ;
    --signal  arprot    :       std_logic_vector (  2 downto 0 ) := (others => '0')   ;
    --signal  arvalid   :       std_logic                        := '0'               ;
    --signal  arready   :       std_logic                                             ;
    --signal  rdata     :       std_logic_vector ( 31 downto 0 )                      ;
    --signal  rresp     :       std_logic_vector (  1 downto 0 )                      ;
    --signal  rvalid    :       std_logic                                             ;
    --signal  rready    :       std_logic                        := '0'               ;


    constant  C_M_TARGET_SLAVE_BASE_ADDR  :           std_Logic_vector ( 31 downto 0 ) := x"40000000"                                 ;
    constant  C_M_AXI_BURST_LEN           :           integer                          := 16                                          ;
    constant  C_M_AXI_ID_WIDTH            :           integer                          := 1                                           ;
    constant  C_M_AXI_ADDR_WIDTH          :           integer                          := 32                                          ;
    constant  C_M_AXI_DATA_WIDTH          :           integer                          := 32                                          ;


    component m_axi_full_iface 
        generic (
            C_M_TARGET_SLAVE_BASE_ADDR  :           std_Logic_vector ( 31 downto 0 ) := x"40000000"                                 ;
            C_M_AXI_BURST_LEN           :           integer                          := 16                                          ;
            C_M_AXI_ID_WIDTH            :           integer                          := 1                                           ;
            C_M_AXI_ADDR_WIDTH          :           integer                          := 32                                          ;
            C_M_AXI_DATA_WIDTH          :           integer                          := 32                                          
        );
        port (
            INIT_AXI_TXN                :   in      std_logic                                                                       ;
            M_AXI_ACLK                  :   in      std_logic                                                                       ;
            M_AXI_ARESETN               :   in      std_logic                                                                       ;
            M_AXI_AWID                  :   out     std_logic_vector (     C_M_AXI_ID_WIDTH-1 downto 0 )                            ;
            M_AXI_AWADDR                :   out     std_logic_vector (   C_M_AXI_ADDR_WIDTH-1 downto 0 )                            ;
            M_AXI_AWLEN                 :   out     std_logic_vector (                      7 downto 0 )                            ;
            M_AXI_AWSIZE                :   out     std_logic_vector (                      2 downto 0 )                            ;
            M_AXI_AWBURST               :   out     std_logic_vector (                      1 downto 0 )                            ;
            M_AXI_AWLOCK                :   out     std_logic                                                                       ;
            M_AXI_AWCACHE               :   out     std_logic_vector (                      3 downto 0 )                            ;
            M_AXI_AWPROT                :   out     std_logic_vector (                      2 downto 0 )                            ;
            M_AXI_AWQOS                 :   out     std_logic_vector (                      3 downto 0 )                            ;
            M_AXI_AWVALID               :   out     std_logic                                                                       ;
            M_AXI_AWREADY               :   in      std_logic                                                                       ;
            M_AXI_WDATA                 :   out     std_logic_vector (   C_M_AXI_DATA_WIDTH-1 downto 0 )                            ;
            M_AXI_WSTRB                 :   out     std_logic_vector ( C_M_AXI_DATA_WIDTH/8-1 downto 0 )                            ;
            M_AXI_WLAST                 :   out     std_logic                                                                       ;
            M_AXI_WVALID                :   out     std_logic                                                                       ;
            M_AXI_WREADY                :   in      std_logic                                                                       ;
            M_AXI_BID                   :   in      std_logic_vector (     C_M_AXI_ID_WIDTH-1 downto 0 )                            ;
            M_AXI_BRESP                 :   in      std_logic_vector (                      1 downto 0 )                            ;
            M_AXI_BVALID                :   in      std_logic                                                                       ;
            M_AXI_BREADY                :   out     std_logic                                                                       ;
            M_AXI_ARID                  :   out     std_logic_vector (     C_M_AXI_ID_WIDTH-1 downto 0 )                            ;
            M_AXI_ARADDR                :   out     std_logic_vector (   C_M_AXI_ADDR_WIDTH-1 downto 0 )                            ;
            M_AXI_ARLEN                 :   out     std_logic_vector (                      7 downto 0 )                            ;
            M_AXI_ARSIZE                :   out     std_logic_vector (                      2 downto 0 )                            ;
            M_AXI_ARBURST               :   out     std_logic_vector (                      1 downto 0 )                            ;
            M_AXI_ARLOCK                :   out     std_logic                                                                       ;
            M_AXI_ARCACHE               :   out     std_logic_vector (                      3 downto 0 )                            ;
            M_AXI_ARPROT                :   out     std_logic_vector (                      2 downto 0 )                            ;
            M_AXI_ARQOS                 :   out     std_logic_vector (                      3 downto 0 )                            ;
            M_AXI_ARVALID               :   out     std_logic                                                                       ;
            M_AXI_ARREADY               :   in      std_logic                                                                       ;
            M_AXI_RID                   :   in      std_logic_vector (     C_M_AXI_ID_WIDTH-1 downto 0 )                            ;
            M_AXI_RDATA                 :   in      std_logic_vector (   C_M_AXI_DATA_WIDTH-1 downto 0 )                            ;
            M_AXI_RRESP                 :   in      std_logic_vector (                      1 downto 0 )                            ;
            M_AXI_RLAST                 :   in      std_logic                                                                       ;
            M_AXI_RVALID                :   in      std_logic                                                                       ;
            M_AXI_RREADY                :   out     std_logic                                                                        
        );
    end component;

    signal  INIT_AXI_TXN                :           std_logic                                            := '0'                     ;
    signal  M_AXI_AWID                  :           std_logic_vector (     C_M_AXI_ID_WIDTH-1 downto 0 )                            ;
    signal  M_AXI_AWADDR                :           std_logic_vector (   C_M_AXI_ADDR_WIDTH-1 downto 0 )                            ;
    signal  M_AXI_AWLEN                 :           std_logic_vector (                      7 downto 0 )                            ;
    signal  M_AXI_AWSIZE                :           std_logic_vector (                      2 downto 0 )                            ;
    signal  M_AXI_AWBURST               :           std_logic_vector (                      1 downto 0 )                            ;
    signal  M_AXI_AWLOCK                :           std_logic                                                                       ;
    signal  M_AXI_AWCACHE               :           std_logic_vector (                      3 downto 0 )                            ;
    signal  M_AXI_AWPROT                :           std_logic_vector (                      2 downto 0 )                            ;
    signal  M_AXI_AWQOS                 :           std_logic_vector (                      3 downto 0 )                            ;
    signal  M_AXI_AWVALID               :           std_logic                                                                       ;
    signal  M_AXI_AWREADY               :           std_logic                                            := '0'                     ;
    signal  M_AXI_WDATA                 :           std_logic_vector (   C_M_AXI_DATA_WIDTH-1 downto 0 )                            ;
    signal  M_AXI_WSTRB                 :           std_logic_vector ( C_M_AXI_DATA_WIDTH/8-1 downto 0 )                            ;
    signal  M_AXI_WLAST                 :           std_logic                                                                       ;
    signal  M_AXI_WVALID                :           std_logic                                                                       ;
    signal  M_AXI_WREADY                :           std_logic                                            := '0'                     ;
    signal  M_AXI_BID                   :           std_logic_vector (     C_M_AXI_ID_WIDTH-1 downto 0 )                            ;
    signal  M_AXI_BRESP                 :           std_logic_vector (                      1 downto 0 )                            ;
    signal  M_AXI_BVALID                :           std_logic                                            := '0'                     ;
    signal  M_AXI_BREADY                :           std_logic                                                                       ;
    signal  M_AXI_ARID                  :           std_logic_vector (     C_M_AXI_ID_WIDTH-1 downto 0 )                            ;
    signal  M_AXI_ARADDR                :           std_logic_vector (   C_M_AXI_ADDR_WIDTH-1 downto 0 )                            ;
    signal  M_AXI_ARLEN                 :           std_logic_vector (                      7 downto 0 )                            ;
    signal  M_AXI_ARSIZE                :           std_logic_vector (                      2 downto 0 )                            ;
    signal  M_AXI_ARBURST               :           std_logic_vector (                      1 downto 0 )                            ;
    signal  M_AXI_ARLOCK                :           std_logic                                                                       ;
    signal  M_AXI_ARCACHE               :           std_logic_vector (                      3 downto 0 )                            ;
    signal  M_AXI_ARPROT                :           std_logic_vector (                      2 downto 0 )                            ;
    signal  M_AXI_ARQOS                 :           std_logic_vector (                      3 downto 0 )                            ;
    signal  M_AXI_ARVALID               :           std_logic                                                                       ;
    signal  M_AXI_ARREADY               :           std_logic                                            := '0'                     ;
    signal  M_AXI_RID                   :           std_logic_vector (     C_M_AXI_ID_WIDTH-1 downto 0 ) := (others => '0')         ;
    signal  M_AXI_RDATA                 :           std_logic_vector (   C_M_AXI_DATA_WIDTH-1 downto 0 ) := (others => '0')         ;
    signal  M_AXI_RRESP                 :           std_logic_vector (                      1 downto 0 ) := (others => '0')         ;
    signal  M_AXI_RLAST                 :           std_logic                                            := '0'                     ;
    signal  M_AXI_RVALID                :           std_logic                                            := '0'                     ;
    signal  M_AXI_RREADY                :           std_logic                                                                       ;


    component axi_full_iface
        generic (
            C_S_AXI_ID_WIDTH   : integer := 1 ;
            C_S_AXI_DATA_WIDTH : integer := 32;
            C_S_AXI_ADDR_WIDTH : integer := 6
        );
        port (
            S_AXI_ACLK       : in   std_logic                                               ;
            S_AXI_ARESETN    : in   std_logic                                               ;
            S_AXI_AWID       : in   std_logic_vector (      C_S_AXI_ID_WIDTH-1 downto 0 )   ;
            S_AXI_AWADDR     : in   std_logic_vector (    C_S_AXI_ADDR_WIDTH-1 downto 0 )   ;
            S_AXI_AWLEN      : in   std_logic_vector (                       7 downto 0 )   ;
            S_AXI_AWSIZE     : in   std_logic_vector (                       2 downto 0 )   ;
            S_AXI_AWBURST    : in   std_logic_vector (                       1 downto 0 )   ;
            S_AXI_AWLOCK     : in   std_logic                                               ;
            S_AXI_AWCACHE    : in   std_logic_vector (                       3 downto 0 )   ;
            S_AXI_AWPROT     : in   std_logic_vector (                       2 downto 0 )   ;
            S_AXI_AWQOS      : in   std_logic_vector (                       3 downto 0 )   ;
            S_AXI_AWVALID    : in   std_logic                                               ;
            S_AXI_AWREADY    : out  std_logic                                               ;
            S_AXI_WDATA      : in   std_logic_vector (    C_S_AXI_DATA_WIDTH-1 downto 0 )   ;
            S_AXI_WSTRB      : in   std_logic_vector ((C_S_AXI_DATA_WIDTH/8)-1 downto 0 )   ;
            S_AXI_WLAST      : in   std_logic                                               ;
            S_AXI_WVALID     : in   std_logic                                               ;
            S_AXI_WREADY     : out  std_logic                                               ;
            S_AXI_BID        : out  std_logic_vector (      C_S_AXI_ID_WIDTH-1 downto 0 )   ;
            S_AXI_BRESP      : out  std_logic_vector (                       1 downto 0 )   ;
            S_AXI_BVALID     : out  std_logic                                               ;
            S_AXI_BREADY     : in   std_logic                                               ;
            S_AXI_ARID       : in   std_logic_vector (      C_S_AXI_ID_WIDTH-1 downto 0 )   ;
            S_AXI_ARADDR     : in   std_logic_vector (    C_S_AXI_ADDR_WIDTH-1 downto 0 )   ;
            S_AXI_ARLEN      : in   std_logic_vector (                       7 downto 0 )   ;
            S_AXI_ARSIZE     : in   std_logic_vector (                       2 downto 0 )   ;
            S_AXI_ARBURST    : in   std_logic_vector (                       1 downto 0 )   ;
            S_AXI_ARLOCK     : in   std_logic                                               ;
            S_AXI_ARCACHE    : in   std_logic_vector (                       3 downto 0 )   ;
            S_AXI_ARPROT     : in   std_logic_vector (                       2 downto 0 )   ;
            S_AXI_ARQOS      : in   std_logic_vector (                       3 downto 0 )   ;
            S_AXI_ARVALID    : in   std_logic                                               ;
            S_AXI_ARREADY    : out  std_logic                                               ;
            S_AXI_RID        : out  std_logic_vector (      C_S_AXI_ID_WIDTH-1 downto 0 )   ;
            S_AXI_RDATA      : out  std_logic_vector (    C_S_AXI_DATA_WIDTH-1 downto 0 )   ;
            S_AXI_RRESP      : out  std_logic_vector (                       1 downto 0 )   ;
            S_AXI_RLAST      : out  std_logic                                               ;
            S_AXI_RVALID     : out  std_logic                                               ;
            S_AXI_RREADY     : in   std_logic                                                
        );
    end component;

    constant  C_S_AXI_LITE_DATA_WIDTH :           integer := 32                                                 ;
    constant  C_S_AXI_LITE_ADDR_WIDTH :           integer := 6                                                  ;


    component axi_adxl345 
        generic (
            C_S_AXI_LITE_DATA_WIDTH :           integer := 32                                                   ;
            C_S_AXI_LITE_ADDR_WIDTH :           integer := 6                                                    ;
            DEVICE_ADDRESS          :           std_logic_Vector ( 6 downto 0 ) := "1010011"                     
        ); 
        port (
            S_AXI_LITE_ACLK         :   in      std_logic                                                       ;
            S_AXI_LITE_ARESETN      :   in      std_logic                                                       ;
            S_AXI_LITE_AWADDR       :   in      std_logic_vector (     C_S_AXI_LITE_ADDR_WIDTH-1 downto 0 )     ;
            S_AXI_LITE_AWPROT       :   in      std_logic_vector (                             2 downto 0 )     ;
            S_AXI_LITE_AWVALID      :   in      std_logic                                                       ;
            S_AXI_LITE_AWREADY      :   out     std_logic                                                       ;
            S_AXI_LITE_WDATA        :   in      std_logic_vector (     C_S_AXI_LITE_DATA_WIDTH-1 downto 0 )     ;
            S_AXI_LITE_WSTRB        :   in      std_logic_vector ( (C_S_AXI_LITE_DATA_WIDTH/8)-1 downto 0 )     ;
            S_AXI_LITE_WVALID       :   in      std_logic                                                       ;
            S_AXI_LITE_WREADY       :   out     std_logic                                                       ;
            S_AXI_LITE_BRESP        :   out     std_logic_vector (                             1 downto 0 )     ;
            S_AXI_LITE_BVALID       :   out     std_logic                                                       ;
            S_AXI_LITE_BREADY       :   in      std_logic                                                       ;
            S_AXI_LITE_ARADDR       :   in      std_logic_vector (     C_S_AXI_LITE_ADDR_WIDTH-1 downto 0 )     ;
            S_AXI_LITE_ARPROT       :   in      std_logic_vector (                             2 downto 0 )     ;
            S_AXI_LITE_ARVALID      :   in      std_logic                                                       ;
            S_AXI_LITE_ARREADY      :   out     std_logic                                                       ;
            S_AXI_LITE_RDATA        :   out     std_logic_vector (     C_S_AXI_LITE_DATA_WIDTH-1 downto 0 )     ;
            S_AXI_LITE_RRESP        :   out     std_logic_vector (                             1 downto 0 )     ;
            S_AXI_LITE_RVALID       :   out     std_logic                                                       ;
            S_AXI_LITE_RREADY       :   in      std_logic                                                       ;

            M_AXIS_TDATA            :   out     std_logic_vector ( 7 downto 0 )                                 ;
            M_AXIS_TKEEP            :   out     std_logic_vector ( 0 downto 0 )                                 ;
            M_AXIS_TUSER            :   out     std_logic_vector ( 7 downto 0 )                                 ;
            M_AXIS_TVALID           :   out     std_logic                                                       ;
            M_AXIS_TLAST            :   out     std_logic                                                       ;
            M_AXIS_TREADY           :   in      std_logic                                                       ;

            S_AXIS_TDATA            :   in      std_logic_vector ( 7 downto 0 )                                 ;
            S_AXIS_TKEEP            :   in      std_logic_vector ( 0 downto 0 )                                 ;
            S_AXIS_TUSER            :   in      std_logic_vector ( 7 downto 0 )                                 ;
            S_AXIS_TVALID           :   in      std_logic                                                       ;
            S_AXIS_TLAST            :   in      std_logic                                                       ;
            S_AXIS_TREADY           :   out     std_logic                                                        

 
        );
    end component;


    signal  awaddr                  :           std_logic_vector (     7 downto 0 ) := (others => '0')  ;
    signal  awprot                  :           std_logic_vector (                             2 downto 0 ) := (others => '0')  ;
    signal  awvalid                 :           std_logic                                                   := '0'              ;
    signal  awready                 :           std_logic                                                                       ;
    signal  wdata                   :           std_logic_vector (     C_S_AXI_LITE_DATA_WIDTH-1 downto 0 ) := (others => '0')  ;
    signal  wstrb                   :           std_logic_vector ( (C_S_AXI_LITE_DATA_WIDTH/8)-1 downto 0 ) := (others => '0')  ;
    signal  wvalid                  :           std_logic                                                   := '0'              ;
    signal  wready                  :           std_logic                                                                       ;
    signal  bresp                   :           std_logic_vector (                             1 downto 0 )                     ;
    signal  bvalid                  :           std_logic                                                                       ;
    signal  bready                  :           std_logic                                                   := '0'              ;
    signal  araddr                  :           std_logic_vector (     7 downto 0 ) := (others => '0')  ;
    signal  arprot                  :           std_logic_vector (                             2 downto 0 ) := (others => '0')  ;
    signal  arvalid                 :           std_logic                                                   := '0'              ;
    signal  arready                 :           std_logic                                                                       ;
    signal  rdata                   :           std_logic_vector (     C_S_AXI_LITE_DATA_WIDTH-1 downto 0 )                     ;
    signal  rresp                   :           std_logic_vector (                             1 downto 0 )                     ;
    signal  rvalid                  :           std_logic                                                                       ;
    signal  rready                  :           std_logic                                                   := '0'              ;

    signal  M_AXIS_TDATA            :           std_logic_vector ( 7 downto 0 )                                                  ;
    signal  M_AXIS_TKEEP            :           std_logic_vector ( 0 downto 0 )                                                  ;
    signal  M_AXIS_TUSER            :           std_logic_vector ( 7 downto 0 )                                                  ;
    signal  M_AXIS_TVALID           :           std_logic                                                                        ;
    signal  M_AXIS_TLAST            :           std_logic                                                                        ;
    signal  M_AXIS_TREADY           :           std_logic                                                    := '0'              ;

    signal  S_AXIS_TDATA            :           std_logic_vector ( 7 downto 0 )                             := (others => '0')  ;
    signal  S_AXIS_TKEEP            :           std_logic_vector ( 0 downto 0 )                             := (others => '0')  ;
    signal  S_AXIS_TUSER            :           std_logic_vector ( 7 downto 0 )                             := (others => '0')  ;
    signal  S_AXIS_TVALID           :           std_logic                                                   := '0'              ;
    signal  S_AXIS_TLAST            :           std_logic                                                   := '0'              ;
    signal  S_AXIS_TREADY           :           std_logic                                                                       ;



begin 

    CLK <= not CLK after clock_period/2;

    i_processing : process(CLK)
    begin
        if CLK'event AND CLK = '1' then 
            i <= i + 1;
        end if;
    end process;

    reset <= '1' when i < 5 else '0';

    axi_adxl345_inst : axi_adxl345 
        generic map (
            C_S_AXI_LITE_DATA_WIDTH =>  C_S_AXI_LITE_DATA_WIDTH ,
            C_S_AXI_LITE_ADDR_WIDTH =>  C_S_AXI_LITE_ADDR_WIDTH ,
            DEVICE_ADDRESS          =>  "1010011"                
        )
        port map (
            S_AXI_LITE_ACLK         =>  CLK                     ,
            S_AXI_LITE_ARESETN      =>  not(RESET)              ,
            S_AXI_LITE_AWADDR       =>  awaddr( 5 downto 0 )    ,
            S_AXI_LITE_AWPROT       =>  awprot                  ,
            S_AXI_LITE_AWVALID      =>  awvalid                 ,
            S_AXI_LITE_AWREADY      =>  awready                 ,
            S_AXI_LITE_WDATA        =>  wdata                   ,
            S_AXI_LITE_WSTRB        =>  wstrb                   ,
            S_AXI_LITE_WVALID       =>  wvalid                  ,
            S_AXI_LITE_WREADY       =>  wready                  ,
            S_AXI_LITE_BRESP        =>  bresp                   ,
            S_AXI_LITE_BVALID       =>  bvalid                  ,
            S_AXI_LITE_BREADY       =>  bready                  ,
            S_AXI_LITE_ARADDR       =>  araddr( 5 downto 0 )    ,
            S_AXI_LITE_ARPROT       =>  arprot                  ,
            S_AXI_LITE_ARVALID      =>  arvalid                 ,
            S_AXI_LITE_ARREADY      =>  arready                 ,
            S_AXI_LITE_RDATA        =>  rdata                   ,
            S_AXI_LITE_RRESP        =>  rresp                   ,
            S_AXI_LITE_RVALID       =>  rvalid                  ,
            S_AXI_LITE_RREADY       =>  rready                  ,

            M_AXIS_TDATA            =>  M_AXIS_TDATA            ,
            M_AXIS_TKEEP            =>  M_AXIS_TKEEP            ,
            M_AXIS_TUSER            =>  M_AXIS_TUSER            ,
            M_AXIS_TVALID           =>  M_AXIS_TVALID           ,
            M_AXIS_TLAST            =>  M_AXIS_TLAST            ,
            M_AXIS_TREADY           =>  M_AXIS_TREADY           ,

            S_AXIS_TDATA            =>  S_AXIS_TDATA            ,
            S_AXIS_TKEEP            =>  S_AXIS_TKEEP            ,
            S_AXIS_TUSER            =>  S_AXIS_TUSER            ,
            S_AXIS_TVALID           =>  S_AXIS_TVALID           ,
            S_AXIS_TLAST            =>  S_AXIS_TLAST            ,
            S_AXIS_TREADY           =>  S_AXIS_TREADY            


        );

    M_AXIS_TREADY <= '1';

    S_AXIS_PROCESSING : process(CLK)
    begin
        if CLK'event AND CLK = '1' then 
            case i is 
                when 1000   => S_AXIS_TDATA <= x"00"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0';
                when 1001   => S_AXIS_TDATA <= x"01"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0';
                when 1002   => S_AXIS_TDATA <= x"02"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0';
                when 1003   => S_AXIS_TDATA <= x"03"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0';
                when 1004   => S_AXIS_TDATA <= x"04"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0';
                when 1005   => S_AXIS_TDATA <= x"05"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0';
                when 1006   => S_AXIS_TDATA <= x"06"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0';
                when 1007   => S_AXIS_TDATA <= x"07"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0';
                when 1008   => S_AXIS_TDATA <= x"08"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0';
                when 1009   => S_AXIS_TDATA <= x"09"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0';
                when 1010   => S_AXIS_TDATA <= x"0a"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0';
                when 1011   => S_AXIS_TDATA <= x"0b"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0';
                when 1012   => S_AXIS_TDATA <= x"0c"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0';
                when 1013   => S_AXIS_TDATA <= x"0d"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0';
                when 1014   => S_AXIS_TDATA <= x"0e"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0';
                when 1015   => S_AXIS_TDATA <= x"0f"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0';
                when 1016   => S_AXIS_TDATA <= x"10"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0';
                when 1017   => S_AXIS_TDATA <= x"11"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0';
                when 1018   => S_AXIS_TDATA <= x"12"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0';
                when 1019   => S_AXIS_TDATA <= x"13"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0';
                when 1020   => S_AXIS_TDATA <= x"14"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0';
                when 1021   => S_AXIS_TDATA <= x"15"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0';
                when 1022   => S_AXIS_TDATA <= x"16"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0';
                when 1023   => S_AXIS_TDATA <= x"17"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0';
                when 1024   => S_AXIS_TDATA <= x"18"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0';
                when 1025   => S_AXIS_TDATA <= x"19"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0';
                when 1026   => S_AXIS_TDATA <= x"1a"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0';
                when 1027   => S_AXIS_TDATA <= x"1b"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0';
                when 1028   => S_AXIS_TDATA <= x"1c"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0';
                when 1029   => S_AXIS_TDATA <= x"1d"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0';
                when 1030   => S_AXIS_TDATA <= x"1e"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0';
                when 1031   => S_AXIS_TDATA <= x"1f"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0';
                when 1032   => S_AXIS_TDATA <= x"20"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0';
                when 1033   => S_AXIS_TDATA <= x"21"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0';
                when 1034   => S_AXIS_TDATA <= x"22"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0';
                when 1035   => S_AXIS_TDATA <= x"23"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0';
                when 1036   => S_AXIS_TDATA <= x"24"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0';
                when 1037   => S_AXIS_TDATA <= x"25"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0';
                when 1038   => S_AXIS_TDATA <= x"26"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0';
                when 1039   => S_AXIS_TDATA <= x"27"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0';
                when 1040   => S_AXIS_TDATA <= x"28"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0';
                when 1041   => S_AXIS_TDATA <= x"29"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0';
                when 1042   => S_AXIS_TDATA <= x"2a"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0';
                when 1043   => S_AXIS_TDATA <= x"2b"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0';
                when 1044   => S_AXIS_TDATA <= x"2c"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0';
                when 1045   => S_AXIS_TDATA <= x"2d"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0';
                when 1046   => S_AXIS_TDATA <= x"2e"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0';
                when 1047   => S_AXIS_TDATA <= x"2f"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0';
                when 1048   => S_AXIS_TDATA <= x"30"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0';
                when 1049   => S_AXIS_TDATA <= x"31"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0';
                when 1050   => S_AXIS_TDATA <= x"32"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0';
                when 1051   => S_AXIS_TDATA <= x"33"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0';
                when 1052   => S_AXIS_TDATA <= x"34"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0';
                when 1053   => S_AXIS_TDATA <= x"35"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0';
                when 1054   => S_AXIS_TDATA <= x"36"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0';
                when 1055   => S_AXIS_TDATA <= x"37"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0';
                when 1056   => S_AXIS_TDATA <= x"38"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '0';
                when 1057   => S_AXIS_TDATA <= x"39"; S_AXIS_TKEEP <= "1"; S_AXIS_TUSER <= x"A7"; S_AXIS_TVALID <= '1'; S_AXIS_TLAST <= '1';
                when others => S_AXIS_TDATA <= S_AXIS_TDATA; S_AXIS_TKEEP <= S_AXIS_TKEEP; S_AXIS_TUSER <= S_AXIS_TUSER; S_AXIS_TVALID <= '0'; S_AXIS_TLAST <= S_AXIS_TLAST;


            end case;
        end if;
    end process;

    --write_processing : process(CLK)
    --begin
    --    if CLK'event AND CLK = '1' then 
    --        case i is 
    --            when 1000   => awaddr <= x"00"; awprot <= "000"; awvalid <= '1'; wdata <= x"03020100"; wstrb <= x"F"; wvalid <= '1'; bready <= '1';
    --            when 1001   => awaddr <= x"00"; awprot <= "000"; awvalid <= '1'; wdata <= x"03020100"; wstrb <= x"F"; wvalid <= '1'; bready <= '1';
    --            when 1002   => awaddr <= x"00"; awprot <= "000"; awvalid <= '0'; wdata <= x"03020100"; wstrb <= x"F"; wvalid <= '0'; bready <= '1';

    --            when 1010   => awaddr <= x"04"; awprot <= "000"; awvalid <= '1'; wdata <= x"07060504"; wstrb <= x"F"; wvalid <= '1'; bready <= '1';
    --            when 1011   => awaddr <= x"04"; awprot <= "000"; awvalid <= '1'; wdata <= x"07060504"; wstrb <= x"F"; wvalid <= '1'; bready <= '1';
    --            when 1012   => awaddr <= x"04"; awprot <= "000"; awvalid <= '0'; wdata <= x"07060504"; wstrb <= x"F"; wvalid <= '0'; bready <= '1';

    --            when 1020   => awaddr <= x"08"; awprot <= "000"; awvalid <= '1'; wdata <= x"0b0a0908"; wstrb <= x"F"; wvalid <= '1'; bready <= '1';
    --            when 1021   => awaddr <= x"08"; awprot <= "000"; awvalid <= '1'; wdata <= x"0b0a0908"; wstrb <= x"F"; wvalid <= '1'; bready <= '1';
    --            when 1022   => awaddr <= x"08"; awprot <= "000"; awvalid <= '0'; wdata <= x"0b0a0908"; wstrb <= x"F"; wvalid <= '0'; bready <= '1';

    --            when 1030   => awaddr <= x"0C"; awprot <= "000"; awvalid <= '1'; wdata <= x"0f0e0d0c"; wstrb <= x"F"; wvalid <= '1'; bready <= '1';
    --            when 1031   => awaddr <= x"0C"; awprot <= "000"; awvalid <= '1'; wdata <= x"0f0e0d0c"; wstrb <= x"F"; wvalid <= '1'; bready <= '1';
    --            when 1032   => awaddr <= x"0C"; awprot <= "000"; awvalid <= '0'; wdata <= x"0f0e0d0c"; wstrb <= x"F"; wvalid <= '0'; bready <= '1';

    --            when 1040   => awaddr <= x"10"; awprot <= "000"; awvalid <= '1'; wdata <= x"13121110"; wstrb <= x"F"; wvalid <= '1'; bready <= '1';
    --            when 1041   => awaddr <= x"10"; awprot <= "000"; awvalid <= '1'; wdata <= x"13121110"; wstrb <= x"F"; wvalid <= '1'; bready <= '1';
    --            when 1042   => awaddr <= x"10"; awprot <= "000"; awvalid <= '0'; wdata <= x"13121110"; wstrb <= x"F"; wvalid <= '0'; bready <= '1';

    --            when 1050   => awaddr <= x"14"; awprot <= "000"; awvalid <= '1'; wdata <= x"17161514"; wstrb <= x"F"; wvalid <= '1'; bready <= '1';
    --            when 1051   => awaddr <= x"14"; awprot <= "000"; awvalid <= '1'; wdata <= x"17161514"; wstrb <= x"F"; wvalid <= '1'; bready <= '1';
    --            when 1052   => awaddr <= x"14"; awprot <= "000"; awvalid <= '0'; wdata <= x"17161514"; wstrb <= x"F"; wvalid <= '0'; bready <= '1';

    --            when 1060   => awaddr <= x"18"; awprot <= "000"; awvalid <= '1'; wdata <= x"1b1a1918"; wstrb <= x"F"; wvalid <= '1'; bready <= '1';
    --            when 1061   => awaddr <= x"18"; awprot <= "000"; awvalid <= '1'; wdata <= x"1b1a1918"; wstrb <= x"F"; wvalid <= '1'; bready <= '1';
    --            when 1062   => awaddr <= x"18"; awprot <= "000"; awvalid <= '0'; wdata <= x"1b1a1918"; wstrb <= x"F"; wvalid <= '0'; bready <= '1';

    --            when 1070   => awaddr <= x"1C"; awprot <= "000"; awvalid <= '1'; wdata <= x"1f1e1d1c"; wstrb <= x"F"; wvalid <= '1'; bready <= '1';
    --            when 1071   => awaddr <= x"1C"; awprot <= "000"; awvalid <= '1'; wdata <= x"1f1e1d1c"; wstrb <= x"F"; wvalid <= '1'; bready <= '1';
    --            when 1072   => awaddr <= x"1C"; awprot <= "000"; awvalid <= '0'; wdata <= x"1f1e1d1c"; wstrb <= x"F"; wvalid <= '0'; bready <= '1';

    --            when 1080   => awaddr <= x"20"; awprot <= "000"; awvalid <= '1'; wdata <= x"23222120"; wstrb <= x"F"; wvalid <= '1'; bready <= '1';
    --            when 1081   => awaddr <= x"20"; awprot <= "000"; awvalid <= '1'; wdata <= x"23222120"; wstrb <= x"F"; wvalid <= '1'; bready <= '1';
    --            when 1082   => awaddr <= x"20"; awprot <= "000"; awvalid <= '0'; wdata <= x"23222120"; wstrb <= x"F"; wvalid <= '0'; bready <= '1';

    --            when 1090   => awaddr <= x"24"; awprot <= "000"; awvalid <= '1'; wdata <= x"27262524"; wstrb <= x"F"; wvalid <= '1'; bready <= '1';
    --            when 1091   => awaddr <= x"24"; awprot <= "000"; awvalid <= '1'; wdata <= x"27262524"; wstrb <= x"F"; wvalid <= '1'; bready <= '1';
    --            when 1092   => awaddr <= x"24"; awprot <= "000"; awvalid <= '0'; wdata <= x"27262524"; wstrb <= x"F"; wvalid <= '0'; bready <= '1';

    --            when 1100   => awaddr <= x"28"; awprot <= "000"; awvalid <= '1'; wdata <= x"2b2a2928"; wstrb <= x"F"; wvalid <= '1'; bready <= '1';
    --            when 1101   => awaddr <= x"28"; awprot <= "000"; awvalid <= '1'; wdata <= x"2b2a2928"; wstrb <= x"F"; wvalid <= '1'; bready <= '1';
    --            when 1102   => awaddr <= x"28"; awprot <= "000"; awvalid <= '0'; wdata <= x"2b2a2928"; wstrb <= x"F"; wvalid <= '0'; bready <= '1';

    --            when 1110   => awaddr <= x"2C"; awprot <= "000"; awvalid <= '1'; wdata <= x"2f2e2d2c"; wstrb <= x"F"; wvalid <= '1'; bready <= '1';
    --            when 1111   => awaddr <= x"2C"; awprot <= "000"; awvalid <= '1'; wdata <= x"2f2e2d2c"; wstrb <= x"F"; wvalid <= '1'; bready <= '1';
    --            when 1112   => awaddr <= x"2C"; awprot <= "000"; awvalid <= '0'; wdata <= x"2f2e2d2c"; wstrb <= x"F"; wvalid <= '0'; bready <= '1';
                
    --            when 1120   => awaddr <= x"30"; awprot <= "000"; awvalid <= '1'; wdata <= x"33323130"; wstrb <= x"F"; wvalid <= '1'; bready <= '1';
    --            when 1121   => awaddr <= x"30"; awprot <= "000"; awvalid <= '1'; wdata <= x"33323130"; wstrb <= x"F"; wvalid <= '1'; bready <= '1';
    --            when 1122   => awaddr <= x"30"; awprot <= "000"; awvalid <= '0'; wdata <= x"33323130"; wstrb <= x"F"; wvalid <= '0'; bready <= '1';
                
    --            when 1130   => awaddr <= x"34"; awprot <= "000"; awvalid <= '1'; wdata <= x"37363534"; wstrb <= x"F"; wvalid <= '1'; bready <= '1';
    --            when 1131   => awaddr <= x"34"; awprot <= "000"; awvalid <= '1'; wdata <= x"37363534"; wstrb <= x"F"; wvalid <= '1'; bready <= '1';
    --            when 1132   => awaddr <= x"34"; awprot <= "000"; awvalid <= '0'; wdata <= x"37363534"; wstrb <= x"F"; wvalid <= '0'; bready <= '1';
                
    --            when 1140   => awaddr <= x"38"; awprot <= "000"; awvalid <= '1'; wdata <= x"3b3a3938"; wstrb <= x"F"; wvalid <= '1'; bready <= '1';
    --            when 1141   => awaddr <= x"38"; awprot <= "000"; awvalid <= '1'; wdata <= x"3b3a3938"; wstrb <= x"F"; wvalid <= '1'; bready <= '1';
    --            when 1142   => awaddr <= x"38"; awprot <= "000"; awvalid <= '0'; wdata <= x"3b3a3938"; wstrb <= x"F"; wvalid <= '0'; bready <= '1';
                
    --            when 1150   => awaddr <= x"3C"; awprot <= "000"; awvalid <= '1'; wdata <= x"3f3e3d3c"; wstrb <= x"F"; wvalid <= '1'; bready <= '1';
    --            when 1151   => awaddr <= x"3C"; awprot <= "000"; awvalid <= '1'; wdata <= x"3f3e3d3c"; wstrb <= x"F"; wvalid <= '1'; bready <= '1';
    --            when 1152   => awaddr <= x"3C"; awprot <= "000"; awvalid <= '0'; wdata <= x"3f3e3d3c"; wstrb <= x"F"; wvalid <= '0'; bready <= '1';

    --            --when 1003   => awaddr <= "001000"; awprot <= "000"; awvalid <= '1'; wdata <= x"83828180"; wstrb <= x"8"; wvalid <= '1'; bready <= '1';
    --            --when 1004   => awaddr <= "001000"; awprot <= "000"; awvalid <= '1'; wdata <= x"83828180"; wstrb <= x"8"; wvalid <= '1'; bready <= '1';
    --            --when 1005   => awaddr <= "001000"; awprot <= "000"; awvalid <= '0'; wdata <= x"83828180"; wstrb <= x"8"; wvalid <= '0'; bready <= '1';

    --            when others => awaddr <= awaddr; awprot <= awprot; awvalid <= '0'; wdata <= wdata; wstrb <= wstrb; wvalid <= '0'; bready <= '0';
    --        end case;
    --    end if;
    --end process;


    --write_processing : process(CLK)
    --begin
    --    if CLK'event AND CLK = '1' then 
    --        case i is 
    --            when 1000   => awaddr <= "000001"; awprot <= "000"; awvalid <= '1'; wdata <= x"83828180"; wstrb <= x"2"; wvalid <= '1'; bready <= '1';
    --            when 1001   => awaddr <= "000001"; awprot <= "000"; awvalid <= '1'; wdata <= x"83828180"; wstrb <= x"2"; wvalid <= '1'; bready <= '1';
    --            when 1002   => awaddr <= "000001"; awprot <= "000"; awvalid <= '0'; wdata <= x"83828180"; wstrb <= x"2"; wvalid <= '0'; bready <= '1';

    --            when 1003   => awaddr <= "001000"; awprot <= "000"; awvalid <= '1'; wdata <= x"83828180"; wstrb <= x"8"; wvalid <= '1'; bready <= '1';
    --            when 1004   => awaddr <= "001000"; awprot <= "000"; awvalid <= '1'; wdata <= x"83828180"; wstrb <= x"8"; wvalid <= '1'; bready <= '1';
    --            when 1005   => awaddr <= "001000"; awprot <= "000"; awvalid <= '0'; wdata <= x"83828180"; wstrb <= x"8"; wvalid <= '0'; bready <= '1';


    --            when others => awaddr <= awaddr; awprot <= awprot; awvalid <= '0'; wdata <= wdata; wstrb <= wstrb; wvalid <= '0'; bready <= '0';
    --        end case;
    --    end if;
    --end process;


    --INIT_AXI_TXN <= '1' when i > 1000 else '0';


    --m_axi_full_iface_inst : m_axi_full_iface 
    --    generic map (
    --        C_M_TARGET_SLAVE_BASE_ADDR  =>  C_M_TARGET_SLAVE_BASE_ADDR  ,
    --        C_M_AXI_BURST_LEN           =>  C_M_AXI_BURST_LEN           ,
    --        C_M_AXI_ID_WIDTH            =>  C_M_AXI_ID_WIDTH            ,
    --        C_M_AXI_ADDR_WIDTH          =>  C_M_AXI_ADDR_WIDTH          ,
    --        C_M_AXI_DATA_WIDTH          =>  C_M_AXI_DATA_WIDTH           
    --    )
    --    port map  (
    --        INIT_AXI_TXN                =>  INIT_AXI_TXN                ,
    --        M_AXI_ACLK                  =>  CLK                         ,
    --        M_AXI_ARESETN               =>  not(RESET)                  ,
    --        M_AXI_AWID                  =>  M_AXI_AWID                  ,
    --        M_AXI_AWADDR                =>  M_AXI_AWADDR                ,
    --        M_AXI_AWLEN                 =>  M_AXI_AWLEN                 ,
    --        M_AXI_AWSIZE                =>  M_AXI_AWSIZE                ,
    --        M_AXI_AWBURST               =>  M_AXI_AWBURST               ,
    --        M_AXI_AWLOCK                =>  M_AXI_AWLOCK                ,
    --        M_AXI_AWCACHE               =>  M_AXI_AWCACHE               ,
    --        M_AXI_AWPROT                =>  M_AXI_AWPROT                ,
    --        M_AXI_AWQOS                 =>  M_AXI_AWQOS                 ,
    --        M_AXI_AWVALID               =>  M_AXI_AWVALID               ,
    --        M_AXI_AWREADY               =>  M_AXI_AWREADY               ,
    --        M_AXI_WDATA                 =>  M_AXI_WDATA                 ,
    --        M_AXI_WSTRB                 =>  M_AXI_WSTRB                 ,
    --        M_AXI_WLAST                 =>  M_AXI_WLAST                 ,
    --        M_AXI_WVALID                =>  M_AXI_WVALID                ,
    --        M_AXI_WREADY                =>  M_AXI_WREADY                ,
    --        M_AXI_BID                   =>  M_AXI_BID                   ,
    --        M_AXI_BRESP                 =>  M_AXI_BRESP                 ,
    --        M_AXI_BVALID                =>  M_AXI_BVALID                ,
    --        M_AXI_BREADY                =>  M_AXI_BREADY                ,
    --        M_AXI_ARID                  =>  M_AXI_ARID                  ,
    --        M_AXI_ARADDR                =>  M_AXI_ARADDR                ,
    --        M_AXI_ARLEN                 =>  M_AXI_ARLEN                 ,
    --        M_AXI_ARSIZE                =>  M_AXI_ARSIZE                ,
    --        M_AXI_ARBURST               =>  M_AXI_ARBURST               ,
    --        M_AXI_ARLOCK                =>  M_AXI_ARLOCK                ,
    --        M_AXI_ARCACHE               =>  M_AXI_ARCACHE               ,
    --        M_AXI_ARPROT                =>  M_AXI_ARPROT                ,
    --        M_AXI_ARQOS                 =>  M_AXI_ARQOS                 ,
    --        M_AXI_ARVALID               =>  M_AXI_ARVALID               ,
    --        M_AXI_ARREADY               =>  M_AXI_ARREADY               ,
    --        M_AXI_RID                   =>  M_AXI_RID                   ,
    --        M_AXI_RDATA                 =>  M_AXI_RDATA                 ,
    --        M_AXI_RRESP                 =>  M_AXI_RRESP                 ,
    --        M_AXI_RLAST                 =>  M_AXI_RLAST                 ,
    --        M_AXI_RVALID                =>  M_AXI_RVALID                ,
    --        M_AXI_RREADY                =>  M_AXI_RREADY                 
    --    );

    --axi_full_iface_inst : axi_full_iface
    --    generic map (
    --        C_S_AXI_ID_WIDTH   => C_M_AXI_ID_WIDTH      ,
    --        C_S_AXI_DATA_WIDTH => C_M_AXI_DATA_WIDTH    ,
    --        C_S_AXI_ADDR_WIDTH => C_M_AXI_ADDR_WIDTH
    --    )
    --    port map  (
    --        S_AXI_ACLK       =>  CLK                         ,
    --        S_AXI_ARESETN    =>  not(RESET)                  ,
    --        S_AXI_AWID       =>  M_AXI_AWID                  ,
    --        S_AXI_AWADDR     =>  M_AXI_AWADDR                ,
    --        S_AXI_AWLEN      =>  M_AXI_AWLEN                 ,
    --        S_AXI_AWSIZE     =>  M_AXI_AWSIZE                ,
    --        S_AXI_AWBURST    =>  M_AXI_AWBURST               ,
    --        S_AXI_AWLOCK     =>  M_AXI_AWLOCK                ,
    --        S_AXI_AWCACHE    =>  M_AXI_AWCACHE               ,
    --        S_AXI_AWPROT     =>  M_AXI_AWPROT                ,
    --        S_AXI_AWQOS      =>  M_AXI_AWQOS                 ,
    --        S_AXI_AWVALID    =>  M_AXI_AWVALID               ,
    --        S_AXI_AWREADY    =>  M_AXI_AWREADY               ,
    --        S_AXI_WDATA      =>  M_AXI_WDATA                 ,
    --        S_AXI_WSTRB      =>  M_AXI_WSTRB                 ,
    --        S_AXI_WLAST      =>  M_AXI_WLAST                 ,
    --        S_AXI_WVALID     =>  M_AXI_WVALID                ,
    --        S_AXI_WREADY     =>  M_AXI_WREADY                ,
    --        S_AXI_BID        =>  M_AXI_BID                   ,
    --        S_AXI_BRESP      =>  M_AXI_BRESP                 ,
    --        S_AXI_BVALID     =>  M_AXI_BVALID                ,
    --        S_AXI_BREADY     =>  M_AXI_BREADY                ,
    --        S_AXI_ARID       =>  M_AXI_ARID                  ,
    --        S_AXI_ARADDR     =>  M_AXI_ARADDR                ,
    --        S_AXI_ARLEN      =>  M_AXI_ARLEN                 ,
    --        S_AXI_ARSIZE     =>  M_AXI_ARSIZE                ,
    --        S_AXI_ARBURST    =>  M_AXI_ARBURST               ,
    --        S_AXI_ARLOCK     =>  M_AXI_ARLOCK                ,
    --        S_AXI_ARCACHE    =>  M_AXI_ARCACHE               ,
    --        S_AXI_ARPROT     =>  M_AXI_ARPROT                ,
    --        S_AXI_ARQOS      =>  M_AXI_ARQOS                 ,
    --        S_AXI_ARVALID    =>  M_AXI_ARVALID               ,
    --        S_AXI_ARREADY    =>  M_AXI_ARREADY               ,
    --        S_AXI_RID        =>  M_AXI_RID                   ,
    --        S_AXI_RDATA      =>  M_AXI_RDATA                 ,
    --        S_AXI_RRESP      =>  M_AXI_RRESP                 ,
    --        S_AXI_RLAST      =>  M_AXI_RLAST                 ,
    --        S_AXI_RVALID     =>  M_AXI_RVALID                ,
    --        S_AXI_RREADY     =>  M_AXI_RREADY                 
    --    );




end architecture;