library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.inst_mem_pkg.all;

entity inst_mem_tester is
	port (
		o_clk       : out  std_logic;
		o_rst       : out  std_logic;
            	o_read_addr : out  std_logic_vector(12 downto 0);
            	i_read_data : in std_logic_vector(31 downto 0)
	);
end inst_mem_tester;

architecture inst_mem_tester_arch of inst_mem_tester is
    signal clk_s       : std_logic := '0';
    constant clk_period : time := 10 ns;


    procedure wait_clk(constant j: in integer) is 
        variable ii: integer := 0;
        begin
        while ii < j loop
            if (rising_edge(clk_s)) then
                ii := ii + 1;
            end if;
            wait for 10 ps;
        end loop;
    end;
begin
    clk_s <= not clk_s after clk_period / 2;
    o_clk <= clk_s;

    process
    begin
	o_rst <= '1';
	wait_clk(2);
	wait for 1 ns;
	o_rst <= '0';
	
        for addr in 0 to 5 loop
            o_read_addr <= std_logic_vector(to_unsigned(addr, 13));
            wait_clk(1);
        end loop;
        wait;
    end process;

end inst_mem_tester_arch;
