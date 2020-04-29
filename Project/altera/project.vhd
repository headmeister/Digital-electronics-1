library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity project is
port (
    CLK    : in  std_logic;
	 
    
	A : in  std_logic ;                 
    
	button: in std_logic;
	 
	 
    B : in  std_logic;   -- Synchronous reset (active low)
	 
	 
    DS_G,DS_F,DS_E,DS_D,DS_C,DS_B,DS_A,PS2_dat : out std_logic;
	 DS_EN1,DS_EN2,DS_EN3,DS_EN4,DS_DP : out std_logic
	 
	 
	 
	 
	 );
	 
	 
	 
end project;

architecture Behavioral of project is

signal ce_10kHz:  std_logic;
	
	
	signal s_en  : std_logic;
	signal dp_o :std_logic;
	signal srst_n_i  : std_logic;
	signal seg_o : std_logic_vector(7-1 downto 0):="0000000";
	signal dig_o : std_logic_vector(4-1 downto 0):="0000";



begin

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

top: entity work.top  							-- velocity controll timer
        
        port map (-- <component_signal> => actual_signal,
                  -- <component_signal> => actual_signal,
                  -- ...
                  -- <component_signal> => actual_signal);
                  -- WRITE YOUR CODE HERE
                 A=>A,
						B=>B,
						clk_i=>ce_10kHz,
						dp_o=>dp_o,
						seg_o=>seg_o,
						dig_o=>dig_o,
						PWM_out=>PS2_dat,
						button=>button
                 );



					  


	Enable_counter: entity work.clock_enable
        generic map (g_NPERIOD=>x"12C0")
        port map (-- <component_signal> => actual_signal,
                  -- <component_signal> => actual_signal,
                  -- ...
                  -- <component_signal> => actual_signal);
                  -- WRITE YOUR CODE HERE
                  clk_i=>CLK,
                  srst_n_i=>'1',
                  clock_enable_o=>ce_10kHz
                 );
					  
--			Seconds_counter: entity work.clock_enable
--        generic map (g_NPERIOD=>x"2710")
--        port map (-- <component_signal> => actual_signal,
--                  -- <component_signal> => actual_signal,
--                  -- ...
--                  -- <component_signal> => actual_signal);
--                  -- WRITE YOUR CODE HERE
--                  clk_i=>ce_10kHz,
--                  srst_n_i=>'1',
--                  clock_enable_o=>DS_DP
--                 );		  
					  


end Behavioral;