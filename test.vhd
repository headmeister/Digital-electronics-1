----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    02:28:13 04/03/2020 
-- Design Name: 
-- Module Name:    counter - Behavioral 
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
USE ieee.numeric_std.ALL; 
   -- Provides unsigned numerical computatio
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity counter is
port (
    clk_i    : in  std_logic;
    srst_n_i : in  std_logic;   -- Synchronous reset (active low)
    ce_1Hz_i: in std_logic;
	 enc_val : in std_logic_vector(12-1 downto 0);
    tent_minutes    : out std_logic_vector(4-1 downto 0);
    minutes    : out std_logic_vector(4-1 downto 0);
	 tents_seconds    : out std_logic_vector(4-1 downto 0);
	 seconds    : out std_logic_vector(4-1 downto 0);
	 countdown_complete : out std_logic
);


end counter;

architecture Behavioral of counter is

	signal init : std_logic:='0';
	 
	 signal tent_min_comp : std_logic:='0';
	 
	 signal  min_comp : std_logic:='0';
	 
	 signal  tent_sec_comp : std_logic:='0';
	 
	 signal  sec_comp : std_logic:='0';

	signal  counter_val : std_logic_vector(12-1 downto 0):=x"0f1";
	
	
	
 signal s_cntc1 : std_logic_vector(4-1 downto 0):="0010" ;
	 
	 signal s_cntc2 : std_logic_vector(4-1 downto 0):="0001" ;
	 
	 signal s_cntc3 : std_logic_vector(4-1 downto 0):="0011" ;
	 
	 signal s_cntc4 : std_logic_vector(4-1 downto 0):="0001" ;
	 
	 signal counter_work : integer range -1000 to 4095:= 0;
	 
	 
begin

		


		p_set : process (clk_i,ce_1hz_i)
    begin
        if rising_edge(clk_i)  then  -- Rising clock edge
            
            if sec_comp='0' then
				
				if init = '0' then
				counter_work<= to_integer (unsigned(counter_val));
				init<='1';
				s_cntc1<="0000";
				
				s_cntc2<="0000";
				s_cntc3<="0000";
				s_cntc4<="0000";
				end if;
				
				if((counter_work-600)>=0 and tent_min_comp='0' and init='1') then
				s_cntc4<=s_cntc4+"0001";
				counter_work<=counter_work-600;
				tent_min_comp<='0';
				else
				tent_min_comp<='1';
		
				end if;
				
				if(counter_work-60>=0 and tent_min_comp='1' and min_comp='0') then
				s_cntc3<=s_cntc3+"0001";
				counter_work<=counter_work-60;
				min_comp<='0';
				else
				min_comp<='1';
			
				end if;
				
				if(counter_work-10>=0 and tent_min_comp='1' and min_comp ='1') then
				s_cntc2<=s_cntc2+"0001";
				counter_work<=counter_work-10;
				tent_sec_comp<='0';
				else
				tent_sec_comp<='1';
			
				end if;
				
				if((counter_work-1)>=0 and tent_min_comp='1' and min_comp='1' and tent_sec_comp='1' and sec_comp='0') then
				s_cntc4<=s_cntc4+"0001";
				counter_work<=counter_work-1;
				init<='1';
				
				elsif(counter_work-1>=0 and tent_min_comp='1' and min_comp='1' and tent_sec_comp='1' and sec_comp='1' and ce_1hz_i='1') then
				s_cntc4<=s_cntc4;
				counter_work<=counter_work;
				init<='0';
				tent_min_comp<='0';
				min_comp<='0';
				tent_sec_comp<='0';
				
				sec_comp<='0';
				
				
				else
				s_cntc4<=s_cntc4;
				counter_work<=counter_work;
				init<='1';
				tent_min_comp<='1';
				min_comp<='1';
				tent_sec_comp<='1';
				sec_comp<='1';
				end if;
				
				
          
				
        end if;
		  
		  end if;
    end process p_set;


	p_reset : process (clk_i,ce_1hz_i)
    begin
	 if rising_edge(clk_i) and ce_1Hz_i='1' then  -- Rising clock edge
	  if srst_n_i ='0' then
		counter_val<=enc_val;
		countdown_complete<='0';
	elsif counter_val>x"0000" then
	  --counter_val<=counter_val-1;
	  countdown_complete<='0';
	  else
	  counter_val<=counter_val;
	  countdown_complete<='1';
	  end if;
	  
	  
	  
	  
		tent_minutes<=s_cntc4;			  
		minutes<=s_cntc3;
		tents_seconds<=s_cntc2;
		seconds<=s_cntc1;
	 
	 
	 end if;
	    end process p_reset;



end Behavioral;

