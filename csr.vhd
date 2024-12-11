library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.csr_mem_pkg.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity CSR is
    port (
        i_clk        : in     std_logic;
        i_rst                  : in     std_logic;
	i_program_counter_write_enable : std_logic;
	i_program_counter : in std_logic_vector(31 downto 0);
	o_program_counter   : out std_logic_vector(31 downto 0);
	i_rs1_write_enable : std_logic;
	i_rs1        : in     std_logic_vector(31 downto 0);
	i_rs2_write_enable : std_logic;
	i_rs2        : in     std_logic_vector(31 downto 0);
	i_rd_write_enable : std_logic;
	i_rd         : in     std_logic_vector(31 downto 0);
	o_rs1        : out    std_logic_vector(31 downto 0);
	o_rs2        : out    std_logic_vector(31 downto 0);
	o_rd         : out    std_logic_vector(31 downto 0);
	i_csr_array_write_enable : in std_logic_vector(31 downto 0);
	i_csr_array : in csr_array;
	o_csr_array : out csr_array
    );
end CSR;

architecture csr_beh of CSR is
    	signal registers : csr_array := (others => (others => '0'));
	signal program_counter_r : std_logic_vector(31 downto 0) := (others => '0');
	signal rs1_r : std_logic_vector(31 downto 0) := (others => '0');
	signal rs2_r : std_logic_vector(31 downto 0) := (others => '0');
	signal rd_r  : std_logic_vector(31 downto 0) := (others => '0');

begin     
    process (i_clk)
    begin
	if i_program_counter_write_enable = '0' then
		o_program_counter <= program_counter_r;
	end if;
	if i_rs1_write_enable = '0' then
		o_rs1 <= rs1_r;
	end if;
	if i_rs2_write_enable = '0' then
		o_rs2 <= rs2_r;
	end if;
	if i_rd_write_enable = '0' then
		o_rd <= rd_r;
	end if;

	o_csr_array(1) <= (others => '0');
	for i in 2 to 31 loop
		if i_csr_array_write_enable(i) = '0' then
			o_csr_array(i) <= registers(i);
		end if;
	end loop;
    end process;
     
    process (i_clk, i_rst)
    begin
	if i_rst = '1' then
		program_counter_r <= (others => '0');
		rs1_r <= x"00000000";
		rs2_r <= x"00000000";
		rd_r <= x"00000000";
		-- synthesis off
		registers <= (others => (others => '0'));
		-- synthesis on
	elsif rising_edge(i_clk) then
		program_counter_r <= program_counter_r + '1';

		if i_program_counter_write_enable = '1' then
			program_counter_r <= i_program_counter;
		end if;
		if i_rs1_write_enable = '1' then
			rs1_r <= i_rs1;
		end if;
		if i_rs2_write_enable = '1' then
			rs2_r <= i_rs2;
		end if;
		if i_rd_write_enable = '1' then
			rd_r <= i_rd;
		end if;

		for i in 2 to 31 loop
			if i_csr_array_write_enable(i) = '1' then
				registers(i) <= i_csr_array(i);
			end if;
		end loop;

		
		for i in 2 to 31 loop
			if i_csr_array_write_enable(i) = '1' then
				registers(i) <= i_csr_array(i);
			end if;
		end loop;
	end if;
    end process;

end csr_beh;

