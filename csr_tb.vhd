library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.csr_mem_pkg.all;

entity CSR_tb is
end entity;

architecture CSR_tb_arch of CSR_tb is
    	signal clk_r        : std_logic := '0';
    	signal rst_r        : std_logic := '0';
	signal program_counter_write_enable_r : std_logic := '0';
	signal program_counter_r   : std_logic_vector(31 downto 0) := (others => '0');
	signal program_counter_res_r : std_logic_vector(31 downto 0) := (others => '0');
	signal rs1_write_enable_r : std_logic := '0';
	signal rs1_r        : std_logic_vector(31 downto 0) := (others => '0');
	signal rs2_write_enable_r : std_logic := '0';
	signal rs2_r        : std_logic_vector(31 downto 0) := (others => '0');
	signal rd_write_enable_r : std_logic := '0';
	signal rd_r         : std_logic_vector(31 downto 0) := (others => '0');
	signal rs1_res_r    : std_logic_vector(31 downto 0) := (others => '0');
	signal rs2_res_r    : std_logic_vector(31 downto 0) := (others => '0');
	signal rd_res_r     : std_logic_vector(31 downto 0) := (others => '0');
	signal csr_array_write_enable_r     : std_logic_vector(31 downto 0) := (others => '0');
	signal csr_array_r : csr_array := (others => (others => '0'));
	signal csr_array_res_r : csr_array := (others => (others => '0'));
	

	component CSR is
	port (
		i_clk        : in     std_logic;
        	i_rst                  : in     std_logic;
		i_program_counter_write_enable : std_logic;
		i_program_counter : in std_logic_vector(31 downto 0);
		o_program_counter   : out std_logic_vector(31 downto 0);
		i_rs1_write_enable : std_logic;
		i_rs1        : in     std_logic_vector(31 downto 0);
		i_rs2_write_enable : std_logic;
		i_rs2        : in     std_logic_vector(31 downto 0);
		i_rd_write_enable : std_logic;
		i_rd         : in     std_logic_vector(31 downto 0);
		o_rs1        : out    std_logic_vector(31 downto 0);
		o_rs2        : out    std_logic_vector(31 downto 0);
		o_rd         : out    std_logic_vector(31 downto 0);
		i_csr_array_write_enable : in std_logic_vector(31 downto 0);
		i_csr_array : in csr_array;
		o_csr_array : out csr_array
	);
	end component;

	component CSR_tester is
	port (
		o_clk        : out    std_logic;
            	o_rst        : out    std_logic;
		o_program_counter   : out std_logic_vector(31 downto 0);
		o_program_counter_write_enable : out std_logic;
		o_rs1        : out    std_logic_vector(31 downto 0);
		o_rs1_write_enable : out std_logic;
		o_rs2        : out    std_logic_vector(31 downto 0);
		o_rs2_write_enable : out std_logic;
		o_rd         : out    std_logic_vector(31 downto 0);
		o_rd_write_enable : out std_logic;
		o_csr_array_write_enable     : out     std_logic_vector(31 downto 0);
		o_csr_array : out csr_array
	);
	end component;


begin

t1: CSR_tester port map(
	o_clk => clk_r,
	o_rst => rst_r,
	o_rs1_write_enable => rs1_write_enable_r,
	o_rs1 => rs1_r,
	o_rs2_write_enable => rs2_write_enable_r,
	o_rs2 => rs2_r,
	o_rd_write_enable => rd_write_enable_r,
	o_rd => rd_r,
	o_program_counter => program_counter_r,
	o_program_counter_write_enable => program_counter_write_enable_r,
	o_csr_array_write_enable => csr_array_write_enable_r,
	o_csr_array => csr_array_r
);

t2: CSR port map(
	i_clk => clk_r,
	i_rst => rst_r,
	i_program_counter_write_enable => program_counter_write_enable_r,
	i_program_counter => program_counter_r,
	o_program_counter => program_counter_res_r,
	i_rs1_write_enable => rs1_write_enable_r,
	i_rs1 => rs1_r,
	o_rs1 => rs1_res_r,
	i_rs2_write_enable => rs2_write_enable_r,
	i_rs2 => rs2_r,
	o_rs2 => rs2_res_r,
	i_rd_write_enable => rd_write_enable_r,
	i_rd => rd_r,
	o_rd => rd_res_r,
	i_csr_array_write_enable => csr_array_write_enable_r,
	i_csr_array => csr_array_r,
	o_csr_array => csr_array_res_r
);

end CSR_tb_arch;