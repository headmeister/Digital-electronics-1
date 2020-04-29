----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:39:59 04/02/2020 
-- Design Name: 
-- Module Name:    top - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
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

entity top is
port (
    clk_i    : in  std_logic;
	 
    A : in  std_logic;   -- Synchronous reset (active low)
	 B : in  std_logic ;                 
    button: in std_logic;
		dp_o     : out std_logic;                       -- Decimal point
    seg_o    : out std_logic_vector(7-1 downto 0);
    dig_o    : out std_logic_vector(4-1 downto 0);
	 
	 
	 PWM_out : out std_logic
	 
	 );
	 
	 
	 
end top;

architecture Behavioral of top is
signal enc_value: std_logic_vector(12-1 downto 0);

signal counter_value: std_logic_vector(12-1 downto 0);


signal digit1: std_logic_vector(4-1 downto 0);
signal digit2: std_logic_vector(4-1 downto 0);
signal digit3: std_logic_vector(4-1 downto 0);
signal digit4: std_logic_vector(4-1 downto 0);


signal counter_reset: std_logic:='0';

signal ce1_Hz :  std_logic;
signal clock_1_Hz: std_logic;
signal display_reset: std_logic:='1';
signal countdown_complete_signal: std_logic;
signal debounced_button: std_logic;
signal debounced_button_before: std_logic:='1';
signal counter_stop: std_logic:='1';
begin				  
----------------------------------------------------------------------------------------------------------		
-- velocity controlled encoder module
--------------------------------------------------------------------------------------------------------------
encoder: entity work.encoder  							
        
        port map (-- <component_signal> => actual_signal,
                  -- <component_signal> => actual_signal,
                  -- ...
                  -- <component_signal> => actual_signal);
                  -- WRITE YOUR CODE HERE
                  clk_i=>clk_i,
                  A=>A,
						B=>B,
                  enc_value=>enc_value,
						reset=>counter_reset
                 );
							  
----------------------------------------------------------------------------------------------------------			
	--debouncer for the encoder button
--------------------------------------------------------------------------------------------------------------
	
						  
					  
					    debouncer_button: entity work.debouncer
        generic map (g_NPERIOD=>x"64")
        port map (-- <component_signal> => actual_signal,
                  -- <component_signal> => actual_signal,
                  -- ...
                  -- <component_signal> => actual_signal);
                  -- WRITE YOUR CODE HERE
                  clk_i=>clk_i,
                  input=>button,
                  debouncer_o=>debounced_button
                 );
					  
					  
----------------------------------------------------------------------------------------------------------			
	--display driver for the 7 segment display to show remaining time
--------------------------------------------------------------------------------------------------------------
	
					
					  

driver: entity work.driver_7seg  							
        
        port map (-- <component_signal> => actual_signal,
                  -- <component_signal> => actual_signal,
                  -- ...
                  -- <component_signal> => actual_signal);
                  -- WRITE YOUR CODE HERE
                  clk_i=>clk_i,
						srst_n_i=>'1',
						data0_i=>digit1,
						data1_i=>digit2,
						data2_i=>digit3,
						data3_i=>digit4,
						dp_i=>"1111",
						dp_o=>dp_o,
						seg_o=>seg_o,
						dig_o=>dig_o,
						disp_enable=>display_reset
						
                 );
					  
					
----------------------------------------------------------------------------------------------------------			
	-- Main counter which manages the countdown and conversion from binary to hexadecimal digits of the display
--------------------------------------------------------------------------------------------------------------
	
			Countdown: entity work.counter  
        port map (clk_i=>clk_i,
						srst_n_i=>counter_reset,
						ce_1Hz_i=>ce1_Hz,
						tent_minutes=>digit1,
						minutes=>digit2,
						tents_seconds=>digit3,
						seconds=>digit4,
						enc_val=>enc_value,
						countdown_complete=>countdown_complete_signal,
						counter_value_o=>counter_value,
						counter_stop=>counter_stop
                  );
					  
		----------------------------------------------------------------
-- dimmer entity which starts dimming the output light when counting has finished
-----------------------------------------
			Dimmer: entity work.PWM_dimmer 
        port map (clk_i=>clk_i,
						dimmer_active=>countdown_complete_signal,
						PWM_out=>PWM_out
						
                  );
					  
		
----------------------------------------------------------------------------------------------------------			
	-- 1Hz clock enable generator for the counter
--------------------------------------------------------------------------------------------------------------	  
					  
					  
					  Enable_counter: entity work.clock_enable
        generic map (g_NPERIOD=>x"2710")
        port map (-- <component_signal> => actual_signal,
                  -- <component_signal> => actual_signal,
                  -- ...
                  -- <component_signal> => actual_signal);
                  -- WRITE YOUR CODE HERE
                  clk_i=>clk_i,
                  srst_n_i=>counter_reset,
                  clock_enable_o=>ce1_Hz
                 );
					  
 ----------------------------------------------------------------------------------------------------------			
	-- 1Hz clock signal generator for blinking the display when the remaining time is less than 10 seconds.
--------------------------------------------------------------------------------------------------------------	  
					  
					  clock_1Hz_entity: entity work.clock_divider
        generic map (g_NPERIOD=>x"1388")
        port map (-- <component_signal> => actual_signal,
                  -- <component_signal> => actual_signal,
                  -- ...
                  -- <component_signal> => actual_signal);
                  -- WRITE YOUR CODE HERE
                  clk_i=>clk_i,
                  srst_n_i=>counter_reset,
                  clock_divide_o=>clock_1_Hz
                 );
					    
					  
 ----------------------------------------------------------------------------------------------------------			
---- Process for controlling blinking of the display when the remaining time is less than 10 seconds.
--------------------------------------------------------------------------------------------------------------	 					  
					
					  
					  
					   disp_blink : process (clk_i)
					begin
					  
					  if rising_edge(clk_i) then
						if(counter_value<x"00A" and (counter_reset='0' or counter_stop='0')) then
						display_reset<=clock_1_Hz;
						--display_reset<='1';
						else
						
						display_reset<='1';
						
						
						end if;
						end if;
						
						end process disp_blink;
						

--------------------------------------------------------------------------------------------------------------			
---- Process for starting and stopping the countdown
--------------------------------------------------------------------------------------------------------------	 					  
					
							

					  
				p_counter_stop : process (clk_i)
					begin
					  
					  if rising_edge(clk_i) then
						if(debounced_button_before/=debounced_button) then
						debounced_button_before<=debounced_button;
						if (debounced_button='1' and debounced_button_before='0') then
						counter_stop<= not counter_stop;
						end if;
						
						else
						
						counter_stop<= counter_stop;
						
						
						end if;
						
						end if;
						
						end process p_counter_stop;
							  
			
					  
end Behavioral;

