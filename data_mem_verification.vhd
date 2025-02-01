library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.inst_mem_pkg.all;
use work.register_file_pkg.all;


entity data_mem_verification is
end data_mem_verification;

architecture data_mem_verification_arch of data_mem_verification is
    	component WriteBack is
	port (
        	i_clk           	: in  STD_LOGIC;
        	i_rst           	: in  STD_LOGIC;
		  i_ALU_result     	: in  STD_LOGIC_VECTOR(31 downto 0); 
		  i_datamem_result   : in  STD_LOGIC_VECTOR(31 downto 0); 
		  i_CSR_result 		: in STD_LOGIC_VECTOR (31 downto 0);
        	i_result_src       : in  STD_LOGIC_VECTOR(1 downto 0);  -- "00" - ALU; "01" - datamem; "10" - CSR                              
        	o_result        : out STD_LOGIC_VECTOR(31 downto 0)
    	);
	end component;

	component DataMemory is
    	port (
        	i_clk           : in  std_logic;
		i_rst           : in  std_logic;
        	i_write_enable  : in  std_logic;
        	i_addr          : in  std_logic_vector(12 downto 0);
        	i_write_data    : in  std_logic_vector(31 downto 0);
        	o_read_data     : out std_logic_vector(31 downto 0)
    	);
	end component;

	component LSU is
	Port (
        	i_clk, i_rst, i_write_enable_decoder : in std_logic;
        	i_opcode_decoder, i_opcode_write_decoder : in std_logic_vector (16 downto 0);
        	i_rs1_decoder, i_rs2_decoder, i_rd_decoder : in std_logic_vector (4 downto 0);
        	i_rd_ans : in std_logic_vector (31 downto 0);
        	i_imm_decoder : in std_logic_vector (11 downto 0);
        	i_rs_csr : in registers_array;
        	i_spec_reg_or_memory_decoder : in std_logic; --????????? ? ???????? ?????? ???? 1, ?? ?????? ?? ???? ?????????, ???? 0 ?? ?? ?????? 
        	i_program_counter_csr : in std_logic_vector (15 downto 0); --?????? ??????? 
        	
        	o_opcode_alu : out std_logic_vector (16 downto 0);
        	o_rs_csr : out registers_array;
        	o_rs1_alu, o_rs2_alu : out std_logic_vector (31 downto 0);
        	o_write_enable_memory, o_write_enable_csr : out std_logic;
        	o_addr_memory: out std_logic_vector (15 downto 0);
        	o_write_data_memory: out std_logic_vector (31 downto 0);
        	o_rd_csr : out std_logic_vector (4 downto 0);
        	o_addr_spec_reg_csr : out std_logic_vector (11 downto 0)  --????????? ? ???????? ??????
	);
	end component;

	component LSUMEM is
		Port (
        		i_clk, i_rst, i_write_enable_LSU : in std_logic;
        		i_addr_LSU : in std_logic_vector (15 downto 0);
        		i_write_data_LSU : in std_logic_vector (31 downto 0);

        		o_write_enable_memory: out std_logic;
        		o_addr_memory: out std_logic_vector (15 downto 0);
        		o_write_data_memory: out std_logic_vector (31 downto 0)
		);
	end component;

    	signal clk_s     	  : std_logic := '0';
   	signal rst_s              : std_logic := '0';
	signal read_data_s        : std_logic_vector(31 downto 0) := (others => '0');
	signal write_data_s       : std_logic_vector(31 downto 0) := (others => '0');
	signal write_data_res_s       : std_logic_vector(31 downto 0) := (others => '0');
	signal result_s           : std_logic_vector(31 downto 0) := (others => '0');
	signal resultSrc_s        : std_logic := '0'; -- '1' - alu; '0' - data memory
	signal write_enable_s     : std_logic := '0';
	signal data_mem_addr_s    : std_logic_vector(15 downto 0) := (others => '0');
	signal write_enable_res_s     : std_logic := '0';
	signal data_mem_addr_res_s    : std_logic_vector(15 downto 0) := (others => '0');
	signal write_enable_decoder_s : std_logic := '0';
	signal instruction_s : std_logic_vector(16 downto 0) := "00000000100100011";
	signal opcode_decoder_s  : std_logic_vector(16 downto 0) := "00000000000000000";
	signal opcode_write_decoder_s  : std_logic_vector(16 downto 0) := "00000000000000000";
  	signal registers_s : registers_array := (others => (others => '0'));
	signal registers_res_s : registers_array := (others => (others => '0'));
	signal rd_decoder_s : std_logic_vector(4 downto 0) := "00000";
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
		i_write_enable => write_enable_res_s,
		i_addr => data_mem_addr_res_s(12 downto 0),
		i_write_data => write_data_res_s,
		o_read_data => read_data_s
	);

	t2: WriteBack
        port map (
            	i_clk => clk_s,
        	i_rst => rst_s,
        	i_datamem_result => read_data_s,
        	i_ALU_result => x"AAAAAAAA",
        	i_result_src => "01",
		i_CSR_result => x"00000000",
        	o_result => result_s
        );

	t3: LSU
	port map (
		i_clk => clk_s,
		i_rst => rst_s,
		i_rs_csr => registers_s,
		i_write_enable_decoder => write_enable_decoder_s,
		i_opcode_decoder => opcode_decoder_s,
		i_opcode_write_decoder => opcode_write_decoder_s,
		i_rs1_decoder => "00001",
		i_rs2_decoder => "00010",
		i_rd_decoder  => rd_decoder_s,
		i_rd_ans      => result_s,
		i_imm_decoder => x"000",
		i_spec_reg_or_memory_decoder => '0',
		i_program_counter_csr => x"0000",

		o_write_data_memory => write_data_s,
		o_addr_memory => data_mem_addr_s,
		o_rs_csr => registers_res_s,
		o_write_enable_memory => write_enable_s
	);

	t4: LSUMEM
	port map (
		i_clk => clk_s,
		i_rst => rst_s,
		i_write_enable_LSU => write_enable_s,
        	i_addr_LSU => data_mem_addr_s,
        	i_write_data_LSU => write_data_s,

        	o_write_enable_memory => write_enable_res_s,
        	o_addr_memory => data_mem_addr_res_s,
        	o_write_data_memory => write_data_res_s
	);


	process
	begin
		write_enable_decoder_s <= '0';
		wait_clk(34);
		write_enable_decoder_s <= '1';
		wait;
	end process;

	process
	begin
		wait_clk(34);
		
		for i in 2 to 31 loop
			rd_decoder_s <= std_logic_vector(to_unsigned(i, 5));
			opcode_write_decoder_s <= "00000000100000011"; -- LW
			wait_clk(1);
		end loop;
		wait;
	end process;

	process
	begin
		rst_s <= '1';
		wait_clk(2);
		wait for 1 ns;
		rst_s <= '0';
		for i in 2 to 31 loop
			registers_s(1) <= std_logic_vector(to_unsigned(i, 32));
			registers_s(2) <= std_logic_vector(to_unsigned(i, 32));
			opcode_decoder_s <= "00000000100100011"; -- SW
			
			wait_clk(1);
		end loop;
		wait_clk(1);
		for i in 2 to 31 loop
			registers_s(1) <= std_logic_vector(to_unsigned(i, 32));
			opcode_decoder_s <= "00000000100000011"; -- LW
			wait_clk(1);
		end loop;

		wait;
	end process;
end data_mem_verification_arch;