library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity CSR is
    port (
        i_clk        : in  std_logic;
        i_rst        : in  std_logic;
        i_write_en   : in  std_logic;
        i_write_addr : in  std_logic_vector(11 downto 0);
        i_read_addr1 : in  std_logic_vector(11 downto 0);
        i_read_addr2 : in  std_logic_vector(11 downto 0);
        i_write_data : in  std_logic_vector(31 downto 0);
        o_read_data1 : out std_logic_vector(31 downto 0);
        o_read_data2 : out std_logic_vector(31 downto 0);
	o_prog_cnt   : out std_logic_vector(31 downto 0)
    );
end CSR;

architecture csr_beh of CSR is
    	type reg_array is array (4095 downto 0) of std_logic_vector(31 downto 0);
    	signal registers : reg_array := (others => (others => '0')); -- all 2^12 registers initializes to zeros
	signal prog_cnt_sig : integer := 0;

begin
     
    process (i_read_addr1, i_read_addr2, registers, i_clk)
    begin
	if rising_edge(i_clk) then
		if i_read_addr1 = x"000" then
			o_read_data1 <= x"00000000";
		end if;
		if i_read_addr2 = x"000" then
			o_read_data2 <= x"00000000";
		else
        		o_read_data1 <= registers(to_integer(unsigned(i_read_addr1)));
			o_read_data2 <= registers(to_integer(unsigned(i_read_addr2)));
		end if;
	end if;
    end process;
     
    process (i_clk, registers, prog_cnt_sig)
    begin
	if i_rst = '1' then
        	registers <= (others => (others => '0'));
		prog_cnt_sig <= 0;
	elsif rising_edge(i_clk) then
		prog_cnt_sig <= prog_cnt_sig + 1;

        	if i_write_en  = '1' AND i_write_addr /= x"000" then
                	registers(to_integer(unsigned(i_write_addr))) <= i_write_data;
            	end if;
        end if;
	o_prog_cnt <= std_logic_vector(to_unsigned(prog_cnt_sig, 32));
    end process;

end csr_beh;

