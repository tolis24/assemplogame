library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_arith.all;

entity framebuffer is port(
      clk           : in  std_logic;
	  rst           : in  std_logic;
	  
	  we            : in  std_logic;
      dataIn        : in  std_logic_vector(15 downto 0);	-- Input data should have the following format
															-- (15 downto 12) don't care
															-- (11 downto 8) row number (X)
															-- (8 downto 4) column number (Y)
															-- (3 downto 0) value to store (V)
	  
      countH  : in  std_logic_vector(9 downto 0);
      countV  : in  std_logic_vector(9 downto 0);
	  
      dataOut : out std_logic_vector(3 downto 0));
end framebuffer;

architecture mapping of framebuffer is

type memory is array(integer range 0 to 7, integer range 0 to 7) of std_logic_vector(3 downto 0);

signal frame : memory;
signal row, col : std_logic_vector(2 downto 0);
signal X,Y,V : std_logic_vector(3 downto 0);


begin

X <= dataIn(11 downto 8);	-- Row
Y <= dataIn(7 downto 4);	-- Column
V <= dataIn(3 downto 0);	-- Value


row <= 	"000" when unsigned(countV) < 60 else
		"001" when unsigned(countV) < 120 else
		"010" when unsigned(countV) < 180 else
		"011" when unsigned(countV) < 240 else
		"100" when unsigned(countV) < 300 else
		"101" when unsigned(countV) < 360 else
		"110" when unsigned(countV) < 420 else
		"111" when unsigned(countV) < 480 else
		"000";
		
col <= 	"000" when unsigned(countH) < 80 else
		"001" when unsigned(countH) < 160 else
		"010" when unsigned(countH) < 240 else
		"011" when unsigned(countH) < 320 else
		"100" when unsigned(countH) < 400 else
		"101" when unsigned(countH) < 480 else
		"110" when unsigned(countH) < 560 else
		"111" when unsigned(countH) < 640 else
		"000";

process (clk, rst) --memory behavior

	begin
		if rst = '0' then
			for i in 0 to 7 loop 
				for j in 0 to 7 loop
					frame(i,j) <= (others => '0');
				end loop;
			end loop;
		elsif rising_edge(clk) then
			if (we = '1' and unsigned(X) < 8 and unsigned(Y) < 8) then
				frame(conv_integer(unsigned(X)),conv_integer(unsigned(Y))) <= V;
			end if;
			
		dataOut <= frame(conv_integer(unsigned(row)),conv_integer(unsigned(col)));
		end if;

	end process;



end mapping;