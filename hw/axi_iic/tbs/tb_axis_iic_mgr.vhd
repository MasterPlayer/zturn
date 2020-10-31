
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

    signal  SCL_I         :        std_logic                                       := '0'               ;
    signal  SDA_I         :        std_logic                                       := '0'               ;
    signal  SCL_T         :        std_logic                                                            ;
    signal  SDA_T         :        std_logic                                                            ;

    signal  SCL_IO        :        std_logic    ;
    signal  SDA_IO        :        std_logic    ;


    constant clk_period : time := 10 ns;
    constant clk_i2c_period : time := 2500 ns;

    signal  i : integer := 0;


    component i2c_controller 
        port (
            clk         :   in      std_logic                               ;
            rst         :   in      std_logic                               ;
            addr        :   in      std_logic_vector ( 6 downto 0 )         ;
            data_in     :   in      std_logic_vector ( 7 downto 0 )         ;
            enable      :   in      std_logic                               ;
            rw          :   in      std_logic                               ;
            data_out    :   out     std_logic_vector ( 7 downto 0 )         ;
            ready       :   out     std_logic                               ;
            i2c_sda     :   inout   std_logic                               ;
            i2c_scl     :   inout   std_logic                                
        );
    end component;

    signal  clk         :         std_logic                       := '0'                ;
    signal  rst         :         std_logic                       := '0'                ;
    signal  addr        :         std_logic_vector ( 6 downto 0 ) := (others => '0')    ;
    signal  data_in     :         std_logic_vector ( 7 downto 0 ) := (others => '0')    ;
    signal  enable      :         std_logic                       := '0'                ;
    signal  rw          :         std_logic                       := '0'                ;
    signal  data_out    :         std_logic_vector ( 7 downto 0 )                       ;
    signal  ready       :         std_logic                                             ;
    signal  i2c_sda     :         std_logic                                             ;
    signal  i2c_scl     :         std_logic                                             ;


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
    rst <= not resetn;

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



    --i2c_slave_controller_inst : i2c_slave_controller
    --    port map (
    --        SCL             =>  i2c_scl ,--SCL_IO          ,
    --        SDA             =>  i2c_sda  --SDA_IO           
    --    );


    --i2c_slave_controller_inst : i2c_slave_controller
    --    port map (
    --        SCL             =>  SCL_IO          ,
    --        SDA             =>  SDA_IO           
    --    );


    --scl_iobuf_inst : IOBUF
    --    --generic map (
    --    --    DRIVE           =>  12,
    --    --    IOSTANDARD      =>  "DEFAULT",
    --    --    SLEW            =>  "SLOW"
    --    --)
    --    port map (
    --        O               =>  SCL_I                               ,     -- Buffer output
    --        IO              =>  '1'                                 ,   -- Buffer inout port (connect directly to top-level port)
    --        I               =>  '0'                                 ,     -- Buffer input
    --        T               =>  SCL_T                                     -- 3-state enable input, high=input, low=output 
    --    );


    --sda_iobuf_inst : IOBUF
    --    --generic map (
    --    --    DRIVE           =>  12,
    --    --    IOSTANDARD      =>  "DEFAULT",
    --    --    SLEW            =>  "SLOW"
    --    --)
    --    port map (
    --        O               =>  SDA_I                               ,     -- Buffer output
    --        IO              =>  '1'                                 ,   -- Buffer inout port (connect directly to top-level port)
    --        I               =>  '0'                                 ,     -- Buffer input
    --        T               =>  SDA_T                                     -- 3-state enable input, high=input, low=output 
    --    );


    --i2c_controller_inst : i2c_controller 
    --    port map (
    --        clk         =>  clk                     ,
    --        rst         =>  rst                     ,
    --        addr        =>  addr                    ,
    --        data_in     =>  data_in                 ,
    --        enable      =>  enable                  ,
    --        rw          =>  rw                      ,
    --        data_out    =>  data_out                ,
    --        ready       =>  ready                   ,
    --        i2c_sda     =>  i2c_sda                 ,
    --        i2c_scl     =>  i2c_scl                  
    --    );

    --addr <= "0101010";

    --test_processing : process(CLK)
    --begin
    --    if CLK'event AND CLK = '1' then 
    --        if i = 100 then 
    --            data_in <= x"11"; enable <= '1'; RW <= '0';
    --        else
    --            data_in <= data_in; enable <= enable; RW <= RW;
    --        end if;
    --    end if;
    --end process;


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
