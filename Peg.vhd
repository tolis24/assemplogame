library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity Peg is
	port (
			clk, rst : in std_logic;
			
			up, down, lft, rght, slct : in std_logic;
	
			hsync, vsync : out std_logic;
			rout, gout, bout : out std_logic_vector(3 downto 0)
		);
end Peg;

architecture game of Peg is

	component processor is
		port (	clk 	: in std_logic;							-- clock
				rst 	: in std_logic;							-- reset
			
				iaddr : out std_logic_vector(15 downto 0);		-- instruction address to fetch
				idata : in std_logic_vector(15 downto 0);		-- instruction data for ir
		
				daddr : out std_logic_vector(15 downto 0);		-- data address in memory
				dwen 	: out std_logic;						-- Data Mem Write Enable
				dout 	: out std_logic_vector(15 downto 0);	-- data write
				din 	: in std_logic_vector(15 downto 0);		-- data read

				wintEn	: in std_logic;						-- enable to write at interrupt software enable
				intEn	: in std_logic;						--value to write at interrupt flag
				intflag	: in std_logic						-- Interrupt to Handle
		);
	end component processor;

	component ram_infer is port(
      clk           : in  std_logic;
	  rst           : in  std_logic;
      dataIn        : in  std_logic_vector(15 downto 0);
      write_address : in  std_logic_vector(15 downto 0);
      read_address  : in  std_logic_vector(15 downto 0);
      we            : in  std_logic;
      dataOut       : out std_logic_vector(15 downto 0));
	end component ram_infer;
	
	component interrupt_controller is
		port (	clk 	: in std_logic;			-- clock
				rst 	: in std_logic;			-- reset
				
				rstVector	: in std_logic_vector(15 downto 0); -- Vector to rst interrupts
				Wen			: in std_logic;
			
				up		:	in std_logic;		-- button inputs
				down	:	in std_logic;
				lft		:	in std_logic;
				rght	:	in std_logic;
				slct	:	in std_logic;
			
				intflag : out std_logic;						-- interrupt flag for processor
				intVector : out std_logic_vector(15 downto 0);	-- 0 up, 1 down, 2 left, 3 right, 4 select , others Don't care 0
				wintEn	: out std_logic;						-- enable to write at interrupt software enable
				intEn	: out std_logic						--value to write at interrupt software enable
		);
		
	end component interrupt_controller;
	
	component mem_controller is
		port (	procWen 	: in std_logic;							--signals from/to Processor
				procAddr	: in std_logic_vector(15 downto 0);
				procIn		: in std_logic_vector(15 downto 0);
				procOut		: out std_logic_vector(15 downto 0);
			
				dmWen		: out std_logic;						--signals from/to DataMem
				dmAddr		: out std_logic_vector(15 downto 0);
				dmIn		: in std_logic_vector(15 downto 0);
				dmOut		: out std_logic_vector(15 downto 0);
			
				fbWen		: out std_logic;						--signals to Frame Buffer
				fbOut		: out std_logic_vector(15 downto 0);
			
				intWen		: out std_logic;						--signals from/to Interrupt Controller
				intOut		: out std_logic_vector(15 downto 0);
				intIn		: in std_logic_vector(15 downto 0)
		);	
	end component mem_controller;

	component framebuffer is 
		port(	clk           : in  std_logic;
				rst           : in  std_logic;
	  
				we            : in  std_logic;
				dataIn        : in  std_logic_vector(15 downto 0);	-- Input data should have the following format
																	-- (15 downto 12) don't care
																	-- (11 downto 8) row number (X)
																	-- (8 downto 4) column number (Y)
																	-- (3 downto 0) value to store (V)
	  
				countV  : in  std_logic_vector(9 downto 0);
				countH  : in  std_logic_vector(9 downto 0);
				
				dataOut : out std_logic_vector(3 downto 0));
	end component framebuffer;
	
	component icon_rom is
		port (countV : in std_logic_vector(9 downto 0);
			countH : in std_logic_vector(9 downto 0);
			pointer : in std_logic_vector(3 downto 0);
			bitstream : out std_logic);
end component icon_rom;
	
	component vga_controller is
		port (clk : in std_logic;
			rst : in std_logic;
			--rin, gin, bin : in std_logic_vector(3 downto 0);
			rout, gout, bout : out std_logic_vector(3 downto 0);
			hsync : out std_logic;
			vsync : out std_logic;
		
			bitstream : in std_logic;
			cntV : out std_logic_vector(9 downto 0);
			cntH : out std_logic_vector(9 downto 0)
		);
end component vga_controller;
	

	signal ground : std_logic_vector(15 downto 0);
	
	signal iaddr, idata : std_logic_vector(15 downto 0); -- lines to InsMem
	
	signal procAddr, procOut, procIn : std_logic_vector(15 downto 0); -- lines to MemController
	signal procWen : std_logic;
	
	signal dmAddr, dmIn, dmOut : std_logic_vector(15 downto 0); -- lines to DataMem
	signal dmWen : std_logic;
	
	signal intOut, intIn : std_logic_vector(15 downto 0); -- lines to Interrupt Controller
	signal intWen : std_logic;								-- Allow to write to procwssors intEn
	signal intflag : std_logic;
	
	signal wintEn : std_logic;
	signal intEn : std_logic;
	
		
	signal fbOut : std_logic_vector(15 downto 0); -- lines to Frame Buffer
	signal fbWen : std_logic;
	signal pointer : std_logic_vector(3 downto 0);
	
	signal countV, countH : std_logic_vector(9 downto 0);
	signal bitstream : std_logic;
	
	
begin

	ground <= (others => '0');

	proc: processor port map (clk, rst, iaddr, idata, procAddr, procWen, procIn, procOut, wintEn, intEn, intflag);
	
	Mem_ctrl: mem_controller port map (procWen, procAddr, procIn, procOut, dmWen, dmAddr, dmIn, dmOut, fbWen, fbOut, intWen, intOut, intIn);
	
	InsMem: ram_infer port map (clk, rst, ground, ground, iaddr, ground(0), idata);
	
	DataMem: ram_infer port map (clk, rst, dmOut, dmAddr, dmAddr, dmWen, dmIn);
	
	Int_ctrl: interrupt_controller port map (clk, rst, intOut, intWen, up, down, lft, rght, slct, intflag, intIn, wintEn, intEn);
	
	FB: framebuffer port map (clk, rst, fbWen, fbOut, countV, countH, pointer);
	
	icons: icon_rom port map (countV,countH, pointer, bitstream);
	
	vga_ctrl: vga_controller port map (clk, rst, rout, bout, gout, hsync, vsync, bitstream, countV, countH);
	
	
end game;