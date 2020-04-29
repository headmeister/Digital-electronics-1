
  
-----------------------------------------------------------------------
--
-- Generates clock debounce signal.
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
-- Entity declaration for clock debounce
------------------------------------------------------------------------
entity debouncer is
generic (
    g_NPERIOD : std_logic_vector(8-1 downto 0) := x"04"
);
port (
    clk_i          : in  std_logic;
    input       : in  std_logic; -- Synchronous reset (active low)
    debouncer_o : out std_logic
);
end entity debouncer;

------------------------------------------------------------------------
-- Architecture declaration for clock debounce
------------------------------------------------------------------------
architecture Behavioral of debouncer is
    signal debounce_time : std_logic_vector(8-1 downto 0) := x"00";
	 signal input_before :std_logic:=input;
	 signal debounce_output_signal : std_logic;
begin

    --------------------------------------------------------------------
    -- p_clk_debounce:
    -- Generate debounced signal which could come from a button.
    --------------------------------------------------------------------
	 debouncer_o<=debounce_output_signal;
    p_clk_debounce : process(clk_i)
    begin
        if rising_edge(clk_i) then  -- Rising clock edge
            if input /=input_before  then  -- Synchronous reset (active low)
             debounce_time<=(others => '0');
				 input_before<=input;
            else
                if debounce_time >= g_NPERIOD-1 then
                    debounce_time <= (others => '0');
                    debounce_output_signal <= input;
                else
                    debounce_time <= debounce_time + x"01";
                    debounce_output_signal <= debounce_output_signal;
                end if;
            end if;
        end if;
    end process p_clk_debounce;

end architecture Behavioral;

