Library IEEE;
USE IEEE.std_logic_1164.all;

Entity registrador_N_bits is
Generic (N: integer := 32);
port(
	entrada : in std_logic_vector (N-1 downto 0);
	clock, load, reset: in std_logic;
	saida: out std_logic_vector (N-1 downto 0)
	
);
end registrador_N_bits;

architecture arch_registrador_N_bits of registrador_N_bits is
BEgin
process(clock, reset, load)
	Begin 
		if reset = '1' then
		   saida <= (others => '0'); --Tantos zeros quanto for meu tamanho de saida.
		elsif clock'event AND clock = '1' AND load = '1' then
			saida <= entrada;
		end if;
	end process;
end arch_registrador_N_bits;