library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_unsigned.all;
--use ieee.numeric_std.all;
use IEEE.std_logic_arith.all;


entity vgasync is
port (clk : in std_logic;
		rst : in std_logic;
		rin, gin, bin : in std_logic_vector(3 downto 0);
		rout, gout, bout : out std_logic_vector(3 downto 0);
		hsync : out std_logic;
		vsync : out std_logic);
end vgasync;

architecture vga of vgasync is

signal Pixelclk : std_logic;
signal countH, countV: std_logic_vector(9 downto 0);

begin

process (clk, rst)
		begin
			if rst='0' then
				Pixelclk <= '0';
			elsif rising_edge(clk) then 
				Pixelclk <= NOT Pixelclk;
			end if;
end process;

process(clk, rst)
	begin
	if rst = '0' then
		countH <= (others => '0');
		countV <= (others => '0');
	elsif rising_edge(clk) then
		if Pixelclk = '1' then
			--Count Pixels
			if unsigned(countH) < 800  then
				countH <= unsigned(countH) + 1;
				if unsigned(countH) > 655 and unsigned(countH) < 752 then 
					hsync <= '0';
				else
					hsync <= '1';
				end if;
			else
				countH <= (others => '0');
				
				if unsigned(countV) = 491 or unsigned(countV) = 492 then
					vsync <= '0';
				else
					vsync <= '1';
				end if;
				
				-- Count Rows
				if unsigned(countV) < 524 then
					countV<=unsigned(countV) + 1;
				else
					countV <= (others => '0'); 
				end if;
			end if;
		end if;
	end if;
 end process;
 
 setColors: process(countH, countV, rin, gin, bin)
		begin

		case conv_integer(unsigned(countH)) is
			when 0 to 640 =>
				case conv_integer(unsigned(countV)) is
					when 0 to 480 =>
						rout <= rin;
						gout <= gin;
						bout <= bin;
					when others =>
						rout <= (others=> '0');
						gout <= (others=> '0');
						bout <= (others=> '0');
					end case;
			when others =>
						rout <= (others=> '0');
						gout <= (others=> '0');
						bout <= (others=> '0');
			end case;
	end process;
 
end vga;