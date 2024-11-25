library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity data_mem_tb is
end entity;

architecture data_mem_tb_arch of data_mem_tb is

    	signal clk_sig        : std_logic := '0';
    	signal rst_sig        : std_logic := '0';
    	signal write_en_sig   : std_logic := '0';
    	signal write_addr_sig : std_logic_vector(15 downto 0) := (others => '0');
    	signal read_addr1_sig : std_logic_vector(15 downto 0) := (others => '0');
    	signal read_addr2_sig : std_logic_vector(15 downto 0) := (others => '0');
   	signal write_data_sig : std_logic_vector(31 downto 0) := (others => '0');
  	signal read_data1_sig : std_logic_vector(31 downto 0) := (others => '0');
    	signal read_data2_sig : std_logic_vector(31 downto 0) := (others => '0');

	component DataMemory is
	port (
		i_clk        : in  std_logic;
        	i_rst        : in  std_logic;
 	       	i_write_en   : in  std_logic;
        	i_write_addr : in  std_logic_vector(15 downto 0);
        	i_read_addr1 : in  std_logic_vector(15 downto 0);
        	i_read_addr2 : in  std_logic_vector(15 downto 0);
        	i_write_data : in  std_logic_vector(31 downto 0);
        	o_read_data1 : out std_logic_vector(31 downto 0);
        	o_read_data2 : out std_logic_vector(31 downto 0)
	);
	end component;

	component data_mem_tester is
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
	end component;


begin

t1: data_mem_tester port map(
	o_clk => clk_sig,
	o_rst => rst_sig,
	o_write_en => write_en_sig,
	o_write_addr => write_addr_sig,
	o_read_addr1 => read_addr1_sig,
	o_read_addr2 => read_addr2_sig,
	o_write_data => write_data_sig,
	i_read_data1 => read_data1_sig,
	i_read_data2 => read_data2_sig
);

t2: DataMemory port map(
	i_clk => clk_sig,
	i_rst => rst_sig,
	i_write_en => write_en_sig,
	i_write_addr => write_addr_sig,
	i_read_addr1 => read_addr1_sig,
	i_read_addr2 => read_addr2_sig,
	i_write_data => write_data_sig,
	o_read_data1 => read_data1_sig,
	o_read_data2 => read_data2_sig
);

end data_mem_tb_arch;