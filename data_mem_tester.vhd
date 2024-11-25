library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity data_mem_tester is
    port (
            o_clk        : out  std_logic;
            o_rst        : out  std_logic;
            o_write_en   : out  std_logic;
            o_write_addr : out  std_logic_vector(15 downto 0);
            o_read_addr1 : out  std_logic_vector(15 downto 0);
            o_read_addr2 : out  std_logic_vector(15 downto 0);
            o_write_data : out  std_logic_vector(31 downto 0);
            i_read_data1 : in std_logic_vector(31 downto 0);
            i_read_data2 : in std_logic_vector(31 downto 0)
    );
end data_mem_tester;

architecture data_mem_tester_arch of data_mem_tester is
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

    	o_write_en <= '0';
   	o_write_addr <= x"0000";
    	o_read_addr1 <= x"0000";
    	o_read_addr2 <= x"0000";
    	o_write_data <= x"AAAAAAAA";

        o_write_en   <= '1';
	wait_clk(1);

        o_write_addr <= x"AAAA";
        o_write_data <= x"AAAAAAAA";
        wait_clk(1);

        o_write_en <= '0';
        wait_clk(1);

        o_read_addr1 <= x"AAAA";
        o_read_addr2 <= x"AAAA";
        wait_clk(1);

        o_rst <= '1';
        wait_clk(1);
        o_rst <= '0';

        o_read_addr1 <= x"AAAA";
        wait_clk(1);

        wait;
    end process;

end data_mem_tester_arch;