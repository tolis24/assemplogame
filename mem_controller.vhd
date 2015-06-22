library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_arith.all;

entity mem_controller is

port (		clk 	: in std_logic;			-- clock
			rst 	: in std_logic;			-- reset
			
			procWen 	: in std_logic;							--signals from/to Processor
			procAddr	: in std_logic_vector(15 downto 0);
			procIn		: in std_logic_vector(15 downto 0);
			procOut		: out std_logic_vector(15 downto 0);
			
			dmWen		: out std_logic;						--signals from/to DataMem
			dmAddr		: out std_logic_vector(15 downto 0);
			dmIN		: in std_logic_vector(15 downto 0);
			dmOut		: out std_logic_vector(15 downto 0);
			
			fbWen		: out std_logic;						--signals to Frame Buffer
			fbAddr		: out std_logic_vector(15 downto 0);
			fdOut		: out std_logic_vector(15 downto 0);
			
			intWen		: out std_logic;						--signals to Interrupt Controller
			intOut		: out std_logic_vector(15 downto 0);
			intIn		: in std_logic_vector(15 downto 0)
		);
		
end mem_controller;

architecture mltplx of mem_controller is

begin

 process (procWen, procAddr, procIn, dmIN)
 begin
 
	if procAddr = "0000000000000000" then  --Address of interrupt Controller (fix)
	
		procOut	<= intIn;
	
		dmWen	<= '0';
		dmAddr	<= (others => '0');
		dmOut 	<= (others => '0');
	
		fbWen	<= '0';
		fbAddr	<= (others => '0');
		fdOut 	<= (others => '0');
	
		intWen <= procWen;
		intOut <= procIn;
		
	elsif procAddr = "0000000000000001" then -- Address of Frame buffer (fix)
		procOut <= (others => '0');
	
		dmWen	<= '0';
		dmAddr	<= (others => '0');
		dmOut 	<= (others => '0');
	
		fbWen	<= procWen;
		fbAddr	<= procAddr;
		fdOut 	<= procIn;
	
		intWen 	<= '0';
		intOut	<= (others => '0');
		
	else
		
		procOut <= dmIN;
	
		dmWen	<= procWen;
		dmAddr	<= procAddr;
		dmOut 	<= procIn;
	
		fbWen	<= '0';
		fbAddr	<= (others => '0');
		fdOut 	<= (others => '0');
	
		intWen 	<= '0';
		intOut	<= (others => '0');
	
	
	
	end if;
 
 
 end process;

end mltplx;