
  
-----------------------------------------------------------------------
--
-- Generates divided clock signal.
-- Xilinx XC2C256-TQ144 CPLD, ISE Design Suite 14.7
--
-- Copyright (c) 2019-2020 Tomas Fryza
-- Dept. of Radio Electronics, Brno University of Technology, Czechia
-- This work is licensed under the terms of the MIT license.
--
------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;    -- Provides unsigned numerical computation

------------------------------------------------------------------------
-- Entity declaration for clock divider
------------------------------------------------------------------------
entity clock_divider is
generic (
    g_NPERIOD : std_logic_vector(16-1 downto 0) := x"0004"
);
port (
    clk_i          : in  std_logic;
    srst_n_i       : in  std_logic; -- Synchronous reset (active low)
    clock_divide_o : out std_logic
);
end entity clock_divider;

------------------------------------------------------------------------
-- Architecture declaration for clock divider
------------------------------------------------------------------------
architecture Behavioral of clock_divider is
    signal s_cnt : std_logic_vector(16-1 downto 0) := x"0000";
	 
	 signal clock_divide: std_logic:='0';
begin
		clock_divide_o<=clock_divide;
    --------------------------------------------------------------------
    -- p_clk_divide:
    -- Generate divided clock. 
    --------------------------------------------------------------------
    p_clk_divide : process(clk_i)
    begin
        if rising_edge(clk_i) then  -- Rising clock edge
            if srst_n_i = '0' then  -- Synchronous reset (active low)
                s_cnt <= (others => '0');   -- Clear all bits
                clock_divide <= '0';
            else
                if s_cnt >= g_NPERIOD-1 and clock_divide='1'  then -- when the output is one and the counter is greater then specified period reset the counter and flip output 
                    s_cnt<=x"0000"; 
                    clock_divide <= '0';
                elsif s_cnt >=g_NPERIOD-1 and clock_divide='0' then
						s_cnt<=x"0000";
						clock_divide <= '1';
					 else 
                    s_cnt <= s_cnt + x"0001"; -- increment the counter
                    
                end if;
            end if;
        end if;
    end process p_clk_divide;

end architecture Behavioral;

