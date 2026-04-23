LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

Entity registrador_N_bits IS
generic (N: integer := 8);
Port(
	clock, load, clear: IN std_logic;
	entrada_dados: IN std_logic_vector (N-1 DOWNto 0);
	saida_dados: OUT std_logic_vector (N-1 DOwNto 0)
);
End registrador_N_bits;

architecture arch_registrador_N_bits of registrador_N_bits is

Component registrador_1bit is
Port(
	entrada, clock, load, clear: IN std_logic;
	q, notq: OUT std_logic
);
End Component;


Begin
generate1:	for i in 0 to N-1 generate --precisa desse label "generate1"
		ri: registrador_1bit port map(entrada => entrada_dados(i), clock => clock, load => load, clear => clear, q => saida_dados(i));
		End generate;
End arch_registrador_N_bits;