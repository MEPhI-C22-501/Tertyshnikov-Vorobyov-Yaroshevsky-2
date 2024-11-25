library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.inst_mem_pkg.all;

entity DataMemory is
    port (
        i_clk        : in  std_logic;
        i_rst        : in  std_logic;
        i_write_en   : in  std_logic;
        i_write_addr : in  std_logic_vector(15 downto 0);
        i_read_addr1 : in  std_logic_vector(15 downto 0);
        i_read_addr2 : in  std_logic_vector(15 downto 0);
        i_write_data : in  std_logic_vector(31 downto 0);
        o_read_data1 : out std_logic_vector(31 downto 0);
        o_read_data2 : out std_logic_vector(31 downto 0)
    );
end DataMemory;

architecture DataMemory_beh of DataMemory is
    signal memory : memory_array := (others => (others => '0'));

begin
     
    process (i_read_addr1, i_read_addr2, memory, i_clk)
    begin
	if rising_edge(i_clk) then
        	o_read_data1 <= memory(to_integer(unsigned(i_read_addr1)));
		o_read_data2 <= memory(to_integer(unsigned(i_read_addr2)));
	end if;
    end process;

     
    process (i_clk, memory)
    begin
        if rising_edge(i_clk) then
            if i_rst = '1' then
                memory <= (others => (others => '0'));  
            elsif i_write_en  = '1' then
                memory(to_integer(unsigned(i_write_addr))) <= i_write_data;
            end if;
        end if;
    end process;

end DataMemory_beh;

