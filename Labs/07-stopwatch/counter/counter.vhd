library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;    -- Provides unsigned numerical computation


entity counter is
port (
    CLK    : in  std_logic;
    KEY1 : in  std_logic;   -- Synchronous reset (active low)
    DS_G,DS_F,DS_E,DS_D,DS_C,DS_B,DS_A : out std_logic;
	 DS_EN1,DS_EN2,DS_EN3,DS_EN4 : out std_logic
);
end entity counter;



architecture Behavioral of counter is
signal ce_100Hz:  std_logic;
signal s_en  : std_logic;
signal srst_n_i  : std_logic;
signal seg_o : std_logic_vector(7-1 downto 0):="0000000";
signal dig_o : std_logic_vector(4-1 downto 0):="0000";
signal   sec_h_o    :  std_logic_vector(4-1 downto 0);
signal   sec_l_o    :  std_logic_vector(4-1 downto 0);
signal	 hth_h_o    :  std_logic_vector(4-1 downto 0);
signal	 hth_l_o    :  std_logic_vector(4-1 downto 0);
signal s_hex : std_logic_vector(4-1 downto 0);
signal s_cnt : std_logic_vector(2-1 downto 0) := "00";
begin

srst_n_i<=  KEY1;

	DS_G<=not seg_o(0); 
	DS_F<=not seg_o(1);
	DS_E<=not seg_o(2);
	DS_D<=not seg_o(3);
	DS_C<=not seg_o(4);
	DS_B<=not seg_o(5);
	DS_A<=not seg_o(6);

DS_EN1<=dig_o(0);
DS_EN2<=dig_o(1);
DS_EN3<=dig_o(2);
DS_EN4<=dig_o(3);	
Enable_counter: entity work.clock_enable
        generic map (g_NPERIOD=>x"0075300")
        port map (-- <component_signal> => actual_signal,
                  -- <component_signal> => actual_signal,
                  -- ...
                  -- <component_signal> => actual_signal);
                  -- WRITE YOUR CODE HERE
                  clk_i=>CLK,
                  srst_n_i=>srst_n_i,
                  clock_enable_o=>ce_100Hz
                 );




	GGenable: entity work.clock_enable
        generic map (g_NPERIOD=>x"000F300")
        port map (-- <component_signal> => actual_signal,
                  -- <component_signal> => actual_signal,
                  -- ...
                  -- <component_signal> => actual_signal);
                  -- WRITE YOUR CODE HERE
                  clk_i=>CLK,
                  srst_n_i=>srst_n_i,
                  clock_enable_o=>s_en
                 );
					  
	HEX2SSEG: entity work.hex_to_7seg
        port map (hex_i=>s_hex,
                  seg_o=>seg_o
                  );
						
						
		Stopky: entity work.stopwatch
        port map (clk_i=>CLK,
						srst_n_i=>srst_n_i,
						ce_100Hz_i=>ce_100Hz,
						cnt_en_i=> '1',
						sec_h_o=>sec_h_o,
						sec_l_o=>sec_l_o,
						hth_h_o=>hth_h_o,
						hth_l_o=>hth_l_o
                  );

    --------------------------------------------------------------------
    -- p_select_cnt:
    -- Sequential process with synchronous reset and clock enable,
    -- which implements an internal 2-bit counter s_cnt for multiplexer 
    -- selection bits.
    --------------------------------------------------------------------
    p_select_cnt : process (CLK)
    begin
        if rising_edge(CLK) then  -- Rising clock edge
            if srst_n_i = '0' then  -- Synchronous reset (active low)
                s_cnt<="00";
            elsif s_en = '1' then
               s_cnt<=s_cnt+1;
            end if;
        end if;
    end process p_select_cnt;

    --------------------------------------------------------------------
    -- p_mux:
    -- Combinational process which implements a 4-to-1 mux.
    --------------------------------------------------------------------
    p_mux : process (s_cnt,sec_h_o,sec_l_o,hth_h_o,hth_l_o)
    begin
        case s_cnt is
        when "00" =>
            s_hex<=sec_h_o;
            dig_o<="1110";
				
        when "01" =>
            s_hex<=sec_l_o;
				dig_o<="1101";
				
        when "10" =>
            s_hex<=hth_h_o;
				dig_o<="1011";
				
        when others =>
            s_hex<=hth_l_o;
				dig_o<="0111";
				
        end case;
    end process p_mux;				  
	 	

end architecture Behavioral;	 