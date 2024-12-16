library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity data_mem_tb is
end entity;

architecture data_mem_tb_arch of data_mem_tb is

    	signal clk_r        : std_logic := '0';
    	signal rst_r        : std_logic := '0';
    	signal write_enable_r   : std_logic := '0';
    	signal write_addr_r : std_logic_vector(15 downto 0) := (others => '0');
	signal read_addr_r : std_logic_vector(15 downto 0) := (others => '0');
    	signal write_data_r : std_logic_vector(31 downto 0) := (others => '0');
	signal read_data_r : std_logic_vector(31 downto 0) := (others => '0');
    	
	component DataMemory is
	port (
		i_clk        : in  std_logic;
        	i_rst        : in  std_logic;
 	       	i_write_enable   : in  std_logic;
        	i_write_addr : in  std_logic_vector(15 downto 0);
        	i_read_addr : in  std_logic_vector(15 downto 0);
        	i_write_data : in  std_logic_vector(31 downto 0);
		o_read_data : out std_logic_vector(31 downto 0)
        );
	end component;

	component data_mem_tester is
	port (
		o_clk        : out  std_logic;
            	o_rst        : out  std_logic;
            	o_write_enable : out  std_logic;
            	o_write_addr : out  std_logic_vector(15 downto 0);
            	o_read_addr : out  std_logic_vector(15 downto 0);
            	o_write_data : out  std_logic_vector(31 downto 0);
		i_read_data : in std_logic_vector(31 downto 0)
        );
	end component;


begin

t1: data_mem_tester port map(
	o_clk => clk_r,
	o_rst => rst_r,
	o_write_enable => write_enable_r,
	o_write_addr => write_addr_r,
	o_read_addr => read_addr_r,
	o_write_data => write_data_r,
	i_read_data => read_data_r
);

t2: DataMemory port map(
	i_clk => clk_r,
	i_rst => rst_r,
	i_write_enable => write_enable_r,
	i_write_addr => write_addr_r,
	i_read_addr => read_addr_r,
	i_write_data => write_data_r,
	o_read_data => read_data_r
);

end data_mem_tb_arch;