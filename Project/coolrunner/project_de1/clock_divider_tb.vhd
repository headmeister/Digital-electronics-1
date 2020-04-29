--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   11:50:02 04/15/2020
-- Design Name:   
-- Module Name:   /home/ise/shared/project_final/project_de1/clock_divider_tb.vhd
-- Project Name:  project_de1
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: clock_divider
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
 
ENTITY clock_divider_tb IS
END clock_divider_tb;
 
ARCHITECTURE behavior OF clock_divider_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT clock_divider
	 generic (
    g_NPERIOD : std_logic_vector(16-1 downto 0) := x"0004"
);
    PORT(
         clk_i : IN  std_logic;
         srst_n_i : IN  std_logic;
         clock_divide_o : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk_i : std_logic := '0';
   signal srst_n_i : std_logic := '0';

 	--Outputs
   signal clock_divide_o : std_logic;

   -- Clock period definitions
   constant clk_i_period : time := 100 us;
  
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: clock_divider 
	generic map (g_NPERIOD=>x"0005")
	PORT MAP (
          clk_i => clk_i,
          srst_n_i => srst_n_i,
          clock_divide_o => clock_divide_o
        );

   -- Clock process definitions
   clk_i_process :process
   begin
		clk_i <= '0';
		wait for clk_i_period/2;
		clk_i <= '1';
		wait for clk_i_period/2;
   end process;
 
  
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		
      wait for 100 ns;	
		srst_n_i<='0';
      wait for clk_i_period*10;
		srst_n_i<='1';
      -- insert stimulus here 

      wait;
   end process;

END;
