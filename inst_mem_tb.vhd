library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.inst_mem_pkg.all;

entity inst_mem_tb is
end inst_mem_tb;

architecture inst_mem_tb_arch of inst_mem_tb is
    component InstructionMemory
        port (
            i_clk       : in  std_logic;
            i_read_addr : in  std_logic_vector(15 downto 0);
            o_read_data : out std_logic_vector(31 downto 0);
            i_mem_init  : in  memory_array
        );
    end component;

    component inst_mem_tester is
	port (
		o_clk       : out  std_logic;
            	o_read_addr : out  std_logic_vector(15 downto 0);
            	i_read_data : in std_logic_vector(31 downto 0);
		o_mem_init  : out  memory_array
	);
    end component;

    signal clk_sig       : std_logic := '0';
    signal read_addr_sig : std_logic_vector(15 downto 0) := (others => '0');
    signal read_data_sig : std_logic_vector(31 downto 0);
    signal mem_init_sig  : memory_array := (others => (others => '0'));

begin         



t1: InstructionMemory
        port map (
            i_clk       => clk_sig,
            i_read_addr => read_addr_sig,
            o_read_data => read_data_sig,
            i_mem_init  => mem_init_sig
        );


    t2: inst_mem_tester
        port map (
            o_clk       => clk_sig,
            o_read_addr => read_addr_sig,
            i_read_data => read_data_sig,
            o_mem_init  => mem_init_sig
        );

end inst_mem_tb_arch;
