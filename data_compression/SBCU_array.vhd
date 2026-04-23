Library IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;

Entity SBCU_array is
Generic (N : integer := 32); --Numero de bits em 4 amostras
Port(
	clock : in std_logic;
	input_line : in std_logic_vector ((4*N*20)-1 downto 0); --São 20 SBCUs, cada SBCU recebe 16 amostras -> 16 bytes, logo são 16 * 8 bits por SBCU, sendo 20 SBCUs fica igual a 2560 bits
	output_word : out std_logic_vector ((20 * N)-1 downto 0) --Cada SBCU outputs, 4 bytes, são 20 SBCUs, 80 bytes, 80*8 = 640 bits. Word que será salva na memória
	--linha de entrada do meu testbench terá que ter 2560 bits.
);
end SBCU_array;

Architecture arch_SBCU_array of SBCU_array is 

Component data_compression is
	Port(
		clock : in std_LOGIC;
		linha_1, linha_2, linha_3, linha_4 : in std_logic_vector (31 downto 0);
		saida : out std_logic_vector (31 downto 0)
	);
ENd Component;



Begin

generate_sbcu: for i in 20 downto 1 generate
	SBCUi: data_compression port map (clock => clock, linha_1 => input_line ((4*N*i)-1 downto (4*N*i)-32), linha_2 => input_line ((4*N*i)-33 downto (4*N*i)-64), linha_3 => input_line ((4*N*i)-65 downto (4*N*i)-96), linha_4 => input_line ((4*N*i)-97 downto (4*N*i)-128), saida => output_word (i*N-1 downto i*N-32));
End generate;

end arch_SBCU_array;