Library IEEE;
Use ieee.std_logic_1164.all;
Use std.textio.all;
Use work.matriz_de_sads.all;

Entity processing_unit_TB is
End processing_unit_TB;

Architecture arch_processing_unit_TB of processing_unit_TB is
	
	signal clock : std_logic;
	signal linha_memoria_CTB : std_logic_vector (2047 downto 0) := (others => '0');
	signal linha_memoria_bloco_candidato : std_logic_vector (2047 downto 0) := (others => '0');
	
	signal std_vector_CTB : std_logic_vector (2047 downto 0) := (others => '0');
	signal std_vector_candidato : std_logic_vector (2047 downto 0) := (others => '0');
	
	signal out_sad_4x8: matriz_SADs4x8;
	signal out_sad_8x4: matriz_SADs8x4;
	signal out_sad_8x8: matriz_SADs8x8;
	signal out_sad_8x16: matriz_SADs8x16;
	signal out_sad_16x8:  matriz_SADs16x8;
	signal out_sad_16x16: matriz_SADs16x16;
	signal out_sad_16x32: matriz_SADs16x32;
	signal out_sad_32x16: matriz_SADs32x16;
	signal out_sad_32x32: matriz_SADs32x32;
	signal out_sad_32x64: matriz_SADs32x64;
	signal out_sad_64x32: matriz_SADs64x32;
	signal out_sad_64x64: matriz_SADs64x64;
	signal out_sad_64x128: matriz_SADs64x128;
	signal out_sad_128x64: matriz_SADs128x64;	
	signal out_sad_128x128: std_logic_vector(21 downto 0);
	
	Component processing_unit is
	port(
		clock : in std_logic;
		linha_memoria_CTB : in std_logic_vector (2047 downto 0); --256 Bytes -> 256 amostras -> alimentar 64 sads 4x4 -> levar 18 ciclos para obter todos os SADs
		linha_memoria_bloco_candidato : in std_logic_vector (2047 downto 0);
		
		out_sad_4x8: out matriz_SADs4x8;
		out_sad_8x4: out matriz_SADs8x4;
		out_sad_8x8: out matriz_SADs8x8;
		out_sad_8x16: out matriz_SADs8x16;
		out_sad_16x8: out matriz_SADs16x8;
		out_sad_16x16: out matriz_SADs16x16;
		out_sad_16x32: out matriz_SADs16x32;
		out_sad_32x16: out matriz_SADs32x16;
		out_sad_32x32: out matriz_SADs32x32;
		out_sad_32x64: out matriz_SADs32x64;
		out_sad_64x32: out matriz_SADs64x32;
		out_sad_64x64: out matriz_SADs64x64;
		out_sad_64x128: out matriz_SADs64x128;
		out_sad_128x64: out matriz_SADs128x64;	
		out_sad_128x128: out std_logic_vector(21 downto 0)
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
	arch: processing_unit port map (clock => clock,
		linha_memoria_CTB => linha_memoria_CTB,
		linha_memoria_bloco_candidato => linha_memoria_bloco_candidato,
		out_sad_4x8 => out_sad_4x8,
		out_sad_8x4 => out_sad_8x4,
		out_sad_8x8 => out_sad_8x8,
		out_sad_8x16 => out_sad_8x16,
		out_sad_16x8 => out_sad_16x8,
		out_sad_16x16 => out_sad_16x16,
		out_sad_16x32 => out_sad_16x32,
		out_sad_32x16 => out_sad_32x16,
		out_sad_32x32 => out_sad_32x32,
		out_sad_32x64 => out_sad_32x64,
		out_sad_64x32 => out_sad_64x32,
		out_sad_64x64 => out_sad_64x64,
		out_sad_64x128 => out_sad_64x128,
		out_sad_128x64 => out_sad_128x64,
		out_sad_128x128 => out_sad_128x128	
	);
	
	
	ciclo : process --Cria um clock de 390MHz
		begin
			clock <= '1', '0' after 1.282 ns;
			wait for 2.564 ns; --390MHZ frequência alvo
		End process;
		
		
	testbench: process(clock)
		variable str_type : string(2048 downto 1);
		variable lineType : line;
		
		file bloco_CTB : text open read_mode is "../entradasReais/TCC/arquivo_CTB_BasketballDrive.txt";
		file bloco_candidato : text open read_mode is "../entradasReais/TCC/arquivo_bloco_candidato_BasketballDrive.txt";
		
		--file bloco_CTB : text open read_mode is "arquivo_CTB_ParkRunning3.txt";
		--file bloco_candidato : text open read_mode is "arquivo_bloco_candidato_ParkRunning3.txt";
		
		Begin
			if (clock'event and clock = '1') then
				if not endfile(bloco_CTB) then 
					readline(bloco_CTB, lineType);
					read(lineType, str_type);
					std_vector_CTB <= str_to_stdvec(str_type);					
					linha_memoria_CTB <= std_vector_CTB(2047 downto 0);					
				Else
					assert false report "end of simulation" severity failure;
				End if;
			
				if not endfile(bloco_candidato) then 
					readline(bloco_candidato, lineType);
					read(lineType, str_type);
					std_vector_candidato <= str_to_stdvec(str_type);					
					linha_memoria_bloco_candidato <= std_vector_candidato(2047 downto 0);					
				Else
					assert false report "end of simulation" severity failure;
				End if;
			
			End if;
	End process;
			
	
	
End arch_processing_unit_TB;