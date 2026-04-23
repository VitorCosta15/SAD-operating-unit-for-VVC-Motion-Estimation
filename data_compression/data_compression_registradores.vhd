Library IEEE;
USE IEEE.std_logic_1164.all;

Entity data_compression_registradores is 
Port (
	linha_1, linha_2, linha_3, linha_4 : in std_logic_vector (31 downto 0);
	clock : in std_logic;
	saida : out std_logic_vector (31 downto 0)
);
end data_compression_registradores;

architecture arch_data_compression_registradores of data_compression_registradores is

Component registrador_N_bits is
Generic (N: integer := 32);
port(
	entrada : in std_logic_vector (N-1 downto 0);
	clock, load, reset: in std_logic;
	saida: out std_logic_vector (N-1 downto 0)
);
end component;

Component data_compression is
	Port(
		linha_1, linha_2, linha_3, linha_4 : in std_logic_vector (31 downto 0);
		saida : out std_logic_vector (31 downto 0)
	);
ENd component;

signal entrada_linha_1, entrada_linha_2, entrada_linha_3, entrada_linha_4 : std_logic_vector (31 downto 0);
signal entrada_registrador_saida : std_logic_vector (31 downto 0);

Begin
	registrador_entrada_1 : registrador_N_bits port map (entrada => linha_1, clock => clock, load => '1', reset => '0', saida => entrada_linha_1);
	registrador_entrada_2 : registrador_N_bits port map (entrada => linha_2, clock => clock, load => '1', reset => '0', saida => entrada_linha_2);
	registrador_entrada_3 : registrador_N_bits port map (entrada => linha_3, clock => clock, load => '1', reset => '0', saida => entrada_linha_3);
	registrador_entrada_4 : registrador_N_bits port map (entrada => linha_4, clock => clock, load => '1', reset => '0', saida => entrada_linha_4);
	
	data_compressor: data_compression port map (linha_1 => entrada_linha_1, linha_2 => entrada_linha_2, linha_3 => entrada_linha_3, linha_4 => entrada_linha_4, saida => entrada_registrador_saida);
	
	registrador_saida: registrador_N_bits port map (entrada => entrada_registrador_saida, clock => clock, load => '1', reset => '0', saida => saida);
	
	
End arch_data_compression_registradores; 