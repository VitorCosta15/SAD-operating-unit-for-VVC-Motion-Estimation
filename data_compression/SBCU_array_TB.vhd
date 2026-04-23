Library IEEE;
Use IEEE.std_logic_1164.all;
Use std.textio.all;

Entity SBCU_array_TB is
End SBCU_array_TB;

Architecture arch_SBCU_array_TB of SBCU_array_TB is
	signal clock : std_logic;
	signal input_line : std_logic_vector (2559 downto 0) := (others => '0');
	signal output_word : std_logic_vector (639 downto 0) ;	
	signal std_input_line : std_logic_vector (2559 downto 0) := (others => '0');	
	
	
	Component SBCU_array is
		Generic (N : integer := 32); --Numero de bits em 4 amostras
		Port(
			clock : in std_logic;
			input_line : in std_logic_vector ((4*N*20)-1 downto 0);
			output_word : out std_logic_vector ((20 * N)-1 downto 0) 
			--linha de entrada do meu testbench terá que ter 2560 bits.
		);
	end Component;
	
	
	function str_to_stdvec(inp: string) return std_logic_vector is
		variable temp: std_logic_vector(inp'range);
	begin
		for i in inp'range loop
			if (inp(i) = '1') then
					temp(i):= '1';
			elsif(inp(i)='0') then
		      temp(i):= '0';
			end if;
		end loop;
		return temp; 
	end function str_to_stdvec;


	function stdvec_to_str(inp: std_logic_vector) return string is
		variable temp: string(inp'left+1 downto 1);
	begin
		for i in inp'reverse_range loop
			if (inp(i) = '1') then
				temp(i+1) := '1';
			elsif (inp(i) = '0') then
				temp(i+1) := '0';
			end if;
		end loop;
		return temp;
	end function stdvec_to_str;
	
	
Begin
	arch: SBCU_array generic map (N => 32) port map (
		clock => clock,
		input_line => input_line,
		output_word => output_word
	);
	
	
	ciclo: process 
		begin 
			clock <= '1', '0' after 1.282 ns;
			wait for 2.564 ns; --360MHZ frequência alvo
		End process;
		
		
	testbench: process(clock)
		variable str_type : string(2560 downto 1);
		variable lineType : line;
		
		file file_input_line : text open read_mode is "../entradasReais/TCC/arquivo_input_SBCU_BasketballDrive.txt"; 
		--file file_input_line : text open read_mode is "arquivo_input_SBCU_ParkRunning3.txt"; 
		
		Begin
			if (clock'event and clock = '1') then
				if not endfile(file_input_line) then 
					readline(file_input_line, lineType);
					read(lineType, str_type);
					std_input_line <= str_to_stdvec(str_type);					
					input_line <= std_input_line(2559 downto 0);					
				Else
					assert false report "end of simulation" severity failure;
				End if;
			End if;
		end process;
	
	
End arch_SBCU_array_TB;