library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.inst_mem_pkg.all;
use STD.TEXTIO.ALL;

entity inst_mem_tb is
end inst_mem_tb;

architecture inst_mem_tb_arch of inst_mem_tb is
    component InstructionMemory
        port (
            i_clk       : in  std_logic;
            i_read_addr : in  std_logic_vector(15 downto 0);
            o_read_data : out std_logic_vector(31 downto 0)
            -- i_mem_init  : in  memory_array
        );
    end component;

    component inst_mem_tester is
	port (
		o_clk       : out  std_logic;
            	o_read_addr : out  std_logic_vector(15 downto 0);
            	i_read_data : in std_logic_vector(31 downto 0)
		-- o_mem_init  : out  memory_array
	);
    end component;

    signal clk_sig       : std_logic := '0';
    signal read_addr_sig : std_logic_vector(15 downto 0) := (others => '0');
    signal read_data_sig : std_logic_vector(31 downto 0);
    -- signal mem_init_sig  : memory_array := (others => (others => '0'));










function string_to_int(x_str : string; radix : positive range 2 to 36 := 10) return integer is
    constant STR_LEN          : integer := x_str'length;
    
    variable chr_val          : integer;
    variable ret_int          : integer := 0;
    variable do_mult          : boolean := true;
    variable power            : integer := 0;
  begin
    
    for i in STR_LEN downto 1 loop
      case x_str(i) is
        when '0'       =>   chr_val := 0;
        when '1'       =>   chr_val := 1;
        when '2'       =>   chr_val := 2;
        when '3'       =>   chr_val := 3;
        when '4'       =>   chr_val := 4;
        when '5'       =>   chr_val := 5;
        when '6'       =>   chr_val := 6;
        when '7'       =>   chr_val := 7;
        when '8'       =>   chr_val := 8;
        when '9'       =>   chr_val := 9;
        when 'A' | 'a' =>   chr_val := 10;
        when 'B' | 'b' =>   chr_val := 11;
        when 'C' | 'c' =>   chr_val := 12;
        when 'D' | 'd' =>   chr_val := 13;
        when 'E' | 'e' =>   chr_val := 14;
        when 'F' | 'f' =>   chr_val := 15;
        when 'G' | 'g' =>   chr_val := 16;
        when 'H' | 'h' =>   chr_val := 17;
        when 'I' | 'i' =>   chr_val := 18;
        when 'J' | 'j' =>   chr_val := 19;
        when 'K' | 'k' =>   chr_val := 20;
        when 'L' | 'l' =>   chr_val := 21;
        when 'M' | 'm' =>   chr_val := 22;
        when 'N' | 'n' =>   chr_val := 23;
        when 'O' | 'o' =>   chr_val := 24;
        when 'P' | 'p' =>   chr_val := 25;
        when 'Q' | 'q' =>   chr_val := 26;
        when 'R' | 'r' =>   chr_val := 27;
        when 'S' | 's' =>   chr_val := 28;
        when 'T' | 't' =>   chr_val := 29;
        when 'U' | 'u' =>   chr_val := 30;
        when 'V' | 'v' =>   chr_val := 31;
        when 'W' | 'w' =>   chr_val := 32;
        when 'X' | 'x' =>   chr_val := 33;
        when 'Y' | 'y' =>   chr_val := 34;
        when 'Z' | 'z' =>   chr_val := 35;                           
        when '-' =>   
          if i /= 1 then
            report "Minus sign must be at the front of the string" severity failure;
          else
            ret_int           := 0 - ret_int;
            chr_val           := 0;
            do_mult           := false;    --Minus sign - do not do any number manipulation
          end if;
                     
        when others => report "Illegal character for conversion for string to integer" severity failure;
      end case;
      
      if chr_val >= radix then report "Illagel character at this radix" severity failure; end if;
        
      if do_mult then
        ret_int               := ret_int + (chr_val * (radix**power));
      end if;
        
      power                   := power + 1;
          
    end loop;
    
    return ret_int;
    
  end function;






begin         



t1: InstructionMemory
        port map (
            i_clk       => clk_sig,
            i_read_addr => read_addr_sig,
            o_read_data => read_data_sig
            -- i_mem_init  => mem_init_sig
        );


process

file test_vector                : text open read_mode is "program.hex";
variable row                    : line;
variable v_data_read            : string(1 to 8);
variable ii                     : integer := 0;


begin
while not endfile(test_vector) loop
        	readline(test_vector,row);
    
        	read(row, v_data_read);
      		-- report integer'image(string_to_int(v_data_read, 16));
		<< signal t1.IntsructionMemory.mem(ii) : std_logic_vector(31 downto 0) >> := std_logic_vector(to_unsigned(string_to_int(v_data_read, 16), 32));
		ii := ii + 1;
		
	end loop;
wait;
end process;

	


    t2: inst_mem_tester
        port map (
            o_clk       => clk_sig,
            o_read_addr => read_addr_sig,
            i_read_data => read_data_sig
            -- o_mem_init  => mem_init_sig
        );

end inst_mem_tb_arch;
