library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
    use ieee.std_logic_unsigned.all;
    use ieee.std_logic_arith.all;


entity axi_led_rgb_vhd is
    generic (
        INVERSE_MODE    :           boolean := true
    );
    port (
        aclk            :   in      std_logic                           ;
        aresetn         :   in      std_logic                           ;

        awaddr          :   in      std_logic_vector (  2 downto 0 )    ;
        awprot          :   in      std_logic_vector (  2 downto 0 )    ;
        awvalid         :   in      std_logic                           ;
        awready         :   out     std_logic                           ;

        wdata           :   in      std_logic_vector ( 31 downto 0 )    ;
        wstrb           :   in      std_logic_vector (  3 downto 0 )    ;
        wvalid          :   in      std_logic                           ;
        wready          :   out     std_logic                           ;

        bresp           :   out     std_logic_vector (  1 downto 0 )    ;
        bvalid          :   out     std_logic                           ;
        bready          :   in      std_logic                           ;

        araddr          :   in      std_logic_vector (  2 downto 0 )    ;
        arprot          :   in      std_logic_vector (  2 downto 0 )    ;
        arvalid         :   in      std_logic                           ;
        arready         :   out     std_logic                           ;

        rdata           :   out     std_logic_vector ( 31 downto 0 )    ;
        rresp           :   out     std_logic_vector (  1 downto 0 )    ;
        rvalid          :   out     std_logic                           ;
        rready          :   in      std_logic                           ;
        LED_R           :   out     std_logic                           ;
        LED_G           :   out     std_logic                           ;
        LED_B           :   out     std_logic                            
    );
end axi_led_rgb_vhd;



architecture axi_led_rgb_vhd_arch of axi_led_rgb_vhd is

    component axi_led_rgb 
        generic (
            INVERSE_MODE    :           boolean := true
        );
        port (
            aclk            :   in      std_logic                           ;
            aresetn         :   in      std_logic                           ;

            awaddr          :   in      std_logic_vector (  2 downto 0 )    ;
            awprot          :   in      std_logic_vector (  2 downto 0 )    ;
            awvalid         :   in      std_logic                           ;
            awready         :   out     std_logic                           ;

            wdata           :   in      std_logic_vector ( 31 downto 0 )    ;
            wstrb           :   in      std_logic_vector (  3 downto 0 )    ;
            wvalid          :   in      std_logic                           ;
            wready          :   out     std_logic                           ;

            bresp           :   out     std_logic_vector (  1 downto 0 )    ;
            bvalid          :   out     std_logic                           ;
            bready          :   in      std_logic                           ;

            araddr          :   in      std_logic_vector (  2 downto 0 )    ;
            arprot          :   in      std_logic_vector (  2 downto 0 )    ;
            arvalid         :   in      std_logic                           ;
            arready         :   out     std_logic                           ;

            rdata           :   out     std_logic_vector ( 31 downto 0 )    ;
            rresp           :   out     std_logic_vector (  1 downto 0 )    ;
            rvalid          :   out     std_logic                           ;
            rready          :   in      std_logic                           ;
            LED_R           :   out     std_logic                           ;
            LED_G           :   out     std_logic                           ;
            LED_B           :   out     std_logic                            
        );
    end component;

begin


    axi_led_rgb_inst : axi_led_rgb 
        generic map (
            INVERSE_MODE    =>  INVERSE_MODE                                
        )
        port map (
            aclk            =>  aclk                                        ,
            aresetn         =>  aresetn                                     ,

            awaddr          =>  awaddr                                      ,
            awprot          =>  awprot                                      ,
            awvalid         =>  awvalid                                     ,
            awready         =>  awready                                     ,

            wdata           =>  wdata                                       ,
            wstrb           =>  wstrb                                       ,
            wvalid          =>  wvalid                                      ,
            wready          =>  wready                                      ,

            bresp           =>  bresp                                       ,
            bvalid          =>  bvalid                                      ,
            bready          =>  bready                                      ,

            araddr          =>  araddr                                      ,
            arprot          =>  arprot                                      ,
            arvalid         =>  arvalid                                     ,
            arready         =>  arready                                     ,

            rdata           =>  rdata                                       ,
            rresp           =>  rresp                                       ,
            rvalid          =>  rvalid                                      ,
            rready          =>  rready                                      ,
            LED_R           =>  LED_R                                       ,
            LED_G           =>  LED_G                                       ,
            LED_B           =>  LED_B                                        
        );


end axi_led_rgb_vhd_arch;
