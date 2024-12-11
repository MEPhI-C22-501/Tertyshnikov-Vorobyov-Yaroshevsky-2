library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity data_mem_tb is
end entity;

architecture data_mem_tb_arch of data_mem_tb is

    	signal clk_r        : std_logic := '0';
    	signal rst_r        : std_logic := '0';
    	signal write_enable1_r   : std_logic := '0';
	signal write_enable2_r   : std_logic := '0';
    	signal write_addr1_r : std_logic_vector(15 downto 0) := (others => '0');
	signal write_addr2_r : std_logic_vector(15 downto 0) := (others => '0');
    	signal read_addr1_r : std_logic_vector(15 downto 0) := (others => '0');
    	signal read_addr2_r : std_logic_vector(15 downto 0) := (others => '0');
   	signal write_data1_r : std_logic_vector(31 downto 0) := (others => '0');
	signal write_data2_r : std_logic_vector(31 downto 0) := (others => '0');
  	signal read_data1_r : std_logic_vector(31 downto 0) := (others => '0');
    	signal read_data2_r : std_logic_vector(31 downto 0) := (others => '0');

	component DataMemory is
	port (
		i_clk        : in  std_logic;
        	i_rst        : in  std_logic;
 	       	i_write_enable1   : in  std_logic;
		i_write_enable2   : in  std_logic;
        	i_write_addr1 : in  std_logic_vector(15 downto 0);
		i_write_addr2 : in  std_logic_vector(15 downto 0);
        	i_read_addr1 : in  std_logic_vector(15 downto 0);
        	i_read_addr2 : in  std_logic_vector(15 downto 0);
        	i_write_data1 : in  std_logic_vector(31 downto 0);
		i_write_data2 : in  std_logic_vector(31 downto 0);
        	o_read_data1 : out std_logic_vector(31 downto 0);
        	o_read_data2 : out std_logic_vector(31 downto 0)
	);
	end component;

	component data_mem_tester is
	port (
		o_clk        : out  std_logic;
            	o_rst        : out  std_logic;
            	o_write_enable1 : out  std_logic;
		o_write_enable2 : out  std_logic;
            	o_write_addr1 : out  std_logic_vector(15 downto 0);
		o_write_addr2 : out  std_logic_vector(15 downto 0);
            	o_read_addr1 : out  std_logic_vector(15 downto 0);
            	o_read_addr2 : out  std_logic_vector(15 downto 0);
            	o_write_data1 : out  std_logic_vector(31 downto 0);
		o_write_data2 : out  std_logic_vector(31 downto 0);
            	i_read_data1 : in std_logic_vector(31 downto 0);
            	i_read_data2 : in std_logic_vector(31 downto 0)
	);
	end component;


begin

t1: data_mem_tester port map(
	o_clk => clk_r,
	o_rst => rst_r,
	o_write_enable1 => write_enable1_r,
	o_write_enable2 => write_enable2_r,
	o_write_addr1 => write_addr1_r,
	o_write_addr2 => write_addr2_r,
	o_read_addr1 => read_addr1_r,
	o_read_addr2 => read_addr2_r,
	o_write_data1 => write_data1_r,
	o_write_data2 => write_data2_r,
	i_read_data1 => read_data1_r,
	i_read_data2 => read_data2_r
);

t2: DataMemory port map(
	i_clk => clk_r,
	i_rst => rst_r,
	i_write_enable1 => write_enable1_r,
	i_write_enable2 => write_enable2_r,
	i_write_addr1 => write_addr1_r,
	i_write_addr2 => write_addr2_r,
	i_read_addr1 => read_addr1_r,
	i_read_addr2 => read_addr2_r,
	i_write_data1 => write_data1_r,
	i_write_data2 => write_data2_r,
	o_read_data1 => read_data1_r,
	o_read_data2 => read_data2_r
);

end data_mem_tb_arch;