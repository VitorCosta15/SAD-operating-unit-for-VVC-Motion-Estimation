LIBRARY ieee ;
USE ieee.std_logic_1164.all ;
USE ieee.std_logic_unsigned.ALL;
ENTITY ABSS IS
GENERIC(n: integer:= 8); 
-- ISSO aqui é muito simples, 
--ele simplesmente pega o numero de entrada e checa o bit mais significativo que chega, se ele for 0 ele mantém o número, 
--remove o bir mais siginificativo e bota na saída, caso o bit mais significativo seja 1, ele faz um complemento de 2 sobre o número de entrada e remove o bit mais significativo, logo após. 
PORT (
	inA: IN STD_LOGIC_VECTOR(n DOWNTO 0) := (others => '0');
	outA: OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0):= (others => '0')
 ) ;
END  ABSS;

ARCHITECTURE Arc_ABSS OF ABSS IS
begin
with inA(n) select
		outA <= 
			inA(n-1 DOWNTO 0) when '0',
			not(inA(n-1 DOWNTO 0))+1 when others;
						  
END Arc_ABSS ;
