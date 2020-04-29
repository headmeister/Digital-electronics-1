
  
-----------------------------------------------------------------------
--
-- Generates clock enable changeable signal.
-- Xilinx XC2C256-TQ144 CPLD, ISE Design Suite 14.7

--
------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;    -- Provides unsigned numerical computation

------------------------------------------------------------------------
-- Entity declaration for clock enable
------------------------------------------------------------------------
entity clock_enable_changeable is

port (
    clk_i          : in  std_logic;
    srst_n_i       : in  std_logic; -- Synchronous reset (active low)
	 g_NPERIOD : in std_logic_vector(8-1 downto 0) := x"04";
    clock_enable_changeable_o : out std_logic
);
end entity clock_enable_changeable;

------------------------------------------------------------------------
-- Architecture declaration for clock enable
------------------------------------------------------------------------
architecture Behavioral of clock_enable_changeable is
    signal s_cnt : std_logic_vector(8-1 downto 0) := x"00";
begin

    --------------------------------------------------------------------
    -- p_clk_enable:
    -- Generate clock enable signal instead of creating another clock 
    -- domain. By default enable signal is low and generated pulse is 
    -- always one clock long. The period of this signal can be changed through the g_NPERIOD signal.
    --------------------------------------------------------------------
    p_clk_enable : process(clk_i)
    begin
        if rising_edge(clk_i) then  -- Rising clock edge
            if srst_n_i = '0' then  -- Synchronous reset (active low)
                s_cnt <= (others => '0');   -- Clear all bits
                clock_enable_changeable_o <= '0';
            else
                if s_cnt >= g_NPERIOD-1 then
                    s_cnt <= (others => '0');
                    clock_enable_changeable_o <= '1';
                else
                    s_cnt <= s_cnt + x"01";
                    clock_enable_changeable_o <= '0';
                end if;
            end if;
        end if;
    end process p_clk_enable;

end architecture Behavioral;

