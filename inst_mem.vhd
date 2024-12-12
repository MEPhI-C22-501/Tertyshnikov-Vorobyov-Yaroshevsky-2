library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library work;
use work.inst_mem_pkg.all;

entity InstructionMemory is
    port (
        i_clk       : in  std_logic;
        i_read_addr : in  std_logic_vector(15 downto 0);
        o_read_data : out std_logic_vector(31 downto 0)
    );
end InstructionMemory;

architecture inst_mem_beh of InstructionMemory is
    	signal read_addr_reg : std_logic_vector(15 downto 0) := (others => '0');

	signal mem : memory_array := read_hex_from_file("program.hex");
	signal read_data_r : std_logic_vector(31 downto 0);
	
begin
	o_read_data <= read_data_r;

	process(i_clk)
	begin
		if rising_edge(i_clk) then
			read_data_r <= mem(to_integer(unsigned(i_read_addr)));
		end if;
	end process;
end inst_mem_beh;
