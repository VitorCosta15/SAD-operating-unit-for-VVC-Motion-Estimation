Library IEEE;
Use IEEE.std_logic_1164.all;
Use work.matriz_de_sads.all;

Entity tabela_SAD is
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
End tabela_SAD;

Architecture arch_tabela_SAD of tabela_SAD is

Component registrador_N_bits IS
generic (N: integer := 8);
Port(
	clock, load, clear: IN std_logic;
	entrada_dados: IN std_logic_vector (N-1 DOWNto 0);
	saida_dados: OUT std_logic_vector (N-1 DOwNto 0)
);
End Component;

Component somador_subtrator_N_bits is
Generic (N: integer := 8);
PORT (
	A, B : in STD_LOGIC_VECTOR(N-1 downto 0);
	--valido : in std_logic; --NECESSÁRIO APENAS NA ARQUITETURA DA SAD TREE. Excluir para as demais arquiteturas, não será mais necessário devido ao registrador
	operacao: in std_logic; --Necessário para fazer com que esse somador seja tambem capaz de subtrair (1 - sub, 0 - add)
	S : out STD_LOGIC_VECTOR (N downto 0); --Concatenarei o carry out à saida para simplificação da sadTree
	Cout, ov : out STD_LOGIC
);
End Component;




constant pares : pair_array_t := ( --Essa é a correlação na qual eu devo somar os índices para cada tamanho de bloco. Replicável pra qualquer tamanho de sad
	(i1 => 0, i2 => 2),
(i1 => 1, i2 => 3),
(i1 => 4, i2 => 6),
(i1 => 5, i2 => 7),
(i1 => 8, i2 => 10),
(i1 => 9, i2 => 11),
(i1 => 12, i2 => 14),
(i1 => 13, i2 => 15),
(i1 => 16, i2 => 18),
(i1 => 17, i2 => 19),
(i1 => 20, i2 => 22),
(i1 => 21, i2 => 23),
(i1 => 24, i2 => 26),
(i1 => 25, i2 => 27),
(i1 => 28, i2 => 30),
(i1 => 29, i2 => 31),
(i1 => 32, i2 => 34),
(i1 => 33, i2 => 35),
(i1 => 36, i2 => 38),
(i1 => 37, i2 => 39),
(i1 => 40, i2 => 42),
(i1 => 41, i2 => 43),
(i1 => 44, i2 => 46),
(i1 => 45, i2 => 47),
(i1 => 48, i2 => 50),
(i1 => 49, i2 => 51),
(i1 => 52, i2 => 54),
(i1 => 53, i2 => 55),
(i1 => 56, i2 => 58),
(i1 => 57, i2 => 59),
(i1 => 60, i2 => 62),
(i1 => 61, i2 => 63)
);


signal entrada_registradores_4x8 : array_4x8;
signal entrada_registradores_8x4 : array_8x4;
signal entrada_registradores_8x8 : array_8x8;
signal entrada_registradores_8x16 : array_8x16;
signal entrada_registradores_16x8 : array_16x8;
signal entrada_registradores_16x16 : array_16x16;
signal entrada_registradores_16x32 : array_16x32;
signal entrada_registradores_32x16 : array_32x16;
signal entrada_registradores_32x32 : std_logic_vector(17 downto 0);


signal saida_auxiliar_registrador_32x32 : matriz_SADs32x32; --Preciso desse auxiliar pq a saída da minha entidade não pode ser usada como entrdaa de um port map.


signal entrada_registradores_32x64 : array_32x64;
signal entrada_registradores_64x32 : array_64x32;
signal entrada_registradores_64x64 : array_64x64;
signal entrada_registradores_64x128 : array_64x128;
signal entrada_registradores_128x64 : array_128x64;
signal entrada_registrador_128x128 : std_LOGIC_VECTOR (21 downto 0);


Begin
	generate_4x8_e_8x4: for i in 0 to 31 generate --Não esquecer de espelhar a saída do SAD4x4 paralelizado
	Begin
		somadores_4x8: somador_subtrator_N_bits generic map (N => 12) port map (A => SADs_4x4((2*12*i+12)-1 downto 2*12*i), B => SADs_4x4((2*12*i+24)-1 downto 2*12*i+12), operacao => '0', S => entrada_registradores_4x8(i));
		somadores_8x4: somador_subtrator_N_bits generic map (N => 12) port map (A => SADs_4x4((pares(i).i1+1)*12-1 downto pares(i).i1*12), B => SADs_4x4((pares(i).i2+1)*12-1 downto pares(i).i2*12), operacao => '0', S => entrada_registradores_8x4(i));
	End Generate;
	
	generate_8x8: for i in 0 to 15 generate
	Begin
		somadores_8x8: somador_subtrator_N_bits generic map (N => 13) port map (A => entrada_registradores_4x8(2*i), B => entrada_registradores_4x8(2*i+1), operacao => '0', S => entrada_registradores_8x8(i));
	End Generate;
	
	generate_8x16_e_16x8: for i in 0 to 7 generate
	Begin
		somadores_8x16: somador_subtrator_N_bits generic map (N => 14) port map (A => entrada_registradores_8x8(2*i), B => entrada_registradores_8x8(2*i+1), operacao => '0', S => entrada_registradores_8x16(i));
		somadores_16x8: somador_subtrator_N_bits generic map (N => 14) port map (A => entrada_registradores_8x8(pares(i).i1), B => entrada_registradores_8x8(pares(i).i2), operacao => '0', S => entrada_registradores_16x8(i));
	End Generate;
	
	generate_16x16: for i in 0 to 3 generate
	Begin
		somadores_16x16: somador_subtrator_N_bits generic map (N => 15) port map (A => entrada_registradores_8x16(2*i), B => entrada_registradores_8x16(2*i+1), operacao => '0', S => entrada_registradores_16x16(i));
	End Generate;
	
	generate_16x32_e_32x16: for i in 0 to 1 generate
	Begin 
		somadores_16x32: somador_subtrator_N_bits generic map (N => 16) port map (A => entrada_registradores_16x16(2*i), B => entrada_registradores_16x16(2*i+1), operacao => '0', S => entrada_registradores_16x32(i));
		soamdores_32x16: somador_subtrator_N_bits generic map (N => 16) port map (A => entrada_registradores_16x16(pares(i).i1), B => entrada_registradores_16x16(pares(i).i2), operacao => '0', S => entrada_registradores_32x16(i));
	End Generate;
	
	somador_32x32: somador_subtrator_N_bits generic map (N => 17) port map (A => entrada_registradores_16x32(0), B => entrada_registradores_16x32(1), operacao => '0', S => entrada_registradores_32x32);
	
	
	
	--GERAÇÃO DOS REGISTRADOREs
	--512 Registradores 8x4 e 4x8
	--256 Registradores 8x8
	--128 Registradores 8x16 e 16x8
	--64 Registradores 16x16
	--32 Registradores 16x32 e 32x16
	--16 Registradores 32x32
	
	--8 Registradores 32x64 e 64x32
	--4 Registradores 64x64
	--2 Registradores 64x128 e 128x64
	--1 Registrador 128x128
		
	--Todas as camadas abaixo de 32x32 serão geradas em 16 grupos, os grupos possuirão loads compartilhados, logo em 16 ciclos (total gasto para a memória ler todo o CTB)
	--Um mesmo registrador nunca terá seu load ativo por mais de um ciclo, preservando o valor de SAD ali armazenado até o processamento de um novo CTB.
	--A arquitetura precisará de um 17º ciclo para calcular o sad de todos os blocos maiores que 32x32, portanto estou considerando que a memória lê 16 ciclos de dados do CTB
	--e descansa por um ciclo. Esse delay de um ciclo a mais já foi contabilizado na planilha do excel.
	
		
	--Entrada dados vai receber a entrada correspondente no índice individual (j), já o load é controlado pelo índice do grupo.
	generate_registradores_4x8_e_8x4_grupo: for i in 0 to 15 generate --16*32 dá os 512 registradores necessários
		generate_registradores_4x8_e_8x4_individuais: for j in 0 to 31 generate
			registrador_4x8: registrador_N_bits generic map (N => 13) port map (clock => clock, clear => valido_registradores_menores_que_32x32(i), load => load_registradores_menores_que_32x32(i), entrada_dados => entrada_registradores_4x8(j), saida_dados => out_sad_4x8(i*32+j));
			registrador_8x4: registrador_N_bits generic map (N => 13) port map (clock => clock, clear => valido_registradores_menores_que_32x32(i), load => load_registradores_menores_que_32x32(i), entrada_dados => entrada_registradores_8x4(j), saida_dados => out_sad_8x4(i*32+j));
		End generate generate_registradores_4x8_e_8x4_individuais;
	End generate generate_registradores_4x8_e_8x4_grupo;
	
	generate_registradores_8x8_grupo: for i in 0 to 15 generate
		generate_registradores_8x8_individuais: for j in 0 to 15 generate
			registrador_8x8: registrador_N_bits generic map (N => 14) port map (clock => clock, clear => valido_registradores_menores_que_32x32(i), load => load_registradores_menores_que_32x32(i), entrada_dados => entrada_registradores_8x8(j), saida_dados => out_sad_8x8(i*16+j));
		End generate generate_registradores_8x8_individuais;
	End generate generate_registradores_8x8_grupo;
	
	generate_registradores_8x16_e_16x8_grupo: for i in 0 to 15 generate 
		generate_registradores_8x16_e_16x8_individuais: for j in 0 to 7 generate
			registrador_8x16: registrador_N_bits generic map (N => 15) port map (clock => clock, clear => valido_registradores_menores_que_32x32(i), load => load_registradores_menores_que_32x32(i), entrada_dados => entrada_registradores_8x16(j), saida_dados => out_sad_8x16(i*8+j));
			registrador_16x8: registrador_N_bits generic map (N => 15) port map (clock => clock, clear => valido_registradores_menores_que_32x32(i), load => load_registradores_menores_que_32x32(i), entrada_dados => entrada_registradores_16x8(j), saida_dados => out_sad_16x8(i*8+j));
		End generate generate_registradores_8x16_e_16x8_individuais;
	End generate generate_registradores_8x16_e_16x8_grupo;
	
	generate_registradores_16x16_grupo: for i in 0 to 15 generate
		generate_registradores_16x16_individuais: for j in 0 to 3 generate
			registrador_16x16: registrador_N_bits generic map (N => 16) port map (clock => clock, clear => valido_registradores_menores_que_32x32(i), load => load_registradores_menores_que_32x32(i), entrada_dados => entrada_registradores_16x16(j), saida_dados => out_sad_16x16(i*4+j));
		End generate generate_registradores_16x16_individuais;
	End generate generate_registradores_16x16_grupo;
	
	generate_registradores_16x32_e_32x16_grupo: for i in 0 to 15 generate 
		generate_registradores_16x32_e_32x16_individuais: for j in 0 to 1 generate
			registrador_16x32: registrador_N_bits generic map (N => 17) port map (clock => clock, clear => valido_registradores_menores_que_32x32(i), load => load_registradores_menores_que_32x32(i), entrada_dados => entrada_registradores_16x32(j), saida_dados => out_sad_16x32(i*2+j));
			registrador_32x16: registrador_N_bits generic map (N => 17) port map (clock => clock, clear => valido_registradores_menores_que_32x32(i), load => load_registradores_menores_que_32x32(i), entrada_dados => entrada_registradores_32x16(j), saida_dados => out_sad_32x16(i*2+j));
		End generate generate_registradores_16x32_e_32x16_individuais;
	End generate generate_registradores_16x32_e_32x16_grupo;

	generate_registradores_32x32_grupo: for i in 0 to 15 generate
		registrador_32x32: registrador_N_bits generic map (N => 18) port map (clock => clock, clear => valido_registradores_menores_que_32x32(i), load => load_registradores_menores_que_32x32(i), entrada_dados => entrada_registradores_32x32, saida_dados => saida_auxiliar_registrador_32x32(i));
	End generate generate_registradores_32x32_grupo;	

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	--Os próximos generates são para gerar somadores e registradores de SADs acima do tamanho 32x32, logo seus vlores só serão válidos no 17º ciclo do CTB sendo processado.
	--Devo obter os dados para os próximos cálculos a partir da saída dos registradores de SADs 32x32.
	--Por mais que esses somadores sempre estejam tentando somar os dados da saída de registradores 32x32 que ainda não tiveram seus dados preenchidos de maneira válida
	--Não é um  problema, pois os registardores de sads maiores que 32x32 possuem todos um load que só habilita a escrita no 17º ciclo de um CTB.
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	


	out_sad_32x32 <= saida_auxiliar_registrador_32x32;
	
	
	generate_32x64_e_64x32: for i in 0 to 7 generate
		somador_32x64: somador_subtrator_N_bits generic map (N => 18) port map (A => saida_auxiliar_registrador_32x32(2*i), B => saida_auxiliar_registrador_32x32(2*i+1), operacao => '0', S => entrada_registradores_32x64(i));
		somador_64x32: somador_subtrator_N_bits generic map (N => 18) port map (A => saida_auxiliar_registrador_32x32(pares(i).i1), B => saida_auxiliar_registrador_32x32(pares(i).i2), operacao => '0', S => entrada_registradores_64x32(i));
	End Generate;
	
	generate_64x64: for i in 0 to 3 generate
		somador_64x64: somador_subtrator_N_bits generic map (N => 19) port map (A => entrada_registradores_32x64(2*i), B => entrada_registradores_32x64(2*i+1), operacao => '0', S => entrada_registradores_64x64(i));
	End generate;
	
	generate_64x128_e_128x64: for i in 0 to 1 generate
		somador_64x128: somador_subtrator_N_bits generic map (N => 20) port map (A => entrada_registradores_64x64(2*i), B => entrada_registradores_64x64(2*i+1), operacao => '0', S => entrada_registradores_64x128(i));
		somador_128x64: somador_subtrator_N_bits generic map (N => 20) port map (A => entrada_registradores_64x64(2*i), B => entrada_registradores_64x64(2*i+1), operacao => '0', S => entrada_registradores_128x64(i));
	End generate;
	
	somador_128x128: somador_subtrator_N_bits generic map (N => 21) port map (A => entrada_registradores_64x128(0), B => entrada_registradores_64x128(1), operacao => '0', S => entrada_registrador_128x128);
	
	
	generate_registradores_32x64_e_64x32: for i in 0 to 7 generate
		registrador_32x64: registrador_N_bits generic map (N => 19) port map (clock => clock, clear => valido_registradores_maiores_que_32x32, load => load_registradores_maiores_que_32x32, entrada_dados => entrada_registradores_32x64(i), saida_dados => out_sad_32x64(i));
		registrador_64x32: registrador_N_bits generic map (N => 19) port map (clock => clock, clear => valido_registradores_maiores_que_32x32, load => load_registradores_maiores_que_32x32, entrada_dados => entrada_registradores_64x32(i), saida_dados => out_sad_64x32(i));
	End generate;
	
	generate_registradores_64x64: for i in 0 to 3 generate
		registrador_64x64: registrador_N_bits generic map (N => 20) port map (clock => clock, clear => valido_registradores_maiores_que_32x32, load => load_registradores_maiores_que_32x32, entrada_dados => entrada_registradores_64x64(i), saida_dados => out_sad_64x64(i));
	End Generate;
	
	generate_registradores_64x128_e_128x64: for i in 0 to 1 generate
		registrador_64x128: registrador_N_bits generic map (N => 21) port map (clock => clock, clear => valido_registradores_maiores_que_32x32, load => load_registradores_maiores_que_32x32, entrada_dados => entrada_registradores_64x128(i), saida_dados => out_sad_64x128(i));
		registrador_128x64: registrador_N_bits generic map (N => 21) port map (clock => clock, clear => valido_registradores_maiores_que_32x32, load => load_registradores_maiores_que_32x32, entrada_dados => entrada_registradores_128x64(i), saida_dados => out_sad_128x64(i));
	End Generate;
	
	registrador_128x128: registrador_N_bits generic map (N => 22) port map (clock => clock, clear => valido_registradores_maiores_que_32x32, load => load_registradores_maiores_que_32x32, entrada_dados => entrada_registrador_128x128, saida_dados => out_sad_128x128);
	
End arch_tabela_SAD;
