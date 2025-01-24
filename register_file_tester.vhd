library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.register_file_pkg.all;

entity RegisterFile_tester is
    	port (
            	o_clk        : out    std_logic;
            	o_rst        : out    std_logic;
		o_registers_write_enable     : out     std_logic;
		o_registers_array : out registers_array;
		o_registers_number : out std_logic_vector(4 downto 0);
		o_program_counter : out std_logic_vector(15 downto 0);
		o_program_counter_write_enable : out std_logic
    	);
end RegisterFile_tester;

architecture RegisterFile_tester_arch of RegisterFile_tester is
    constant clk_period : time := 10 ns;
    signal clk_r : std_logic := '0';

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
	o_registers_array <= (others => (others => '0'));

	o_rst <= '1';
	wait_clk(2);
        wait for 1 ns;
        o_rst <= '0';
	wait_clk(1);

	o_program_counter <= x"AAAA";
	o_program_counter_write_enable <= '1';
	wait_clk(1);
	o_program_counter_write_enable <= '0';

	o_registers_number <= "11111";
	o_registers_array(31) <= x"AAAAAAAA";
	o_registers_write_enable <= '1';
	wait_clk(1);
	o_registers_write_enable <= '0';
	wait_clk(1);

	o_registers_number <= "11110";
	o_registers_array(30) <= x"BBBBBBBB";
	o_registers_write_enable <= '1';
	wait_clk(1);
	o_registers_write_enable <= '0';
	wait_clk(1);

	o_registers_number <= "00000";
	o_registers_array(0) <= x"CCCCCCCC";
	o_registers_write_enable <= '1';
	wait_clk(1);
	o_registers_write_enable <= '0';
	wait_clk(1);

	o_rst <= '1';
	wait_clk(2);
        wait for 1 ns;
        o_rst <= '0';

        wait;
    end process;

end RegisterFile_tester_arch;