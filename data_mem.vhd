library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.inst_mem_pkg.all;

entity DataMemory is
    port (
        i_clk        : in  std_logic;
        i_rst        : in  std_logic;
        i_write_enable1 : in  std_logic;
	i_write_enable2 : in std_logic;
        i_write_addr1 : in  std_logic_vector(15 downto 0);
	i_write_addr2 : in  std_logic_vector(15 downto 0);
        i_read_addr1 : in  std_logic_vector(15 downto 0);
        i_read_addr2 : in  std_logic_vector(15 downto 0);
        i_write_data1 : in  std_logic_vector(31 downto 0);
	i_write_data2 : in  std_logic_vector(31 downto 0);
        o_read_data1 : out std_logic_vector(31 downto 0);
        o_read_data2 : out std_logic_vector(31 downto 0)
    );
end DataMemory;

architecture DataMemory_beh of DataMemory is
    signal memory : memory_array := (others => (others => '0'));

begin
     
    process (i_clk)
    begin
	if rising_edge(i_clk) then
        	o_read_data1 <= memory(to_integer(unsigned(i_read_addr1)));
		o_read_data2 <= memory(to_integer(unsigned(i_read_addr2)));
	end if;
    end process;

     
    process (i_clk, i_rst)
    begin
	if i_rst = '1' then
		-- synthesis off
                memory <= (others => (others => '0')); 
		-- synthesis on
        elsif rising_edge(i_clk) then
            if i_write_enable1  = '1' then
                memory(to_integer(unsigned(i_write_addr1))) <= i_write_data1;
            end if;
	
	    if i_write_enable2  = '1' then
                memory(to_integer(unsigned(i_write_addr2))) <= i_write_data2;
            end if;
        end if;
    end process;

end DataMemory_beh;

