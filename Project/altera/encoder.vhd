----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:36:30 04/02/2020 
-- Design Name: 
-- Module Name:    encoder - Behavioral 
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

entity encoder is
port (
    clk_i    : in  std_logic;
	 
    A : in  std_logic;   -- Synchronous reset (active low)
	 B : in  std_logic;                  
    enc_value: out std_logic_vector(12-1 downto 0);
	 reset: out std_logic);
end entity encoder;

architecture Behavioral of encoder is

signal A_before : std_logic :='0';
signal enc : std_logic_vector(13-1 downto 0):="0000000010000";
signal srstn : std_logic :='1';
signal inc : std_logic_vector(8-1 downto 0) :=x"01";
signal increment_en_signal: std_logic;
signal enc_enable: std_logic;
signal A_debounced,B_debounced: std_logic;
begin


 debouncer_A: entity work.debouncer
        generic map (g_NPERIOD=>x"20")
        port map (-- <component_signal> => actual_signal,
                  -- <component_signal> => actual_signal,
                  -- ...
                  -- <component_signal> => actual_signal);
                  -- WRITE YOUR CODE HERE
                  clk_i=>clk_i,
                  input=>A,
                  debouncer_o=>A_debounced
                 );


					  debouncer_B: entity work.debouncer
        generic map (g_NPERIOD=>x"20")
        port map (-- <component_signal> => actual_signal,
                  -- <component_signal> => actual_signal,
                  -- ...
                  -- <component_signal> => actual_signal);
                  -- WRITE YOUR CODE HERE
                  clk_i=>clk_i,
                  input=>B,
                  debouncer_o=>B_debounced
                 );



p_encoder : process (clk_i)
    begin
        if rising_edge(clk_i)  then  -- Rising clock edge
           
              
				if B_debounced = A_debounced and A_before /= A_debounced   then
				
					if enc+inc <"1110000100000" then -- check the overflow
						enc<=enc+inc;
						
					else
						enc<="1110000100000";
					end if;
					A_before<=A_debounced;
					srstn<='0';
					
					inc<=x"3C";
				
					reset<='0';
				
				elsif B_debounced /= A_debounced and A_before /= A_debounced  then -- has been turned counter clockwise decrement the value
					if enc-inc > "0000000000010" and enc >inc then -- overflow
						enc<=enc-inc;
					else
						enc<="0000000000010";
					end if;
					A_before<=A_debounced;
					srstn<='0';
					inc<=x"3C";
				
					reset<='0';	
				else --otherwise do nothing just change the timer for velocity controll values
				
					enc<=enc;
					A_before<=A_before;
					reset<='1';
					srstn<='1';
				
					if  increment_en_signal='1' then
						if inc-1> x"00" then -- decrement the timer to see the velocity
						inc<=inc-1;	
						else
						inc<=x"01";
						end if;
					else 
					inc<=inc;
						
					end if;
					
					
				end if;
			end if;
    end process p_encoder;

enc_value<=enc(12 downto 1); -- use first 12 bits to divide by 2



					  
increment_enable: entity work.clock_enable_changeable  							-- increment update timer (every triger event increase increment) timer for velocity controll
        
        port map (-- <component_signal> => actual_signal,
                  -- <component_signal> => actual_signal,
                  -- ...
                  -- <component_signal> => actual_signal);
                  -- WRITE YOUR CODE HERE
                  clk_i=>clk_i,
                  srst_n_i=>srstn,
                  clock_enable_changeable_o=>increment_en_signal,
						g_NPERIOD=>x"03"
                 );					  
					  


end Behavioral;

