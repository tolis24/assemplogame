library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;


entity ram_infer is port(
      clk           : in  std_logic;
	  rst           : in  std_logic;
      dataIn        : in  std_logic_vector(15 downto 0);
      write_address : in  std_logic_vector(15 downto 0);
      read_address  : in  std_logic_vector(15 downto 0);
      we            : in  std_logic;
      dataOut       : out std_logic_vector(15 downto 0));
end ram_infer;

architecture rtl of ram_infer is
   type memory is array(0 to 1023) of std_logic_vector(15 downto 0);
   
-------------------------------------------------------
-- memory initialization for simulation in modelsim
-- synthesis will ignore this initialization
-------------------------------------------------------
-- impure function init_my_RAM(mif_file_name : in string) return memory is
--    file mif_file : text open read_mode is mif_file_name;
--    variable mif_line : line;
--    variable temp_bv  : std_logic_vector(15 downto 0);
--    variable temp_mem : memory;
--     begin
--	 for i in memory'range loop
--	   if not (endfile (mif_file)) then
--          readline(mif_file, mif_line);
--		  hread(mif_line, temp_bv);
--		  temp_mem(i) := temp_bv;
--	   else 
--	      temp_mem(i) := (others => '0');
--	   end if;
--	  end loop;
--	  file_close(mif_file);
--    return temp_mem;
--end function;
--
--signal ram_block      : memory := init_my_RAM("diff_out");

-------------------------------------------------------
-- initialize memory for altera quartus and fpga programming
-- (does not work for modelsim)
-------------------------------------------------------
signal    ram_block: memory;
attribute ram_init_file : string;
attribute ram_init_file of ram_block : signal is "diff_out.mif";
-------------------------------------------------------

signal data : std_logic_vector(15 downto 0);

BEGIN
  
  dataOut <= data;
  process(clk)
    begin
      if rising_edge(clk) then
        if (we = '1') then
		  ram_block(conv_integer(write_address)) <= dataIn;
		end if;
		data <= ram_block(conv_integer(read_address));
      end if;
  end process;
END rtl;