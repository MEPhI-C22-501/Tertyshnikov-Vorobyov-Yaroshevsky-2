library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.inst_mem_pkg.all;
use work.register_file_pkg.all;


entity CSR_verification is
end CSR_verification;

architecture CSR_verification_arch of CSR_verification is
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

	component CSR is
    	port (
		i_addr		: IN STD_LOGIC_VECTOR (11 DOWNTO 0);
		i_clk		: IN STD_LOGIC  := '1';
		o_data		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
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
        	i_spec_reg_or_memory_decoder : in std_logic; --???? 1, ?? ?????? ?? ???? ?????????, ???? 0 ?? ?? ?????? (??????)
        	i_program_counter_csr : in std_logic_vector (15 downto 0); --?????? ??????? (??????)

        	o_opcode_alu : out std_logic_vector (16 downto 0);
        	o_rs_csr : out registers_array;
        	o_rs1_alu, o_rs2_alu : out std_logic_vector (31 downto 0);
        	o_write_enable_memory, o_write_enable_csr : out std_logic;
        	o_addr_memory: out std_logic_vector (15 downto 0);
        	o_write_data_memory: out std_logic_vector (31 downto 0);
        	o_rd_csr : out std_logic_vector (4 downto 0);
        	o_addr_spec_reg_csr : out std_logic_vector (11 downto 0)
	);
	end component;

    	signal clk_s     	  : std_logic := '0';
   	signal rst_s              : std_logic := '0';
	signal read_data_s        : std_logic_vector(31 downto 0) := (others => '0');
	signal result_s           : std_logic_vector(31 downto 0) := (others => '0');
	signal resultSrc_s        : STD_LOGIC_VECTOR(1 downto 0) := "10";  -- "00" - ALU; "01" - datamem; "10" - CSR 
	signal csr_addr_s    : std_logic_vector(11 downto 0) := (others => '0');
	signal opcode_decoder_s  : std_logic_vector(16 downto 0) := "00000000100000011";
	signal opcode_write_decoder_s  : std_logic_vector(16 downto 0) := "00000000100000011";
  	signal registers_s : registers_array := (others => (others => '0'));
	signal registers_res_s : registers_array := (others => (others => '0'));
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
	
	t1: CSR
	port map (
		i_clk => clk_s,
		i_addr => csr_addr_s,
		o_data => read_data_s
	);

	t2: WriteBack
        port map (
            	i_clk => clk_s,
        	i_rst => rst_s,
        	i_datamem_result => read_data_s,
        	i_ALU_result => x"00000000",
        	i_result_src => resultSrc_s,
        	o_result => result_s,
		i_CSR_result => x"AAAAAAAA"
        );

	t3: LSU
	port map (
		i_clk => clk_s,
		i_rst => rst_s,
		i_rs_csr => registers_s,
		i_write_enable_decoder => '0',
		i_opcode_decoder => opcode_decoder_s,
		i_opcode_write_decoder => opcode_write_decoder_s,
		i_rs1_decoder => "00001",
		i_rs2_decoder => "00010",
		i_rd_decoder  => "00011",
		i_rd_ans      => result_s,
		i_imm_decoder => x"000",
		i_spec_reg_or_memory_decoder => '1',
		i_program_counter_csr => x"0000",

		o_rs_csr => registers_res_s,
		o_addr_spec_reg_csr => csr_addr_s
	);

	process
	begin
		registers_s(1) <= x"00000003";
		rst_s <= '1';
		wait_clk(2);
		wait for 1 ns;
		rst_s <= '0';

		wait;
	end process;
end CSR_verification_arch;