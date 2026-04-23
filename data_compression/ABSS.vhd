LIBRARY ieee ;
USE ieee.std_logic_1164.all ;
USE ieee.std_logic_unsigned.ALL;
ENTITY ABSS IS
GENERIC(n: integer:= 8);
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
