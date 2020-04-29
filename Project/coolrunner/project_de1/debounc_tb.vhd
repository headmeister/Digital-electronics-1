--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   12:32:59 04/15/2020
-- Design Name:   
-- Module Name:   /home/ise/shared/project_final/project_de1/debounc_tb.vhd
-- Project Name:  project_de1
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: debouncer
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
 
ENTITY debounc_tb IS
END debounc_tb;
 
ARCHITECTURE behavior OF debounc_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT debouncer
	  generic (
    g_NPERIOD : std_logic_vector(8-1 downto 0) := x"04"
);
    PORT(
         clk_i : IN  std_logic;
         input : IN  std_logic;
         debouncer_o : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk_i : std_logic := '0';
   signal input : std_logic := '0';

 	--Outputs
   signal debouncer_o : std_logic;

   -- Clock period definitions
   constant clk_i_period : time := 100 us;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: debouncer 
	generic map (g_NPERIOD=>x"10")
	PORT MAP (
          clk_i => clk_i,
          input => input,
          debouncer_o => debouncer_o
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
      input<='1';
		wait for 10 ms;
		input<='1';
		wait for 100 us;
		input<='0';
		wait for 100 us;
		input<='1';
		wait for 100 us;
		input<='0';
		wait for 100 us;
		input<='1';
		wait for 100 us;
		input<='0';
		wait for 100 us;
		input<='1';
		wait for 100 us;
		input<='0';
		wait for 100 us;
		input<='1';
		wait for 100 us;
		input<='0';
		wait for 100 us;
		input<='1';
		wait for 100 us;
		input<='0';
		wait for 10 ms;
		input<='1';
		wait for 100 us;
		input<='0';
		wait for 100 us;
		input<='1';
		wait for 100 us;
		input<='0';
		wait for 100 us;
		input<='1';
		wait for 100 us;
		input<='0';
		wait for 100 us;
		input<='1';
		wait for 100 us;
		input<='0';
		wait for 100 us;
		input<='1';
		wait for 100 us;
		input<='0';
		wait for 100 us;
		input<='1';
		wait for 100 us;
		
		
      wait for clk_i_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
