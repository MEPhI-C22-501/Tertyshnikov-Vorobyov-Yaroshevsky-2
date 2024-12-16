library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.inst_mem_pkg.all;

entity DataMemory is
    port (
        i_clk        : in  std_logic;
        i_rst        : in  std_logic;
        i_write_enable : in  std_logic;
        i_write_addr : in  std_logic_vector(15 downto 0);
        i_read_addr : in  std_logic_vector(15 downto 0);
        i_write_data : in  std_logic_vector(31 downto 0);
        o_read_data : out std_logic_vector(31 downto 0)
    );
end DataMemory;

architecture DataMemory_beh of DataMemory is
    	signal memory : memory_array := (others => (others => '0'));
	signal data_r : std_logic_vector(31 downto 0) := (others => '0');

begin
   	o_read_data <= data_r;

	process(i_clk, i_rst)
	variable addr : integer := 0;
	begin
		-- if i_write_enable  = '0' then
			addr := to_integer(unsigned(i_read_addr));
			for i in 0 to 3 loop
				if i + 1 > 65535 then
					data_r((i + 1) * 8 - 1 downto i * 8) <= x"0";
				else
					data_r((i + 1) * 8 - 1 downto i * 8) <= memory(addr + i);
				end if;
			end loop;
		-- end if;
	end process;

     
    process (i_clk, i_rst)
	variable addr : integer := 0;
    begin
	if i_rst = '1' then
		-- pragma synthesis_off
                memory <= (others => (others => '0')); 
		-- pragma synthesis_on
        elsif rising_edge(i_clk) then
            	if i_write_enable  = '1' then
			addr := to_integer(unsigned(i_write_addr));
			for i in 0 to 3 loop
				if i <= 65535 then
					memory(addr + i) <= i_write_data((i + 1) * 8 - 1 downto  i * 8);
				end if;
			end loop;
		end if;
        end if;
    end process;

end DataMemory_beh;

