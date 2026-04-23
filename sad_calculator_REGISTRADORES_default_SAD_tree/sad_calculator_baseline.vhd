Library IEEE;
Use IEEE.std_logic_1164.all;

ENtity sad_calculator_baseline is --SUbtratores devem considerar bit sinal obviamente. Aqui chegam valores amostrais absolutos mas o resultado de uma subtração pode ser negativo, logo deve conter um circuito modular.
Generic (N: integer := 9); --Tamanho da bitdepth 
Port(
	clock : in std_logic;
	clear : in std_logic;
	bloco_preditor_linha_1, bloco_preditor_linha_2, bloco_preditor_linha_3, bloco_preditor_linha_4 : in std_logic_vector (31 downto 0);
	area_busca_linha_1, area_busca_linha_2, area_busca_linha_3, area_busca_linha_4 : in std_logic_vector (31 downto 0);
	sad_saida : out std_logic_vector (N+2 downto 0)
);
End sad_calculator_baseline;

--Essa arquitetura começa realizando o cálculo das diferenças absolutas pixel a pixel e dps vem somando as diferenças até obter o sad final.
Architecture arch_sad_calculator_baseline of sad_calculator_baseline is
	type matriz_16x8 is array (15 downto 0) of std_LOGIC_VECTOR (N-1 downto 0);
	type matriz_16x7 is array (15 downto 0) of std_logic_vector (N-2 downto 0);
	type matriz_8x8 is array (7 downto 0) of std_Logic_vector (N-1 downto 0);
	type matriz_4x9 is array (3 downto 0) of std_Logic_vector (N downto 0);
	type matriz_2x10 is array (1 downto 0) of std_Logic_vector (N+1 downto 0);
	signal saida_subtratores : matriz_16x8;
	signal saida_somadores_1 : matriz_8x8;
	signal saida_somadores_2 : matriz_4x9;
	signal saida_somadores_3 : matriz_2x10;
	signal saida_abss : matriz_16x7;
	signal entrada_mux_final_x2, entrada_mux_final_x4 : std_logic_vector(N+2 downto 0);
	signal sad_saida_registrador : std_logic_vector (N+2 downto 0);
	signal saida_somador_final : std_Logic_vector (N+2 downto 0);
	signal palavra_controle : std_logic_vector (6 downto 0);
	signal entrada_A1_linha_1 : std_LOGIC_VECTOR (N-2 downto 0);
	signal entrada_A2_linha_1 : std_Logic_vector (N-2 downto 0);
	signal entrada_A3_linha_1 : std_logic_vector (N-2 downto 0);
	signal entrada_A4_linha_1 : std_logic_vector (N-2 downto 0);
	signal entrada_B1_linha_1 : std_Logic_vector (N-2 downto 0);
	signal entrada_B2_linha_1 : std_logic_vector (N-2 downto 0);
	signal entrada_B3_linha_1 : std_logic_vector (N-2 downto 0);
	signal entrada_B4_linha_1 : std_logic_vector (N-2 downto 0);
	signal entrada_A1_linha_2 : std_LOGIC_VECTOR (N-2 downto 0);
	signal entrada_A2_linha_2 : std_Logic_vector (N-2 downto 0);
	signal entrada_A3_linha_2 : std_logic_vector (N-2 downto 0);
	signal entrada_A4_linha_2 : std_logic_vector (N-2 downto 0);
	signal entrada_B1_linha_2 : std_Logic_vector (N-2 downto 0);
	signal entrada_B2_linha_2 : std_logic_vector (N-2 downto 0);
	signal entrada_B3_linha_2 : std_logic_vector (N-2 downto 0);
	signal entrada_B4_linha_2 : std_logic_vector (N-2 downto 0);
	signal entrada_A1_linha_3 : std_LOGIC_VECTOR (N-2 downto 0);
	signal entrada_A2_linha_3 : std_Logic_vector (N-2 downto 0);
	signal entrada_A3_linha_3 : std_logic_vector (N-2 downto 0);
	signal entrada_A4_linha_3 : std_logic_vector (N-2 downto 0);
	signal entrada_B1_linha_3 : std_Logic_vector (N-2 downto 0);
	signal entrada_B2_linha_3 : std_logic_vector (N-2 downto 0);
	signal entrada_B3_linha_3 : std_logic_vector (N-2 downto 0);
	signal entrada_B4_linha_3 : std_logic_vector (N-2 downto 0);
	signal entrada_A1_linha_4 : std_LOGIC_VECTOR (N-2 downto 0);
	signal entrada_A2_linha_4 : std_Logic_vector (N-2 downto 0);
	signal entrada_A3_linha_4 : std_logic_vector (N-2 downto 0);
	signal entrada_A4_linha_4 : std_logic_vector (N-2 downto 0);
	signal entrada_B1_linha_4 : std_Logic_vector (N-2 downto 0);
	signal entrada_B2_linha_4 : std_logic_vector (N-2 downto 0);
	signal entrada_B3_linha_4 : std_logic_vector (N-2 downto 0);
	signal entrada_B4_linha_4 : std_logic_vector (N-2 downto 0);
	--signal entrada_A_subtrator_1, entrada_A_subtrator_2, entrada_A_subtrator_3, entrada_A_subtrator_4, entrada_A_subtrator_5, entrada_A_subtrator_6, entrada_A_subtrator_7, entrada_A_subtrator_8, entrada_A_subtrator_9, entrada_A_subtrator_10, entrada_A_subtrator_11, entrada_A_subtrator_12, entrada_A_subtrator_13, entrada_A_subtrator_14, entrada_A_subtrator_15, entrada_A_subtrator_16 : std_logic_vector (N-2 downto 0);
	--signal entrada_B_subtrator_1, entrada_B_subtrator_2, entrada_B_subtrator_3, entrada_B_subtrator_4, entrada_B_subtrator_5, entrada_B_subtrator_6, entrada_B_subtrator_7, entrada_B_subtrator_8, entrada_B_subtrator_9, entrada_B_subtrator_10, entrada_B_subtrator_11, entrada_B_subtrator_12, entrada_B_subtrator_13, entrada_B_subtrator_14, entrada_B_subtrator_15, entrada_B_subtrator_16 : std_logic_vector (N-2 downto 0);
	signal saida_melhor_caso : std_Logic_vector (N+2 downto 0);
	signal saida_caso_medio : std_Logic_vector (N+2 downto 0);
	signal sad_selecionado : std_Logic_vector (N+2 downto 0);
	--signal saida_sub1, saida_sub2, saida_sub3, saida_sub4, saida_sub5, saida_sub6, saida_sub7, saida_sub8, saida_sub9, saida_sub10, saida_sub11, saida_sub12, saida_sub13, saida_sub14, saida_sub15, saida_sub16 : std_logic_vector (N downto 0);
	
	
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
	
	--Component mux_4_1 is
	--Generic (N : integer := 8);
	--Port(
		--A, B, C, D : in std_logic_vector (N-1 downto 0);
		--sel : in std_logic_vector (1 downto 0);
		--S : out std_logic_vector (N-1 downto 0)
	--);
	--End Component;
	
	Component ABSS is
	GENERIC(n: integer:= 8); 
	PORT (
		inA: IN STD_LOGIC_VECTOR(n DOWNTO 0) := (others => '0');
		outA: OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0):= (others => '0')
	) ;
	End COmponent;
	
	
	--Component mode_analyser is
	--Port (
		--mode_1 : in std_logic_vector (3 downto 0);
		--mode_2 : in std_logic_vector (3 downto 0);
		--ativador_de_subtratores : out std_logic_vector (6 downto 0) --São 31 somadores/subtratores no total. Gerarei o controle linearmente, primeiro os controles dos subtratores até o ultimo somador
	--);
	--End component;
	
	Component registrador_N_bits IS
	generic (N: integer := 8);
	Port(
		clock, load, clear: IN std_logic;
		entrada_dados: IN std_logic_vector (N-1 DOWNto 0);
		saida_dados: OUT std_logic_vector (N-1 DOwNto 0)
	);
	End Component;
	
	
	Begin
		entrada_A1_linha_1 <= bloco_preditor_linha_1(31 downto 24); --O BCU é o responsável por comprimir, logo as entradas do CSTC não devem ser truncadas.
		entrada_A2_linha_1 <= bloco_preditor_linha_1(23 downto 16);
		entrada_A3_linha_1 <= bloco_preditor_linha_1(15 downto 8);
		entrada_A4_linha_1 <= bloco_preditor_linha_1(7 downto 0);
		entrada_B1_linha_1 <= area_busca_linha_1(31 downto 24);
		entrada_B2_linha_1 <= area_busca_linha_1(23 downto 16);
		entrada_B3_linha_1 <= area_busca_linha_1(15 downto 8);
		entrada_B4_linha_1 <= area_busca_linha_1(7 downto 0);
		entrada_A1_linha_2 <= bloco_preditor_linha_2(31 downto 24); --O BCU é o responsável por comprimir, logo as entradas do CSTC não devem ser truncadas.
		entrada_A2_linha_2 <= bloco_preditor_linha_2(23 downto 16);
		entrada_A3_linha_2 <= bloco_preditor_linha_2(15 downto 8);
		entrada_A4_linha_2 <= bloco_preditor_linha_2(7 downto 0);
		entrada_B1_linha_2 <= area_busca_linha_2(31 downto 24);
		entrada_B2_linha_2 <= area_busca_linha_2(23 downto 16);
		entrada_B3_linha_2 <= area_busca_linha_2(15 downto 8);
		entrada_B4_linha_2 <= area_busca_linha_2(7 downto 0);
		entrada_A1_linha_3 <= bloco_preditor_linha_3(31 downto 24); --O BCU é o responsável por comprimir, logo as entradas do CSTC não devem ser truncadas.
		entrada_A2_linha_3 <= bloco_preditor_linha_3(23 downto 16);
		entrada_A3_linha_3 <= bloco_preditor_linha_3(15 downto 8);
		entrada_A4_linha_3 <= bloco_preditor_linha_3(7 downto 0);
		entrada_B1_linha_3 <= area_busca_linha_3(31 downto 24);
		entrada_B2_linha_3 <= area_busca_linha_3(23 downto 16);
		entrada_B3_linha_3 <= area_busca_linha_3(15 downto 8);
		entrada_B4_linha_3 <= area_busca_linha_3(7 downto 0);
		entrada_A1_linha_4 <= bloco_preditor_linha_4(31 downto 24); --O BCU é o responsável por comprimir, logo as entradas do CSTC não devem ser truncadas.
		entrada_A2_linha_4 <= bloco_preditor_linha_4(23 downto 16);
		entrada_A3_linha_4 <= bloco_preditor_linha_4(15 downto 8);
		entrada_A4_linha_4 <= bloco_preditor_linha_4(7 downto 0);
		entrada_B1_linha_4 <= area_busca_linha_4(31 downto 24);
		entrada_B2_linha_4 <= area_busca_linha_4(23 downto 16);
		entrada_B3_linha_4 <= area_busca_linha_4(15 downto 8);
		entrada_B4_linha_4 <= area_busca_linha_4(7 downto 0);
		--controle: mode_analyser port map (mode_1 => bloco_preditor(31 downto 28), mode_2 => area_busca(31 downto 28), ativador_de_subtratores => palavra_controle);
		
		--Necessário a implementação de 32 registradores, para controlar se a entrada dos 16 subtratores será atualizada ou não.
		--Cada par de dados das saídas destes registradores vão para as entradas de um dos 16 subtratores, se load, que vem do Mode Analyzer está em 0, a entrada daquele subtrator é conservada, não fazendo o chaveamento, e o resultado do SAD é coletado de um mux a partir de 3 pontos do circuito
		--registrador_entrada_A_subtrator_1: registrador_N_bits generic map(N => N-1) port map (clock => clock, load => '1', clear => clear, entrada_dados => entrada_A1_linha_1, saida_dados => entrada_A_subtrator_1);
		--registrador_entrada_B_subtrator_1: registrador_N_bits generic map(N => N-1) port map (clock => clock, load => '1', clear => clear, entrada_dados => entrada_B1_linha_1, saida_dados => entrada_B_subtrator_1);
		
		--registrador_entrada_A_subtrator_2: registrador_N_bits generic map(N => N-1) port map (clock => clock, load => '1', clear => clear, entrada_dados => entrada_A2_linha_1, saida_dados => entrada_A_subtrator_2);
		--registrador_entrada_B_subtrator_2: registrador_N_bits generic map(N => N-1) port map (clock => clock, load => '1', clear => clear, entrada_dados => entrada_B2_linha_1, saida_dados => entrada_B_subtrator_2);
		
		--registrador_entrada_A_subtrator_3: registrador_N_bits generic map(N => N-1) port map (clock => clock, load => '1', clear => clear, entrada_dados => entrada_A3_linha_1, saida_dados => entrada_A_subtrator_3);
		--registrador_entrada_B_subtrator_3: registrador_N_bits generic map(N => N-1) port map (clock => clock, load => '1', clear => clear, entrada_dados => entrada_B3_linha_1, saida_dados => entrada_B_subtrator_3);
		
		--registrador_entrada_A_subtrator_4: registrador_N_bits generic map(N => N-1) port map (clock => clock, load => '1', clear => clear, entrada_dados => entrada_A4_linha_1, saida_dados => entrada_A_subtrator_4);
		--registrador_entrada_B_subtrator_4: registrador_N_bits generic map(N => N-1) port map (clock => clock, load => '1', clear => clear, entrada_dados => entrada_B4_linha_1, saida_dados => entrada_B_subtrator_4);
		
		--registrador_entrada_A_subtrator_5: registrador_N_bits generic map(N => N-1) port map (clock => clock, load => '1', clear => clear, entrada_dados => entrada_A1_linha_2, saida_dados => entrada_A_subtrator_5);
		--registrador_entrada_B_subtrator_5: registrador_N_bits generic map(N => N-1) port map (clock => clock, load => '1', clear => clear, entrada_dados => entrada_B1_linha_2, saida_dados => entrada_B_subtrator_5);
		
		--registrador_entrada_A_subtrator_6: registrador_N_bits generic map(N => N-1) port map (clock => clock, load => '1', clear => clear, entrada_dados => entrada_A2_linha_2, saida_dados => entrada_A_subtrator_6);
		--registrador_entrada_B_subtrator_6: registrador_N_bits generic map(N => N-1) port map (clock => clock, load => '1', clear => clear, entrada_dados => entrada_B2_linha_2, saida_dados => entrada_B_subtrator_6);
		
		--registrador_entrada_A_subtrator_7: registrador_N_bits generic map(N => N-1) port map (clock => clock, load => '1', clear => clear, entrada_dados => entrada_A3_linha_2, saida_dados => entrada_A_subtrator_7);
		--registrador_entrada_B_subtrator_7: registrador_N_bits generic map(N => N-1) port map (clock => clock, load => '1', clear => clear, entrada_dados => entrada_B3_linha_2, saida_dados => entrada_B_subtrator_7);
		
		--registrador_entrada_A_subtrator_8: registrador_N_bits generic map(N => N-1) port map (clock => clock, load => '1', clear => clear, entrada_dados => entrada_A4_linha_2, saida_dados => entrada_A_subtrator_8);
		--registrador_entrada_B_subtrator_8: registrador_N_bits generic map(N => N-1) port map (clock => clock, load => '1', clear => clear, entrada_dados => entrada_B4_linha_2, saida_dados => entrada_B_subtrator_8);	
		
		--registrador_entrada_A_subtrator_9: registrador_N_bits generic map(N => N-1) port map (clock => clock, load => '1', clear => clear, entrada_dados => entrada_A1_linha_3, saida_dados => entrada_A_subtrator_9);
		--registrador_entrada_B_subtrator_9: registrador_N_bits generic map(N => N-1) port map (clock => clock, load => '1', clear => clear, entrada_dados => entrada_B1_linha_3, saida_dados => entrada_B_subtrator_9);
		
		--registrador_entrada_A_subtrator_10: registrador_N_bits generic map(N => N-1) port map (clock => clock, load => '1', clear => clear, entrada_dados => entrada_A2_linha_3, saida_dados => entrada_A_subtrator_10);
		--registrador_entrada_B_subtrator_10: registrador_N_bits generic map(N => N-1) port map (clock => clock, load => '1', clear => clear, entrada_dados => entrada_B2_linha_3, saida_dados => entrada_B_subtrator_10);
		
		--registrador_entrada_A_subtrator_11: registrador_N_bits generic map(N => N-1) port map (clock => clock, load => '1', clear => clear, entrada_dados => entrada_A3_linha_3, saida_dados => entrada_A_subtrator_11);
		--registrador_entrada_B_subtrator_11: registrador_N_bits generic map(N => N-1) port map (clock => clock, load => '1', clear => clear, entrada_dados => entrada_B3_linha_3, saida_dados => entrada_B_subtrator_11);
		
		--registrador_entrada_A_subtrator_12: registrador_N_bits generic map(N => N-1) port map (clock => clock, load => '1', clear => clear, entrada_dados => entrada_A4_linha_3, saida_dados => entrada_A_subtrator_12);
		--registrador_entrada_B_subtrator_12: registrador_N_bits generic map(N => N-1) port map (clock => clock, load => '1', clear => clear, entrada_dados => entrada_B4_linha_3, saida_dados => entrada_B_subtrator_12);
		
		--registrador_entrada_A_subtrator_13: registrador_N_bits generic map(N => N-1) port map (clock => clock, load => '1', clear => clear, entrada_dados => entrada_A1_linha_4, saida_dados => entrada_A_subtrator_13);
		--registrador_entrada_B_subtrator_13: registrador_N_bits generic map(N => N-1) port map (clock => clock, load => '1', clear => clear, entrada_dados => entrada_B1_linha_4, saida_dados => entrada_B_subtrator_13);
		
		--registrador_entrada_A_subtrator_14: registrador_N_bits generic map(N => N-1) port map (clock => clock, load => '1', clear => clear, entrada_dados => entrada_A2_linha_4, saida_dados => entrada_A_subtrator_14);
		--registrador_entrada_B_subtrator_14: registrador_N_bits generic map(N => N-1) port map (clock => clock, load => '1', clear => clear, entrada_dados => entrada_B2_linha_4, saida_dados => entrada_B_subtrator_14);
		
		--registrador_entrada_A_subtrator_15: registrador_N_bits generic map(N => N-1) port map (clock => clock, load => '1', clear => clear, entrada_dados => entrada_A3_linha_4, saida_dados => entrada_A_subtrator_15);
		--registrador_entrada_B_subtrator_15: registrador_N_bits generic map(N => N-1) port map (clock => clock, load => '1', clear => clear, entrada_dados => entrada_B3_linha_4, saida_dados => entrada_B_subtrator_15);
		
		--registrador_entrada_A_subtrator_16: registrador_N_bits generic map(N => N-1) port map (clock => clock, load => '1', clear => clear, entrada_dados => entrada_A4_linha_4, saida_dados => entrada_A_subtrator_16);
		--registrador_entrada_B_subtrator_16: registrador_N_bits generic map(N => N-1) port map (clock => clock, load => '1', clear => clear, entrada_dados => entrada_B4_linha_4, saida_dados => entrada_B_subtrator_16);
		
		
		--Não fiz com generate pq tem uma ordem específica das entradas, os subtratores e registradores tem que serem gerados em uma ordem específica.
		--Na entrada os valores estão truncados então eles perdem o bit menos significativo, sendo necessário colocar um zero a esquerda
		subtrator1: somador_subtrator_N_bits generic map (N => N-1) port map (A => entrada_A1_linha_1, B => entrada_B1_linha_1, operacao => '1', S => saida_subtratores(0));
		subtrator2: somador_subtrator_N_bits generic map (N => N-1) port map (A => entrada_A2_linha_1, B => entrada_B2_linha_1, operacao => '1', S => saida_subtratores(1));
		subtrator3: somador_subtrator_N_bits generic map (N => N-1) port map (A => entrada_A3_linha_1, B => entrada_B3_linha_1, operacao => '1', S => saida_subtratores(2));
		subtrator4: somador_subtrator_N_bits generic map (N => N-1) port map (A => entrada_A4_linha_1, B => entrada_B4_linha_1, operacao => '1', S => saida_subtratores(3));
		subtrator5: somador_subtrator_N_bits generic map (N => N-1) port map (A => entrada_A1_linha_2, B => entrada_B1_linha_2, operacao => '1', S => saida_subtratores(4));
		subtrator6: somador_subtrator_N_bits generic map (N => N-1) port map (A => entrada_A2_linha_2, B => entrada_B2_linha_2, operacao => '1', S => saida_subtratores(5));
		subtrator7: somador_subtrator_N_bits generic map (N => N-1) port map (A => entrada_A3_linha_2, B => entrada_B3_linha_2, operacao => '1', S => saida_subtratores(6));
		subtrator8: somador_subtrator_N_bits generic map (N => N-1) port map (A => entrada_A4_linha_2, B => entrada_B4_linha_2, operacao => '1', S => saida_subtratores(7));			
					
		--Estes subtratores abaixo só serão utilizados caso precise de todos os subtratores
		subtrator9: somador_subtrator_N_bits generic map (N => N-1) port map (A => entrada_A1_linha_3, B => entrada_B1_linha_3, operacao => '1', S => saida_subtratores(8));
		subtrator10: somador_subtrator_N_bits generic map (N => N-1) port map (A => entrada_A2_linha_3, B => entrada_B2_linha_3, operacao => '1', S => saida_subtratores(9));
		subtrator11: somador_subtrator_N_bits generic map (N => N-1) port map (A => entrada_A3_linha_3, B => entrada_B3_linha_3, operacao => '1', S => saida_subtratores(10));
		subtrator12: somador_subtrator_N_bits generic map (N => N-1) port map (A => entrada_A4_linha_3, B => entrada_B4_linha_3, operacao => '1', S => saida_subtratores(11));
		subtrator13: somador_subtrator_N_bits generic map (N => N-1) port map (A => entrada_A1_linha_4, B => entrada_B1_linha_4, operacao => '1', S => saida_subtratores(12));
		subtrator14: somador_subtrator_N_bits generic map (N => N-1) port map (A => entrada_A2_linha_4, B => entrada_B2_linha_4, operacao => '1', S => saida_subtratores(13));
		subtrator15: somador_subtrator_N_bits generic map (N => N-1) port map (A => entrada_A3_linha_4, B => entrada_B3_linha_4, operacao => '1', S => saida_subtratores(14));
		subtrator16: somador_subtrator_N_bits generic map (N => N-1) port map (A => entrada_A4_linha_4, B => entrada_B4_linha_4, operacao => '1', S => saida_subtratores(15));
		
		generate1: for i in 0 to 15 generate --16 circuitos de módulo
		Begin
			modulo: ABSS generic map (N => N-1) port map (inA => saida_subtratores(i), outA => saida_abss(i));
		End generate;
		
		generate2: for i in 0 to 7 generate --8 somadores.
		Begin
			somadores1: somador_subtrator_N_bits generic map (N => N-1) port map (A => saida_abss(i*2), B => saida_abss(i*2+1), operacao => '0', S => saida_somadores_1(i));
		End generate;
		
		generate3: for i in 0 to 3 generate
		Begin 
			somadores2: somador_subtrator_N_bits generic map (N => N) port map (A => saida_somadores_1(i*2), B => saida_somadores_1(i*2+1), operacao => '0', S => saida_somadores_2(i));
		end generate;
		
		generate4: for i in 0 to 1 generate
		Begin 
			somadores3: somador_subtrator_N_bits generic map (N => N+1) port map (A => saida_somadores_2(i*2), B => saida_somadores_2(i*2+1), operacao => '0', S => saida_somadores_3(i));
		End generate;
		
		somador_final: somador_subtrator_N_bits generic map (N => N+2) port map (A => saida_somadores_3(0), B =>saida_somadores_3(1), operacao => '0', S => saida_somador_final);
		
		--saida_melhor_caso <= "00" & saida_somadores_2(0);
		--saida_caso_medio <= '0' & saida_somadores_3(0);
		sad_saida_registrador <= saida_somador_final;
		registrador_final: registrador_N_bits generic map (N => 12) port map (clock => clock, load => '1', clear => clear, entrada_dados => sad_saida_registrador, saida_dados => sad_saida);
		--mux_possiveis_saidas: mux_4_1 generic map (N => N+3) port map (A => saida_melhor_caso, B => saida_caso_medio, C => saida_somador_final, D => saida_somador_final, sel => palavra_controle(3 downto 2), S => sad_selecionado); --Define as early terminations
		--entrada_mux_final_x2 <= sad_selecionado(N+1 downto 0) & '0'; --multiplica por 2
		--entrada_mux_final_x4 <= sad_selecionado(N downto 0) & "00"; --multiplica por 4
		--mux_ponderador: mux_4_1 generic map (N => N+3) port map (A => sad_selecionado, B => entrada_mux_final_x2, C => entrada_mux_final_x4, D => entrada_mux_final_x4, sel => palavra_controle(1 downto 0), S => sad_saida);
	End arch_sad_calculator_baseline;