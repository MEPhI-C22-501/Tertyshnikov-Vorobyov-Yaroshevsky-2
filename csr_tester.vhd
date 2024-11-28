library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity CSR_tester is
    port (
            	o_clk        : out    std_logic;
            	o_rst        : out    std_logic;
            	o_reg_we     : out    std_logic;
            	o_write_addr : out    std_logic_vector(11 downto 0);
            	o_read_addr1 : out    std_logic_vector(11 downto 0);
            	o_read_addr2 : out    std_logic_vector(11 downto 0);
            	o_write_data : out    std_logic_vector(31 downto 0);
	    	o_rs1        : out    std_logic_vector(31 downto 0);
		o_rs2        : out    std_logic_vector(31 downto 0);
		o_rd         : out    std_logic_vector(31 downto 0);
		o_csr_we     : out    std_logic
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

    	o_reg_we <= '0';
   	o_write_addr <= x"001";
    	o_read_addr1 <= x"001";
    	o_read_addr2 <= x"001";
    	o_write_data <= x"AAAAAAAA";
	o_csr_we <= '0';

	o_rs1 <= x"00000001";
	o_rs2 <= x"00000002";
	o_rd <= x"00000003";
	o_csr_we <= '1';
	wait_clk(1);
	o_csr_we <= '0';

        o_reg_we   <= '1';
	wait_clk(1);

        o_write_addr <= x"005";
        o_write_data <= x"AAAAAAAA";
        wait_clk(1);

        o_reg_we <= '0';
        wait_clk(1);

	o_reg_we   <= '1';
	wait_clk(1);

        o_write_addr <= x"000";
        o_write_data <= x"AAAAAAAA";
        wait_clk(1);

        o_reg_we <= '0';
        wait_clk(1);

	o_read_addr1 <= x"000";
        o_read_addr2 <= x"000";
        wait_clk(1);

        o_read_addr1 <= x"005";
        o_read_addr2 <= x"005";
        wait_clk(1);

        o_rst <= '1';
        wait_clk(1);
        o_rst <= '0';

        o_read_addr1 <= x"105";
        wait_clk(1);
        wait;
    end process;

end CSR_tester_arch;