--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   08:55:56 04/15/2020
-- Design Name:   
-- Module Name:   /home/ise/shared/project_final/project_de1/Countdown_tb.vhd
-- Project Name:  project_de1
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: counter
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY Countdown_tb IS
END Countdown_tb;
 
ARCHITECTURE behavior OF Countdown_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT counter
    PORT(
         clk_i : IN  std_logic;
         srst_n_i : IN  std_logic;
         ce_1Hz_i : IN  std_logic;
         enc_val : IN  std_logic_vector(11 downto 0);
         counter_stop : IN  std_logic;
         tent_minutes : OUT  std_logic_vector(3 downto 0);
         minutes : OUT  std_logic_vector(3 downto 0);
         tents_seconds : OUT  std_logic_vector(3 downto 0);
         seconds : OUT  std_logic_vector(3 downto 0);
         countdown_complete : OUT  std_logic;
         counter_value_o : OUT  std_logic_vector(11 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk_i : std_logic := '0';
   signal srst_n_i : std_logic := '0';
   signal ce_1Hz_i : std_logic := '0';
   signal enc_val : std_logic_vector(11 downto 0) := (others => '0');
   signal counter_stop : std_logic := '0';

 	--Outputs
   signal tent_minutes : std_logic_vector(3 downto 0);
   signal minutes : std_logic_vector(3 downto 0);
   signal tents_seconds : std_logic_vector(3 downto 0);
   signal seconds : std_logic_vector(3 downto 0);
   signal countdown_complete : std_logic;
   signal counter_value_o : std_logic_vector(11 downto 0);

   -- Clock period definitions
   constant clk_i_period : time := 100 us;
	constant clk_i_period_2: time :=1000 ms;
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: counter PORT MAP (
          clk_i => clk_i,
          srst_n_i => srst_n_i,
          ce_1Hz_i => ce_1Hz_i,
          enc_val => enc_val,
          counter_stop => counter_stop,
          tent_minutes => tent_minutes,
          minutes => minutes,
          tents_seconds => tents_seconds,
          seconds => seconds,
          countdown_complete => countdown_complete,
          counter_value_o => counter_value_o
        );

   -- Clock process definitions
   clk_i_process :process
   begin
		clk_i <= '0';
		wait for clk_i_period/2;
		clk_i <= '1';
		wait for clk_i_period/2;
   end process;
 
 clk_1Hz_process :process
   begin
		ce_1Hz_i <= '0';
		wait for clk_i_period_2/2-clk_i_period/2;
		
		ce_1Hz_i <= '1';
		wait for clk_i_period/2;
		ce_1Hz_i <= '0';
		wait for clk_i_period_2/2;
   end process;


   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		counter_stop<='0';
		enc_val<=x"E0F";
		wait for 100 ns;
		
		srst_n_i<='0';
      wait for 1 ms;	
		srst_n_i<='1';
		
      wait for 3000 ms;
		counter_stop<='1';
		
		wait for 3000 ms;
		srst_n_i<='0';
		wait for 500 ms;
		srst_n_i<='1';

      -- insert stimulus here 

      wait;
   end process;

END;
