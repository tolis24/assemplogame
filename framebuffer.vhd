library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_arith.all;

entity framebuffer is port(
      clk           : in  std_logic;
	  rst           : in  std_logic;
	  
	  we            : in  std_logic;
      dataIn        : in  std_logic_vector(15 downto 0);
	  
      countH  : in  std_logic_vector(9 downto 0);
      countV  : in  std_logic_vector(9 downto 0);
	  
      dataOut : out std_logic_vector(3 downto 0));
end framebuffer;

architecture mapping of framebuffer is

type memory is array(integer range 0 to 7, integer range 0 to 7) of std_logic_vector(3 downto 0);

signal frame : memory;
signal row, col : std_logic_vector(2 downto 0);


begin

-- Horizontal
--079 -> 000 100 1111
--159 -> 001 001 1111
--239 -> 001 110 1111
--319 -> 010 011 1111
--399 -> 011 000 1111
--479 -> 011 101 1111
--559 -> 100 010 1111
--639 -> 100 111 1111

--Vertical
--059 -> 0001 110 11
--119 -> 0011 101 11
--179 -> 0101 100 11
--239 -> 0111 011 11
--299 -> 1001 010 11
--359 -> 1011 001 11
--419 -> 1101 000 11
--479 -> 1110 111 11

-- As we see from the countH and countV with 3 bits we recognize the row and the column

row <= 	"000" when countV(4 downto 2)= "110" else
		"001" when countV(4 downto 2)= "101" else
		"010" when countV(4 downto 2)= "100" else
		"011" when countV(4 downto 2)= "011" else
		"100" when countV(4 downto 2)= "010" else
		"101" when countV(4 downto 2)= "001" else
		"110" when countV(4 downto 2)= "000" else
		"111" when countV(4 downto 2)= "111" else
		"000";
		
col <= 	"000" when countH(6 downto 4)= "100" else
		"001" when countH(6 downto 4)= "001" else
		"010" when countH(6 downto 4)= "110" else
		"011" when countH(6 downto 4)= "011" else
		"100" when countH(6 downto 4)= "000" else
		"101" when countH(6 downto 4)= "101" else
		"110" when countH(6 downto 4)= "010" else
		"111" when countH(6 downto 4)= "111" else
		"000";

wrt : process (clk, rst)

	begin
		if rising_edge(clk) then
			if (we = '1') then
				frame(conv_integer(unsigned(dataIn(11 downto 8))),conv_integer(unsigned(dataIn(7 downto 4)))) <= dataIn(3 downto 0);
			end if;
			
		dataOut <= frame(conv_integer(unsigned(row)),conv_integer(unsigned(col)));
		end if;

	end process;



end mapping;