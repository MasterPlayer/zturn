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


    component axi_adxl345 
        generic (
            DEFAULT_REQUEST_INTERVAL : integer := 10000     ;
            DEFAULT_BW_RATE          : integer := 10        ;
            DEFAULT_I2C_ADDRESS      : std_logic_Vector ( 7 downto  0)  := x"A6"  
        ); 
        port (
            aclk      : in    std_logic                             ;
            aresetn   : in    std_logic                             ;
            awaddr    : in    std_logic_vector (  5 downto 0 )      ;
            awprot    : in    std_logic_vector (  2 downto 0 )      ;
            awvalid   : in    std_logic                             ;
            awready   : out   std_logic                             ;
            wdata     : in    std_logic_vector ( 31 downto 0 )      ;
            wstrb     : in    std_logic_vector (  3 downto 0 )      ;
            wvalid    : in    std_logic                             ;
            wready    : out   std_logic                             ;
            bresp     : out   std_logic_vector (  1 downto 0 )      ;
            bvalid    : out   std_logic                             ;
            bready    : in    std_logic                             ;
            araddr    : in    std_logic_vector (  5 downto 0 )      ;
            arprot    : in    std_logic_vector (  2 downto 0 )      ;
            arvalid   : in    std_logic                             ;
            arready   : out   std_logic                             ;
            rdata     : out   std_logic_vector ( 31 downto 0 )      ;
            rresp     : out   std_logic_vector (  1 downto 0 )      ;
            rvalid    : out   std_logic                             ;
            rready    : in    std_logic                      
        );
    end component;

begin 

    CLK <= not CLK after clock_period/2;

    i_processing : process(CLK)
    begin
        if CLK'event AND CLK = '1' then 
            i <= i + 1;
        end if;
    end process;

    reset <= '1' when i < 5 else '0';



end architecture;