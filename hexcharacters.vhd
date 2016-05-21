-- Arthur Makumbi
-- project 2
-- hexadecimal characters

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity hexcharacters is
	port 
	(
		abcd	   : in std_logic_vector (3 downto 0);
		result : out std_logic_vector (6 downto 0)
	);

end entity;

architecture rtl of hexcharacters is
begin
process (abcd)
BEGIN
case  abcd is
when "0000"=> result <= "1000000";  -- '0'
when "0001"=> result <= "1111001";  -- '1'
when "0010"=> result <= "0100100";  -- '2'
when "0011"=> result <= "0110000";  -- '3'
when "0100"=> result <= "0011001";  -- '4'
when "0101"=> result <= "0010010";  -- '5'
when "0110"=> result <= "0000010";  -- '6'
when "0111"=> result <= "1111000";  -- '7'
when "1000"=> result <= "0000000";  -- '8'
when "1001"=> result <= "0010000";  -- '9'
when "1010"=> result <= "0001000";  -- 'A'
when "1011"=> result <= "0000011";  -- 'b'
when "1100"=> result <= "1000110";  -- 'C'
when "1101"=> result <= "0100001";  -- 'D'
when "1110"=> result <= "0000110";  -- 'E'
when "1111"=> result <= "0001110";  -- 'F'

end case;
end process;
end rtl;
