library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity data_mem_tester is
    	port (
            	o_clk        : out  std_logic;
            	o_rst        : out  std_logic;
            	o_write_enable : out  std_logic;
            	o_write_addr : out  std_logic_vector(15 downto 0);
            	o_read_addr : out  std_logic_vector(15 downto 0);
            	o_write_data : out  std_logic_vector(31 downto 0);
            	i_read_data : in std_logic_vector(31 downto 0)
    	);
end data_mem_tester;

architecture data_mem_tester_arch of data_mem_tester is
    constant clk_period : time := 10 ns;
    signal clk_r : std_logic := '0';

	constant ADDR0 : std_logic_vector(15 downto 0) := "0000000000000000";
	constant ADDR1 : std_logic_vector(15 downto 0) := "1010101010101010";
	constant ADDR2 : std_logic_vector(15 downto 0) := "1010101010101011";

    procedure wait_clk(constant j: in integer) is 
        variable ii: integer := 0;
        begin
        while ii < j loop
            if (rising_edge(clk_r)) then
                ii := ii + 1;
            end if;
            wait for 10 ps;
        end loop;
    end;

begin
    clk_r <= not clk_r after clk_period / 2;
    o_clk <= clk_r;

    process
    begin
	o_rst <= '1';
	wait_clk(3);
        wait for 1 ns;
        o_rst <= '0';

    	o_write_enable <= '0';
   	o_write_addr <= ADDR0;
    	o_read_addr <= ADDR0;
    	o_write_data <= x"AAAAAAAA";

        o_write_enable <= '1';
	wait_clk(1);

        o_write_addr <= ADDR1;
        o_write_data <= x"AAAAAAAA";
        wait_clk(1);

        o_write_enable <= '0';
        wait_clk(1);

	o_read_addr <= ADDR1;
        wait_clk(1);

        o_read_addr <= ADDR2;
        wait_clk(1);

        o_rst <= '1';
	wait_clk(3);
        wait for 1 ns;
        o_rst <= '0';

        o_read_addr <= ADDR1;
        wait;
    end process;

end data_mem_tester_arch;