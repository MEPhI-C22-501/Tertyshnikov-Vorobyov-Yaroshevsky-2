library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.register_file_pkg.all;


entity register_file_verification is
end register_file_verification;

architecture register_file_verification_arch of register_file_verification is
    	component RegisterFile is
	port (
		i_clk        : in     std_logic;
        	i_rst                  : in     std_logic;
		i_program_counter_write_enable : in std_logic;
		i_program_counter : in std_logic_vector(15 downto 0);
		o_program_counter   : out std_logic_vector(15 downto 0);
		i_registers_write_enable : in std_logic;
		i_registers_array : in registers_array;
		i_registers_number : in std_logic_vector(4 downto 0);
		o_registers_array : out registers_array
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
        	o_addr_spec_reg_csr : out std_logic_vector (11 downto 0)  --????? ????? ?? ???????? (??????)
	);
	end component;

    	signal clk_s     	  : std_logic := '0';
   	signal rst_s              : std_logic := '0';
   	signal registers_write_enable_s : std_logic := '0';
	signal write_enable_decoder_s : std_logic := '0';
	signal registers_number_s       : std_logic_vector(4 downto 0) := "00011";
	signal registers_number3_s       : std_logic_vector(4 downto 0) := "00011";
	signal registers_number_res_s       : std_logic_vector(4 downto 0) := "00011";
    	signal program_counter_s  : std_logic_vector(15 downto 0) := (others => '0');
	signal program_counter_res_s  : std_logic_vector(15 downto 0) := (others => '0');
	signal program_counter_write_enable_s  : std_logic := '0';
    	constant clk_period       : time := 10 ns;
	signal registers_array_s        : registers_array := (others => (others => '0'));
	signal registers_array_res_s    : registers_array := (others => (others => '0'));
	signal instruction_s : std_logic_vector(16 downto 0) := "00000000100000011";
	signal opcode_decoder_s  : std_logic_vector(16 downto 0) := "00000000000000000";
	signal opcode_write_decoder_s  : std_logic_vector(16 downto 0) := "00000000000000000";
	signal write_data_memory_s : std_logic_vector(31 downto 0) := x"00000000";
	signal data_s : std_logic_vector(31 downto 0) := x"00000000";
	signal addr_memory_s : std_logic_vector(15 downto 0) := x"0000";
	

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
	

	t1: RegisterFile
	port map (
		i_clk => clk_s,
		i_rst => rst_s,
		o_program_counter => program_counter_res_s,
		i_program_counter_write_enable => program_counter_write_enable_s,
		i_program_counter => program_counter_s,
		i_registers_write_enable => registers_write_enable_s,
		i_registers_array => registers_array_s,
		i_registers_number => registers_number_res_s,
		o_registers_array => registers_array_res_s
	);

	t2: LSU
	port map (
		i_clk => clk_s,
		i_rst => rst_s,
		i_rs_csr => registers_array_res_s,
		i_write_enable_decoder => write_enable_decoder_s, -- ??????????? ?????? ? ????????
		i_opcode_decoder => opcode_decoder_s,
		i_opcode_write_decoder => opcode_write_decoder_s, -- ??????????, ?? ??? ????? ~3 ?????
		i_rs1_decoder => registers_number_s, -- ????? 1 ????????
		i_rs2_decoder => registers_number_s, -- - 2 -
		i_rd_decoder  => registers_number3_s, -- - ?????????? - 
		i_rd_ans      => data_s, -- ??? ????????? ?? writeback
		i_imm_decoder => x"000", -- ????? ?????
		i_program_counter_csr => x"AAAA", -- ??????? ?????? ?? ?????????
		i_spec_reg_or_memory_decoder => '0',
		
		o_write_enable_csr => registers_write_enable_s,
		o_rd_csr => registers_number_res_s,
		o_write_data_memory => write_data_memory_s,
		o_addr_memory => addr_memory_s,
		o_rs_csr => registers_array_s
	);

	process 
	begin
		rst_s <= '1';
		wait_clk(2);
		wait for 1 ns;
		rst_s <= '0';

		for i in 1 to 31 loop
			opcode_decoder_s <= "00000000010000011"; -- LH
			write_enable_decoder_s <= '1';
			data_s <= x"FFFFFFFF";
			registers_number3_s <= std_logic_vector(to_unsigned(i, 5));
			opcode_write_decoder_s <= "00000000010000011"; -- LH
			wait_clk(1);
		end loop;

		for i in 1 to 31 loop
			write_enable_decoder_s <= '0';
			opcode_decoder_s <= "00000000010100011"; -- SH
			registers_number_s <= std_logic_vector(to_unsigned(i, 5));
			opcode_write_decoder_s <= "00000000010100011"; -- SH
			wait_clk(1);
		end loop;

		wait;
	end process;

	   
end register_file_verification_arch;