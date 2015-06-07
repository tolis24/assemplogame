library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity tb is
	port (
			clk, rst : in std_logic;
	
			hsync, vsync : out std_logic;
			rout, gout, bout : out std_logic_vector(3 downto 0)
		);
end tb;

architecture test of tb is

	component ram_infer is port(
      clk           : in  std_logic;
	  rst           : in  std_logic;
      dataIn        : in  std_logic_vector(15 downto 0);
      write_address : in  std_logic_vector(15 downto 0);
      read_address  : in  std_logic_vector(15 downto 0);
      we            : in  std_logic;
      dataOut       : out std_logic_vector(15 downto 0));
	end component ram_infer;
	
	component processor is
		port (	clk : in std_logic;
				rst :in std_logic;
		
				iaddr : out std_logic_vector(15 downto 0);
				idata : in std_logic_vector(15 downto 0);
		
				daddr : out std_logic_vector(15 downto 0);
				dwen : out std_logic;							--Data Mem write Enable warning!!!
				dout : out std_logic_vector(15 downto 0);
				din : in std_logic_vector(15 downto 0)
		);
	end component processor;
	
	component vgasync is
	port (clk : in std_logic;
			rst : in std_logic;
			rin, gin, bin : in std_logic_vector(3 downto 0);
			rout, gout, bout : out std_logic_vector(3 downto 0);
			hsync : out std_logic;
			vsync : out std_logic);
	end component vgasync;
	
	signal dwen : std_logic;
	signal idata, daddr, dout, din : STD_LOGIC_VECTOR(15 downto 0);
	signal iaddr : STD_LOGIC_VECTOR(15 downto 0);
	
	signal rin, gin, bin : std_logic_vector(3 downto 0);
	
	signal dummydatain, dummywraddr : std_logic_vector(15 downto 0);
	signal dummywen : std_logic;
	
	--to output when top level --start
	--signal clk, rst : std_logic;
	--
	--signal hsync, vsync : std_logic;
	--signal rout, gout, bout : std_logic_vector(3 downto 0);
	-- output for vga --end
	
begin
	proc: processor port map (clk, rst, iaddr, idata, daddr, dwen, dout, din);
	
	instrmem : ram_infer port map(clk, rst, dummydatain, dummywraddr, iaddr, dummywen, idata);
	
	datamem : ram_infer port map(clk, rst, dout, daddr, daddr, dwen, din);
	
	vga : vgasync port map(clk, rst, rin, gin, bin, rout, gout, bout, hsync, vsync);
	
	dummydatain <= (others => '0');
	dummywen <= '0';
	dummywraddr <= (others => '0');
	
	sendcolors: process (clk, rst)
		begin
			if  rst='0' then
				rin <= (others => '0');
				gin <= (others => '0');
				bin <= (others => '0');
			elsif rising_edge(clk) then 
				if dwen='1' then
					rin <= dout(15 downto 12);
					gin <= dout(11 downto 8);
					bin <= dout(7 downto 4);
				end if;
			end if;
end process;

end test;