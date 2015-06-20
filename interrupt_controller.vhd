entity interrupt_controller is

port (		clk 	: in std_logic;			-- clock
			rst 	: in std_logic;			-- reset
			
			wint	: in std_logic;						-- write interrupt enable
			intEnable:in std_logic;						-- interrupt enable
			rstVector :in std_logic_vector(4 downto 0); -- Vector to rst interrupts
			
			up		:	in std_logic;		-- button inputs
			down	:	in std_logic;
			lft		:	in std_logic;
			rght	:	in std_logic;
			slct	:	in std_logic;
			
			intVector : out std_logic_vector(4 downto 0);	-- 0 up, 1 down, 2 left, 3 right, 4 select
		);
		
end interrupt_controller;

architecture sync of interrupt_controller is

	signal upSync : std_logic_vector(3 downto 0);
	signal downSync : std_logic_vector(3 downto 0);
	signal lftSync : std_logic_vector(3 downto 0);
	signal rghtSync : std_logic_vector(3 downto 0);
	signal slctSync : std_logic_vector(3 downto 0);

	signal inten	: std_logic;
	
begin
	upSync(0)   <= up;
	downSync(0) <= down;
	lftSync(0)  <= lft;
	rghtSync(0) <= rght;
	
	intVector(0) <= upSync(3);
	intVector(1) <= downSync(3);
	intVector(2) <= lftSync(3);
	intVector(3) <= rghtSync(3);
	intVector(4) <= slctSync(3);
	
	process(clk,rst)
	begin
	
		if rst = '0' then
		
			upSync   <= (others => '0');
			downSync <= (others => '0');
			lftSync  <= (others => '0');
			rghtSync <= (others => '0');
			slctSync <= (others => '0');
			
			intVector <= (others => '0');
			
			inten <= '0';
		
		elsif rising_edge(clk) then
		
			if wint ='1' then 
				inten <= intEnable;
			end if;
			
			upSync(1)   <= upSync(0);		--Sync(1) <= Sync(0)
			downSync(1) <= downSync(0);
			lftSync(1)  <= lftSync(0);
			rghtSync(1) <= rghtSync(0);
			
			upSync(2)   <= upSync(1);		--Sync(2) <= Sync(1)
			downSync(2) <= downSync(1);
			lftSync(2)  <= lftSync(1);
			rghtSync(2) <= rghtSync(1);
			
			upSync(3)   <= upSync(2);		--Sync(3) <= Sync(2)
			downSync(3) <= downSync(2);
			lftSync(3)  <= lftSync(2);
			rghtSync(3) <= rghtSync(2);
			
			if inten ='1' then 				-- if Enable = 1 then set intVector at falling edge
				
				if upSync(2) = '1' and upSync(3) ='0' and rstVector(0) = '0' then	
					intVector(0) <= '1';
				end if;
				
				if downSync(2) = '1' and downSync(3) ='0' and rstVector(1) = '0' then	
					intVector(1) <= '1';
				end if;
				
				if lftSync(2) = '1' and lftSync(3) ='0' and rstVector(2) = '0' then	
					intVector(2) <= '1';
				end if;
				
				if rghtSync(2) = '1' and rghtSync(3) ='0' and rstVector(3) = '0' then	
					intVector(3) <= '1';
				end if;
				
				if slctSync(2) = '1' and slctSync(3) ='0' and rstVector(4) = '0' then	
					intVector(4) <= '1';
				end if;
				
			end if;
			
			if rstVector(0) = '1' then
				intVector(0) <= '0';
			end if;
			
			if rstVector(1) = '1' then
				intVector(1) <= '0';
			end if;
			
			if rstVector(2) = '1' then
				intVector(2) <= '0';
			end if;
			
			if rstVector(3) = '1' then
				intVector(3) <= '0';
			end if;
			
			if rstVector(4) = '1' then
				intVector(4) <= '0';
			end if;
		
		end if;
	end process;
end sync;
	