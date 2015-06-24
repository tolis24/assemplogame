library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_arith.all;

entity interrupt_controller is

port (		clk 	: in std_logic;			-- clock
			rst 	: in std_logic;			-- reset
			
			--wint	: in std_logic;						-- write interrupt enable
			--intEnable:in std_logic;						-- interrupt enable
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
		
end interrupt_controller;

architecture sync of interrupt_controller is

	signal upSync : std_logic_vector(3 downto 0);
	signal downSync : std_logic_vector(3 downto 0);
	signal lftSync : std_logic_vector(3 downto 0);
	signal rghtSync : std_logic_vector(3 downto 0);
	signal slctSync : std_logic_vector(3 downto 0);
	signal intvctr	: std_logic_vector(4 downto 0);

	--signal inten	: std_logic;
	
begin

	wintEn <= Wen and rstVector(6);
	intEn <= Wen and rstVector(5);

	intVector(15 downto 5) <= (others => '0');
	intVector(4 downto 0) <=	intvctr;
	intflag <= '0' when intvctr = "00000" else '1';
	
	process(clk,rst)
	begin
	
		if rst = '0' then
		
			--upSync 	<= (others => '0');  --WRONG it gives fake pulse
			--downSync <= (others => '0');
			--lftSync  <= (others => '0');
			--rghtSync <= (others => '0');
			--slctSync <= (others => '0');
			
			intvctr(4 downto 0) <= (others => '0');
		
		elsif rising_edge(clk) then
		
			-- if wint ='1' then 
			-- 	inten <= intEnable;
			-- end if;
			
			upSync(0)   <= up;
			downSync(0) <= down;
			lftSync(0)  <= lft;
			rghtSync(0) <= rght;
			slctSync(0) <= slct;
			
			upSync(1)   <= upSync(0);		--Sync(1) <= Sync(0)
			downSync(1) <= downSync(0);
			lftSync(1)  <= lftSync(0);
			rghtSync(1) <= rghtSync(0);
			slctSync(1) <= slctSync(0);
			
			upSync(2)   <= upSync(1);		--Sync(2) <= Sync(1)
			downSync(2) <= downSync(1);
			lftSync(2)  <= lftSync(1);
			rghtSync(2) <= rghtSync(1);
			slctSync(2) <= slctSync(1);
			
			upSync(3)   <= upSync(2);		--Sync(3) <= Sync(2)
			downSync(3) <= downSync(2);
			lftSync(3)  <= lftSync(2);
			rghtSync(3) <= rghtSync(2);
			slctSync(3) <= slctSync(2);
				
				
			-- Setting interrupts at Falling Edge
			if upSync(2) = '0' and upSync(3) ='1' and rstVector(0) = '0' then	
				intvctr(0) <= '1';
			end if;
			
			if downSync(2) = '0' and downSync(3) ='1' and rstVector(1) = '0' then	
				intvctr(1) <= '1';
			end if;
			
			if lftSync(2) = '0' and lftSync(3) ='1' and rstVector(2) = '0' then	
				intvctr(2) <= '1';
			end if;
			
			if rghtSync(2) = '0' and rghtSync(3) ='1' and rstVector(3) = '0' then	
				intvctr(3) <= '1';
			end if;
			
			if slctSync(2) = '0' and slctSync(3) ='1' and rstVector(4) = '0' then	
				intvctr(4) <= '1';
			end if;
			
			
			--Resetting interrupts
			if rstVector(0) = '1' and Wen = '1' then
				intvctr(0) <= '0';
			end if;
			
			if rstVector(1) = '1' and Wen = '1' then
				intvctr(1) <= '0';
			end if;
			
			if rstVector(2) = '1' and Wen = '1' then
				intvctr(2) <= '0';
			end if;
			
			if rstVector(3) = '1' and Wen = '1' then
				intvctr(3) <= '0';
			end if;
			
			if rstVector(4) = '1' and Wen = '1' then
				intvctr(4) <= '0';
			end if;
		
		end if;
	end process;
end sync;
	