
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
            CLK_PERIOD          :           integer     :=  100000000                           ;
            CLK_I2C_PERIOD      :           integer     :=  400000                              ;
            N_BYTES             :           integer     :=  32                                  
        ); 
        port (
            clk                 :   in      std_logic                                           ;
            resetn              :   in      std_logic                                           ;
            
            s_axis_cmd_tdata    :   in      std_logic_vector ( 15 downto 0 )                    ;
            s_axis_cmd_tvalid   :   in      std_logic                                           ;
            s_axis_cmd_tready   :   out     std_logic                                           ;

            s_axis_tdata        :   in      std_logic_vector ( ((N_BYTES*8)-1) downto 0 )       ;
            s_axis_tkeep        :   in      std_logic_vector (         N_BYTES-1 downto 0 )     ;
            s_axis_tvalid       :   in      std_logic                                           ;
            s_axis_tready       :   out     std_logic                                           ;
            s_axis_tlast        :   in      std_logic                                           ;

            m_axis_tdata        :   out     std_logic_vector ( ((N_BYTES*8)-1) downto 0 )       ;
            m_axis_tkeep        :   out     std_logic_vector (         N_BYTES-1 downto 0 )     ;
            m_axis_tvalid       :   out     std_logic                                           ;
            m_axis_tready       :   in      std_logic                                           ;
            m_axis_tlast        :   out     std_logic                                           ;

            SCL_I               :   in      std_logic                                           ;
            SDA_I               :   in      std_logic                                           ;
            SCL_T               :   out     std_logic                                           ;
            SDA_T               :   out     std_logic                                           
        );
    end component;

    
    signal  resetn        :        std_logic                                       := '0'               ;

    signal  s_axis_cmd_tdata    :           std_logic_vector ( 15 downto 0 )  := (others => '0')   ;
    signal  s_axis_cmd_tvalid   :           std_logic                         := '0'               ;
    signal  s_axis_cmd_tready   :           std_logic                         := '0'               ;


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


    --component i2c_slave_controller
    --    port (
    --        SDA :  inout  std_logic ;
    --        SCL :  inout  std_logic  
    --    );
    --end component;



    --component i2c_master
    --    generic(
    --        input_clk : integer := 100_000_000; --input clock speed from user logic in hz
    --        bus_clk   : integer := 400_000
    --    );
    --    port(
    --        CLK       : in     std_logic;                    --system clock
    --        RESET_N   : in     std_logic;                    --active low reset
    --        ENA       : in     std_logic;                    --latch in command
    --        ADDR      : in     std_logic_vector(6 downto 0); --address of target slave
    --        RW        : in     std_logic;                    --'0' is write, '1' is read
    --        DATA_WR   : in     std_logic_vector(7 downto 0); --data to write to slave
    --        BUSY      : out    std_logic;                    --indicates transaction in progress
    --        DATA_RD   : out    std_logic_vector(7 downto 0); --data read from slave
    --        ACK_ERROR : buffer std_logic;                    --flag if improper acknowledge from slave
    --        SDA       : inout  std_logic;                    --serial data output of i2c bus
    --        SCL       : inout  std_logic
    --    );                   --serial clock output of i2c bus
    --end component;


    --signal  M_CLK       :   std_logic                           := '0'                      ;                    --system clock
    --signal  M_RESET_N   :   std_logic                           := '0'                      ;                    --active low reset
    --signal  M_ENA       :   std_logic                           := '0'                      ;                    --latch in command
    --signal  M_ADDR      :   std_logic_vector (  6 downto 0 )    := (others => '0')          ; --address of target slave
    --signal  M_RW        :   std_logic                           := '0'                      ;                    --'0' is write, '1' is read
    --signal  M_DATA_WR   :   std_logic_vector (  7 downto 0 )    := (others => '0')          ; --data to write to slave
    --signal  M_BUSY      :   std_logic                                                       ;                    --indicates transaction in progress
    --signal  M_DATA_RD   :   std_logic_vector (  7 downto 0 )                                ; --data read from slave
    --signal  M_ACK_ERROR :   std_logic                                                       ;                    --flag if improper acknowledge from slave
    --signal  M_SDA       :   std_logic                                                       ;                    --serial data output of i2c bus
    --signal  M_SCL       :   std_logic                                                       ;



begin

    CLK <= not CLK after clk_period/2;

    i_processing : process(CLK)
    begin
        if CLK'event AND CLK = '1' then 
            i <= i + 1;
        end if;
    end process;

    resetn <= '0' when i < 800 else '1';
    rst <= not resetn;

    axis_iic_mgr_inst : axis_iic_mgr
        generic map (
            N_BYTES         =>  N_BYTES     
        )
        port map  (
            clk                 =>  clk                     ,
            resetn              =>  resetn                  ,

            s_axis_cmd_tdata    =>  s_axis_cmd_tdata        ,
            s_axis_cmd_tvalid   =>  s_axis_cmd_tvalid       ,
            s_axis_cmd_tready   =>  s_axis_cmd_tready       ,

            s_axis_tdata        =>  s_axis_tdata            ,
            s_axis_tkeep        =>  s_axis_tkeep            ,
            s_axis_tvalid       =>  s_axis_tvalid           ,
            s_axis_tready       =>  s_axis_tready           ,
            s_axis_tlast        =>  s_axis_tlast            ,

            m_axis_tdata        =>  m_axis_tdata            ,
            m_axis_tkeep        =>  m_axis_tkeep            ,
            m_axis_tvalid       =>  m_axis_tvalid           ,
            m_axis_tready       =>  m_axis_tready           ,
            m_axis_tlast        =>  m_axis_tlast            ,

            SCL_I               =>  SCL_I                   ,
            SDA_I               =>  SDA_I                   ,
            SCL_T               =>  SCL_T                   ,
            SDA_T               =>  SDA_T                   
        );

    SCL_I <= SCL_T;

    sda_i_processing : process(CLK)
    begin
        if CLK'event AND CLK = '1' then 
            case i is 
                when 0 => SDA_I <= '1';
                when 1062 => SDA_I <= '0';
                when 1312 => SDA_I <= '1';
                when 1562 => SDA_I <= '0';
                when 2062 => SDA_I <= '1';
                when 2312 => SDA_I <= '0';
                when 2812 => SDA_I <= '1';
                when 3312 => SDA_I <= '0';
                when 4062 => SDA_I <= '1';
                when 4312 => SDA_I <= '0';
                when 4562 => SDA_I <= '1';
                when 4812 => SDA_I <= '0';
                when 5812 => SDA_I <= '1';
                when 6062 => SDA_I <= '0';
                when 6312 => SDA_I <= '1';
                when 6562 => SDA_I <= '0';
                when 7812 => SDA_I <= '1';
                when 8062 => SDA_I <= '0';
                when 8312 => SDA_I <= '1';
                
                
                
                
                
                
                --when 2062 => SDA_I <= '1';
                --when 2062 => SDA_I <= '1';
                --when 2062 => SDA_I <= '1';
                --when 2062 => SDA_I <= '1';
                --when 2062 => SDA_I <= '1';
                --when 2062 => SDA_I <= '1';
                --when 2062 => SDA_I <= '1';
                --when 2062 => SDA_I <= '1';



                when others =>
                    SDA_I <= SDA_I;
            end case;
        end if;
    end process;



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


    s_axis_cmd_processing : process(CLK)
    begin
        if CLK'event aND CLK = '1' then 
            case i is 
                when 1000   => s_axis_cmd_tdata <= x"0293"; s_axis_cmd_tvalid <= '1';
                when 1001   => s_axis_cmd_tdata <= x"0092"; s_axis_cmd_tvalid <= '1';
                when others => s_axis_cmd_tdata <= s_axis_cmd_tdata; s_axis_cmd_tvalid <= '0';
            end case;   
        end if;
    end process;

    s_axis_processing : process(CLK)
    begin
        if CLK'event aND CLK = '1' then 
            case i is 
                when 1000   => s_axis_tdata <= x"00000000"; s_axis_tkeep <= x"1"; s_axis_tvalid <= '1'; s_axis_tlast <= '1';
                when others => s_axis_tdata <= s_axis_tdata; s_axis_tkeep <= s_axis_tkeep; s_axis_tvalid <= '0'; s_axis_tlast <= s_axis_tlast; 
            end case;   
        end if;
    end process;





    --i2c_master_inst : i2c_master
    --    generic map (
    --        input_clk   =>  100_000_000     , --input clock speed from user logic in hz
    --        bus_clk     =>  400_000
    --    )
    --    port map (
    --        CLK         =>  M_CLK             ,
    --        RESET_N     =>  M_RESET_N         ,
    --        ENA         =>  M_ENA             ,
    --        ADDR        =>  M_ADDR            ,
    --        RW          =>  M_RW              ,
    --        DATA_WR     =>  M_DATA_WR         ,
    --        BUSY        =>  M_BUSY            ,
    --        DATA_RD     =>  M_DATA_RD         ,
    --        ACK_ERROR   =>  M_ACK_ERROR       ,
    --        SDA         =>  M_SDA             ,
    --        SCL         =>  M_SCL              
    --    );                   --serial clock output of i2c bus

    --M_CLK <= CLK ;

    --M_RESET_N <= '0' when i < 10 else '1';

    --inp_processing : process(CLK)
    --begin
    --    if CLK'event AND CLK = '1' then 
    --        if M_BUSY = '1' then 
    --            M_ENA <= '0';
    --        else
    --            case i is
    --                when 1000 =>  M_ENA <= '1'; M_ADDR <= "1010101"; M_RW <= '0'; M_DATA_WR <= x"DD";
    --                when others => M_ENA <= M_ENA; M_ADDR <= M_ADDR; M_RW <= M_RW; M_DATA_WR <= M_DATA_WR;

    --            end case;
    --        end if;
    --    end if;
    --end process;



end Behavioral;
