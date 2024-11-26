library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.inst_mem_pkg.all;

entity InstructionMemory is
    port (
        i_clk       : in  std_logic;
        i_read_addr : in  std_logic_vector(15 downto 0);
        o_read_data : out std_logic_vector(31 downto 0);
	i_mem_init  : in  memory_array -- port to initialize memory
    );
end InstructionMemory;

architecture inst_mem_beh of InstructionMemory is
    signal mem : memory_array := (others => (others => '0'));

    signal read_addr_reg : std_logic_vector(15 downto 0) := (others => '0');
begin

    process(i_mem_init)
    begin
        if i_mem_init'length > 0 then
            mem <= i_mem_init;
        end if;
    end process;

    process(i_clk, i_read_addr)
    begin
        if rising_edge(i_clk) then
            o_read_data <= mem(to_integer(unsigned(i_read_addr)));
        end if;
    end process;
end inst_mem_beh;
