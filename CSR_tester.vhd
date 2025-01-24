library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity CSR_tester is
	port (
		o_clk       : out  std_logic;
            	o_addr : out  std_logic_vector(11 downto 0)
	);
end CSR_tester;

architecture CSR_tester_arch of CSR_tester is
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
	o_addr <= x"000";
	for addr in 0 to 5 loop
            o_addr <= std_logic_vector(to_unsigned(addr, 12));
            wait_clk(1);
        end loop;
        wait;
    end process;

end CSR_tester_arch;
