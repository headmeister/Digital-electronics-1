------------------------------------------------------------------------
--
-- Driver for seven-segment displays.
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
-- Entity declaration for display driver
------------------------------------------------------------------------
entity PWM_dimmer is
port (
    clk_i    : in  std_logic;
    dimmer_active : in  std_logic;   -- Synchronous reset (active low)
   
   
    PWM_out    : out std_logic                       -- Decimal point

	 
);
end entity PWM_dimmer;

------------------------------------------------------------------------
-- Architecture declaration for display driver
------------------------------------------------------------------------
architecture Behavioral of PWM_dimmer is
    signal PWM_period  : std_logic;
	 signal PWM_reset : std_logic;
	signal PWM : std_logic;
	signal PWM_reset_reset_n: std_logic;
	
	signal PWM_duty_value :std_logic_vector(8-1 downto 0) := x"64";
begin

	PWM_out<=PWM;
	
    --------------------------------------------------------------------
    -- Sub-block of clock_enable entity. Create period of PWM signal.

	enable_PWM_period: entity work.clock_enable
        generic map (g_NPERIOD=>x"0064")
        port map (-- <component_signal> => actual_signal,
                  -- <component_signal> => actual_signal,
                  -- ...
                  -- <component_signal> => actual_signal);
                  -- WRITE YOUR CODE HERE
                  clk_i=>clk_i,
                  srst_n_i=>'1',
                  clock_enable_o=>PWM_period
                 );

    --------------------------------------------------------------------
  
  ----------------------------------------------------------------------
  -- Changeable enable signal for duty cycle regulation
  -----------------------------------------------------------------------
  	enable_PWM_reset: entity work.clock_enable_changeable
        port map (-- <component_signal> => actual_signal,
                  -- <component_signal> => actual_signal,
                  -- ...
                  -- <component_signal> => actual_signal);
                  -- WRITE YOUR CODE HERE
                  clk_i=>clk_i,
                  srst_n_i=>PWM_reset_reset_n,
                  clock_enable_changeable_o=>PWM_reset,
						g_NPERIOD=>PWM_duty_value
                 );
  ----------------------------------------------------------------------
  -- Main dimming process
  -----------------------------------------------------------------------					  
	
p_dimm : process (clk_i)
    begin
        if rising_edge(clk_i) then
		  if dimmer_active ='1' then  -- If active dimming then start dimming otherwise turn the light immediately on
		  if PWM_period='1' then -- on PWM period which is approx 100 Hz
		  
		  PWM<='1';
		  PWM_reset_reset_n<='0';
		  if(PWM_duty_value>1) then -- lower the value of duty cycle by one step which translates to aprrox. change of duty cycle of 1 %
		  PWM_duty_value<=PWM_duty_value-1;
		  else
		  PWM_duty_value<=x"00";
		  PWM<='0';
		  end if;
		  
		  elsif PWM_reset='1' and PWM_period='0' then -- if the time is up (duty cycle counter has finished) change the output to 0 and stop the duty cycle counter
		  PWM<='0';
		  PWM_reset_reset_n<='0';
		  else
		  
		  PWM<=PWM;
		  PWM_reset_reset_n<='1';
		  end if;
		  
		  else
		  
		  PWM_duty_value<=x"62"; -- reinitialize the duty cycle counter stop value
		  if(PWM_duty_value>1) then -- if it is not finished keep output high, otherwise keep it low (not active)
		  
		  PWM<='1';
		  else
		  PWM<='0';
		  end if;
		  PWM_reset_reset_n<='0';
		  end if;
		  
		  end if;
		  
    end process p_dimm;

	
  

end architecture Behavioral;