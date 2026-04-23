Library IEEE;
Use IEEE.std_logic_1164.all;
Use work.matriz_de_sads.all;

Entity sads4x4_paralelizadas is
	port(
		clock : in std_logic;
		linha_memoria_CTB : in std_logic_vector (2047 downto 0); -- Leio 256 Bytes por ciclo, 256 amostras, 2048 bits, alimentando 64 SAD trees, cada SAD tree receberá 32 bits.
		linha_memoria_bloco_candidato : in std_logic_vector (2047 downto 0);
		Sads4x4 : out std_logic_vector (767 downto 0) --Eu calculo 64 sads de blocos 4x4, cada SAD de bloco 4x4 tem 12 bits, logo 12 * 64 = 768
	);
End sads4x4_paralelizadas;

Architecture arch_sads4x4_paralelizadas of sads4x4_paralelizadas is

	Component sad_calculator is 
	Generic (N: integer := 8); --Tamanho da bitdepth 
	Port(
		clock : in std_logic;
		clear : in std_logic;
		bloco_preditor : in std_logic_vector (4*N-1 downto 0);
		area_busca : in std_logic_vector (4*N-1 downto 0);
		sad_saida : out std_logic_vector (N+3 downto 0) 
	);
	End Component;
	
	signal matriz_de_sads : array_SADs_4x4 := (others => (others => '0')); --Instancia um array de std_logic de índices (63 downto 0) of std_logic_vector (11 downto 0);
	
Begin

	generate_4x4_SAD_trees: for i in 0 to 63 generate
		RSTC: sad_calculator generic map (N => 8) port map (clock => clock, clear => '0', bloco_preditor => linha_memoria_CTB((32*i)+31 downto 32*i), area_busca => linha_memoria_bloco_candidato((32*i)+31 downto 32*i), sad_saida => matriz_de_sads(i));
	End generate;
	
	Sads4x4 <= matriz_de_sads(63) & 
				matriz_de_sads(62) &
				matriz_de_sads(61) &
				matriz_de_sads(60) &
				matriz_de_sads(59) &
				matriz_de_sads(58) &
				matriz_de_sads(57) &
				matriz_de_sads(56) &
				matriz_de_sads(55) &
				matriz_de_sads(54) &
				matriz_de_sads(53) &
				matriz_de_sads(52) &
				matriz_de_sads(51) & 
				matriz_de_sads(50) &
				matriz_de_sads(49) &
				matriz_de_sads(48) &
				matriz_de_sads(47) &
				matriz_de_sads(46) &
				matriz_de_sads(45) &
				matriz_de_sads(44) &
				matriz_de_sads(43) &
				matriz_de_sads(42) &
				matriz_de_sads(41) &
				matriz_de_sads(40) &
				matriz_de_sads(39) & 
				matriz_de_sads(38) &
				matriz_de_sads(37) &
				matriz_de_sads(36) &
				matriz_de_sads(35) &
				matriz_de_sads(34) &
				matriz_de_sads(33) &
				matriz_de_sads(32) &
				matriz_de_sads(31) &
				matriz_de_sads(30) &
				matriz_de_sads(29) &
				matriz_de_sads(28) &
				matriz_de_sads(27) & 
				matriz_de_sads(26) &
				matriz_de_sads(25) &
				matriz_de_sads(24) &
				matriz_de_sads(23) &
				matriz_de_sads(22) &
				matriz_de_sads(21) &
				matriz_de_sads(20) &
				matriz_de_sads(19) &
				matriz_de_sads(18) &
				matriz_de_sads(17) &
				matriz_de_sads(16) &
				matriz_de_sads(15) & 
				matriz_de_sads(14) &
				matriz_de_sads(13) &
				matriz_de_sads(12) &
				matriz_de_sads(11) &
				matriz_de_sads(10) &
				matriz_de_sads(9) &
				matriz_de_sads(8) &
				matriz_de_sads(7) &
				matriz_de_sads(6) &
				matriz_de_sads(5) &
				matriz_de_sads(4) &
				matriz_de_sads(3) &
				matriz_de_sads(2) &
				matriz_de_sads(1) &
				matriz_de_sads(0);
	
End arch_sads4x4_paralelizadas;