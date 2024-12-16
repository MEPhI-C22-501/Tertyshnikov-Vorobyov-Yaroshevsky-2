library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.csr_mem_pkg.all;
use ieee.std_logic_unsigned.all;

entity CSR is
    port (
        i_clk        : in     std_logic;
        i_rst                  : in     std_logic;
	i_program_counter_write_enable : in std_logic;
	i_program_counter : in std_logic_vector(15 downto 0);
	o_program_counter   : out std_logic_vector(15 downto 0);
	i_csr_write_enable : in std_logic;
	i_csr_data : in std_logic_vector(31 downto 0);
	i_csr_number : in std_logic_vector(4 downto 0);
	o_csr_array : out csr_array
    );
end CSR;

architecture csr_beh of CSR is
    	signal registers : csr_array := (others => (others => '0'));
	signal program_counter_r : std_logic_vector(15 downto 0) := (others => '0');

begin     

	o_program_counter <= program_counter_r;
	o_csr_array(0) <= (others => '0');
	o_csr_array(31 downto 1) <= registers(31 downto 1);
     
    process (i_clk, i_rst)
    begin
	if i_rst = '1' then
		program_counter_r <= (others => '0');
		-- pragma synthesis_off
		registers <= (others => (others => '0'));
		-- pragma synthesis_on
	elsif rising_edge(i_clk) then
		program_counter_r <= program_counter_r + '1';

		if i_program_counter_write_enable = '1' then
			program_counter_r <= i_program_counter;
		end if;

		if i_csr_write_enable = '1' then
			registers(to_integer(unsigned(i_csr_number))) <= i_csr_data;
		end if;
	end if;
    end process;

end csr_beh;

