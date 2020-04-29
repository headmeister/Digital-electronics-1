--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   09:51:47 04/15/2020
-- Design Name:   
-- Module Name:   /home/ise/shared/project_final/project_de1/encoder_tb.vhd
-- Project Name:  project_de1
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: encoder
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
 
ENTITY encoder_tb IS
END encoder_tb;
 
ARCHITECTURE behavior OF encoder_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT encoder
    PORT(
         clk_i : IN  std_logic;
         A : IN  std_logic;
         B : IN  std_logic;
         enc_value : OUT  std_logic_vector(11 downto 0);
         reset : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk_i : std_logic := '0';
   signal A : std_logic := '0';
   signal B : std_logic := '0';

 	--Outputs
   signal enc_value : std_logic_vector(11 downto 0);
   signal reset : std_logic;

   -- Clock period definitions
   constant clk_i_period : time := 100 us;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: encoder PORT MAP (
          clk_i => clk_i,
          A => A,
          B => B,
          enc_value => enc_value,
          reset => reset
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
		B<='1';
      wait for 5 ms;	
		A<='1';
		wait for 5 ms;
		B<='0';
		wait for 5 ms;	
		A<='0';
		wait for 5 ms;
		B<='1';
      wait for 5 ms;	
		A<='1';
		wait for 5 ms;
		B<='0';
		wait for 5 ms;	
		A<='0';
		wait for 5 ms;
		B<='1';
      wait for 5 ms;	
		A<='1';
		wait for 20 ms;
		B<='0';
		wait for 20 ms;	
		A<='0';
		wait for 20 ms;
		B<='1';
      wait for 20 ms;	
		A<='1';
		wait for 20 ms;
		B<='0';
		wait for 20 ms;	
		A<='0';
		wait for 20 ms;
      wait for clk_i_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
