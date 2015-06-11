library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_unsigned.all;
--use ieee.numeric_std.all;
use IEEE.std_logic_arith.all;


entity processor is
port (	clk : in std_logic;
		rst :in std_logic;
		
		iaddr : out std_logic_vector(15 downto 0);
		idata : in std_logic_vector(15 downto 0);
		
		daddr : out std_logic_vector(15 downto 0);
		dwen : out std_logic;							--Data Mem write Enable warning!!!
		dout : out std_logic_vector(15 downto 0);
		din : in std_logic_vector(15 downto 0)
		);
end processor;

architecture proc of processor is

	type registerFile is array(7 downto 0) of std_logic_vector(15 downto 0);
	type fexstates is (fetch, execute);
	type states is (s0, s1, s2, s3);

	signal pc : std_logic_vector(15 downto 0);
	signal reg : registerFile;
	signal ir : std_logic_vector(15 downto 0);
	signal ra, rb, rc : std_logic_vector(15 downto 0);
	signal opcode : std_logic_vector(2 downto 0);
	signal fex : fexstates;
	signal state : states;
	signal interrupt :std_logic;
	
	
	
	begin
	
		iaddr <= pc;
		opcode <= ir(15 downto 13);
		process (clk, rst) 
			
			variable pcvar, intrb, intrc : integer;
			
			begin
			if rst = '0' then
				for i in 0 to 7 loop 
					reg(i) <= (others => '0');
				end loop;
				pc <= (others => '0');
				ir <= (others => '0');
				fex <= fetch;
				state <= s0;
			elsif rising_edge(clk) then
				if interrupt='0' then
					case fex is
						when fetch =>
							ir <= idata;
							fex <= execute;
						when execute =>
							case opcode is
								when "000" => --add
									case state is
										when s0 =>
											rb <= reg(conv_integer(unsigned(ir(9 downto 7))));
											rc <= reg(conv_integer(unsigned(ir(2 downto 0))));
											state <= s1;
										when s1 =>
											-- intrb := to_integer(signed(rb));
											-- intrc := to_integer(signed(rc));
											-- intrb := intrb + intrc;
											-- ra <= std_logic_vector(to_signed(intrb, 16));
											ra <= signed(rb) + signed(rc);
											state <= s2;
										when s2 =>
											reg(conv_integer(unsigned(ir(12 downto 10)))) <= ra;
											pc <= unsigned(pc) + 1;
											state <= s0;
											fex <= fetch;
										when others =>
											fex <= fetch;
											state <= s0;
									end case;
									
								when "001" => --addi
									case state is
										when s0 =>
											rb <= reg(conv_integer(unsigned(ir(9 downto 7))));
											rc(15 downto 6) <= (others => ir(6));
											rc(5 downto 0) <= ir(5 downto 0);
											state <= s1;
										when s1 =>
											-- intrb := to_integer(signed(rb));
											-- intrc := to_integer(signed(rc));
											-- intrb := intrb + intrc;
											-- ra <= std_logic_vector(to_signed(intrb, 16));
											ra <= signed(rb) + signed(rc);
											state <= s2;
										when s2 =>
											reg(conv_integer(unsigned(ir(12 downto 10)))) <= ra;
											pc <= unsigned(pc) + 1;
											state <= s0;
											fex <= fetch;
										when others =>
											fex <= fetch;
											state <= s0;
									end case;
									
								when "010" => --nand
									case state is
										when s0 =>
											rb <= reg(conv_integer(unsigned(ir(9 downto 7))));
											rc <= reg(conv_integer(unsigned(ir(2 downto 0))));
											state <= s1;
										when s1 =>
											ra <= rb nand rc;
											state <= s2;
										when s2 =>
											reg(conv_integer(unsigned(ir(12 downto 10)))) <= ra;
											pc <= unsigned(pc) + 1;
											state <= s0;
											fex <= fetch;
										when others =>
											fex <= fetch;
											state <= s0;
									end case;
									
								when "011" => --lui
									case state is
										when s0 =>
											ra(15 downto 6) <= ir(9 downto 0);
											ra(5 downto 0) <= (others => '0');
											state <= s1;
										when s1 =>
											reg(conv_integer(unsigned(ir(12 downto 10)))) <= ra;
											pc <= unsigned(pc) + 1;
											state <= s0;
											fex <= fetch;
										when others =>
											fex <= fetch;
											state <= s0;
									end case;
								
								when "100" => --sw
									case state is
										when s0 =>
											rb <= reg(conv_integer(unsigned(ir(9 downto 7))));
											ra <= reg(conv_integer(unsigned(ir(12 downto 10))));
											rc(15 downto 6) <= (others => ir(6));
											rc(5 downto 0) <= ir(5 downto 0);
											state <= s1;
										when s1 =>
											-- intrb := to_integer(signed(rb));
											-- intrc := to_integer(signed(rc));
											-- intrb := intrb + intrc;
											-- rc <= std_logic_vector(to_signed(intrb, 16));
											rc <= signed(rb) + signed(rc);
											state <= s2;
										when s2 =>
											dwen <= '1';
											daddr <= rc;
											dout <= ra;
											state <= s3;
										when s3 =>
											dwen <= '0';
											pc <= unsigned(pc) + 1;
											state <= s0;
											fex <= fetch;
										when others =>
											fex <= fetch;
											state <= s0;
									end case;
									
								when "101" => --lw
									case state is
										when s0 =>
											rb <= reg(conv_integer(unsigned(ir(9 downto 7))));
											rc(15 downto 6) <= (others => ir(6));
											rc(5 downto 0) <= ir(5 downto 0);
											state <= s1;
										when s1 =>
											-- intrb := to_integer(signed(rb));
											-- intrc := to_integer(signed(rc));
											-- intrb := intrb + intrc;
											-- ra <= std_logic_vector(to_signed(intrb, 16));
											rc <= signed(rb) + signed(rc);
											state <= s2;
										when s2 =>
											daddr <= rc;
											state <= s3;
										when s3 =>
											reg(conv_integer(unsigned(ir(12 downto 10)))) <= din;
											pc <= unsigned(pc) + 1;
											state <= s0;
											fex <= fetch;
										when others =>
											fex <= fetch;
											state <= s0;
									end case;
									
								when "110" => --bne
									case state is
										when s0 =>
											rb <= reg(conv_integer(unsigned(ir(9 downto 7))));
											ra <= reg(conv_integer(unsigned(ir(12 downto 10))));
											rc(15 downto 6) <= (others => ir(6));
											rc(5 downto 0) <= ir(5 downto 0);
											state <= s1;
										when s1 =>
											if ra = rb then
												pc <= unsigned(pc) + 1;
											else
												pc <= unsigned(pc) + unsigned(rc);
											end if;
											state <= s0;
											fex <= fetch;
										when others =>
											fex <= fetch;
											state <= s0;
									end case;
									
								when "111" => --jalr
									case state is
										when s0 =>
											rb <= reg(conv_integer(unsigned(ir(9 downto 7))));
											state <= s1;
										when s1 =>
											reg(conv_integer(unsigned(ir(12 downto 10)))) <= unsigned(pc) + 1;
											pc <= rb;
											state <= s0;
											fex <= fetch;
										when others =>
											fex <= fetch;
											state <= s0;
									end case;
								when others =>
									fex <= fetch;
									state <= s0;
							end case;
						when others =>
							fex <= fetch;
							state <= s0;
					end case;
					reg(0)<= (others =>'0');
				else
				-- write to interrupt buffer
				end if;
			end if;
		end process;
end proc;