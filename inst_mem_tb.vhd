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
	    i_rst       : in  std_logic;
            i_read_addr : in  std_logic_vector(12 downto 0);
            o_read_data : out std_logic_vector(31 downto 0)
        );
    end component;

    component inst_mem_tester is
	port (
		o_clk       : out  std_logic;
		o_rst       : out  std_logic;
            	o_read_addr : out  std_logic_vector(12 downto 0);
            	i_read_data : in std_logic_vector(31 downto 0)
	);
    end component;

    signal clk_s       : std_logic := '0';
    signal rst_s       : std_logic := '0';
    signal read_addr_s : std_logic_vector(12 downto 0) := (others => '0');
    signal read_data_s : std_logic_vector(31 downto 0);

begin         



t1: InstructionMemory
	generic map (
		file_path => "program.hex"
	)
        port map (
            i_clk       => clk_s,
	    i_rst       => rst_s,
            i_read_addr => read_addr_s,
            o_read_data => read_data_s
        );


    t2: inst_mem_tester
        port map (
            o_clk       => clk_s,
	    o_rst       => rst_s,
            o_read_addr => read_addr_s,
            i_read_data => read_data_s
        );

end inst_mem_tb_arch;
