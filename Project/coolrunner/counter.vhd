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

--------------------------------------------------------------------------------
-- entity declaration for counter whicch performs countdown of the remaining time
--------------------------------------------------------------------------------
entity counter is
port (
    clk_i    : in  std_logic; -- input clock
    srst_n_i : in  std_logic;   -- Synchronous reset (active low)
    ce_1Hz_i: in std_logic;  -- 1 Hz clock enable
	 enc_val : in std_logic_vector(12-1 downto 0);  -- current value of set remaining time in seconds
    counter_stop: in std_logic; -- signal to stop countdown
	 
	 tent_minutes    : out std_logic_vector(4-1 downto 0); -- binary output of the digit which shows tenths of minutes
    minutes    : out std_logic_vector(4-1 downto 0);-- binary output of the digit which shows minutes
	 tents_seconds    : out std_logic_vector(4-1 downto 0); -- binary output of the digit which shows tenths of seconds
	 seconds    : out std_logic_vector(4-1 downto 0);-- binary output of the digit which shows seconds
	 countdown_complete : out std_logic; -- output flag, that the countdown has finished
	counter_value_o : out std_logic_vector(12-1 downto 0) -- output value of the counter for blinking or other purpouses
	 
);


end counter;

architecture Behavioral of counter is

	signal init : std_logic:='0';
	 
	 signal tent_min_comp : std_logic:='0';
	 
	 signal  min_comp : std_logic:='0';
	 
	 signal  tent_sec_comp : std_logic:='0';
	 
	 

	signal  counter_val : std_logic_vector(12-1 downto 0):=x"010";
	
	-----------------------------------------------------
	--- counter registers
	-----------------------------------------------------
	
 signal s_cntc1 : std_logic_vector(4-1 downto 0):="0000" ;
	 
	 signal s_cntc2 : std_logic_vector(4-1 downto 0):="0000" ;
	 
	 signal s_cntc3 : std_logic_vector(4-1 downto 0):="0000" ;
	 
	 signal s_cntc4 : std_logic_vector(4-1 downto 0):="0000" ;
	 
	 --------------------------------------------------------------
	 --temporary counter registers for synchronized display updates
	 --------------------------------------------------------------
	  signal s_cntc1_temp : std_logic_vector(4-1 downto 0):="0000" ;
	 
	 signal s_cntc2_temp : std_logic_vector(4-1 downto 0):="0000" ;
	 
	 signal s_cntc3_temp : std_logic_vector(4-1 downto 0):="0000" ;
	 
	 signal s_cntc4_temp : std_logic_vector(4-1 downto 0):="0000" ;
	 
	 
	 signal counter_work : integer range -600 to 3600 := 0;
	 
	 
begin

	--------------------------------------------------------------
	 -- sequential process performing conversion from binary to display digits values (binary) 
	 
	 -- This process performs sequential divison with the remainder by using multiple substractions
	 -- First it substracts tenths of minutes (600 s) from the working register. When the remainder is less then 600
	 -- it jumps to single minutes (60 s) and so on till it substracts the last second.
	 -- since this process can take different amount of time (however this amount of time is still far less than one second) 
	 -- for different inputs of counter values (remaining time), it stores the output values in buffer registers scnt_temp1-4. 
	 --Their contents are forwarded to the output registers in the other process p_reset every second when the timer is decremented 
	 --by one, or when the encoder value changes, so that the update rate is large enough, when turning the encoder to catch all changes
	 --------------------------------------------------------------


		p_set : process (clk_i,ce_1hz_i)
    begin
        if rising_edge(clk_i)  then  -- Rising clock edge
            
            
				
				if init = '0'   then  -- initialization 
					counter_work<= to_integer (unsigned(counter_val));
					init<='1';
					s_cntc1<="0000";
				
					s_cntc2<="0000";
					s_cntc3<="0000";
					s_cntc4<="0000";
				elsif((counter_work-600)>=0 and tent_min_comp='0' and init='1') then  -- substraction of tenths of minutes
					s_cntc4<=s_cntc4+"0001";
					counter_work<=counter_work-600;
					tent_min_comp<='0';
				elsif((counter_work-600)<0 and tent_min_comp='0' and init='1') then 
					tent_min_comp<='1';
				
				elsif(counter_work-60>=0 and tent_min_comp='1' and min_comp='0') then -- substraction of minutes
					s_cntc3<=s_cntc3+"0001";
					counter_work<=counter_work-60;
					min_comp<='0';
				elsif (counter_work-60<0 and tent_min_comp='1' and min_comp='0') then 
					min_comp<='1';
				
				elsif(counter_work-10>=0 and tent_min_comp='1' and min_comp ='1' and tent_sec_comp ='0') then-- substraction of tenths of seconds
					s_cntc2<=s_cntc2+"0001";
					counter_work<=counter_work-10;
					tent_sec_comp<='0';
				elsif (counter_work-10<0 and tent_min_comp='1' and min_comp ='1' and tent_sec_comp ='0') then
					tent_sec_comp<='1';

				elsif((counter_work-1)>=0 and tent_min_comp='1' and min_comp='1' and tent_sec_comp='1' ) then -- substraction of seconds
					s_cntc1<=s_cntc1+"0001";
					counter_work<=counter_work-1;
				
				else -- otherwise the conversion is finished so move the output to intermediate register and start again
					init<='0';
					tent_min_comp<='0';
					min_comp<='0';
					tent_sec_comp<='0';	
				
					s_cntc4_temp<=s_cntc4;			  
					s_cntc3_temp<=s_cntc3;		
					s_cntc2_temp<=s_cntc2;		
					s_cntc1_temp<=s_cntc1;		
				
				
				end if;
				  
		  
		  end if;
    end process p_set;

	--------------------------------------------------------------
	 -- sequential process performing decrement of the counter, updating of the current remaining time and updating the display.
	 --------------------------------------------------------------
	 
	 
	 
	p_reset : process (clk_i,ce_1hz_i)
    begin
	 if rising_edge(clk_i)  then  -- Rising clock edge
		if srst_n_i ='0' then -- if the reset is on (comes on on button press or rotation of the encoder)
			counter_val<=enc_val; -- import the value of the encoder to counter
			countdown_complete<='0';
			-- update the display ( the value is likely to be delayed but by so small fraction of the time, that human eye cannot see it)
		   tent_minutes<=s_cntc4_temp;			  
			minutes<=s_cntc3_temp;
			tents_seconds<=s_cntc2_temp;
			seconds<=s_cntc1_temp;
		
			counter_value_o<=counter_val;

		elsif  counter_val=enc_val and ce_1hz_i='0'  then -- to update the display after the encoder stopped changing values
		  tent_minutes<=s_cntc4_temp;			  
		  minutes<=s_cntc3_temp;
		  tents_seconds<=s_cntc2_temp;
		  seconds<=s_cntc1_temp;
		
			countdown_complete<='0';
			counter_value_o<=counter_val;

		
		elsif counter_val>x"0000" and ce_1hz_i='1' and counter_stop='0' then -- if the counter is more than 0 (hasnt finished) and it one second has passed decrement
			counter_val<=counter_val-1;
			countdown_complete<='0';
			tent_minutes<=s_cntc4_temp;			  
			minutes<=s_cntc3_temp;
			tents_seconds<=s_cntc2_temp;
			seconds<=s_cntc1_temp;
			counter_value_o<=counter_val;
			
		elsif counter_val>x"0000" and ce_1hz_i='0' then
			countdown_complete<='0';
			counter_val<=counter_val;
			counter_value_o<=counter_val;
			
		else -- otherwise keep the value of the counter set the output flag that the counter has finished and keep updating the display
			counter_val<=counter_val;
			countdown_complete<='1';
	  
			tent_minutes<=s_cntc4_temp;			  
			minutes<=s_cntc3_temp;
			tents_seconds<=s_cntc2_temp;
			seconds<=s_cntc1_temp;
	 
	  
			counter_value_o<=counter_val;
	   end if;

	 
	 end if;
	    end process p_reset;



end Behavioral;