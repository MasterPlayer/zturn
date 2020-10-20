library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
    use ieee.std_logic_unsigned.all;
    use ieee.std_logic_arith.all;


entity tb_buzzer is
end tb_buzzer;



architecture tb_buzzer_arch of tb_buzzer is



    signal  i : integer := 0;

    constant CLK_PERIOD : time := 10 ns;

    component buzzer
        port (
            clk             :   in      std_logic                                   ;

            resetn          :   in      std_logic                                   ;

            enable          :   in      std_logic                                   ;
            mode            :   in      std_logic_Vector (  1 downto 0 )            ;
            duration_on     :   in      std_logic_Vector ( 31 downto 0 )            ;
            duration_off    :   in      std_logic_Vector ( 31 downto 0 )            ;

            BUZZER_OUT      :   out     std_logic                                     
        );
    end component;

    signal  clk             :           std_logic                        := '0'                 ;
    signal  resetn          :           std_logic                        := '0'                 ;
    signal  enable          :           std_logic                        := '0'                 ;
    signal  mode            :           std_logic_Vector (  1 downto 0 ) := (others => '0')     ;
    signal  duration_on     :           std_logic_Vector ( 31 downto 0 ) := (others => '0')     ;
    signal  duration_off    :           std_logic_Vector ( 31 downto 0 ) := (others => '0')     ;
    signal  BUZZER_OUT      :           std_logic                                               ;


begin

    CLK <= not CLK after CLK_period/2;

    i_processing : process(CLK)
    begin
        if CLK'event AND CLK = '1' then 
            i <= i + 1;
        end if;
    end process;

    resetn <= '0' when i < 10 else '1';

    buzzer_inst : buzzer
        port map (
            clk             =>  clk                                         ,
            resetn          =>  resetn                                      ,
            enable          =>  enable                                      ,
            mode            =>  mode                                        ,
            duration_on     =>  duration_on                                 ,
            duration_off    =>  duration_off                                ,
            BUZZER_OUT      =>  BUZZER_OUT                                   
        );

    inp_processing : process(CLK)
    begin
        if CLK'event AND CLK = '1' then 
            case i is 
                when 1000   => enable <= '1'; mode <= "10"; duration_on <= x"00000100"; duration_off <= x"00000010";
                when 2000   => enable <= '0'; mode <= "10"; duration_on <= x"00000100"; duration_off <= x"00000010";
                when others => enable <= enable; mode <= mode; duration_on <= duration_on; duration_off <= duration_off;

            end case;
        end if;
    end process;


end tb_buzzer_arch;
