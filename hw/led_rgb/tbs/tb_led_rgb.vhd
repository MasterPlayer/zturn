library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
    use ieee.std_logic_unsigned.all;
    use ieee.std_logic_arith.all;


entity tb_led_rgb is
end tb_led_rgb;



architecture tb_led_rgb_arch of tb_led_rgb is

    signal  clk         :           std_logic                           := '0'                  ;

    signal  resetn      :           std_logic                           := '0'                  ;

    signal  i : integer := 0;

    constant CLK_PERIOD : time := 10 ns;

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


    signal  awaddr          :           std_logic_vector (  2 downto 0 ) := (others => '0')     ;
    signal  awprot          :           std_logic_vector (  2 downto 0 ) := (others => '0')     ;
    signal  awvalid         :           std_logic                        := '0'                 ;
    signal  awready         :           std_logic                           ;

    signal  wdata           :           std_logic_vector ( 31 downto 0 ) := (others => '0')     ;
    signal  wstrb           :           std_logic_vector (  3 downto 0 ) := (others => '0')     ;
    signal  wvalid          :           std_logic                        := '0'                 ;
    signal  wready          :           std_logic                           ;

    signal  bresp           :           std_logic_vector (  1 downto 0 )    ;
    signal  bvalid          :           std_logic                           ;
    signal  bready          :           std_logic                        := '0'                 ;

    signal  araddr          :           std_logic_vector (  2 downto 0 ) := (others => '0')     ;
    signal  arprot          :           std_logic_vector (  2 downto 0 ) := (others => '0')     ;
    signal  arvalid         :           std_logic                        := '0'                 ;
    signal  arready         :           std_logic                           ;

    signal  rdata           :           std_logic_vector ( 31 downto 0 )    ;
    signal  rresp           :           std_logic_vector (  1 downto 0 )    ;
    signal  rvalid          :           std_logic                           ;
    signal  rready          :           std_logic                        := '0'                 ;
    signal  LED_R           :           std_logic                           ;
    signal  LED_G           :           std_logic                           ;
    signal  LED_B           :           std_logic                            ;




begin

    CLK <= not CLK after CLK_period/2;

    i_processing : process(CLK)
    begin
        if CLK'event AND CLK = '1' then 
            i <= i + 1;
        end if;
    end process;

    resetn <= '0' when i < 10 else '1';

    axi_led_rgb_inst : axi_led_rgb 
        generic map (
            INVERSE_MODE    =>  true
        )
        port map (
            aclk            =>  CLK                         ,
            aresetn         =>  resetn                      ,

            awaddr          =>  awaddr                      ,
            awprot          =>  awprot                      ,
            awvalid         =>  awvalid                     ,
            awready         =>  awready                     ,

            wdata           =>  wdata                       ,
            wstrb           =>  wstrb                       ,
            wvalid          =>  wvalid                      ,
            wready          =>  wready                      ,

            bresp           =>  bresp                       ,
            bvalid          =>  bvalid                      ,
            bready          =>  bready                      ,

            araddr          =>  araddr                      ,
            arprot          =>  arprot                      ,
            arvalid         =>  arvalid                     ,
            arready         =>  arready                     ,

            rdata           =>  rdata                       ,
            rresp           =>  rresp                       ,
            rvalid          =>  rvalid                      ,
            rready          =>  rready                      ,
            
            LED_R           =>  LED_R                       ,
            LED_G           =>  LED_G                       ,
            LED_B           =>  LED_B                        
        );

    write_processing : process(CLK)
    begin
        if CLK'event AND CLK = '1' then 
            case i is 
                when 1000 => 
                    awaddr  <= "000";
                    awvalid <= '1';
                    wdata   <= x"00000001";
                    wvalid  <= '1';
                    bready  <= '1';

                when 1008 => 
                    awaddr  <= "001";
                    awvalid <= '1';
                    wdata   <= x"00000003";
                    wvalid  <= '1';
                    bready  <= '1';

                when 1004 => 
                    awaddr  <= "010";
                    awvalid <= '1';
                    wdata   <= x"00000010";
                    wvalid  <= '1';
                    bready  <= '1';

                --when 1012 => 
                --    awaddr  <= "011";
                --    awvalid <= '1';
                --    wdata   <= x"00000010";
                --    wvalid  <= '1';
                --    bready  <= '1';

                --when 1016 => 
                --    awaddr  <= "0100";
                --    awvalid <= '1';
                --    wdata   <= x"DEADBEE4";
                --    wvalid  <= '1';
                --    bready  <= '1';

                --when 1020 => 
                --    awaddr  <= "0101";
                --    awvalid <= '1';
                --    wdata   <= x"DEADBEE5";
                --    wvalid  <= '1';
                --    bready  <= '1';

                --when 1024 => 
                --    awaddr  <= "0110";
                --    awvalid <= '1';
                --    wdata   <= x"DEADBEE6";
                --    wvalid  <= '1';
                --    bready  <= '1';

                --when 1028 => 
                --    awaddr  <= "0111";
                --    awvalid <= '1';
                --    wdata   <= x"DEADBEE7";
                --    wvalid  <= '1';
                --    bready  <= '1';

                --when 1032 => 
                --    awaddr  <= "1000";
                --    awvalid <= '1';
                --    wdata   <= x"DEADBEE8";
                --    wvalid  <= '1';
                --    bready  <= '1';


                --when 1036 => 
                --    awaddr  <= "1001";
                --    awvalid <= '1';
                --    wdata   <= x"DEADBEE9";
                --    wvalid  <= '1';
                --    bready  <= '1';


                when 1001 | 1005 | 1009 | 1013 | 1017 | 1021 | 1025 | 1029 | 1033 | 1037 => 
                    awaddr  <= awaddr;
                    awvalid <= '0';
                    wdata   <= wdata;
                    wvalid  <= '0';
                    bready  <= '1';

                when others => 
                    awaddr  <= awaddr;
                    awvalid <= '0';
                    wdata   <= wdata;
                    wvalid  <= '0';
                    bready  <= '0';

            end case;
        end if;
    end process;

    read_processing : process(CLK)
    begin
        if CLK'event AND CLK = '1' then 
            case i is 
                when 2000 => 
                    araddr <= araddr; arvalid <= '1'; rready <= '1';

                when others => 
                    araddr <= araddr; arvalid <= '0'; rready <= '0';
            end case;
        end if;
    end process;

end tb_led_rgb_arch;
