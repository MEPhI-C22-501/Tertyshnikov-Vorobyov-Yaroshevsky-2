library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.inst_mem_pkg.all;
use work.csr_mem_pkg.all;


entity data_mem_verification is
end data_mem_verification;

architecture data_mem_verification_arch of data_mem_verification is
    	component WriteBack is
	port (
        	i_clk          : in  STD_LOGIC;
        	i_rst          : in  STD_LOGIC;
        	i_read_data    : in  STD_LOGIC_VECTOR(31 downto 0); 
        	i_ALUResult    : in  STD_LOGIC_VECTOR(31 downto 0); 
        	i_resultSrc    : in  STD_LOGIC;                
        	i_regWrite     : in  STD_LOGIC;               
        	o_result       : out STD_LOGIC_VECTOR(31 downto 0);   
        	o_regWrite     : out STD_LOGIC
    	);
	end component;

	component DataMemory is
    	port (
        	i_clk           : in  std_logic;
		i_rst           : in  std_logic;
        	i_write_enable  : in  std_logic;
        	i_addr          : in  std_logic_vector(15 downto 0);
        	i_write_data    : in  std_logic_vector(31 downto 0);
        	o_read_data     : out std_logic_vector(31 downto 0)
    	);
	end component;

    	signal clk_s     	  : std_logic := '0';
   	signal rst_s              : std_logic := '0';
	signal read_data_s        : std_logic_vector(31 downto 0) := (others => '0');
	signal write_data_s       : std_logic_vector(31 downto 0) := (others => '0');
	signal result_s           : std_logic_vector(31 downto 0) := (others => '0');
	signal resultSrc_s        : std_logic := '1';
	signal write_enable_s     : std_logic := '0';
	signal data_mem_addr_s    : std_logic_vector(15 downto 0) := (others => '0');
  
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
	
	t1: DataMemory
	port map (
		i_clk => clk_s,
		i_rst => rst_s,
		i_write_enable => write_enable_s,
		i_addr => data_mem_addr_s,
		i_write_data => write_data_s,
		o_read_data => read_data_s
	);

	t2: WriteBack
        port map (
            	i_clk => clk_s,
        	i_rst => rst_s,
        	i_read_data => read_data_s,
        	i_ALUResult => x"AAAAAAAA", 
        	i_resultSrc => resultSrc_s, -- '1' - alu; '0' - data memory
        	i_regWrite => '0',
        	o_result => result_s
        );

	process
	begin
		rst_s <= '1';
		wait_clk(2);
		wait for 1 ns;
		rst_s <= '0';
	
		data_mem_addr_s <= (others => '0');
		write_enable_s <= '1';
		write_data_s <= x"BBBBBBBB";
		wait_clk(1);
		write_enable_s <= '0';
		
		wait_clk(2);
		resultSrc_s <= '0';
		wait_clk(1);

		wait;
	end process;
end data_mem_verification_arch;