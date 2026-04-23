Library IEEE;
Use ieee.std_logic_1164.all;
Use std.textio.all;
Use work.matriz_de_sads.all;

Entity sads4x4_paralelizadas_baseline_TB is
End sads4x4_paralelizadas_baseline_TB;

Architecture arch_sads4x4_paralelizadas_baseline_TB of sads4x4_paralelizadas_baseline_TB is
	
	signal clock : std_logic;
	signal linha_memoria_CTB : std_logic_vector (8191 downto 0) := (others => '0');
	signal linha_memoria_bloco_candidato : std_logic_vector (8191 downto 0) := (others => '0');
	
	signal std_vector_CTB : std_logic_vector (8191 downto 0) := (others => '0');
	signal std_vector_candidato : std_logic_vector (8191 downto 0) := (others => '0');
	signal sads4x4 : std_logic_vector (767 downto 0) := (others => '0');
	
	Component sads4x4_paralelizadas is
	port(
		clock : in std_logic;
		linha_memoria_CTB : in std_logic_vector (8191 downto 0); -- Leio 256 Bytes por ciclo, 256 amostras, 2048 bits, alimentando 64 SAD trees, cada SAD tree receberá 32 bits.
		linha_memoria_bloco_candidato : in std_logic_vector (8191 downto 0);
		Sads4x4 : out std_logic_vector (767 downto 0) --Eu calculo 64 sads de blocos 4x4, cada SAD de bloco 4x4 tem 12 bits, logo 12 * 64 = 768
	);
	End Component;	
	
	
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
	arch: sads4x4_paralelizadas port map (clock => clock,
		linha_memoria_CTB => linha_memoria_CTB,
		linha_memoria_bloco_candidato => linha_memoria_bloco_candidato,
		sads4x4 => sads4x4	
	);
	
	
	ciclo : process --Cria um clock de 390MHz
		begin
			clock <= '1', '0' after 1.282 ns;
			wait for 2.564 ns; --390MHZ frequência alvo
		End process;
		
		
	testbench: process(clock)
		variable str_type : string(8192 downto 1);
		variable lineType : line;
		
		file bloco_CTB : text open read_mode is "../entradasReais/TCC/arquivo_CTB_baseline_ParkRunning3.txt";
		file bloco_candidato : text open read_mode is "../entradasReais/TCC/arquivo_bloco_candidato_baseline_ParkRunning3.txt";
		
		--file bloco_CTB : text open read_mode is "arquivo_CTB_ParkRunning3.txt";
		--file bloco_candidato : text open read_mode is "arquivo_bloco_candidato_ParkRunning3.txt";
		
		Begin
			if (clock'event and clock = '1') then
				if not endfile(bloco_CTB) then 
					readline(bloco_CTB, lineType);
					read(lineType, str_type);
					std_vector_CTB <= str_to_stdvec(str_type);					
					linha_memoria_CTB <= std_vector_CTB(8191 downto 0);					
				Else
					assert false report "end of simulation" severity failure;
				End if;
			
				if not endfile(bloco_candidato) then 
					readline(bloco_candidato, lineType);
					read(lineType, str_type);
					std_vector_candidato <= str_to_stdvec(str_type);					
					linha_memoria_bloco_candidato <= std_vector_candidato(8191 downto 0);					
				Else
					assert false report "end of simulation" severity failure;
				End if;
			
			End if;
	End process;
			
	
	
End arch_sads4x4_paralelizadas_baseline_TB;