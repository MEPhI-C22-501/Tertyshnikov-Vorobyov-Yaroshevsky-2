library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.register_file_pkg.all;

entity RegisterFile_tb is
end entity;

architecture RegisterFile_tb_arch of RegisterFile_tb is
    	signal clk_s        : std_logic := '0';
    	signal rst_s        : std_logic := '0';
	signal program_counter_s : std_logic_vector(15 downto 0) := (others => '0');
	signal program_counter_res_s : std_logic_vector(15 downto 0) := (others => '0');
	signal program_counter_write_enable_s : std_logic := '0';
	signal registers_write_enable_s     : std_logic := '0';
	signal registers_array_s : registers_array := (others => (others => '0'));
	signal registers_array_res_s : registers_array := (others => (others => '0'));
	signal registers_number_s : std_logic_vector(4 downto 0) := "00000";

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

	component RegisterFile_tester is
	port (
		o_clk        : out    std_logic;
            	o_rst        : out    std_logic;
		o_registers_write_enable     : out     std_logic;
		o_registers_array : out registers_array;
		o_registers_number : out std_logic_vector(4 downto 0);
		o_program_counter : out std_logic_vector(15 downto 0);
		o_program_counter_write_enable : out std_logic
	);
	end component;
begin

t1: RegisterFile_tester port map(
	o_clk => clk_s,
	o_rst => rst_s,
	o_registers_write_enable => registers_write_enable_s,
	o_registers_array => registers_array_s,
	o_registers_number => registers_number_s,
	o_program_counter => program_counter_s,
	o_program_counter_write_enable => program_counter_write_enable_s
);

t2: RegisterFile port map(
	i_clk => clk_s,
	i_rst => rst_s,
	i_program_counter => program_counter_s,
	i_program_counter_write_enable => program_counter_write_enable_s,
	o_program_counter => program_counter_res_s,
	i_registers_write_enable => registers_write_enable_s,
	i_registers_array => registers_array_s,
	i_registers_number => registers_number_s,
	o_registers_array => registers_array_res_s
);

end RegisterFile_tb_arch;