library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
    use ieee.std_logic_unsigned.all;
    use ieee.std_logic_arith.all;


entity axi_adxl345_vhd is
    generic (
        C_S_AXI_LITE_DATA_WIDTH : integer                         := 32                                         ;
        C_S_AXI_LITE_ADDR_WIDTH : integer                         := 6                                          ;
        DEVICE_ADDRESS          : std_logic_Vector ( 6 downto 0 ) := "1010011"                                  ;
        REQUEST_INTERVAL        : integer                         := 1000                                        
    ); 
    port (
        S_AXI_LITE_ACLK         :   in      std_Logic                                                           ;
        S_AXI_LITE_ARESETN      :   in      std_Logic                                                           ;
        S_AXI_LITE_AWADDR       :   in      std_Logic_vector (     C_S_AXI_LITE_ADDR_WIDTH-1 downto 0 )         ;
        S_AXI_LITE_AWPROT       :   in      std_Logic_vector (                             2 downto 0 )         ;
        S_AXI_LITE_AWVALID      :   in      std_Logic                                                           ;
        S_AXI_LITE_AWREADY      :   out     std_Logic                                                           ;
        S_AXI_LITE_WDATA        :   in      std_Logic_vector (     C_S_AXI_LITE_DATA_WIDTH-1 downto 0 )         ;
        S_AXI_LITE_WSTRB        :   in      std_Logic_vector ( (C_S_AXI_LITE_DATA_WIDTH/8)-1 downto 0 )         ;
        S_AXI_LITE_WVALID       :   in      std_Logic                                                           ;
        S_AXI_LITE_WREADY       :   out     std_Logic                                                           ;
        S_AXI_LITE_BRESP        :   out     std_Logic_vector (                             1 downto 0 )         ;
        S_AXI_LITE_BVALID       :   out     std_Logic                                                           ;
        S_AXI_LITE_BREADY       :   in      std_Logic                                                           ;
        S_AXI_LITE_ARADDR       :   in      std_Logic_vector (     C_S_AXI_LITE_ADDR_WIDTH-1 downto 0 )         ;
        S_AXI_LITE_ARPROT       :   in      std_Logic_vector (                             2 downto 0 )         ;
        S_AXI_LITE_ARVALID      :   in      std_Logic                                                           ;
        S_AXI_LITE_ARREADY      :   out     std_Logic                                                           ;
        S_AXI_LITE_RDATA        :   out     std_Logic_vector (     C_S_AXI_LITE_DATA_WIDTH-1 downto 0 )         ;
        S_AXI_LITE_RRESP        :   out     std_Logic_vector (                             1 downto 0 )         ;
        S_AXI_LITE_RVALID       :   out     std_Logic                                                           ;
        S_AXI_LITE_RREADY       :   in      std_Logic                                                           ;

        M_AXIS_TDATA            :   out     std_Logic_vector (                             7 downto 0 )         ;
        M_AXIS_TKEEP            :   out     std_Logic_vector (                             0 downto 0 )         ;
        M_AXIS_TUSER            :   out     std_Logic_vector (                             7 downto 0 )         ;
        M_AXIS_TVALID           :   out     std_Logic                                                           ;
        M_AXIS_TLAST            :   out     std_Logic                                                           ;
        M_AXIS_TREADY           :   in      std_Logic                                                           ;

        S_AXIS_TDATA            :   in      std_Logic_vector (                             7 downto 0 )         ;
        S_AXIS_TKEEP            :   in      std_Logic_vector (                             0 downto 0 )         ;
        S_AXIS_TUSER            :   in      std_Logic_vector (                             7 downto 0 )         ;
        S_AXIS_TVALID           :   in      std_Logic                                                           ;
        S_AXIS_TLAST            :   in      std_Logic                                                           ;
        S_AXIS_TREADY           :   out     std_Logic                                                         
    );
end axi_adxl345_vhd;



architecture axi_adxl345_vhd_arch of axi_adxl345_vhd is

    component axi_adxl345 
        generic (
            C_S_AXI_LITE_DATA_WIDTH : integer                         := 32                                         ;
            C_S_AXI_LITE_ADDR_WIDTH : integer                         := 6                                          ;
            DEVICE_ADDRESS          : std_logic_Vector ( 6 downto 0 ) := "1010011"                                  ;
            REQUEST_INTERVAL        : integer                         := 1000                                        
        ); 
        port (
            S_AXI_LITE_ACLK         :   in      std_Logic                                                           ;
            S_AXI_LITE_ARESETN      :   in      std_Logic                                                           ;
            S_AXI_LITE_AWADDR       :   in      std_Logic_vector (     C_S_AXI_LITE_ADDR_WIDTH-1 downto 0 )         ;
            S_AXI_LITE_AWPROT       :   in      std_Logic_vector (                             2 downto 0 )         ;
            S_AXI_LITE_AWVALID      :   in      std_Logic                                                           ;
            S_AXI_LITE_AWREADY      :   out     std_Logic                                                           ;
            S_AXI_LITE_WDATA        :   in      std_Logic_vector (     C_S_AXI_LITE_DATA_WIDTH-1 downto 0 )         ;
            S_AXI_LITE_WSTRB        :   in      std_Logic_vector ( (C_S_AXI_LITE_DATA_WIDTH/8)-1 downto 0 )         ;
            S_AXI_LITE_WVALID       :   in      std_Logic                                                           ;
            S_AXI_LITE_WREADY       :   out     std_Logic                                                           ;
            S_AXI_LITE_BRESP        :   out     std_Logic_vector (                             1 downto 0 )         ;
            S_AXI_LITE_BVALID       :   out     std_Logic                                                           ;
            S_AXI_LITE_BREADY       :   in      std_Logic                                                           ;
            S_AXI_LITE_ARADDR       :   in      std_Logic_vector (     C_S_AXI_LITE_ADDR_WIDTH-1 downto 0 )         ;
            S_AXI_LITE_ARPROT       :   in      std_Logic_vector (                             2 downto 0 )         ;
            S_AXI_LITE_ARVALID      :   in      std_Logic                                                           ;
            S_AXI_LITE_ARREADY      :   out     std_Logic                                                           ;
            S_AXI_LITE_RDATA        :   out     std_Logic_vector (     C_S_AXI_LITE_DATA_WIDTH-1 downto 0 )         ;
            S_AXI_LITE_RRESP        :   out     std_Logic_vector (                             1 downto 0 )         ;
            S_AXI_LITE_RVALID       :   out     std_Logic                                                           ;
            S_AXI_LITE_RREADY       :   in      std_Logic                                                           ;
            
            M_AXIS_TDATA            :   out     std_Logic_vector (                             7 downto 0 )         ;
            M_AXIS_TKEEP            :   out     std_Logic_vector (                             0 downto 0 )         ;
            M_AXIS_TUSER            :   out     std_Logic_vector (                             7 downto 0 )         ;
            M_AXIS_TVALID           :   out     std_Logic                                                           ;
            M_AXIS_TLAST            :   out     std_Logic                                                           ;
            M_AXIS_TREADY           :   in      std_Logic                                                           ;

            S_AXIS_TDATA            :   in      std_Logic_vector (                             7 downto 0 )         ;
            S_AXIS_TKEEP            :   in      std_Logic_vector (                             0 downto 0 )         ;
            S_AXIS_TUSER            :   in      std_Logic_vector (                             7 downto 0 )         ;
            S_AXIS_TVALID           :   in      std_Logic                                                           ;
            S_AXIS_TLAST            :   in      std_Logic                                                           ;
            S_AXIS_TREADY           :   out     std_Logic                                                         
    );
    end component;


begin

    axi_adxl345_inst : axi_adxl345 
        generic map (
            C_S_AXI_LITE_DATA_WIDTH =>  32                          ,
            C_S_AXI_LITE_ADDR_WIDTH =>  6                           ,
            DEVICE_ADDRESS          =>  "1010011"                   ,
            REQUEST_INTERVAL        =>  1000                         
        )
        port map (
            S_AXI_LITE_ACLK         =>  S_AXI_LITE_ACLK             ,
            S_AXI_LITE_ARESETN      =>  S_AXI_LITE_ARESETN          ,
            S_AXI_LITE_AWADDR       =>  S_AXI_LITE_AWADDR           ,
            S_AXI_LITE_AWPROT       =>  S_AXI_LITE_AWPROT           ,
            S_AXI_LITE_AWVALID      =>  S_AXI_LITE_AWVALID          ,
            S_AXI_LITE_AWREADY      =>  S_AXI_LITE_AWREADY          ,
            S_AXI_LITE_WDATA        =>  S_AXI_LITE_WDATA            ,
            S_AXI_LITE_WSTRB        =>  S_AXI_LITE_WSTRB            ,
            S_AXI_LITE_WVALID       =>  S_AXI_LITE_WVALID           ,
            S_AXI_LITE_WREADY       =>  S_AXI_LITE_WREADY           ,
            S_AXI_LITE_BRESP        =>  S_AXI_LITE_BRESP            ,
            S_AXI_LITE_BVALID       =>  S_AXI_LITE_BVALID           ,
            S_AXI_LITE_BREADY       =>  S_AXI_LITE_BREADY           ,
            S_AXI_LITE_ARADDR       =>  S_AXI_LITE_ARADDR           ,
            S_AXI_LITE_ARPROT       =>  S_AXI_LITE_ARPROT           ,
            S_AXI_LITE_ARVALID      =>  S_AXI_LITE_ARVALID          ,
            S_AXI_LITE_ARREADY      =>  S_AXI_LITE_ARREADY          ,
            S_AXI_LITE_RDATA        =>  S_AXI_LITE_RDATA            ,
            S_AXI_LITE_RRESP        =>  S_AXI_LITE_RRESP            ,
            S_AXI_LITE_RVALID       =>  S_AXI_LITE_RVALID           ,
            S_AXI_LITE_RREADY       =>  S_AXI_LITE_RREADY           ,
            
            M_AXIS_TDATA            =>  M_AXIS_TDATA                ,
            M_AXIS_TKEEP            =>  M_AXIS_TKEEP                ,
            M_AXIS_TUSER            =>  M_AXIS_TUSER                ,
            M_AXIS_TVALID           =>  M_AXIS_TVALID               ,
            M_AXIS_TLAST            =>  M_AXIS_TLAST                ,
            M_AXIS_TREADY           =>  M_AXIS_TREADY               ,

            S_AXIS_TDATA            =>  S_AXIS_TDATA                ,
            S_AXIS_TKEEP            =>  S_AXIS_TKEEP                ,
            S_AXIS_TUSER            =>  S_AXIS_TUSER                ,
            S_AXIS_TVALID           =>  S_AXIS_TVALID               ,
            S_AXIS_TLAST            =>  S_AXIS_TLAST                ,
            S_AXIS_TREADY           =>  S_AXIS_TREADY                
        );


end axi_adxl345_vhd_arch;
