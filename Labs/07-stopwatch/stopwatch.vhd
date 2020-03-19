------------------------------------------------------------------------
--
-- Driver for seven-segment displays.
-- Xilinx XC2C256-TQ144 CPLD, ISE Design Suite 14.7
--
-- Copyright (c) 2019-2020 Tomas Fryza
-- Dept. of Radio Electronics, Brno University of Technology, Czechia
-- This work is licensed under the terms of the MIT license.
--
------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;    -- Provides unsigned numerical computation

------------------------------------------------------------------------
-- Entity declaration for display driver
------------------------------------------------------------------------
entity stopwatch is
port (
    clk_i    : in  std_logic;
    srst_n_i : in  std_logic;   -- Synchronous reset (active low)
    ce_100Hz_i: in std_logic;
	 cnt_en_i : in std_logic;
	 
    sec_h_o    : out std_logic_vector(4-1 downto 0);
    sec_l_o    : out std_logic_vector(4-1 downto 0);
	 hth_h_o    : out std_logic_vector(4-1 downto 0);
	 hth_l_o    : out std_logic_vector(4-1 downto 0)
);
end entity stopwatch;

------------------------------------------------------------------------
-- Architecture declaration for display driver
------------------------------------------------------------------------
architecture Behavioral of stopwatch is
    

    
    
	 
	 signal s_cntc1 : std_logic_vector(4-1 downto 0) := "0000";
	 
	 signal s_cntc2 : std_logic_vector(4-1 downto 0) := "0000";
	 
	 signal s_cntc3 : std_logic_vector(4-1 downto 0) := "0000";
	 
	 signal s_cntc4 : std_logic_vector(4-1 downto 0) := "0000";

begin
	
    --------------------------------------------------------------------
    -- Sub-block of clock_enable entity. Create s_en signal.
    --- WRITE YOUR CODE HERE

		sec_h_o<=s_cntc4;			  
		sec_l_o<=s_cntc3;
		hth_h_o<=s_cntc2;
		hth_l_o<=s_cntc1;
		


    p_select_cnt1 : process (clk_i)
    begin
        if rising_edge(clk_i) then  -- Rising clock edge
            if srst_n_i = '0' then  -- Synchronous reset (active low)
                s_cntc1<="0000";
            elsif ce_100Hz_i = '1' and cnt_en_i='1' then
				if s_cntc1<"1001" then
               s_cntc1<=s_cntc1+1;
				
				else
				s_cntc1<="0000";
				
				end if;
            end if;
        end if;
    end process p_select_cnt1;



    p_select_cnt2 : process (clk_i)
    begin
        if rising_edge(clk_i) then  -- Rising clock edge
            if srst_n_i = '0' then  -- Synchronous reset (active low)
                s_cntc2<="0000";
					 
            elsif ce_100Hz_i = '1' and s_cntc1="1001" then
				if s_cntc2<"1001" then
               s_cntc2<=s_cntc2+1;

				else
				s_cntc2<="0000";

				end if;
            end if;
        end if;
    end process p_select_cnt2;
	 
	     p_select_cnt3 : process (clk_i)
    begin
        if rising_edge(clk_i) then  -- Rising clock edge
            if srst_n_i = '0' then  -- Synchronous reset (active low)
                s_cntc3<="0000";
					 
            elsif ce_100Hz_i = '1' and s_cntc1="1001" and s_cntc2="1001" then
				if s_cntc3<"1001" then
               s_cntc3<=s_cntc3+1;

				else
				s_cntc3<="0000";
			
				end if;
            end if;
        end if;
    end process p_select_cnt3;
	 
	     p_select_cnt4 : process (clk_i)
    begin
        if rising_edge(clk_i) then  -- Rising clock edge
            if srst_n_i = '0' then  -- Synchronous reset (active low)
                s_cntc4<="0000";
            elsif ce_100Hz_i = '1' and s_cntc1="1001" and s_cntc3="1001" and s_cntc2="1001" then
				if s_cntc4<"0101" then
               s_cntc4<=s_cntc4+1;
					
				else
				s_cntc4<="0000";
				
				end if;
            end if;
        end if;
    end process p_select_cnt4;

		






end architecture Behavioral;