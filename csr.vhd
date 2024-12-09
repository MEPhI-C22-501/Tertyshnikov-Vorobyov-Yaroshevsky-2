library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.csr_mem_pkg.all;

entity CSR is
    port (
        i_clk        : in     std_logic;
        i_rst                  : in     std_logic;
        -- i_register_write_enable    : in     std_logic;
        -- i_write_addr : in     std_logic_vector(4 downto 0);
        -- i_read_addr1 : in     std_logic_vector(4 downto 0);
        -- i_read_addr2 : in     std_logic_vector(4 downto 0);
        -- i_write_data : in     std_logic_vector(31 downto 0);
        -- o_read_data1 : out    std_logic_vector(31 downto 0);
        -- o_read_data2 : out    std_logic_vector(31 downto 0);
	i_program_counter : in std_logic_vector(31 downto 0);
	o_program_counter   : out std_logic_vector(31 downto 0);
	i_rs1        : in     std_logic_vector(31 downto 0);
	i_rs2        : in     std_logic_vector(31 downto 0);
	i_rd         : in     std_logic_vector(31 downto 0);
	o_rs1        : out    std_logic_vector(31 downto 0);
	o_rs2        : out    std_logic_vector(31 downto 0);
	o_rd         : out    std_logic_vector(31 downto 0);
	i_csr_write_enable     : in     std_logic;
	i_csr_array : in csr_array;
	o_csr_array : out csr_array
    );
end CSR;

architecture csr_beh of CSR is
    	signal registers : csr_array := (others => (others => '0'));
	signal program_counter_sig : integer := 0;
	signal rs1_sig : std_logic_vector(31 downto 0) := (others => '0');
	signal rs2_sig : std_logic_vector(31 downto 0) := (others => '0');
	signal rd_sig  : std_logic_vector(31 downto 0) := (others => '0');

begin     
    process (registers, i_clk, i_rs1, i_rs2, i_rd, i_csr_write_enable)
    begin
	if rising_edge(i_clk) then
		if i_csr_write_enable = '0' then
			o_rs1 <= rs1_sig;
			o_rs2 <= rs2_sig;
			o_rd <= rd_sig;
			o_program_counter <= std_logic_vector(to_unsigned(program_counter_sig, 32));

			o_csr_array(1) <= (others => '0');
			for i in 2 to 31 loop
				o_csr_array(i) <= registers(i);
			end loop;
		end if;
	end if;
    end process;
     
    process (i_clk, registers, program_counter_sig, rs1_sig, rs2_sig, rd_sig)
    begin
	if i_rst = '1' then
		program_counter_sig <= 0;
		rs1_sig <= x"00000000";
		rs2_sig <= x"00000000";
		rd_sig <= x"00000000";
	elsif rising_edge(i_clk) then
		program_counter_sig <= program_counter_sig + 1;

		if i_csr_write_enable = '1' then
			rs1_sig <= i_rs1;
			rs2_sig <= i_rs2;
			rd_sig <= i_rd;
			program_counter_sig <= to_integer(unsigned(i_program_counter));

			for i in 2 to 31 loop
				registers(i) <= i_csr_array(i);
			end loop;
            	end if;
        end if;
    end process;

end csr_beh;

