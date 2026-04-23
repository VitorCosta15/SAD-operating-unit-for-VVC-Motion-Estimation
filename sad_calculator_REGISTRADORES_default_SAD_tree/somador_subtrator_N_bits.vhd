LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

Entity somador_subtrator_N_bits is
Generic (N: integer := 8);
PORT (
	A, B : in STD_LOGIC_VECTOR(N-1 downto 0);
	--valido : in std_logic; --NECESSÁRIO APENAS NA ARQUITETURA DA SAD TREE. Excluir para as demais arquiteturas, não será mais necessário devido ao registrador
	operacao: in std_logic; --Necessário para fazer com que esse somador seja tambem capaz de subtrair (1 - sub, 0 - add)
	S : out STD_LOGIC_VECTOR (N downto 0); --Concatenarei o carry out à saida para simplificação da sadTree
	Cout, ov : out STD_LOGIC
);
End somador_subtrator_N_bits;


Architecture arq_somador_subtrator_N_bits of somador_subtrator_N_bits IS
Component somador_1_bit is
Port(A0, B0: IN STD_LOGIC;
	c_in: IN STD_LOGIC;
	S0 : OUT STD_LOGIC;
	c_out : out STD_LOGIC
);
End COmponent;
signal n_aux : STD_LOGIC_VECTOR (N downto 0);
signal auxi : STD_LOGIC_VECTOR (N-1 downto 0);
signal s_aux : STD_LOGIC_VECTOR (N-1 downto 0);
--signal A_valido, B_valido : std_logic_vector (N-1 downto 0);
BEGIN --BEGIN DA ARCHITECTURE

--A_valido <= A when valido = '1' else (others => '0');
--B_valido <= B when valido = '1' else (others => '0');
--For generate com estruturas condicionais dentro. (If generate)
G1: for i in 0 to N-1 generate	
	auxi(i) <= B(i) xor operacao; --Se operação for subtração inverte tudo, e soma um devido ao carry in do primeiro somador (bit operação)
	caso1: if (i = 0) generate --Se operacao for 1, quer dizer que o somador efetuará uma subtração.
			s0: somador_1_bit port map (A0 => A(i), B0 => auxi(i), c_in => operacao, S0 => s_aux(i), c_out => n_aux(i+1));
		End generate caso1;
	caso2: if (i /= 0) generate
			si: somador_1_bit port map (A0 => A(i), B0 => auxi(i), c_in => n_aux(i), S0 => s_aux(i), c_out => n_aux(i+1));
		End generate caso2;
End generate G1;

n_aux(0) <= '0';
Cout <= n_aux(N); 
S <= s_aux(N-1) & s_aux; --To propagando o ultimo bit ao valor do resultado (ao inves de pegar a porra do carry out.)
ov <= n_aux(N) xor n_aux(N-1); --Lógica do overflow, xor entre o carry out do ultimo registrador, com o carry out do penultimo registrador
END arq_somador_subtrator_N_bits;
