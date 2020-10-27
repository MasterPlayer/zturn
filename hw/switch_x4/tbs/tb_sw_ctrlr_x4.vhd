library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
    use ieee.std_logic_unsigned.all;
    use ieee.std_logic_arith.all;


entity tb_sw_ctrlr_x4 is
end tb_sw_ctrlr_x4;



architecture tb_sw_ctrlr_x4_arch of tb_sw_ctrlr_x4 is



    signal  i : integer := 0;

    constant CLK_PERIOD : time := 10 ns;

    component axi_sw_ctrlr_vhd
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
    end component;

    signal  CLK          :           std_logic                        := '0'                 ;
    signal  RESETN       :           std_logic                        := '0'                 ;

    signal  S_AXI_AWADDR        :           std_logic_vector (  3 downto 0 ) := (others => '0')     ;
    signal  S_AXI_AWPROT        :           std_logic_vector (  2 downto 0 ) := (others => '0')     ;
    signal  S_AXI_AWVALID       :           std_logic                        := '0'                 ;
    signal  S_AXI_AWREADY       :           std_logic                           ;

    signal  S_AXI_WDATA         :           std_logic_vector ( 31 downto 0 ) := (others => '0')     ;
    signal  S_AXI_WSTRB         :           std_logic_vector (  3 downto 0 ) := (others => '0')     ;
    signal  S_AXI_WVALID        :           std_logic                        := '0'                 ;
    signal  S_AXI_WREADY        :           std_logic                           ;

    signal  S_AXI_BRESP         :           std_logic_vector (  1 downto 0 )    ;
    signal  S_AXI_BVALID        :           std_logic                           ;
    signal  S_AXI_BREADY        :           std_logic                        := '0'                 ;

    signal  S_AXI_ARADDR        :           std_logic_vector (  3 downto 0 ) := (others => '0')     ;
    signal  S_AXI_ARPROT        :           std_logic_vector (  2 downto 0 ) := (others => '0')     ;
    signal  S_AXI_ARVALID       :           std_logic                        := '0'                 ;
    signal  S_AXI_ARREADY       :           std_logic                           ;

    signal  S_AXI_RDATA         :           std_logic_vector ( 31 downto 0 )    ;
    signal  S_AXI_RRESP         :           std_logic_vector (  1 downto 0 )    ;
    signal  S_AXI_RVALID        :           std_logic                           ;
    signal  S_AXI_RREADY        :           std_logic                        := '0'                 ;

    signal  IRQ                 :           std_logic                           ;
    signal  SW                  :           std_logic_vector (  3 downto 0 ) := (others => '0')     ;




    component switch_ctrlr_x4_filter 
        port (
            clk    : in     std_logic                               ;
            resetn :    in      std_logic                               ;
            SW     : in     std_logic_vector ( 3 downto 0 )         ;
            SW_F   : out    std_logic_vector ( 3 downto 0 )          
        );
    end component;





begin

    CLK <= not CLK after CLK_period/2;

    i_processing : process(CLK)
    begin
        if CLK'event AND CLK = '1' then 
            i <= i + 1;
        end if;
    end process;

    resetn <= '0' when i < 10 else '1';

    axi_sw_ctrlr_vhd_inst : axi_sw_ctrlr_vhd
        port map (
            S_AXI_ACLK          =>  CLK                              ,
            S_AXI_ARESETN       =>  RESETN                           ,

            S_AXI_AWADDR        =>  S_AXI_AWADDR                            ,
            S_AXI_AWPROT        =>  S_AXI_AWPROT                            ,
            S_AXI_AWVALID       =>  S_AXI_AWVALID                           ,
            S_AXI_AWREADY       =>  S_AXI_AWREADY                           ,

            S_AXI_WDATA         =>  S_AXI_WDATA                             ,
            S_AXI_WSTRB         =>  S_AXI_WSTRB                             ,
            S_AXI_WVALID        =>  S_AXI_WVALID                            ,
            S_AXI_WREADY        =>  S_AXI_WREADY                            ,

            S_AXI_BRESP         =>  S_AXI_BRESP                             ,
            S_AXI_BVALID        =>  S_AXI_BVALID                            ,
            S_AXI_BREADY        =>  S_AXI_BREADY                            ,

            S_AXI_ARADDR        =>  S_AXI_ARADDR                            ,
            S_AXI_ARPROT        =>  S_AXI_ARPROT                            ,
            S_AXI_ARVALID       =>  S_AXI_ARVALID                           ,
            S_AXI_ARREADY       =>  S_AXI_ARREADY                           ,

            S_AXI_RDATA         =>  S_AXI_RDATA                             ,
            S_AXI_RRESP         =>  S_AXI_RRESP                             ,
            S_AXI_RVALID        =>  S_AXI_RVALID                            ,
            S_AXI_RREADY        =>  S_AXI_RREADY                            ,

            IRQ                 =>  IRQ                                     ,
            SW                  =>  SW                                       
        );


    SW <= "0001" when (i > 2000 and i < 2200) or i > 3000 else "0000" ;





    switch_ctrlr_x4_filter_inst : switch_ctrlr_x4_filter 
        port map (
            clk    =>  CLK                              , 
            resetn =>  resetn                           ,
            SW     =>  SW                               ,
            SW_F   =>  open 
        );


    s_axi_processing : process(CLK)
    begin
        if CLK'event AND CLK = '1' then 

            if i = 900 then 
                S_AXI_AWADDR <= "1000"; S_AXI_AWVALID <= '1'; S_AXI_WDATA <= x"0000000F"; S_AXI_WSTRB <= x"F"; S_AXI_WVALID <= '1'; S_AXI_BREADY <= '1';
            elsif i = 1000 then 
                S_AXI_AWADDR <= "0000"; S_AXI_AWVALID <= '1'; S_AXI_WDATA <= x"00000001"; S_AXI_WSTRB <= x"F"; S_AXI_WVALID <= '1'; S_AXI_BREADY <= '1';
            else

                if S_AXI_AWREADY = '1' and S_AXI_AWVALID = '1' then 
                    S_AXI_AWVALID <= '0';
                else
                    S_AXI_AWVALID <= S_AXI_AWVALID;
                end if;

                if S_AXI_WVALID = '1' and S_AXI_WREADY = '1' then 
                    S_AXI_WVALID <= '0';
                else
                    S_AXI_WVALID <= S_AXI_WVALID;
                end if;

                if S_AXI_BVALID = '1' and S_AXI_BREADY = '1' then 
                    S_AXI_BREADY <= '0';
                else
                    S_AXI_BREADY <= S_AXI_BREADY;
                end if;

            end if;
        end if;
    end process;

end tb_sw_ctrlr_x4_arch;
