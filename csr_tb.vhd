library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.csr_mem_pkg.all;

entity CSR_tb is
end entity;

architecture CSR_tb_arch of CSR_tb is
    	signal clk_sig        : std_logic := '0';
    	signal rst_sig        : std_logic := '0';
	signal program_counter_sig   : std_logic_vector(31 downto 0) := (others => '0');
	signal program_counter_res_sig : std_logic_vector(31 downto 0) := (others => '0');
	signal rs1_sig        : std_logic_vector(31 downto 0) := (others => '0');
	signal rs2_sig        : std_logic_vector(31 downto 0) := (others => '0');
	signal rd_sig         : std_logic_vector(31 downto 0) := (others => '0');
	signal rs1_res_sig    : std_logic_vector(31 downto 0) := (others => '0');
	signal rs2_res_sig    : std_logic_vector(31 downto 0) := (others => '0');
	signal rd_res_sig     : std_logic_vector(31 downto 0) := (others => '0');
	signal csr_write_enable_sig     : std_logic := '0';
	signal csr_array_sig : csr_array := (others => (others => '0'));
	signal csr_array_res_sig : csr_array := (others => (others => '0'));
	

	component CSR is
	port (
		i_clk        : in     std_logic;
        	i_rst        : in     std_logic;
        	i_program_counter : in std_logic_vector(31 downto 0);
		o_program_counter   : out std_logic_vector(31 downto 0);
		i_rs1        : in     std_logic_vector(31 downto 0);
		i_rs2        : in     std_logic_vector(31 downto 0);
		i_rd         : in     std_logic_vector(31 downto 0);
		o_rs1        : out    std_logic_vector(31 downto 0);
		o_rs2        : out    std_logic_vector(31 downto 0);
		o_rd         : out    std_logic_vector(31 downto 0);
		i_csr_write_enable     : in     std_logic;
		i_csr_array : in csr_array;
		o_csr_array : out csr_array
	);
	end component;

	component CSR_tester is
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
	end component;


begin

t1: CSR_tester port map(
	o_clk => clk_sig,
	o_rst => rst_sig,
	o_rs1 => rs1_sig,
	o_rs2 => rs2_sig,
	o_rd => rd_sig,
	o_csr_write_enable => csr_write_enable_sig,
	o_csr_array => csr_array_sig
);

t2: CSR port map(
	i_clk => clk_sig,
	i_rst => rst_sig,
	i_program_counter => program_counter_sig,
	o_program_counter => program_counter_res_sig,
	i_rs1 => rs1_sig,
	o_rs1 => rs1_res_sig,
	i_rs2 => rs2_sig,
	o_rs2 => rs2_res_sig,
	i_rd => rd_sig,
	o_rd => rd_res_sig,
	i_csr_write_enable => csr_write_enable_sig,
	i_csr_array => csr_array_sig,
	o_csr_array => csr_array_res_sig
);

end CSR_tb_arch;