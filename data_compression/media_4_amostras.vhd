LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.NUMERIC_STD.all; --SEMPRE USAR ESSA LIB PARA FAZER CALCULOS ARITMÉTICOS

--ANtes de se fazer um cálculo direto, é necessário que o valor std_logic_vector esteja ou em signed ou em unsigned, para tanto basta usar um cast para tal tipo, mantendo o mesmo tamanho de vetor.
-- It is good practice to use the Numeric_Std package as you should not use Std_Logic_Arith.
--SIgned e Unsigned são estruturas de vetores de bit.
--função to_signed e to_unsigned necessitam dois argumentos, o primeiro é o valor de entrada a ser convertido para signed/unsigned e o segundo é o número de bits a ser usado no vetor signed/unsigned.
--EX to_signed(4, 8) retorna 00001000


Entity media_4_amostras is
Generic (N : integer := 8);
Port(
	A, B, C, D : in std_logic_vector (N-1 downto 0);
	media : out std_logic_vector (N-1 downto 0)
);
End media_4_amostras;



architecture arch_media_4_amostras of media_4_amostras is
--signed soma : std_logic_vector(N+1 downto 0);

Begin
		--soma <= std_logic_vector(unsigned('00' & a) +  unsigned('00' & b)+  unsigned('00' & c)+  unsigned('00' & d));
		--media <= soma (N+1 downto 2);
		
		
	Process (A, B, C, D)
	variable soma : integer := 0; --Valor máximo dessa soma é 1020 (111111100) a saida é representável com 8 bits sempre
	variable divisao : integer := 0; 
	Begin
		soma := to_integer(unsigned(A)) + to_integer(unsigned(B)) + to_integer(unsigned(C)) + to_integer(unsigned(D)); --Não utilizar acumuladores aqui.
		divisao := soma/4; --Por causa dessa divisão por 4 eu posso descartar o bit 10 e o bit 9
		media <= std_logic_vector(to_unsigned(divisao, 8));
	End Process;
End arch_media_4_amostras;