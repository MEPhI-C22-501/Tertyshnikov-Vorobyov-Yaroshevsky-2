library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ROM_tb is
end ROM_tb;

architecture ROM_tb_arch of ROM_tb is
    component ROM
        port (
            i_clk       : in  std_logic;
            i_addr : in  std_logic_vector(11 downto 0);
            o_data : out std_logic_vector(31 downto 0)
        );
    end component;

    component ROM_tester is
	port (
		o_clk       : out  std_logic;
            	o_addr : out  std_logic_vector(11 downto 0)
	);
    end component;

    signal clk_s       : std_logic := '0';
    signal addr_s : std_logic_vector(11 downto 0) := (others => '0');
    signal data_s : std_logic_vector(31 downto 0);

begin         



t1: ROM
	port map (
            i_clk       => clk_s,
            i_addr => addr_s,
            o_data => data_s
        );


    t2: ROM_tester
        port map (
            o_clk  => clk_s,
            o_addr => addr_s
        );

end ROM_tb_arch;
