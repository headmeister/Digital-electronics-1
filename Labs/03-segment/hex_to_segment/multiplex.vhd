----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:02:09 02/19/2020 
-- Design Name: 
-- Module Name:    multiplex - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity multiplex is
  port(vstup:         in std_logic_vector(4-1 downto 0);
             vystup: out std_logic;
             adresa:         in std_logic_vector(2-1 downto 0));
end multiplex;

architecture Behavioral of multiplex is
      
begin


LD0<= vstup(0)  when (adresa = "00") else 
      vstup(1)  when (adresa = "01") else 
      vstup(2)  when (adresa = "10") else            
       vstup(3);



end Behavioral;

