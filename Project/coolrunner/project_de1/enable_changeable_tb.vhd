--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   11:20:20 04/15/2020
-- Design Name:   
-- Module Name:   /home/ise/shared/project_final/project_de1/enable_changeable_tb.vhd
-- Project Name:  project_de1
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: clock_enable_changeable
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
 
ENTITY enable_changeable_tb IS
END enable_changeable_tb;
 
ARCHITECTURE behavior OF enable_changeable_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT clock_enable_changeable
    PORT(
         clk_i : IN  std_logic;
         srst_n_i : IN  std_logic;
         g_NPERIOD : IN  std_logic_vector(7 downto 0);
         clock_enable_changeable_o : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk_i : std_logic := '0';
   signal srst_n_i : std_logic := '0';
   signal g_NPERIOD : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal clock_enable_changeable_o : std_logic;

   -- Clock period definitions
   constant clk_i_period : time := 100 us;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: clock_enable_changeable PORT MAP (
          clk_i => clk_i,
          srst_n_i => srst_n_i,
          g_NPERIOD => g_NPERIOD,
          clock_enable_changeable_o => clock_enable_changeable_o
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
		srst_n_i<='1';
		g_NPERIOD<=x"10";
    	
		
      wait for 5 ms;
	g_NPERIOD<=x"05";
      -- insert stimulus here 

      wait;
   end process;

END;
