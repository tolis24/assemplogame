library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_arith.all;

entity icon_rom is
port (countV : in std_logic_vector(9 downto 0);
		pointer : in std_logic_vector(3 downto 0);
		data : out std_logic_vector(79 downto 0));
end entity;

architecture RTL of icon_rom is

signal row : std_logic_vector(5 downto 0);
signal address : std_logic_vector(9 downto 0);

begin


process (countV)
begin 
	if unsigned(countV) < 60 then 
		row <= countV;
	elsif unsigned(countV) < 120 then
		row <= unsigned(countV) - 60;
	elsif unsigned(countV) < 180 then
		row <= unsigned(countV) - 120;
	elsif unsigned(countV) < 240 then
		row <= unsigned(countV) - 180;
	elsif unsigned(countV) < 300 then
		row <= unsigned(countV) - 240;
	elsif unsigned(countV) < 360 then
		row <= unsigned(countV) - 300;
	elsif unsigned(countV) < 420 then
		row <= unsigned(countV) - 360;
	elsif unsigned(countV) < 480 then
		row <= unsigned(countV) - 420;
	else
		row <= (others => '0');
	end if;
end process;

		
address(9 downto 6) <= pointer;
address(5 downto 0) <= row;

process(address)
begin
case address is
-- 0
when "0000000000"=> data <= "00000000000000000000000000000000000000000000000000000000000000000000000000000000";
when "0000000001"=> data <= "11111111111111111111111111111111111111111111111111111111111111111111111111111111";
when "0000000010"=> data <= "00000000000000000000000000000000000000000000000000000000000000000000000000000000";
when "0000000011"=> data <= "11111111111111111111111111111111111111111111111111111111111111111111111111111111";
when "0000000100"=> data <= "00000000000000000000000000000000000000000000000000000000000000000000000000000000";
when "0000000101"=> data <= "11111111111111111111111111111111111111111111111111111111111111111111111111111111";
when "0000000110"=> data <= "00000000000000000000000000000000000000000000000000000000000000000000000000000000";
when "0000000111"=> data <= "11111111111111111111111111111111111111111111111111111111111111111111111111111111";
when "0000001000"=> data <= "00000000000000000000000000000000000000000000000000000000000000000000000000000000";
when "0000001001"=> data <= "11111111111111111111111111111111111111111111111111111111111111111111111111111111";
when "0000001010"=> data <= "00000000000000000000000000000000000000000000000000000000000000000000000000000000";
when "0000001011"=> data <= "11111111111111111111111111111111111111111111111111111111111111111111111111111111";
when "0000001100"=> data <= "00000000000000000000000000000000000000000000000000000000000000000000000000000000";
when "0000001101"=> data <= "11111111111111111111111111111111111111111111111111111111111111111111111111111111";
when "0000001110"=> data <= "00000000000000000000000000000000000000000000000000000000000000000000000000000000";
when "0000001111"=> data <= "11111111111111111111111111111111111111111111111111111111111111111111111111111111";
when "0000010000"=> data <= "00000000000000000000000000000000000000000000000000000000000000000000000000000000";
when "0000010001"=> data <= "11111111111111111111111111111111111111111111111111111111111111111111111111111111";
when "0000010010"=> data <= "00000000000000000000000000000000000000000000000000000000000000000000000000000000";
when "0000010011"=> data <= "11111111111111111111111111111111111111111111111111111111111111111111111111111111";
when "0000010100"=> data <= "00000000000000000000000000000000000000000000000000000000000000000000000000000000";
when "0000010101"=> data <= "11111111111111111111111111111111111111111111111111111111111111111111111111111111";
when "0000010110"=> data <= "00000000000000000000000000000000000000000000000000000000000000000000000000000000";
when "0000010111"=> data <= "11111111111111111111111111111111111111111111111111111111111111111111111111111111";
when "0000011000"=> data <= "00000000000000000000000000000000000000000000000000000000000000000000000000000000";
when "0000011001"=> data <= "11111111111111111111111111111111111111111111111111111111111111111111111111111111";
when "0000011010"=> data <= "00000000000000000000000000000000000000000000000000000000000000000000000000000000";
when "0000011011"=> data <= "11111111111111111111111111111111111111111111111111111111111111111111111111111111";
when "0000011100"=> data <= "00000000000000000000000000000000000000000000000000000000000000000000000000000000";
when "0000011101"=> data <= "11111111111111111111111111111111111111111111111111111111111111111111111111111111";
when "0000011110"=> data <= "00000000000000000000000000000000000000000000000000000000000000000000000000000000";
when "0000011111"=> data <= "11111111111111111111111111111111111111111111111111111111111111111111111111111111";
when "0000100000"=> data <= "00000000000000000000000000000000000000000000000000000000000000000000000000000000";
when "0000100001"=> data <= "11111111111111111111111111111111111111111111111111111111111111111111111111111111";
when "0000100010"=> data <= "00000000000000000000000000000000000000000000000000000000000000000000000000000000";
when "0000100011"=> data <= "11111111111111111111111111111111111111111111111111111111111111111111111111111111";
when "0000100100"=> data <= "00000000000000000000000000000000000000000000000000000000000000000000000000000000";
when "0000100101"=> data <= "11111111111111111111111111111111111111111111111111111111111111111111111111111111";
when "0000100110"=> data <= "00000000000000000000000000000000000000000000000000000000000000000000000000000000";
when "0000100111"=> data <= "11111111111111111111111111111111111111111111111111111111111111111111111111111111";
when "0000101000"=> data <= "00000000000000000000000000000000000000000000000000000000000000000000000000000000";
when "0000101001"=> data <= "11111111111111111111111111111111111111111111111111111111111111111111111111111111";
when "0000101010"=> data <= "00000000000000000000000000000000000000000000000000000000000000000000000000000000";
when "0000101011"=> data <= "11111111111111111111111111111111111111111111111111111111111111111111111111111111";
when "0000101100"=> data <= "00000000000000000000000000000000000000000000000000000000000000000000000000000000";
when "0000101101"=> data <= "11111111111111111111111111111111111111111111111111111111111111111111111111111111";
when "0000101110"=> data <= "00000000000000000000000000000000000000000000000000000000000000000000000000000000";
when "0000101111"=> data <= "11111111111111111111111111111111111111111111111111111111111111111111111111111111";
when "0000110000"=> data <= "00000000000000000000000000000000000000000000000000000000000000000000000000000000";
when "0000110001"=> data <= "11111111111111111111111111111111111111111111111111111111111111111111111111111111";
when "0000110010"=> data <= "00000000000000000000000000000000000000000000000000000000000000000000000000000000";
when "0000110011"=> data <= "11111111111111111111111111111111111111111111111111111111111111111111111111111111";
when "0000110100"=> data <= "00000000000000000000000000000000000000000000000000000000000000000000000000000000";
when "0000110101"=> data <= "11111111111111111111111111111111111111111111111111111111111111111111111111111111";
when "0000110110"=> data <= "00000000000000000000000000000000000000000000000000000000000000000000000000000000";
when "0000110111"=> data <= "11111111111111111111111111111111111111111111111111111111111111111111111111111111";
when "0000111000"=> data <= "00000000000000000000000000000000000000000000000000000000000000000000000000000000";
when "0000111001"=> data <= "11111111111111111111111111111111111111111111111111111111111111111111111111111111";
when "0000111010"=> data <= "00000000000000000000000000000000000000000000000000000000000000000000000000000000";
when "0000111011"=> data <= "11111111111111111111111111111111111111111111111111111111111111111111111111111111";

--1
when "0001000000"=> data <= "00000000000000000000000000000000000000000000000000000000000000000000000000000000";
when "0001000001"=> data <= "00000000000000000000000000000000000000000000000000000000000000000000000000000000";
when "0001000010"=> data <= "00000000000000000000000000000000000000000000000000000000000000000000000000000000";
when "0001000011"=> data <= "00000000000000000000000000000000000000001000000000000000000000000000000000000000";
when "0001000100"=> data <= "00000000000000000000000000000000000000011100000000000000000000000000000000000000";
when "0001000101"=> data <= "00000000000000000000000000000000000000111110000000000000000000000000000000000000";
when "0001000110"=> data <= "00000000000000000000000000000000000001110111000000000000000000000000000000000000";
when "0001000111"=> data <= "00000000000000000000000000000000000011100111000000000000000000000000000000000000";
when "0001001000"=> data <= "00000000000000000000000000000000000111000011100000000000000000000000000000000000";
when "0001001001"=> data <= "00000000000000000000000000000000001110000001110000000000000000000000000000000000";
when "0001001010"=> data <= "00000000000000000000000000000000011100000000111000000000000000000000000000000000";
when "0001001011"=> data <= "00000000000000000000000000000000111000000000011100000000000000000000000000000000";
when "0001001100"=> data <= "00000000000000000000000000000001110000000000001110000000000000000000000000000000";
when "0001001101"=> data <= "00000000000000000000000000000011100000000000000111000000000000000000000000000000";
when "0001001110"=> data <= "00000000000000000000000000000111000000000000000011100000000000000000000000000000";
when "0001001111"=> data <= "00000000000000000000000000001110000000000000000001110000000000000000000000000000";
when "0001010000"=> data <= "00000000000000000000000000011100000000000000000000111000000000000000000000000000";
when "0001010001"=> data <= "00000000000000000000000000111000000000000000000000011100000000000000000000000000";
when "0001010010"=> data <= "00000000000000000000000001110000000000000000000000001110000000000000000000000000";
when "0001010011"=> data <= "00000000000000000000000011100000000000000000000000000111000000000000000000000000";
when "0001010100"=> data <= "00000000000000000000000111000000000000000000000000000011100000000000000000000000";
when "0001010101"=> data <= "00000000000000000000001110000000000000000000000000000001110000000000000000000000";
when "0001010110"=> data <= "00000000000000000000011100000000000000000000000000000000111000000000000000000000";
when "0001010111"=> data <= "00000000000000000000111000000000000000000000000000000000011100000000000000000000";
when "0001011000"=> data <= "00000000000000000001110000000000000000000000000000000000001110000000000000000000";
when "0001011001"=> data <= "00000000000000000011100000000000000000000000000000000000000111000000000000000000";
when "0001011010"=> data <= "00000000000000000111000000000000000000000000000000000000000011100000000000000000";
when "0001011011"=> data <= "00000000000000001110000000000000000000000000000000000000000001110000000000000000";
when "0001011100"=> data <= "00000000000000011100000000000000000000000000000000000000000000111000000000000000";
when "0001011101"=> data <= "00000000000000111000000000000000000000000000000000000000000000011100000000000000";
when "0001011110"=> data <= "00000000000001110000000000000000000000000000000000000000000000001110000000000000"; --center
when "0001011111"=> data <= "00000000000000111000000000000000000000000000000000000000000000011100000000000000";
when "0001100000"=> data <= "00000000000000011100000000000000000000000000000000000000000000111000000000000000";
when "0001100001"=> data <= "00000000000000001110000000000000000000000000000000000000000001110000000000000000";
when "0001100010"=> data <= "00000000000000000111000000000000000000000000000000000000000011100000000000000000";
when "0001100011"=> data <= "00000000000000000011100000000000000000000000000000000000000111000000000000000000";
when "0001100100"=> data <= "00000000000000000001110000000000000000000000000000000000001110000000000000000000";
when "0001100101"=> data <= "00000000000000000000111000000000000000000000000000000000011100000000000000000000";
when "0001100110"=> data <= "00000000000000000000011100000000000000000000000000000000111000000000000000000000";
when "0001100111"=> data <= "00000000000000000000001110000000000000000000000000000001110000000000000000000000";
when "0001101000"=> data <= "00000000000000000000000111000000000000000000000000000011100000000000000000000000";
when "0001101001"=> data <= "00000000000000000000000011100000000000000000000000000111000000000000000000000000";
when "0001101010"=> data <= "00000000000000000000000001110000000000000000000000001110000000000000000000000000";
when "0001101011"=> data <= "00000000000000000000000000111000000000000000000000011100000000000000000000000000";
when "0001101100"=> data <= "00000000000000000000000000011100000000000000000000111000000000000000000000000000";
when "0001101101"=> data <= "00000000000000000000000000001110000000000000000001110000000000000000000000000000";
when "0001101110"=> data <= "00000000000000000000000000000111000000000000000011100000000000000000000000000000";
when "0001101111"=> data <= "00000000000000000000000000000011100000000000000111000000000000000000000000000000";
when "0001110000"=> data <= "00000000000000000000000000000001110000000000001110000000000000000000000000000000";
when "0001110001"=> data <= "00000000000000000000000000000000111000000000011100000000000000000000000000000000";
when "0001110010"=> data <= "00000000000000000000000000000000011100000000111000000000000000000000000000000000";
when "0001110011"=> data <= "00000000000000000000000000000000001110000001110000000000000000000000000000000000";
when "0001110100"=> data <= "00000000000000000000000000000000000111000011100000000000000000000000000000000000";
when "0001110101"=> data <= "00000000000000000000000000000000000011100111000000000000000000000000000000000000";
when "0001110110"=> data <= "00000000000000000000000000000000000001110111000000000000000000000000000000000000";
when "0001110111"=> data <= "00000000000000000000000000000000000000111110000000000000000000000000000000000000";
when "0001111000"=> data <= "00000000000000000000000000000000000000011100000000000000000000000000000000000000";
when "0001111001"=> data <= "00000000000000000000000000000000000000000000000000000000000000000000000000000000";
when "0001111010"=> data <= "00000000000000000000000000000000000000000000000000000000000000000000000000000000";
when "0001111011"=> data <= "00000000000000000000000000000000000000000000000000000000000000000000000000000000";

--2


when others => data <= "00000000000000000000000000000000000000000000000000000000000000000000000000000000";
end case;
end process;
end RTL;