library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.csr_mem_pkg.all;

entity CSR_tester is
    	port (
            	o_clk        : out    std_logic;
            	o_rst        : out    std_logic;
		o_program_counter   : out std_logic_vector(31 downto 0);
		o_rs1        : out    std_logic_vector(31 downto 0);
		o_rs2        : out    std_logic_vector(31 downto 0);
		o_rd         : out    std_logic_vector(31 downto 0);
		o_csr_write_enable     : out     std_logic;
		o_csr_array : out csr_array
    	);
end CSR_tester;

architecture CSR_tester_arch of CSR_tester is
    constant clk_period : time := 10 ns;
    signal clk_sig : std_logic := '0';

    procedure wait_clk(constant j: in integer) is 
        variable ii: integer := 0;
        begin
        while ii < j loop
            if (rising_edge(clk_sig)) then
                ii := ii + 1;
            end if;
            wait for 10 ps;
        end loop;
    end;

begin
    clk_sig <= not clk_sig after clk_period / 2;
    o_clk <= clk_sig;

    process
    begin
	o_rst <= '1';
        wait_clk(1);
        o_rst <= '0';

	o_csr_write_enable <= '1';
	o_program_counter <= x"00009999";
	o_rs1 <= x"00009999";
	o_rs2 <= x"00009999";
	o_rd  <= x"00009999";

	for i in 31 downto 0 loop
		o_csr_array(i) <= std_logic_vector(to_unsigned(i, 32));
	end loop;
	
	o_csr_write_enable <= '0';

        wait;
    end process;

end CSR_tester_arch;