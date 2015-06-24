library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_arith.all;
--use IEEE.numeric_std.all;
--use IEEE.std_logic_unsigned.all;

entity processor is

port (	clk 	: in std_logic;								-- clock
		rst 	: in std_logic;								-- reset
			
		iaddr : out std_logic_vector(15 downto 0);	-- instruction address to fetch
		idata : in std_logic_vector(15 downto 0);		-- instruction data for ir
			
		daddr : out std_logic_vector(15 downto 0);	-- data address in memory
		dwen 	: out std_logic;								-- Data Mem Write Enable
		dout 	: out std_logic_vector(15 downto 0);	-- data write
		din 	: in std_logic_vector(15 downto 0);		-- data read
			
		--intVector 	: in std_logic_vector(4 downto 0);	-- 0 up, 1 down, 2 left, 3 right, 4 select
		wintEn	: in std_logic;						-- enable to write at interrupt software enable
		intEn	: in std_logic;						--value to write at interrupt flag
		intflag	: in std_logic						-- Interrupt to Handle
	);
		
end processor;

architecture proc of processor is

	type registerFile is array(7 downto 0) of std_logic_vector(15 downto 0);
	type cycles is (interrupt, dummy, fetch, reg_read, execute, result, final, read_mem); -- memory_write);

	signal pc 				: std_logic_vector(15 downto 0);	-- program counter
	signal reg 				: registerFile;						-- array of registers
	signal ir 				: std_logic_vector(15 downto 0);	-- instruction register
	signal ra, rb, ALUOut: std_logic_vector(15 downto 0);		-- registers a, b, ALUOut
	signal opcode 			: std_logic_vector(2 downto 0);		-- operation code
	signal cycle 			: cycles;							-- cycles
	signal HWintEn, SWintEn	: std_logic;
	--signal intflag			: std_logic;						-- Interrupt flag
--	signal counter       : std_logic_vector(27 downto 0);
	
begin
	iaddr <= pc;
	HWintEn <= '0' when unsigned(pc) > 125 else '1';  -- (fix) Program Counter range to disable interrupts

		
	process (clk, rst) 
			
		begin
			
			-- Reset
			if rst = '0' then
			
			-- Reset Registers
				for i in 0 to 7 loop 
					reg(i) <= (others => '0');
				end loop;
				
			-- Reset interrupt flag
				SWintEn <= '0';
				
			-- Reset Program Counter
				pc <= (others => '0');
				
			-- Reset Instuction Register
				ir <= (others => '0');
				
				cycle <= dummy;
				
			elsif rising_edge(clk) then
			
				if wintEn ='1' then 
					SWintEn <= intEn ;
				end if;
			
				case cycle is 
					when interrupt =>
					
						cycle <= fetch;
						
						if HWintEn = '1'and SWintEn = '1' and intflag = '1' then
							pc <= 		"0000000001111111"; --address (of InsMem) of up interrupt Handler  (fix)
							daddr <= 	"0000000001000010"; -- address (of DatMem) to store the normal flow (fix)
							dout <= pc;
							dwen <= '1';
							--intEn <= '0';			-- caution! at setting intEn at the end of the Handler no interrupt should waiting (have to fix it)
							cycle <= dummy;
						end if;
						
					when dummy =>
						cycle <= fetch;
						dwen <='0'; -- When an interrupt happens must reset dwen of writing the normal flow pc to DataMem 
					when fetch =>
					
						ir <= idata;
						
						cycle <= reg_read;
							
					when reg_read =>
					
					-- ra
					
					-- lui
					-- immed & 0xffc0
						if ir(15 downto 13) = "011" then 
						-- top bits
							ra(15 downto 6) <= ir(9 downto 0);
						-- bottom bits
							ra(5 downto 0)  <= (others => '0');	
							
					-- jalr
					-- PC + 1
						elsif ir(15 downto 13) = "111" then
							ra <= unsigned(pc) + 1;
							
					-- add
					-- addi
					-- nand
					-- bne
					-- sw
					-- lw
					-- R[regB] <= RegFile(IR(9:7))
						else
							ra <= reg(conv_integer(unsigned(ir(9 downto 7))));
						end if;
						
					-- end ra
					
					-- rb
					
					-- add
					-- nand
					-- R[regC]
						if ir(15 downto 13) = "000" or ir(15 downto 13) = "010" then
							rb <= reg(conv_integer(unsigned(ir(2 downto 0)))); -- load B from RF's address regC
							
					-- addi
					-- sw
					-- lw
					-- immed
						elsif ir(15 downto 13) = "001" or ir(15 downto 13) = "100" or ir(15 downto 13) = "101" then
						-- sign extension
							rb(15 downto 6) <= (others => ir(6)); -- top bits
										
							rb(5 downto 0) <= ir(5 downto 0); -- bottom bits
							
					-- bne
						elsif ir(15 downto 13) = "110" then
							rb <= reg(conv_integer(unsigned(ir(12 downto 10))));
						
					-- jalr
						elsif ir(15 downto 13) = "111" then
							rb <= reg(conv_integer(unsigned(ir(9 downto 7))));
						end if;
					
					-- end rb
						
						cycle <= execute;
						
				  when execute => 
						-- ALUOut
						
						-- add  : R[regB] + R[regC]
						-- addi : R[regB] + immed
						-- sw,lw: R[regB] + immed
						if ir(15 downto 13) = "000" OR ir(15 downto 13) = "001" OR ir(15 downto 13) = "100" OR ir(15 downto 13) = "101" then
							ALUOut <= unsigned(ra) + unsigned(rb);
							
						-- nand : ¬(R[regB] + R[regC])
						elsif ir(15 downto 13) = "010" then
							ALUOut <= NOT (ra AND rb);
						
						-- lui  : ALUOut <= immed & 0xffc0
						-- jalr
						elsif ir(15 downto 13) = "011" or ir(15 downto 13) = "111" then
							ALUOut <= ra;
						-- bne
						elsif ir(15 downto 13) = "110" then 
							ALUOut(15 downto 6) <= (others => ir(6)); -- top bits
										
							ALUOut(5 downto 0) <= ir(5 downto 0); -- bottom bits
						end if;
						
					-- in operation sw sets write enable for storing in memory
--						if ir(15 downto 13) = "100" then 
--							dwen <= '1';
--						end if;
						
						--lw
						if ir(15 downto 13) = "101" then
							cycle <= read_mem;
						else
							cycle <= result;
						end if;
						
					when read_mem => 
					
						daddr <= ALUOut;
						
						cycle <= result;
						
					when result =>
						-- sw : R[regA] => RegFile(R[regB] + immed) 
						if ir(15 downto 13) = "100" then	
							daddr <= ALUOut;
							dout 	<= reg(conv_integer(unsigned(ir(12 downto 10))));
							dwen 	<= '1'; -- write in the same cycle
							
						-- lw : R[regA] <= RegFile(R[regB] + immed) 
						elsif ir(15 downto 13) = "101" then
							-- Just wait for this cycle
							--reg(conv_integer(unsigned(ir(12 downto 10)))) <= din;
						
						-- add, addi, nand, lui, jalr: R[regA] <= ALUOut
						else
							reg(conv_integer(unsigned(ir(12 downto 10)))) <= ALUOut;
						end if;
						
						cycle <= final;
						
					when final =>
					
						--sw
						if ir(15 downto 13) = "100" then 
							dwen <= '0';
						--lw
						elsif ir(15 downto 13) = "101" then
							reg(conv_integer(unsigned(ir(12 downto 10)))) <= din;
						end if;
						--bne
						if ir(15 downto 13) = "110" then 
							if (ra = rb) then
								pc <= unsigned(pc) + 1;
							else
								-- PC <= PC + immed + 1
								pc <= unsigned(pc) + unsigned(ALUOut) + 1;
							end if;
						--jalr
						elsif ir(15 downto 13) = "111" then
							pc <= rb;
						else
							pc <= unsigned(pc) + 1;
						end if;
						
						cycle <= interrupt;
						
					when others =>
					
						pc <= unsigned(pc) + 1;
						
						cycle <= interrupt;
						
					end case;
			-- set RegFile(0) to 0
				reg(0)<= (others =>'0');	
				
			
			end if;
	end process;
end proc;
			
	










--
--library ieee;
--use ieee.std_logic_1164.all;
--use IEEE.std_logic_arith.all;
--
--
--entity processor is
--port (	clk 	: in std_logic;								-- clock
--			rst 	: in std_logic;								-- reset
--			
--			iaddr : out std_logic_vector(15 downto 0);	-- instruction address to fetch
--			idata : in std_logic_vector(15 downto 0);		-- instruction data for ir
--			
--			daddr : out std_logic_vector(15 downto 0);	-- data address in memory
--			dwen 	: out std_logic;								-- Data Mem Write Enable
--			dout 	: out std_logic_vector(15 downto 0);	-- data read
--			din 	: in std_logic_vector(15 downto 0)		-- data write
--		);
--end processor;
--
--architecture proc of processor is
--
--	type registerFile is array(7 downto 0) of std_logic_vector(15 downto 0);
--	type fexstates is (fetch, execute);
--	type states is (s0, s1, s2, s3, s4);
--
--	signal pc 			: std_logic_vector(15 downto 0); -- program counter
--	signal reg 			: registerFile;						-- array of registers
--	signal ir 			: std_logic_vector(15 downto 0); -- instruction register
--	signal ra, rb, rc : std_logic_vector(15 downto 0); -- registers a, b, c
--	signal ir(15 downto 13) 		: std_logic_vector(2 downto 0);	-- operation code
--	signal fex 			: fexstates;							-- fetch or execute
--	signal state 		: states;								-- s0 or s1 or s2 or s3
--	
--	
--	
--	begin
--		-- Fetch next instruction from pc (program counter)
--		iaddr <= pc;
--		-- store 3bit operation to signal ir(15 downto 13)
--		ir(15 downto 13) <= ir(15 downto 13);
--		process (clk, rst) 
--			
--			begin
--			
--			-- Reset
--			if rst = '0' then
--			
--			-- Reset Registers
--				for i in 0 to 7 loop 
--					reg(i) <= (others => '0');
--				end loop;
--				
--			-- Reset Program Counter
--				pc <= (others => '0');
--				
--			-- Reset Instuction Register
--				ir <= (others => '0');
--				
--			-- (Re-)Set to fetch next instruction
--				fex <= fetch;
--				
--			-- (Re-)Set state to s0
--				state <= s0;
--				
--			elsif rising_edge(clk) then
--				case fex is
--					when fetch =>
--						ir <= idata;
--						fex <= execute;
--					when execute =>
--						case ir(15 downto 13) is
--						-- add
--							when "000" =>
--								case state is
--									when s0 =>
--									-- B <= RegFile(IR(9:7))
--										rb <= reg(conv_integer(unsigned(ir(9 downto 7))));
--									-- C <= RegFile(IR(2:0))
--										rc <= reg(conv_integer(unsigned(ir(2 downto 0))));
--										
--										state <= s1;
--									when s1 =>
--									-- A <= B + C
--										ra <= signed(rb) + signed(rc);
--										
--										state <= s2;
--									when s2 =>
--									-- RegFile(IR(12:10)) <= A
--										reg(conv_integer(unsigned(ir(12 downto 10)))) <= ra;
--										
--										state <= s3;
--									when s3 =>
--									-- PC <= PC + 1
--										pc <= unsigned(pc) + 1;
--										
--										state <= s0;
--										
--										fex <= fetch;
--									when others =>
--									
--										fex <= fetch;
--										
--										state <= s0;
--								end case;
--					   -- addi
--							when "001" =>
--								case state is
--									when s0 =>
--									-- B <= RegFile(IR(9:7))
--										rb <= reg(conv_integer(unsigned(ir(9 downto 7))));
--									-- sign extension
--										rc(15 downto 6) <= (others => ir(6));
--									
--										rc(5 downto 0) <= ir(5 downto 0);
--										
--										state <= s1;
--									when s1 =>
--									-- A <= B + C
--										ra <= signed(rb) + signed(rc);
--										
--										state <= s2;
--									when s2 =>
--									-- RegFile(IR(12:10)) <= A
--										reg(conv_integer(unsigned(ir(12 downto 10)))) <= ra;
--										
--										state <= s3;
--									when s3 =>
--									-- PC <= PC +1
--										pc <= unsigned(pc) + 1;
--										
--										state <= s0;
--										
--										fex <= fetch;
--									when others =>
--									
--										fex <= fetch;
--										
--										state <= s0;
--								end case;
--						-- nand
--							when "010" => 
--								case state is
--									when s0 =>
--									-- B <= RegFile(IR(9:7))
--										rb <= reg(conv_integer(unsigned(ir(9 downto 7))));
--									-- C <= RegFile(IR(2:0)
--										rc <= reg(conv_integer(unsigned(ir(2 downto 0))));
--										
--										state <= s1;
--									when s1 =>
--									-- A <= B NAND C
--										ra <= rb nand rc;
--										
--										state <= s2;
--									when s2 =>
--									-- RegFile(IR(12:10))
--										reg(conv_integer(unsigned(ir(12 downto 10)))) <= ra;
--									-- PC <= PC + 1
--										pc <= unsigned(pc) + 1;
--									
--										state <= s0;
--										
--										fex <= fetch;
--									when others =>
--									
--										fex <= fetch;
--										
--										state <= s0;
--								end case;
--						-- lui
--							when "011" =>
--								case state is
--									when s0 =>
--									-- top bits
--										ra(15 downto 6) <= ir(9 downto 0);
--									-- bottom bits
--										ra(5 downto 0) <= (others => '0');
--										
--										state <= s1;
--									when s1 =>
--									-- RegFile(IR(12:10)) <= A
--										reg(conv_integer(unsigned(ir(12 downto 10)))) <= ra;
--										
--										state <= s2;
--									when s2 =>
--									-- PC <= PC + 1
--										pc <= unsigned(pc) + 1;
--										
--										state <= s0;
--										
--										fex <= fetch;
--									when others =>
--									
--										fex <= fetch;
--										
--										state <= s0;
--								end case;
--						-- sw
--							when "100" =>
--								case state is
--									when s0 =>
--									-- B <= RegFile(IR(9:7))
--										rb <= reg(conv_integer(unsigned(ir(9 downto 7))));
--									-- A <= RegFile(IR(12:10))
--										ra <= reg(conv_integer(unsigned(ir(12 downto 10))));
--									-- sign extension
--										rc(15 downto 6) <= (others => ir(6));
--										
--										rc(5 downto 0) <= ir(5 downto 0);
--										
--										state <= s1;
--									when s1 =>
--									-- C <= B + C
--										rc <= signed(rb) + signed(rc);
--										
--										state <= s2;
--									when s2 =>
--										dwen <= '1';
--										
--										daddr <= rc;
--										
--										dout <= ra;
--										
--										state <= s3;
--									when s3 =>
--									
--										dwen <= '0';
--									-- PC <= PC + 1
--										pc <= unsigned(pc) + 1;
--										
--										state <= s0;
--										
--										fex <= fetch;
--									when others =>
--									
--										fex <= fetch;
--										
--										state <= s0;
--								end case;
--						-- lw
--							when "101" =>
--								case state is
--									when s0 =>
--									-- B <= RegFile(IR(9:7))
--										rb <= reg(conv_integer(unsigned(ir(9 downto 7))));
--									-- sign extention
--										rc(15 downto 6) <= (others => ir(6));
--										
--										rc(5 downto 0) <= ir(5 downto 0);
--										
--										state <= s1;
--									when s1 =>
--									-- C <= B + C
--										rc <= signed(rb) + signed(rc);
--										
--										state <= s2;
--									when s2 =>
--									
--										daddr <= rc;
--										
--										state <= s3;
--									when s3 =>
--									-- RegFile(IR(12:10)) <= MWD
--										reg(conv_integer(unsigned(ir(12 downto 10)))) <= din;
--										
--										state <= s4;
--									when s4 =>
--									-- PC <= PC + 1
--										pc <= unsigned(pc) + 1;
--										
--										state <= s0;
--										
--										fex <= fetch;
--									when others =>
--									
--										fex <= fetch;
--										
--										state <= s0;
--								end case;
--						-- bne
--							when "110" => 
--								case state is
--									when s0 =>
--									-- B <= RegFile(IR(9:7))
--										rb <= reg(conv_integer(unsigned(ir(9 downto 7))));
--									-- A <= RegFile(IR(12:10))
--										ra <= reg(conv_integer(unsigned(ir(12 downto 10))));
--									-- sign extension
--										rc(15 downto 6) <= (others => ir(6));
--									-- C <= IR(5:0)
--										rc(5 downto 0) <= ir(5 downto 0);
--										
--										state <= s1;
--									when s1 =>
--									-- if A == B to next instruction
--										if ra = rb then
--											pc <= unsigned(pc) + 1;
--										else
--									-- if A != B PC <= PC + C 
--											pc <= unsigned(pc) + unsigned(rc);
--										end if;
--										
--										state <= s0;
--										
--										fex <= fetch;
--									when others =>
--									
--										fex <= fetch;
--										
--										state <= s0;
--								end case;
--						-- jalr
--							when "111" => 
--								case state is
--									when s0 =>
--									-- B <= RegFile(IR(9:7))
--
--
--
--
--
--										rb <= reg(conv_integer(unsigned(ir(9 downto 7))));
--										
--										state <= s1;
--									when s1 =>
--									-- RegFile(IR(12:10)) <= PC + 1
--										reg(conv_integer(unsigned(ir(12 downto 10)))) <= unsigned(pc) + 1;
--									-- PC <= B
--										pc <= rb;
--										
--										state <= s0;
--										
--										fex <= fetch;
--									when others =>
--									
--										fex <= fetch;
--										
--										state <= s0;
--								end case;
--							when others =>
--							
--								fex <= fetch;
--								
--								state <= s0;
--						end case; -- end execute
--					when others =>
--					
--						fex <= fetch;
--						
--						state <= s0;
--				end case; -- end fex
--			-- set RegFile(0) to 0
--				reg(0)<= (others =>'0');
--			end if;
--		end process;
--end proc;