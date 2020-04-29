--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   12:14:09 04/15/2020
-- Design Name:   
-- Module Name:   /home/ise/shared/project_final/project_de1/Dimmer_tb.vhd
-- Project Name:  project_de1
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: PWM_dimmer
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
 
ENTITY Dimmer_tb IS
END Dimmer_tb;
 
ARCHITECTURE behavior OF Dimmer_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT PWM_dimmer
    PORT(
         clk_i : IN  std_logic;
         dimmer_active : IN  std_logic;
         PWM_out : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk_i : std_logic := '0';
   signal dimmer_active : std_logic := '0';

 	--Outputs
   signal PWM_out : std_logic;

   -- Clock period definitions
   constant clk_i_period : time := 100 us;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: PWM_dimmer PORT MAP (
          clk_i => clk_i,
          dimmer_active => dimmer_active,
          PWM_out => PWM_out
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
       dimmer_active<='0';
      wait for 100 ms;	
			dimmer_active<='1';
      wait for clk_i_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
