----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:51:27 03/25/2020 
-- Design Name: 
-- Module Name:    Traffic - Behavioral 
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
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Traffic is
    Port ( clk_i : in  STD_LOGIC;
           srst_n_i : in  STD_LOGIC;
			  lights_o : out  std_logic_vector(5 downto 0));
end Traffic;

architecture Traffic of Traffic is
	type State_type is (zelena_cervena, oranzova_cervena, cervena_cervena, cervena_zelena, cervena_oranzova, cervena_cervena2);
	signal state: State_type;
	signal count : unsigned(3 downto 0);
	constant SEC5: unsigned(3 downto 0) := "1110"; -- upraveno aby bloky při f 3Hz trvaly přesně 1s
	constant SEC1: unsigned(3 downto 0) := "0010"; -- upraveno aby bloky při f 3Hz trvaly přesně 1s

begin
	process (clk_i, srst_n_i)
		begin
			
			if rising_edge(clk_i) then
			if srst_n_i = '0' then   -- udělat synchronní reset
				state <= zelena_cervena;
				count <= X"0";
			else
			
			case state is 
				when zelena_cervena => 
					if count < SEC5 then
					state <= zelena_cervena;
					count <= count + 1;
					else
					state <= oranzova_cervena;
					count <= X"0";
					end if;
			
				when oranzova_cervena => 
					if count < SEC1 then
					state <= oranzova_cervena;
					count <= count + 1;
					else
					state <= cervena_cervena;
					count <= X"0";
					end if;
			
				when cervena_cervena => 
					if count < SEC1 then
					state <= cervena_cervena;
					count <= count + 1;
					else
					state <= cervena_zelena;
					count <= X"0";
					end if;
			
				when cervena_zelena => 
					if count < SEC5 then
					state <= cervena_zelena;
					count <= count + 1;
					else
					state <= cervena_oranzova;
					count <= X"0";
					end if;
					
				when cervena_oranzova => 
					if count < SEC1 then
					state <= cervena_oranzova;
					count <= count + 1;
					else
					state <= cervena_cervena2;
					count <= X"0";
					end if;
					
				when cervena_cervena2=> 
					if count < SEC1 then
					state <= cervena_cervena2;
					count <= count + 1;
					else
					state <= zelena_cervena;
					count <= X"0";
					end if;	
				when others =>
					state <= zelena_cervena;
			end case;
			end if;
		end if;
		end process;
		
		C2:process(state) -- definovat korespondující výstupní stavy 
		begin 
		case state is
		when zelena_cervena=>lights_o<="100001";
		when oranzova_cervena=>lights_o<="010001";
		when cervena_cervena=>lights_o<="001001";
		when cervena_zelena=>lights_o<="001100";
		when cervena_oranzova=>lights_o<="001010";
		when cervena_cervena2=>lights_o<="001001";
		when others =>lights_o<="100001";
		end case;
		
		end process;
		
		
		
end Traffic;

