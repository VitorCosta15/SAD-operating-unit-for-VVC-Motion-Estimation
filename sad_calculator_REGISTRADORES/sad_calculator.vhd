Library IEEE;
Use IEEE.std_logic_1164.all;
ENtity sad_calculator is --SUbtratores devem considerar bit sinal obviamente. Aqui chegam valores amostrais absolutos mas o resultado de uma subtração pode ser negativo, logo deve conter um circuito modular.
Generic (N: integer := 8); --Tamanho da bitdepth 
Port(
	clock : in std_logic;
	clear : in std_logic;
	bloco_preditor : in std_logic_vector (4*N-1 downto 0);
	area_busca : in std_logic_vector (4*N-1 downto 0);
	sad_saida : out std_logic_vector (N+3 downto 0) 
);
End sad_calculator;

--Essa arquitetura começa realizando o cálculo das diferenças absolutas pixel a pixel e dps vem somando as diferenças até obter o sad final.
Architecture arch_sad_calculator of sad_calculator is
	type matriz_4x9 is array (3 downto 0) of std_logic_vector (N downto 0);
	type matriz_2x9 is array (1 downto 0) of std_logic_vector (N downto 0);
	type matriz_4x8 is array (3 downto 0) of std_logic_vector (N-1 downto 0);
	signal saida_abss : matriz_4x8 := (others => (others => '0'));
	signal saida_subtratores : matriz_4x9 := (others => (others => '0'));
	signal saida_somadores_1 : matriz_2x9 := (others => (others => '0'));
	signal saida_somador_final : std_logic_vector (N+1 downto 0) := (others => '0');
	signal sad_saida_registrador : std_logic_vector (N+3 downto 0) := (others => '0');
	signal entrada_A1 : std_LOGIC_VECTOR (N-1 downto 0) := (others => '0');
	signal entrada_A2 : std_Logic_vector (N-1 downto 0) := (others => '0');
	signal entrada_A3 : std_logic_vector (N-1 downto 0) := (others => '0');
	signal entrada_A4 : std_logic_vector (N-1 downto 0) := (others => '0');
	signal entrada_B1 : std_Logic_vector (N-1 downto 0) := (others => '0');
	signal entrada_B2 : std_logic_vector (N-1 downto 0) := (others => '0');
	signal entrada_B3 : std_logic_vector (N-1 downto 0) := (others => '0');
	signal entrada_B4 : std_logic_vector (N-1 downto 0) := (others => '0');
	--signal entrada_A_subtrator_1, entrada_A_subtrator_2, entrada_A_subtrator_3, entrada_A_subtrator_4 : std_logic_vector (N-1 downto 0);
	--signal entrada_B_subtrator_1, entrada_B_subtrator_2, entrada_B_subtrator_3, entrada_B_subtrator_4 : std_logic_vector (N-1 downto 0);
	
	
	--saida dos subtratores/somadores já está concatenada com o bit sinal (carry out)
	Component somador_subtrator_N_bits is
	Generic (N: integer := 8);
	PORT (
		A, B : in STD_LOGIC_VECTOR(N-1 downto 0);
		--valido : in std_logic; --NECESSÁRIO APENAS NA ARQUITETURA DA SAD TREE. Excluir para as demais arquiteturas
		operacao: in std_logic; --Necessário para fazer com que esse somador seja tambem capaz de subtrair (1 - sub, 0 - add)
		S : out STD_LOGIC_VECTOR (N downto 0);
		Cout, ov : out STD_LOGIC
	);
	End Component;
	
	
	COmponent registrador_N_bits IS
	generic (N: integer := 8);
	Port(
		clock, load, clear: IN std_logic;
		entrada_dados: IN std_logic_vector (N-1 DOWNto 0);
		saida_dados: OUT std_logic_vector (N-1 DOwNto 0)
	);
	End Component;
	
	
	Component ABSS is
	GENERIC(n: integer:= 8); 
	PORT (
		inA: IN STD_LOGIC_VECTOR(n DOWNTO 0) := (others => '0');
		outA: OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0):= (others => '0')
	) ;
	End COmponent;
	
	
	
	Begin
		entrada_A1 <= bloco_preditor(31 downto 24); 
		entrada_A2 <= bloco_preditor(23 downto 16);
		entrada_A3 <= bloco_preditor(15 downto 8);
		entrada_A4 <= bloco_preditor(7 downto 0);
		entrada_B1 <= area_busca(31 downto 24);
		entrada_B2 <= area_busca(23 downto 16);
		entrada_B3 <= area_busca(15 downto 8);
		entrada_B4 <= area_busca(7 downto 0);		
		--controle: mode_analyser port map (mode_1 => bloco_preditor(31 downto 28), mode_2 => area_busca(31 downto 28), ativador_de_subtratores => palavra_controle, um_dos_modos_is_horizontal => um_dos_modos_is_horizontal);
		--horizontal_e_intermediate_case <= um_dos_modos_is_horizontal and palavra_controle(0);
	
		
		--Necessário a implementação de 32 registradores, para controlar se a entrada dos 16 subtratores será atualizada ou não.
		--Cada par de dados das saídas destes registradores vão para as entradas de um dos 16 subtratores, se load, que vem do Mode Analyzer está em 0, a entrada daquele subtrator é conservada, não fazendo o chaveamento, e o resultado do SAD é coletado de um mux a partir de 3 pontos do circuito
		--registrador_entrada_A_subtrator_1: registrador_N_bits generic map(N => N) port map (clock => clock, load => '1', clear => clear, entrada_dados => entrada_A1, saida_dados => entrada_A_subtrator_1);
		--registrador_entrada_B_subtrator_1: registrador_N_bits generic map(N => N) port map (clock => clock, load => '1', clear => clear, entrada_dados => entrada_B1, saida_dados => entrada_B_subtrator_1);
		
		--registrador_entrada_A_subtrator_2: registrador_N_bits generic map(N => N) port map (clock => clock, load => '1', clear => clear, entrada_dados => entrada_A4, saida_dados => entrada_A_subtrator_2);
		--registrador_entrada_B_subtrator_2: registrador_N_bits generic map(N => N) port map (clock => clock, load => '1', clear => clear, entrada_dados => entrada_B4, saida_dados => entrada_B_subtrator_2);
		
		--registrador_entrada_A_subtrator_3: registrador_N_bits generic map(N => N) port map (clock => clock, load => '1', clear => clear, entrada_dados => entrada_A2, saida_dados => entrada_A_subtrator_3);
		--registrador_entrada_B_subtrator_3: registrador_N_bits generic map(N => N) port map (clock => clock, load => '1', clear => clear, entrada_dados => entrada_B2, saida_dados => entrada_B_subtrator_3);
		
		--registrador_entrada_A_subtrator_4: registrador_N_bits generic map(N => N) port map (clock => clock, load => '1', clear => clear, entrada_dados => entrada_A3, saida_dados => entrada_A_subtrator_4);
		--registrador_entrada_B_subtrator_4: registrador_N_bits generic map(N => N) port map (clock => clock, load => '1', clear => clear, entrada_dados => entrada_B3, saida_dados => entrada_B_subtrator_4);
		
		
		
		--Não fiz com generate pq tem uma ordem específica das entradas, os subtratores e registradores tem que serem gerados em uma ordem específica.
		--Na entrada os valores estão truncados então eles perdem o bit menos significativo, sendo necessário colocar um zero a esquerda
		subtrator1: somador_subtrator_N_bits generic map (N => N) port map (A => entrada_A1, B => entrada_B1, operacao => '1', S => saida_subtratores(0));
		subtrator2: somador_subtrator_N_bits generic map (N => N) port map (A => entrada_A4, B => entrada_B4, operacao => '1', S => saida_subtratores(1));
		subtrator3: somador_subtrator_N_bits generic map (N => N) port map (A => entrada_A2, B => entrada_B2, operacao => '1', S => saida_subtratores(2));
		subtrator4: somador_subtrator_N_bits generic map (N => N) port map (A => entrada_A3, B => entrada_B3, operacao => '1', S => saida_subtratores(3));
					
		
		generate1: for i in 0 to 3 generate --4 circuitos de módulo
		Begin
			modulo: ABSS generic map (N => N) port map (inA => saida_subtratores(i), outA => saida_abss(i));
		End generate;
		
		generate2: for i in 0 to 1 generate --2 somadores.
		Begin
			somadores1: somador_subtrator_N_bits generic map (N => 8) port map (A => saida_abss(i*2), B => saida_abss(i*2+1), operacao => '0', S => saida_somadores_1(i));
		End generate;
		
		somador_final: somador_subtrator_N_bits generic map (N => 9) port map (A => saida_somadores_1(0), B =>saida_somadores_1(1), operacao => '0', S => saida_somador_final);
		sad_saida_registrador <= saida_somador_final & "00"; -- Saida multiplicada por 4.
		
		registrador_final: registrador_N_bits generic map (N => 12)port map (clock => clock, load => '1', clear => clear, entrada_dados => sad_saida_registrador, saida_dados => sad_saida);
		
		--mux_possiveis_saidas: mux_4_1 generic map (N => N+3) port map (A => saida_melhor_caso, B => saida_caso_medio, C => saida_somador_final, D => saida_somador_final, sel => palavra_controle(1 downto 0), S => sad_selecionado); --Define as early terminations
		--entrada_mux_final_x2 <= sad_selecionado(N+1 downto 0) & '0'; --multiplica por 2
		--entrada_mux_final_x4 <= sad_selecionado(N downto 0) & "00"; --multiplica por 4
		--mux_ponderador: mux_4_1 generic map (N => N+3) port map (A => entrada_mux_final_x4, B => entrada_mux_final_x2, C => sad_selecionado, D => sad_selecionado, sel => palavra_controle(1 downto 0), S => sad_saida);
	End arch_sad_calculator;