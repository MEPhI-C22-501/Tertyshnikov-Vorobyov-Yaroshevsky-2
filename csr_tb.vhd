library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity CSR_tb is
end entity;

architecture CSR_tb_arch of CSR_tb is

    	signal clk_sig        : std_logic := '0';
    	signal rst_sig        : std_logic := '0';
    	signal reg_we_sig     : std_logic := '0';
    	signal write_addr_sig : std_logic_vector(11 downto 0) := (others => '0');
    	signal read_addr1_sig : std_logic_vector(11 downto 0) := (others => '0');
    	signal read_addr2_sig : std_logic_vector(11 downto 0) := (others => '0');
   	signal write_data_sig : std_logic_vector(31 downto 0) := (others => '0');
  	signal read_data1_sig : std_logic_vector(31 downto 0) := (others => '0');
    	signal read_data2_sig : std_logic_vector(31 downto 0) := (others => '0');
	signal prog_cnt_sig   : std_logic_vector(31 downto 0) := (others => '0');
	signal rs1_sig        : std_logic_vector(31 downto 0) := (others => '0');
	signal rs2_sig        : std_logic_vector(31 downto 0) := (others => '0');
	signal rd_sig         : std_logic_vector(31 downto 0) := (others => '0');
	signal rs1_res_sig    : std_logic_vector(31 downto 0) := (others => '0');
	signal rs2_res_sig    : std_logic_vector(31 downto 0) := (others => '0');
	signal rd_res_sig     : std_logic_vector(31 downto 0) := (others => '0');
	signal csr_we_sig     : std_logic := '0';

	component CSR is
	port (
		i_clk        : in     std_logic;
        	i_rst        : in     std_logic;
        	i_reg_we     : in     std_logic;
        	i_write_addr : in     std_logic_vector(11 downto 0);
        	i_read_addr1 : in     std_logic_vector(11 downto 0);
        	i_read_addr2 : in     std_logic_vector(11 downto 0);
        	i_write_data : in     std_logic_vector(31 downto 0);
        	o_read_data1 : out    std_logic_vector(31 downto 0);
        	o_read_data2 : out    std_logic_vector(31 downto 0);
		o_prog_cnt   : out    std_logic_vector(31 downto 0);
		i_rs1        : in     std_logic_vector(31 downto 0);
		i_rs2        : in     std_logic_vector(31 downto 0);
		i_rd         : in     std_logic_vector(31 downto 0);
		o_rs1        : out    std_logic_vector(31 downto 0);
		o_rs2        : out    std_logic_vector(31 downto 0);
		o_rd         : out    std_logic_vector(31 downto 0);
		i_csr_we     : in     std_logic
	);
	end component;

	component CSR_tester is
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
	end component;


begin

t1: CSR_tester port map(
	o_clk => clk_sig,
	o_rst => rst_sig,
	o_reg_we => reg_we_sig,
	o_write_addr => write_addr_sig,
	o_read_addr1 => read_addr1_sig,
	o_read_addr2 => read_addr2_sig,
	o_write_data => write_data_sig,
	o_rs1 => rs1_sig,
	o_rs2 => rs2_sig,
	o_rd => rd_sig,
	o_csr_we => csr_we_sig
);

t2: CSR port map(
	i_clk => clk_sig,
	i_rst => rst_sig,
	i_reg_we => reg_we_sig,
	i_write_addr => write_addr_sig,
	i_read_addr1 => read_addr1_sig,
	i_read_addr2 => read_addr2_sig,
	i_write_data => write_data_sig,
	o_read_data1 => read_data1_sig,
	o_read_data2 => read_data2_sig,
	o_prog_cnt => prog_cnt_sig,
	i_rs1 => rs1_sig,
	i_rs2 => rs2_sig,
	i_rd => rd_sig,
	o_rs1 => rs1_res_sig,
	o_rs2 => rs2_res_sig,
	o_rd => rd_res_sig,
	i_csr_we => csr_we_sig
);

end CSR_tb_arch;