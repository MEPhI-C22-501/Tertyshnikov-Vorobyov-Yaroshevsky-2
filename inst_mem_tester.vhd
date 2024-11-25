library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.inst_mem_pkg.all;

entity inst_mem_tester is
	port (
		o_clk       : out  std_logic;
            	o_read_addr : out  std_logic_vector(15 downto 0);
            	i_read_data : in std_logic_vector(31 downto 0);
		o_mem_init  : out  memory_array
	);
end inst_mem_tester;

architecture inst_mem_tester_arch of inst_mem_tester is
    signal clk_sig       : std_logic := '0';
    constant clk_period : time := 10 ns;

    constant test_mem : memory_array := (
        0 => x"00000001", 1 => x"00000002", 2 => x"00000003", 3 => x"00000004",
        4 => x"00000005", 5 => x"00000006", 6 => x"00000007", 7 => x"00000008",
        8 => x"00000009", 9 => x"0000000A", 10 => x"0000000B", 11 => x"0000000C",
        12 => x"0000000D", 13 => x"0000000E", 14 => x"0000000F", 15 => x"00000010",
        others => (others => '0')
    );

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
        o_mem_init <= test_mem;
        wait_clk(1);
        for addr in 0 to 15 loop
            o_read_addr <= std_logic_vector(to_unsigned(addr, 16));
            wait_clk(1);
        end loop;
        wait;
    end process;

end inst_mem_tester_arch;
