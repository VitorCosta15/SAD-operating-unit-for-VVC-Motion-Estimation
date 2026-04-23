Library IEEE;
Use IEEE.std_logic_1164.all;

Entity unidade_de_controle is
	port(
		clock : in std_logic;
		valido_registradores_menores_que_32x32 : out std_logic_vector (15 downto 0);
		valido_registradores_maiores_que_32x32 : out std_logic;
		load_registradores_menores_que_32x32 : out std_logic_vector (15 downto 0);
		load_registradores_maiores_que_32x32 : out std_logic
	);
End unidade_de_controle;

Architecture arch_unidade_de_controle of unidade_de_controle is
	type state is (sMinusOne, s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17); --18 estados totais. (O primeiro é pra encher o pipeline, e o último é pra calcular os SADs grandes)
	signal estado_atual, proximo_estado: state := sMinusOne;
	
	
	Begin
		Process(clock)
		Begin
			if (rising_edge(clock)) then 
				estado_atual <= proximo_estado;
			end if;
		end Process;
		
		Process(estado_atual)
		Begin
			valido_registradores_maiores_que_32x32 <= '1';
			load_registradores_maiores_que_32x32   <= '0';
			valido_registradores_menores_que_32x32 <= (others => '0');
			load_registradores_menores_que_32x32   <= (others => '0');
			proximo_estado                         <= estado_atual;
		
			
			case estado_atual is 
				--NUNCA volto pra SMInusOne
				when sMinusOne => --Estado de partida da maquina de estados. Necessário pq antes de ler a primeira linha do testbench eu já estaria em um estado válido.
					valido_registradores_maiores_que_32x32 <= '1';
					load_registradores_maiores_que_32x32 <= '0'; 
					valido_registradores_menores_que_32x32 <= "1111111111111111";
					load_registradores_menores_que_32x32 <= "0000000000000000";
					proximo_estado <= s0;
				
				when s0 => 
					valido_registradores_maiores_que_32x32 <= '1';
					load_registradores_maiores_que_32x32 <= '0'; 
					valido_registradores_menores_que_32x32 <= "1111111111111111";
					load_registradores_menores_que_32x32 <= "0000000000000000";
					proximo_estado <= s1;
				
				when s1 => 
					valido_registradores_maiores_que_32x32 <= '1'; --1 é desativado, pq isso vai direto no clear dos registradores dos sad grandes
					load_registradores_maiores_que_32x32 <= '0'; --Aqui é normal, 0 desativa o load, 1 ativa o load.
					valido_registradores_menores_que_32x32 <= "1111111111111110";
					load_registradores_menores_que_32x32 <= "0000000000000001";
					proximo_estado <= s2;
					
				when s2 => 
					valido_registradores_maiores_que_32x32 <= '1';
					load_registradores_maiores_que_32x32 <= '0'; 
					valido_registradores_menores_que_32x32 <= "1111111111111100";
					load_registradores_menores_que_32x32 <= "0000000000000010";
					proximo_estado <= s3;
				
				when s3 =>
					valido_registradores_maiores_que_32x32 <= '1';
					load_registradores_maiores_que_32x32 <= '0'; 
					valido_registradores_menores_que_32x32 <= "1111111111111000";
					load_registradores_menores_que_32x32 <= "0000000000000100";	
					proximo_estado <= s4;
			
				when s4 =>
					valido_registradores_maiores_que_32x32 <= '1';
					load_registradores_maiores_que_32x32 <= '0'; 
					valido_registradores_menores_que_32x32 <= "1111111111110000";
					load_registradores_menores_que_32x32 <= "0000000000001000";
					proximo_estado <= s5;
				
				when s5 => 
					valido_registradores_maiores_que_32x32 <= '1';
					load_registradores_maiores_que_32x32 <= '0'; 
					valido_registradores_menores_que_32x32 <= "1111111111100000";
					load_registradores_menores_que_32x32 <= "0000000000010000";
					proximo_estado <= s6;
					
				when s6 =>
					valido_registradores_maiores_que_32x32 <= '1';
					load_registradores_maiores_que_32x32 <= '0'; 
					valido_registradores_menores_que_32x32 <= "1111111111000000";
					load_registradores_menores_que_32x32 <= "0000000000100000";
					proximo_estado <= s7;
					
				when s7 =>
					valido_registradores_maiores_que_32x32 <= '1';
					load_registradores_maiores_que_32x32 <= '0'; 
					valido_registradores_menores_que_32x32 <= "1111111110000000";
					load_registradores_menores_que_32x32 <= "0000000001000000";
					proximo_estado <= s8;
				
				when s8 =>
					valido_registradores_maiores_que_32x32 <= '1';
					load_registradores_maiores_que_32x32 <= '0'; 
					valido_registradores_menores_que_32x32 <= "1111111100000000";
					load_registradores_menores_que_32x32 <= "0000000010000000";
					proximo_estado <= s9;
					
				when s9 =>
					valido_registradores_maiores_que_32x32 <= '1';
					load_registradores_maiores_que_32x32 <= '0'; 
					valido_registradores_menores_que_32x32 <= "1111111000000000";
					load_registradores_menores_que_32x32 <= "0000000100000000";
					proximo_estado <= s10;
					
				when s10 =>
					valido_registradores_maiores_que_32x32 <= '1';
					load_registradores_maiores_que_32x32 <= '0'; 
					valido_registradores_menores_que_32x32 <= "1111110000000000";
					load_registradores_menores_que_32x32 <= "0000001000000000";
					proximo_estado <= s11;
					
				when s11 =>
					valido_registradores_maiores_que_32x32 <= '1';
					load_registradores_maiores_que_32x32 <= '0'; 
					valido_registradores_menores_que_32x32 <= "1111100000000000";
					load_registradores_menores_que_32x32 <= "0000010000000000";
					proximo_estado <= s12;
					
				when s12 => 
					valido_registradores_maiores_que_32x32 <= '1';
					load_registradores_maiores_que_32x32 <= '0'; 
					valido_registradores_menores_que_32x32 <= "1111000000000000";
					load_registradores_menores_que_32x32 <= "0000100000000000";
					proximo_estado <= s13;
					
				when s13 => 
					valido_registradores_maiores_que_32x32 <= '1';
					load_registradores_maiores_que_32x32 <= '0'; 
					valido_registradores_menores_que_32x32 <= "1110000000000000";
					load_registradores_menores_que_32x32 <= "0001000000000000";
					proximo_estado <= s14;
														
				when s14 => 
					valido_registradores_maiores_que_32x32 <= '1';
					load_registradores_maiores_que_32x32 <= '0'; 
					valido_registradores_menores_que_32x32 <= "1100000000000000";
					load_registradores_menores_que_32x32 <= "0010000000000000";
					proximo_estado <= s15;
					
				when s15 => 
					valido_registradores_maiores_que_32x32 <= '1';
					load_registradores_maiores_que_32x32 <= '0'; 
					valido_registradores_menores_que_32x32 <= "1000000000000000";
					load_registradores_menores_que_32x32 <= "0100000000000000";
					proximo_estado <= s16;
					
				when s16 =>
					valido_registradores_maiores_que_32x32 <= '1';
					load_registradores_maiores_que_32x32 <= '0'; 
					valido_registradores_menores_que_32x32 <= "0000000000000000";
					load_registradores_menores_que_32x32 <= "1000000000000000";
					proximo_estado <= s17;
					
				when s17 => --Ciclo para obter os sads maiores que 32x32
					valido_registradores_maiores_que_32x32 <= '0';
					load_registradores_maiores_que_32x32 <= '1'; 
					valido_registradores_menores_que_32x32 <= "0000000000000000";
					load_registradores_menores_que_32x32 <= "0000000000000000";
					proximo_estado <= s0;
					
				End case;
			End Process;
	
End arch_unidade_de_controle;