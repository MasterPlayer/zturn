library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
    use ieee.std_logic_unsigned.all;
    use ieee.std_logic_arith.all;


entity axi_sw_ctrlr_vhd is
    port (
        S_AXI_ACLK          :   in      std_logic                           ;
        S_AXI_ARESETN       :   in      std_logic                           ;

        S_AXI_AWADDR        :   in      std_logic_vector (  3 downto 0 )    ;
        S_AXI_AWPROT        :   in      std_logic_vector (  2 downto 0 )    ;
        S_AXI_AWVALID       :   in      std_logic                           ;
        S_AXI_AWREADY       :   out     std_logic                           ;

        S_AXI_WDATA         :   in      std_logic_vector ( 31 downto 0 )    ;
        S_AXI_WSTRB         :   in      std_logic_vector (  3 downto 0 )    ;
        S_AXI_WVALID        :   in      std_logic                           ;
        S_AXI_WREADY        :   out     std_logic                           ;

        S_AXI_BRESP         :   out     std_logic_vector (  1 downto 0 )    ;
        S_AXI_BVALID        :   out     std_logic                           ;
        S_AXI_BREADY        :   in      std_logic                           ;

        S_AXI_ARADDR        :   in      std_logic_vector (  3 downto 0 )    ;
        S_AXI_ARPROT        :   in      std_logic_vector (  2 downto 0 )    ;
        S_AXI_ARVALID       :   in      std_logic                           ;
        S_AXI_ARREADY       :   out     std_logic                           ;

        S_AXI_RDATA         :   out     std_logic_vector ( 31 downto 0 )    ;
        S_AXI_RRESP         :   out     std_logic_vector (  1 downto 0 )    ;
        S_AXI_RVALID        :   out     std_logic                           ;
        S_AXI_RREADY        :   in      std_logic                           ;

        IRQ                 :   out     std_logic                           ;
        SW                  :   in      std_logic_vector (  3 downto 0 )     

    );
end axi_sw_ctrlr_vhd;



architecture axi_sw_ctrlr_vhd_arch of axi_sw_ctrlr_vhd is

    ATTRIBUTE X_INTERFACE_INFO : STRING;
    ATTRIBUTE X_INTERFACE_INFO of IRQ: SIGNAL is "xilinx.com:signal:interrupt:1.0 IRQ INTERRUPT";
    -- Supported parameter: SENSITIVITY { LEVEL_HIGH, LEVEL_LOW, EDGE_RISING, EDGE_FALLING }
    -- Normally LEVEL_HIGH is assumed.  Use this parameter to force the level
    ATTRIBUTE X_INTERFACE_PARAMETER : STRING;
    ATTRIBUTE X_INTERFACE_PARAMETER of IRQ: SIGNAL is "SENSITIVITY LEVEL_HIGH";

    component axi_sw_ctrlr 
        port (
            aclk        :   in      std_logic                                                   ;
            aresetn     :   in      std_logic                                                   ;
            awaddr      :   in      std_logic_vector (  3 downto 0 )                            ;
            awprot      :   in      std_logic_vector (  2 downto 0 )                            ;
            awvalid     :   in      std_logic                                                   ;
            awready     :   out     std_logic                                                   ;
            wdata       :   in      std_logic_vector ( 31 downto 0 )                            ;
            wstrb       :   in      std_logic_vector (  3 downto 0 )                            ;
            wvalid      :   in      std_logic                                                   ;
            wready      :   out     std_logic                                                   ;
            bresp       :   out     std_logic_vector (  1 downto 0 )                            ;
            bvalid      :   out     std_logic                                                   ;
            bready      :   in      std_logic                                                   ;
            araddr      :   in      std_logic_vector (  3 downto 0 )                            ;
            arprot      :   in      std_logic_vector (  2 downto 0 )                            ;
            arvalid     :   in      std_logic                                                   ;
            arready     :   out     std_logic                                                   ;
            rdata       :   out     std_logic_vector ( 31 downto 0 )                            ;
            rresp       :   out     std_logic_vector (  1 downto 0 )                            ;
            rvalid      :   out     std_logic                                                   ;
            rready      :   in      std_logic                                                   ;
            IRQ         :   out     std_logic                                                   ;
            SW          :   in      std_logic_vector (  3 downto 0 )                             
        );
    end component;


begin

    axi_sw_ctrlr_inst : axi_sw_ctrlr 
        port map (
            aclk        =>  S_AXI_ACLK                                  ,
            aresetn     =>  S_AXI_ARESETN                               ,
            awaddr      =>  S_AXI_AWADDR                                ,
            awprot      =>  S_AXI_AWPROT                                ,
            awvalid     =>  S_AXI_AWVALID                               ,
            awready     =>  S_AXI_AWREADY                               ,
            wdata       =>  S_AXI_WDATA                                 ,
            wstrb       =>  S_AXI_WSTRB                                 ,
            wvalid      =>  S_AXI_WVALID                                ,
            wready      =>  S_AXI_WREADY                                ,
            bresp       =>  S_AXI_BRESP                                 ,
            bvalid      =>  S_AXI_BVALID                                ,
            bready      =>  S_AXI_BREADY                                ,
            araddr      =>  S_AXI_ARADDR                                ,
            arprot      =>  S_AXI_ARPROT                                ,
            arvalid     =>  S_AXI_ARVALID                               ,
            arready     =>  S_AXI_ARREADY                               ,
            rdata       =>  S_AXI_RDATA                                 ,
            rresp       =>  S_AXI_RRESP                                 ,
            rvalid      =>  S_AXI_RVALID                                ,
            rready      =>  S_AXI_RREADY                                ,
            IRQ         =>  IRQ                                         ,
            SW          =>  SW                                           
        );


end axi_sw_ctrlr_vhd_arch;
