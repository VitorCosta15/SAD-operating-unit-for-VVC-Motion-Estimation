Library IEEE;
Library work;
USE IEEE.std_logic_1164.all;
USE ieee.std_logic_unsigned.ALL;
USE IEEE.std_logic_arith.all;
USE work.ME_types.all;


Entity data_compression is
	Port(
		clock : in std_LOGIC;
		linha_1, linha_2, linha_3, linha_4 : in std_logic_vector (31 downto 0);
		saida : out std_logic_vector (31 downto 0)
	);
ENd data_compression;

architecture arch_data_compression of data_compression is 

Component SqrdSad is
	generic (
		n : integer := 8 
	);
	port (
		valido                             : in  std_logic                       ;

		bSad_l1, bSad_l2, bSad_l3, bSad_l4 : in  array_1d_4_8bits                ;
		rSad_l1, rSad_l2, rSad_l3, rSad_l4 : in  array_1d_4_8bits                ;
		--saidaValida                        : out std_logic                       ;
		saida_sad                          : out std_logic_vector  (n+3 downto 0) 
	);
END Component;

component mux_2_1 is
Port(
	A: in std_logic_vector (13 downto 0);
	B: in std_logic_vector (13 downto 0);
	sel: in std_logic;
	data_out: out std_logic_vector (13 downto 0)
);
End Component;

Component registrador_N_bits is
Generic (N: integer := 32);
port(
	entrada : in std_logic_vector (N-1 downto 0);
	clock, load, reset: in std_logic;
	saida: out std_logic_vector (N-1 downto 0)
	
);
end component;


Component somador_subtrator_N_bits is
Generic (N: integer := 12);
PORT (
	A, B : in STD_LOGIC_VECTOR(N-1 downto 0);
	operacao: in std_logic; --Necessário para fazer com que esse somador seja tambem capaz de subtrair (1 - sub, 0 - add)
	S : out STD_LOGIC_VECTOR (N-1 downto 0);
	Cout, ov : out STD_LOGIC
);
End Component;


Component mux_4_1 is 
Generic (N : integer := 32);
port (
	E0, E1, E2, E3 : in std_logic_vector (N-1 downto 0);
	sel : in std_logic_vector (1 downto 0);
	S : out std_logic_vector (N-1 downto 0)
);
End Component;


--Component mux_16_1 is --Não preciso declarar o component se durante a chamada do port map eu instanciar a entity, EX: entity work.circuito_X port map (A => A, B => B);
--port (
	--E0, E1, E2, E3, E4, E5, E6, E7, E8, E9, E10, E11, E12, E13, E14, E15 : in std_logic_vector (31 downto 0);
	--sel : in std_logic_vector (3 downto 0);
	--S : out std_logic_vector (31 downto 0)
--);
--End Component;


--Sinais para o cálculo do SAD.
signal sad0, sad1, sad2, sad3, sad4, sad5, sad6, sad7, sad8, sad9, sad10, sad11, sad12 : std_logic_vector (11 downto 0);
signal entrada_array_l1, entrada_array_l2, entrada_array_l3, entrada_array_l4 : array_1d_4_8bits;
signal pixel_truncado_0, pixel_truncado_1, pixel_truncado_2, pixel_truncado_3, pixel_truncado_4, pixel_truncado_5, pixel_truncado_6, pixel_truncado_7, pixel_truncado_8, pixel_truncado_9, pixel_truncado_10, pixel_truncado_11, pixel_truncado_12, pixel_truncado_13, pixel_truncado_14, pixel_truncado_15 : std_logic_vector (7 downto 0);



signal linha_1_sad_0 : array_1d_4_8bits; --iSSO Aqui é uma linha
signal linha_1_sad_1 : array_1d_4_8bits;
signal linha_1_sad_2 : array_1d_4_8bits;
signal linha_1_sad_3 : array_1d_4_8bits;
signal linha_1_sad_4, linha_2_sad_4, linha_3_sad_4, linha_4_sad_4 : array_1d_4_8bits;
signal linha_1_sad_5, linha_2_sad_5, linha_3_sad_5, linha_4_sad_5 : array_1d_4_8bits;
signal linha_1_sad_6, linha_2_sad_6, linha_3_sad_6, linha_4_sad_6 : array_1d_4_8bits;
signal linha_1_sad_7, linha_2_sad_7, linha_3_sad_7, linha_4_sad_7 : array_1d_4_8bits;
signal linha_1_sad_8, linha_2_sad_8 : array_1d_4_8bits;
signal linha_1_sad_9, linha_2_sad_9 : array_1d_4_8bits;
signal linha_1_sad_10, linha_2_sad_10 : array_1d_4_8bits;
signal linha_1_sad_11, linha_2_sad_11 : array_1d_4_8bits;
signal linha_1_sad_12, linha_2_sad_12 : array_1d_4_8bits;






--sinais para obtenção do melhor (menor) SAD.
signal sad_8_modo, sad_9_modo, sad_10_modo, sad_11_modo : std_logic_vector (13 downto 0);--, sad_4_modo, sad_5_modo, sad_6_modo, sad_7_modo, sad_8_modo, sad_9_modo, sad_10_modo, sad_11_modo : std_logic_vector (13 downto 0);

signal seletor_semi_1, seletor_semi_2 : std_logic;
signal saida_somador_semi_1, saida_somador_semi_2 : std_logic_vector(11 downto 0);
signal vencedor_semi_1, vencedor_semi_2 : std_logic_vector(13 downto 0);

signal seletor_final : std_logic;
signal saida_somador_final : std_logic_vector(11 downto 0);
signal vencedor_final : std_logic_vector(13 downto 0);
signal melhor_modo : std_logic_vector (1 downto 0);

--Sinais referentes as possíveis saídas do compressor
signal saida_modo_8, saida_modo_9, saida_modo_10, saida_modo_11 : std_logic_vector (31 downto 0); --saida_modo_4, saida_modo_5, saida_modo_6, saida_modo_7, saida_modo_8, saida_modo_9, saida_modo_10, saida_modo_11, saida_modo_12 : std_logic_vector (31 downto 0);

signal saida_mux_final : std_LOGIC_VECTOR (31 downto 0);
 






Begin
	--Tratamento das entradas para o tipo array_1d_4_8bits.
	entrada_array_l1(1) <= linha_1 (31 downto 24);
	entrada_array_l1(2) <= linha_1 (23 downto 16);
	entrada_array_l1(3) <= linha_1 (15 downto 8);
	entrada_array_l1(4) <= linha_1 (7 downto 0);
	
	entrada_array_l2(1) <= linha_2 (31 downto 24);
	entrada_array_l2(2) <= linha_2 (23 downto 16);
	entrada_array_l2(3) <= linha_2 (15 downto 8);
	entrada_array_l2(4) <= linha_2 (7 downto 0);

	entrada_array_l3(1) <= linha_3 (31 downto 24);
	entrada_array_l3(2) <= linha_3 (23 downto 16);
	entrada_array_l3(3) <= linha_3 (15 downto 8);
	entrada_array_l3(4) <= linha_3 (7 downto 0);		
	
	entrada_array_l4(1) <= linha_4 (31 downto 24);
	entrada_array_l4(2) <= linha_4 (23 downto 16);
	entrada_array_l4(3) <= linha_4 (15 downto 8);
	entrada_array_l4(4) <= linha_4 (7 downto 0);
	
	
	
	--Truncamento de todos os pixels e medias. (NO ARTIGO SBCCI NÃO IREI TRUNCAR)
	pixel_truncado_0 <= linha_1(31 downto 24);
	pixel_truncado_1 <= linha_1(23 downto 16);
	pixel_truncado_2 <= linha_1(15 downto 8);
	pixel_truncado_3 <= linha_1(7 downto 0);

	pixel_truncado_4 <= linha_2(31 downto 24);
	pixel_truncado_5 <= linha_2(23 downto 16);
	pixel_truncado_6 <= linha_2(15 downto 8);
	pixel_truncado_7 <= linha_2(7 downto 0);
	
	pixel_truncado_8 <= linha_3(31 downto 24);
	pixel_truncado_9 <= linha_3(23 downto 16);
	pixel_truncado_10 <= linha_3(15 downto 8);
	pixel_truncado_11 <= linha_3(7 downto 0);
	
	pixel_truncado_12 <= linha_4(31 downto 24);
	pixel_truncado_13 <= linha_4(23 downto 16);
	pixel_truncado_14 <= linha_4(15 downto 8);
	pixel_truncado_15 <= linha_4(7 downto 0);
	
	
	
	
	--Os quatro primeiros modos de Compressão reutilizam a mesma linha para o calculo dos SAD.
	--linha_1_sad_0(1) <= pixel_truncado_0;
	--linha_1_sad_0(2) <= pixel_truncado_1;
	--linha_1_sad_0(3) <= pixel_truncado_2;
	--linha_1_sad_0(4) <= pixel_truncado_3;
	
	--linha_1_sad_1(1) <= pixel_truncado_4;
	--linha_1_sad_1(2) <= pixel_truncado_5;
	--linha_1_sad_1(3) <= pixel_truncado_6;
	--linha_1_sad_1(4) <= pixel_truncado_7;
	
	--linha_1_sad_2(1) <= pixel_truncado_8;
	--linha_1_sad_2(2) <= pixel_truncado_9;
	--linha_1_sad_2(3) <= pixel_truncado_10;
	--linha_1_sad_2(4) <= pixel_truncado_11;
	
	--linha_1_sad_3(1) <= pixel_truncado_12;
	--linha_1_sad_3(2) <= pixel_truncado_13;
	--linha_1_sad_3(3) <= pixel_truncado_14;
	--linha_1_sad_3(4) <= pixel_truncado_15;
	
	
	
	--Linhas de pixeis truncados do sad4.
	--linha_1_sad_4(1) <= pixel_truncado_0;
	--linha_1_sad_4(2) <= pixel_truncado_0;
	--linha_1_sad_4(3) <= pixel_truncado_0;
	--linha_1_sad_4(4) <= pixel_truncado_0;
	--linha_2_sad_4(1) <= pixel_truncado_4;
	--linha_2_sad_4(2) <= pixel_truncado_4;
	--linha_2_sad_4(3) <= pixel_truncado_4;
	--linha_2_sad_4(4) <= pixel_truncado_4;
	--linha_3_sad_4(1) <= pixel_truncado_8;
	--linha_3_sad_4(2) <= pixel_truncado_8;
	--linha_3_sad_4(3) <= pixel_truncado_8;
	--linha_3_sad_4(4) <= pixel_truncado_8;
	--linha_4_sad_4(1) <= pixel_truncado_12;
	--linha_4_sad_4(2) <= pixel_truncado_12;
	--linha_4_sad_4(3) <= pixel_truncado_12;
	--linha_4_sad_4(4) <= pixel_truncado_12;
	
	
	
	--Linhas de pixeis truncados do sad5.
	--linha_1_sad_5(1) <= pixel_truncado_1;
	--linha_1_sad_5(2) <= pixel_truncado_1;
	--linha_1_sad_5(3) <= pixel_truncado_1;
	--linha_1_sad_5(4) <= pixel_truncado_1;
	--linha_2_sad_5(1) <= pixel_truncado_5;
	---linha_2_sad_5(2) <= pixel_truncado_5;
	--linha_2_sad_5(3) <= pixel_truncado_5;
	--linha_2_sad_5(4) <= pixel_truncado_5;
	--linha_3_sad_5(1) <= pixel_truncado_9;
	---linha_3_sad_5(2) <= pixel_truncado_9;
	--linha_3_sad_5(3) <= pixel_truncado_9;
	--linha_3_sad_5(4) <= pixel_truncado_9;
	--linha_4_sad_5(1) <= pixel_truncado_13;
	--linha_4_sad_5(2) <= pixel_truncado_13;
	--linha_4_sad_5(3) <= pixel_truncado_13;
	--linha_4_sad_5(4) <= pixel_truncado_13;
	
	
	
	--Linhas de pixeis truncados do sad6.
	--linha_1_sad_6(1) <= pixel_truncado_2;
	--linha_1_sad_6(2) <= pixel_truncado_2;
	--linha_1_sad_6(3) <= pixel_truncado_2;
	--linha_1_sad_6(4) <= pixel_truncado_2;
	--linha_2_sad_6(1) <= pixel_truncado_6;
	--linha_2_sad_6(2) <= pixel_truncado_6;
	--linha_2_sad_6(3) <= pixel_truncado_6;
	--linha_2_sad_6(4) <= pixel_truncado_6;
	--linha_3_sad_6(1) <= pixel_truncado_10;
	--linha_3_sad_6(2) <= pixel_truncado_10;
	--linha_3_sad_6(3) <= pixel_truncado_10;
	--linha_3_sad_6(4) <= pixel_truncado_10;
	--linha_4_sad_6(1) <= pixel_truncado_14;
	--linha_4_sad_6(2) <= pixel_truncado_14;
	--linha_4_sad_6(3) <= pixel_truncado_14;
	--linha_4_sad_6(4) <= pixel_truncado_14;
	
	
	--Linhas de pixeis truncados do sad7.
	--linha_1_sad_7(1) <= pixel_truncado_3;
	--linha_1_sad_7(2) <= pixel_truncado_3;
	--linha_1_sad_7(3) <= pixel_truncado_3;
	--linha_1_sad_7(4) <= pixel_truncado_3;
	--linha_2_sad_7(1) <= pixel_truncado_7;
	--linha_2_sad_7(2) <= pixel_truncado_7;
	--linha_2_sad_7(3) <= pixel_truncado_7;
	--linha_2_sad_7(4) <= pixel_truncado_7;
	--linha_3_sad_7(1) <= pixel_truncado_11;
	--linha_3_sad_7(2) <= pixel_truncado_11;
	--linha_3_sad_7(3) <= pixel_truncado_11;
	---linha_3_sad_7(4) <= pixel_truncado_11;
	--linha_4_sad_7(1) <= pixel_truncado_15;
	--linha_4_sad_7(2) <= pixel_truncado_15;
	--linha_4_sad_7(3) <= pixel_truncado_15;
	--linha_4_sad_7(4) <= pixel_truncado_15;
	
	
	
	--Linhas de pixeis truncados do sad8.
	linha_1_sad_8(1) <= pixel_truncado_0;
	linha_1_sad_8(2) <= pixel_truncado_0;
	linha_1_sad_8(3) <= pixel_truncado_2;
	linha_1_sad_8(4) <= pixel_truncado_2;
	linha_2_sad_8(1) <= pixel_truncado_8;
	linha_2_sad_8(2) <= pixel_truncado_8;
	linha_2_sad_8(3) <= pixel_truncado_10;
	linha_2_sad_8(4) <= pixel_truncado_10;
	
	
	--Linhas de pixeis truncados do sad9.
	linha_1_sad_9(1) <= pixel_truncado_1;
	linha_1_sad_9(2) <= pixel_truncado_1;
	linha_1_sad_9(3) <= pixel_truncado_3;
	linha_1_sad_9(4) <= pixel_truncado_3;
	linha_2_sad_9(1) <= pixel_truncado_9;
	linha_2_sad_9(2) <= pixel_truncado_9;
	linha_2_sad_9(3) <= pixel_truncado_11;
	linha_2_sad_9(4) <= pixel_truncado_11;
	
	
	--Linhas de pixeis truncados do sad10.
	linha_1_sad_10(1) <= pixel_truncado_4;
	linha_1_sad_10(2) <= pixel_truncado_4;
	linha_1_sad_10(3) <= pixel_truncado_6;
	linha_1_sad_10(4) <= pixel_truncado_6;
	linha_2_sad_10(1) <= pixel_truncado_12;
	linha_2_sad_10(2) <= pixel_truncado_12;
	linha_2_sad_10(3) <= pixel_truncado_14;
	linha_2_sad_10(4) <= pixel_truncado_14;
	
	
	
	--Linhas de pixeis truncados do sad11.
	linha_1_sad_11(1) <= pixel_truncado_5;
	linha_1_sad_11(2) <= pixel_truncado_5;
	linha_1_sad_11(3) <= pixel_truncado_7;
	linha_1_sad_11(4) <= pixel_truncado_7;
	linha_2_sad_11(1) <= pixel_truncado_13;
	linha_2_sad_11(2) <= pixel_truncado_13;
	linha_2_sad_11(3) <= pixel_truncado_15;
	linha_2_sad_11(4) <= pixel_truncado_15;
	
	
	--Linhas de pixeis truncados do sad12.
	--linha_1_sad_12(1) <= pixel_truncado_0;
	--linha_1_sad_12(2) <= pixel_truncado_0;
	--linha_1_sad_12(3) <= pixel_truncado_3;
	--linha_1_sad_12(4) <= pixel_truncado_3;
	--linha_2_sad_12(1) <= pixel_truncado_12;
	--linha_2_sad_12(2) <= pixel_truncado_12;
	--linha_2_sad_12(3) <= pixel_truncado_15;
	--linha_2_sad_12(4) <= pixel_truncado_15;
	
	
	
	
	
	
	
	--SAD do modo 0.
	--sad_0: SqrdSad port map (valido => '1', bSad_l1 => entrada_array_l1, bsad_l2 => entrada_array_l2, bsad_l3 => entrada_array_l3, bsad_l4 => entrada_array_l4, rsad_l1 => linha_1_sad_0, rsad_l2 => linha_1_sad_0, rsad_l3 => linha_1_sad_0, rsad_l4 => linha_1_sad_0, saida_sad => sad0);
	
	--SAD do modo 1
	--sad_1: SqrdSad port map (valido => '1', bSad_l1 => entrada_array_l1, bsad_l2 => entrada_array_l2, bsad_l3 => entrada_array_l3, bsad_l4 => entrada_array_l4, rsad_l1 => linha_1_sad_1, rsad_l2 => linha_1_sad_1, rsad_l3 => linha_1_sad_1, rsad_l4 => linha_1_sad_1, saida_sad => sad1);
	
	--SAD do modo 2
	--sad_2: SqrdSad port map (valido => '1', bSad_l1 => entrada_array_l1, bsad_l2 => entrada_array_l2, bsad_l3 => entrada_array_l3, bsad_l4 => entrada_array_l4, rsad_l1 => linha_1_sad_2, rsad_l2 => linha_1_sad_2, rsad_l3 => linha_1_sad_2, rsad_l4 => linha_1_sad_2, saida_sad => sad2); 

	--SAD do modo 3
	--sad_3: SqrdSad port map (valido => '1', bSad_l1 => entrada_array_l1, bsad_l2 => entrada_array_l2, bsad_l3 => entrada_array_l3, bsad_l4 => entrada_array_l4, rsad_l1 => linha_1_sad_3, rsad_l2 => linha_1_sad_3, rsad_l3 => linha_1_sad_3, rsad_l4 => linha_1_sad_3, saida_sad => sad3);
	
	--SAD do modo 4
	--sad_4: SqrdSad port map (valido => '1', bSad_l1 => entrada_array_l1, bsad_l2 => entrada_array_l2, bsad_l3 => entrada_array_l3, bsad_l4 => entrada_array_l4, rsad_l1 => linha_1_sad_4, rsad_l2 => linha_2_sad_4, rsad_l3 => linha_3_sad_4, rsad_l4 => linha_4_sad_4, saida_sad => sad4);
	
	--SAD do modo 5
	--sad_5: SqrdSad port map (valido => '1', bSad_l1 => entrada_array_l1, bsad_l2 => entrada_array_l2, bsad_l3 => entrada_array_l3, bsad_l4 => entrada_array_l4, rsad_l1 => linha_1_sad_5, rsad_l2 => linha_2_sad_5, rsad_l3 => linha_3_sad_5, rsad_l4 => linha_4_sad_5, saida_sad => sad5);

	--SAD do modo 6
	--sad_6: SqrdSad port map (valido => '1', bSad_l1 => entrada_array_l1, bsad_l2 => entrada_array_l2, bsad_l3 => entrada_array_l3, bsad_l4 => entrada_array_l4, rsad_l1 => linha_1_sad_6, rsad_l2 => linha_2_sad_6, rsad_l3 => linha_3_sad_6, rsad_l4 => linha_4_sad_6, saida_sad => sad6);
	
	--SAD do modo 7
	--sad_7: SqrdSad port map (valido => '1', bSad_l1 => entrada_array_l1, bsad_l2 => entrada_array_l2, bsad_l3 => entrada_array_l3, bsad_l4 => entrada_array_l4, rsad_l1 => linha_1_sad_7, rsad_l2 => linha_2_sad_7, rsad_l3 => linha_3_sad_7, rsad_l4 => linha_4_sad_7, saida_sad => sad7);
	
	--SAD do modo 8
	sad_8: SqrdSad port map (valido => '1', bSad_l1 => entrada_array_l1, bsad_l2 => entrada_array_l2, bsad_l3 => entrada_array_l3, bsad_l4 => entrada_array_l4, rsad_l1 => linha_1_sad_8, rsad_l2 => linha_1_sad_8, rsad_l3 => linha_2_sad_8, rsad_l4 => linha_2_sad_8, saida_sad => sad8);
	
	--SAD do modo 9
	sad_9: SqrdSad port map (valido => '1', bSad_l1 => entrada_array_l1, bsad_l2 => entrada_array_l2, bsad_l3 => entrada_array_l3, bsad_l4 => entrada_array_l4, rsad_l1 => linha_1_sad_9, rsad_l2 => linha_1_sad_9, rsad_l3 => linha_2_sad_9, rsad_l4 => linha_2_sad_9, saida_sad => sad9);
	
	--SAD do modo 10
	sad_10: SqrdSad port map (valido => '1', bSad_l1 => entrada_array_l1, bsad_l2 => entrada_array_l2, bsad_l3 => entrada_array_l3, bsad_l4 => entrada_array_l4, rsad_l1 => linha_1_sad_10, rsad_l2 => linha_1_sad_10, rsad_l3 => linha_2_sad_10, rsad_l4 => linha_2_sad_10, saida_sad => sad10);

	--SAD do modo 11
	sad_11: SqrdSad port map (valido => '1', bSad_l1 => entrada_array_l1, bsad_l2 => entrada_array_l2, bsad_l3 => entrada_array_l3, bsad_l4 => entrada_array_l4, rsad_l1 => linha_1_sad_11, rsad_l2 => linha_1_sad_11, rsad_l3 => linha_2_sad_11, rsad_l4 => linha_2_sad_11, saida_sad => sad11);
	
	--SAD do modo 12
	--sad_12: SqrdSad port map (valido => '1', bSad_l1 => entrada_array_l1, bsad_l2 => entrada_array_l2, bsad_l3 => entrada_array_l3, bsad_l4 => entrada_array_l4, rsad_l1 => linha_1_sad_12, rsad_l2 => linha_1_sad_12, rsad_l3 => linha_2_sad_12, rsad_l4 => linha_2_sad_12, saida_sad => sad12);

	
	
	
	--SELEÇÃO DO MENOR SAD.
	--sad_0_modo <= sad0 & "00"; --Concatenação do valor do SAD mais o respectivo modo.
	--sad_1_modo <= sad1 & "01";
	--sad_2_modo <= sad2 & "10";
	--sad_3_modo <= sad3 & "11";
	--sad_4_modo <= sad4 & "00";
	--sad_5_modo <= sad5 & "01";
	--sad_6_modo <= sad6 & "10";
	--sad_7_modo <= sad7 & "11";
	sad_8_modo <= sad8 & "00";
	sad_9_modo <= sad9 & "01";
	sad_10_modo <= sad10 & "10";
	sad_11_modo <= sad11 & "11";
--	sad_12_modo <= sad12 & "00";

	
	semi_final_1: mux_2_1 port map (A => sad_8_modo, B => sad_9_modo, sel => seletor_semi_1, data_out => vencedor_semi_1);
	somador_semi_1: somador_subtrator_N_bits port map (A => sad_8_modo(13 downto 2), B => sad_9_modo(13 downto 2) , operacao => '1', S => saida_somador_semi_1); --sad_0_modo - sad_1_modo
	seletor_semi_1 <= not saida_somador_semi_1(11); --Pega o bit mais significativo (o bit sinal) da subtração para julgar se o número é negativo ou positivo.
	semi_final_2: mux_2_1 port map (A => sad_10_modo, B => sad_11_modo, sel => seletor_semi_2, data_out => vencedor_semi_2);
	somador_semi_2: somador_subtrator_N_bits port map (A => sad_10_modo(13 downto 2), B => sad_11_modo(13 downto 2) , operacao => '1', S => saida_somador_semi_2);
	seletor_semi_2 <= not saida_somador_semi_2(11);
	
	
	final: mux_2_1 port map (A => vencedor_semi_1, B => vencedor_semi_2, sel => seletor_final, data_out => vencedor_final);
	somador_final: somador_subtrator_N_bits port map (A => vencedor_semi_1(13 downto 2), B => vencedor_semi_2(13 downto 2), operacao => '1', S => saida_somador_final);
	seletor_final <= not saida_somador_final(11);
	
	melhor_modo <= vencedor_final(1 downto 0);
	
	--A partir do melhor modo, gerar a palavra (32 bits) a ser salva na memória.
	
	
	
	--saida_modo_0 <= linha_1(31 downto 24) & linha_1(23 downto 16) & linha_1(15 downto 8) & linha_1(7 downto 0);
	--saida_modo_1 <= linha_2(31 downto 24) & linha_2(23 downto 16) & linha_2(15 downto 8) & linha_2(7 downto 0);
	--saida_modo_2 <= linha_3(31 downto 24) & linha_3(23 downto 16) & linha_3(15 downto 8) & linha_3(7 downto 0);
	--saida_modo_3 <= linha_4(31 downto 24) & linha_4(23 downto 16) & linha_4(15 downto 8) & linha_4(7 downto 0);
	--saida_modo_4 <= linha_1(31 downto 24) & linha_2(31 downto 24) & linha_3(31 downto 24) & linha_4(31 downto 24);
	--saida_modo_5 <= linha_1(23 downto 16) & linha_2(23 downto 16) & linha_3(23 downto 16) & linha_4(23 downto 16);
	--saida_modo_6 <= linha_1(15 downto 8) & linha_2(15 downto 8) & linha_3(15 downto 8) & linha_4(15 downto 8);
	--saida_modo_7 <= linha_1(7 downto 0) & linha_2(7 downto 0) & linha_3(7 downto 0) & linha_4(7 downto 0);
	saida_modo_8 <= linha_1(31 downto 24) & linha_1(15 downto 8) & linha_3(31 downto 24) & linha_3(15 downto 8);
	saida_modo_9 <= linha_1(23 downto 16) & linha_1(7 downto 0) & linha_3(23 downto 16) & linha_3(7 downto 0);
	saida_modo_10 <= linha_2(31 downto 24) & linha_2(15 downto 8) & linha_4(31 downto 24) & linha_4(15 downto 8);
	saida_modo_11 <= linha_2(23 downto 16) & linha_2(7 downto 0) & linha_4(23 downto 16) & linha_4(7 downto 0);
--	saida_modo_12 <= linha_1(31 downto 25) & linha_1(7 downto 1) & linha_4(31 downto 25) & linha_4(7 downto 1);
	
	
	
	--seletor_compressao: mux_16_1 port map (E0 => saida_modo_0, E1 => saida_modo_1, E2 => saida_modo_2, E3 => saida_modo_3, E4 => saida_modo_4, E5 => saida_modo_5, E6 => saida_modo_6, E7 => saida_modo_7, E8 => saida_modo_8, E9 => saida_modo_9, E10 => saida_modo_10, E11 => saida_modo_11, E12 => saida_modo_12, E13 => saida_modo_13, E14 => saida_modo_14, E15 => saida_modo_15, sel => melhor_modo, S => saida);
	seletor_compressao: mux_4_1 port map (E0 => saida_modo_8, E1 => saida_modo_9, E2 => saida_modo_10, E3 => saida_modo_11, sel => melhor_modo, S => saida_mux_final);
	
	registrador_saida: registrador_N_bits port map (entrada => saida_mux_final, clock => clock, load => '1', reset => '0', saida => saida);
	
	
End arch_data_compression;
