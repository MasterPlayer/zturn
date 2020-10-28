
library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
    use ieee.std_logic_unsigned.all;
    use ieee.std_logic_arith.all;


library UNISIM;
    use UNISIM.VComponents.all;

entity tb_axis_iic_mgr is
end tb_axis_iic_mgr;



architecture Behavioral of tb_axis_iic_mgr is

    constant N_BYTES : integer := 4     ;

    component axis_iic_mgr
        generic (
            N_BYTES : integer := 32     
        ); 
        port (
            clk             :   in      std_logic                                           ;
            resetn          :   in      std_logic                                           ;
            clk_i2c         :   in      std_logic                                           ;
            s_axis_tdata    :   in      std_logic_vector ( ((N_BYTES*8)-1) downto 0 )       ;
            s_axis_tkeep    :   in      std_logic_vector (         N_BYTES-1 downto 0 )     ;
            s_axis_tuser    :   in      std_logic_vector (                 7 downto 0 )     ;
            s_axis_tvalid   :   in      std_logic                                           ;
            s_axis_tready   :   out     std_logic                                           ;
            s_axis_tlast    :   in      std_logic                                           ;
            m_axis_tdata    :   out     std_logic_vector ( ((N_BYTES*8)-1) downto 0 )       ;
            m_axis_tkeep    :   out     std_logic_vector (         N_BYTES-1 downto 0 )     ;
            m_axis_tvalid   :   out     std_logic                                           ;
            m_axis_tready   :   in      std_logic                                           ;
            m_axis_tlast    :   out     std_logic                                           ;

            SCL_I           :   in      std_logic                                           ;
            SDA_I           :   in      std_logic                                           ;
            SCL_T           :   out     std_logic                                           ;
            SDA_T           :   out     std_logic                                            
        );
    end component;

    signal  clk           :        std_logic                                       := '0'               ;
    signal  resetn        :        std_logic                                       := '0'               ;
    signal  clk_i2c       :        std_logic                                       := '0'               ;

    signal  s_axis_tdata  :        std_logic_vector ( ((N_BYTES*8)-1) downto 0 )   := (others => '0')   ;
    signal  s_axis_tkeep  :        std_logic_vector (         N_BYTES-1 downto 0 ) := (others => '0')   ;
    signal  s_axis_tuser  :        std_logic_vector (                 7 downto 0 ) := (others => '0')   ;
    signal  s_axis_tvalid :        std_logic                                       := '0'               ;
    signal  s_axis_tready :        std_logic                                                            ;
    signal  s_axis_tlast  :        std_logic                                       := '0'               ;

    signal  m_axis_tdata  :        std_logic_vector ( ((N_BYTES*8)-1) downto 0 )                        ;
    signal  m_axis_tkeep  :        std_logic_vector (         N_BYTES-1 downto 0 )                      ;
    signal  m_axis_tvalid :        std_logic                                                            ;
    signal  m_axis_tready :        std_logic                                       := '0'               ;
    signal  m_axis_tlast  :        std_logic                                                            ;

    signal  scl_i         :        std_logic                                       := '0'               ;
    signal  sda_i         :        std_logic                                       := '0'               ;
    signal  scl_t         :        std_logic                                                            ;
    signal  sda_t         :        std_logic                                                            ;

    signal  scl_io        :        std_logic    ;
    signal  sda_io        :        std_logic    ;


    constant clk_period : time := 10 ns;
    constant clk_i2c_period : time := 2500 ns;

    signal  i : integer := 0;



    component i2c_slave_controller
        port (
            SDA :  inout  std_logic ;
            SCL :  inout  std_logic  
        );
    end component;

begin

    CLK <= not CLK after clk_period/2;
    clk_i2c <= not clk_i2c after clk_period/2;

    i_processing : process(CLK)
    begin
        if CLK'event AND CLK = '1' then 
            i <= i + 1;
        end if;
    end process;

    resetn <= '0' when i < 10 else '1';

    axis_iic_mgr_inst : axis_iic_mgr
        generic map (
            N_BYTES         =>  N_BYTES     
        )
        port map  (
            clk             =>  clk                                 ,
            resetn          =>  resetn                              ,
            clk_i2c         =>  clk_i2c                             ,
            s_axis_tdata    =>  s_axis_tdata                        ,
            s_axis_tkeep    =>  s_axis_tkeep                        ,
            s_axis_tuser    =>  s_axis_tuser                        ,
            s_axis_tvalid   =>  s_axis_tvalid                       ,
            s_axis_tready   =>  s_axis_tready                       ,
            s_axis_tlast    =>  s_axis_tlast                        ,
            m_axis_tdata    =>  m_axis_tdata                        ,
            m_axis_tkeep    =>  m_axis_tkeep                        ,
            m_axis_tvalid   =>  m_axis_tvalid                       ,
            m_axis_tready   =>  m_axis_tready                       ,
            m_axis_tlast    =>  m_axis_tlast                        ,

            SCL_I           =>  SCL_I                               ,
            SDA_I           =>  SDA_I                               ,
            SCL_T           =>  SCL_T                               ,
            SDA_T           =>  SDA_T                                
        );



    i2c_slave_controller_inst : i2c_slave_controller
        port map (
            SCL             =>  SCL_IO          ,
            SDA             =>  SDA_IO           
        );

    scl_iobuf_inst : IOBUF
        generic map (
            DRIVE           =>  12,
            IOSTANDARD      =>  "DEFAULT",
            SLEW            =>  "SLOW"
        )
        port map (
            O               =>  SCL_I                               ,     -- Buffer output
            IO              =>  SCL_IO                              ,   -- Buffer inout port (connect directly to top-level port)
            I               =>  '0'                                 ,     -- Buffer input
            T               =>  SCL_T                                     -- 3-state enable input, high=input, low=output 
        );


    sda_iobuf_inst : IOBUF
        generic map (
            DRIVE           =>  12,
            IOSTANDARD      =>  "DEFAULT",
            SLEW            =>  "SLOW"
        )
        port map (
            O               =>  SDA_I                               ,     -- Buffer output
            IO              =>  SDA_IO                              ,   -- Buffer inout port (connect directly to top-level port)
            I               =>  '0'                                 ,     -- Buffer input
            T               =>  SDA_T                                     -- 3-state enable input, high=input, low=output 
        );



    s_axis_processing : process(CLK)
    begin
        if CLK'event aND CLK = '1' then 
            case i is 
                when 100    => s_axis_tdata <= x"03020100"; s_axis_tvalid <= '1'; s_axis_tlast <= '1'; s_axis_tuser <= x"A5";
                when others => s_axis_tdata <= s_axis_tdata; s_axis_tvalid <= '0'; s_axis_tlast <= s_axis_tlast; s_axis_tuser <= s_axis_tuser;
            end case;   
        end if;
    end process;


end Behavioral;
