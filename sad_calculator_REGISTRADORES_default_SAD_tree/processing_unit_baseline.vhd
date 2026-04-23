Library IEEE;
Use IEEE.std_logic_1164.all;
Use work.matriz_de_sads.all;

Entity processing_unit_baseline is
port(
	clock : in std_logic;
	linha_memoria_CTB : in std_logic_vector (8191 downto 0); --256 Bytes -> 256 amostras -> alimentar 64 sads 4x4 -> levar 17 ciclos para obter todos os SADs
	linha_memoria_bloco_candidato : in std_logic_vector (8191 downto 0);
	
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
End processing_unit_baseline;

Architecture arch_processing_unit_baseline of processing_unit_baseline is
	
	
	Component unidade_de_controle is
		port(
			clock : in std_logic;
			valido_registradores_menores_que_32x32 : out std_logic_vector (15 downto 0);
			valido_registradores_maiores_que_32x32 : out std_logic;
			load_registradores_menores_que_32x32 : out std_logic_vector (15 downto 0);
			load_registradores_maiores_que_32x32 : out std_logic
		);
	End Component;
	
	Component tabela_SAD is
		Generic (N :integer := 8; numero_de_SAD_trees : integer := 64);
		port(
			clock, clear: in std_logic;
			valido_registradores_menores_que_32x32: in std_logic_vector (15 downto 0);
			valido_registradores_maiores_que_32x32: in std_logic;
			load_registradores_menores_que_32x32: in std_logic_vector (15 downto 0); --São 16 grupos de registradores em todas as camadas.
			load_registradores_maiores_que_32x32: in std_logic;
		
			SADs_4x4: in std_logic_vector (((N+4) * numero_de_SAD_trees)-1 downto 0); -- 768 bits, do 767 até o 0.		
		
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
	
	
	Component sads4x4_paralelizadas is
		port(
			clock : in std_logic;
			linha_memoria_CTB : in std_logic_vector (8191 downto 0); 
			linha_memoria_bloco_candidato : in std_logic_vector (8191 downto 0);
			Sads4x4 : out std_logic_vector (767 downto 0) 
		);
	End Component;
	
	signal aux_SADs4x4 : std_logic_vector (767 downto 0) := (others => '0'); --Saída das 64 RSTCs.
	signal controle_valido_registradores_menores_que_32x32 : std_logic_vector (15 downto 0) := (others => '0');
	signal controle_valido_registradores_maiores_que_32x32 : std_logic := '0';
	signal controle_load_registradores_menores_que_32x32 : std_logic_vector (15 downto 0) := (others => '0');
	signal controle_load_registradores_maiores_que_32x32 : std_logic := '0';
	
	Begin
	
	controle: unidade_de_controle port map (clock => clock,
		valido_registradores_maiores_que_32x32 => controle_valido_registradores_maiores_que_32x32, 
		valido_registradores_menores_que_32x32 => controle_valido_registradores_menores_que_32x32,
		load_registradores_maiores_que_32x32 => controle_load_registradores_maiores_que_32x32,
		load_registradores_menores_que_32x32 => controle_load_registradores_menores_que_32x32);
		
		
	arvore_de_SADs_4x4: sads4x4_paralelizadas port map (clock => clock, 
		linha_memoria_CTB => linha_memoria_CTB, 
		linha_memoria_bloco_candidato => linha_memoria_bloco_candidato, 
		Sads4x4 => aux_SADs4x4);
		
		
	tabela_dos_SADs: tabela_SAD port map (clock => clock,
		clear => '0',
		valido_registradores_maiores_que_32x32 => controle_valido_registradores_maiores_que_32x32,
		valido_registradores_menores_que_32x32 => controle_valido_registradores_menores_que_32x32,
		load_registradores_maiores_que_32x32 => controle_load_registradores_maiores_que_32x32,
		load_registradores_menores_que_32x32 => controle_load_registradores_menores_que_32x32,
		SADs_4x4 => aux_SADs4x4,
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
	
	
End arch_processing_unit_baseline;