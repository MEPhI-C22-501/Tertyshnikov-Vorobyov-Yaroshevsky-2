library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.csr_mem_pkg.all;

entity CSR_tb is
end entity;

architecture CSR_tb_arch of CSR_tb is
    	signal clk_s        : std_logic := '0';
    	signal rst_s        : std_logic := '0';
	signal program_counter_s : std_logic_vector(15 downto 0) := (others => '0');
	signal program_counter_res_s : std_logic_vector(15 downto 0) := (others => '0');
	signal program_counter_write_enable_s : std_logic := '0';
	signal csr_write_enable_s     : std_logic := '0';
	signal csr_array_s : csr_array := (others => (others => '0'));
	signal csr_array_res_s : csr_array := (others => (others => '0'));
	signal csr_number_s : std_logic_vector(4 downto 0) := "00000";

	component CSR is
	port (
		i_clk        : in     std_logic;
        	i_rst                  : in     std_logic;
		i_program_counter_write_enable : in std_logic;
		i_program_counter : in std_logic_vector(15 downto 0);
		o_program_counter   : out std_logic_vector(15 downto 0);
		i_csr_write_enable : in std_logic;
		i_csr_array : in csr_array;
		i_csr_number : in std_logic_vector(4 downto 0);
		o_csr_array : out csr_array
	);
	end component;

	component CSR_tester is
	port (
		o_clk        : out    std_logic;
            	o_rst        : out    std_logic;
		o_csr_write_enable     : out     std_logic;
		o_csr_array : out csr_array;
		o_csr_number : out std_logic_vector(4 downto 0);
		o_program_counter : out std_logic_vector(15 downto 0);
		o_program_counter_write_enable : out std_logic
	);
	end component;
begin

t1: CSR_tester port map(
	o_clk => clk_s,
	o_rst => rst_s,
	o_csr_write_enable => csr_write_enable_s,
	o_csr_array => csr_array_s,
	o_csr_number => csr_number_s,
	o_program_counter => program_counter_s,
	o_program_counter_write_enable => program_counter_write_enable_s
);

t2: CSR port map(
	i_clk => clk_s,
	i_rst => rst_s,
	i_program_counter => program_counter_s,
	i_program_counter_write_enable => program_counter_write_enable_s,
	o_program_counter => program_counter_res_s,
	i_csr_write_enable => csr_write_enable_s,
	i_csr_array => csr_array_s,
	i_csr_number => csr_number_s,
	o_csr_array => csr_array_res_s
);

end CSR_tb_arch;