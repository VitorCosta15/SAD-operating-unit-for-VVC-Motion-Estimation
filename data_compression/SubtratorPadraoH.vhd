LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_arith.all;
USE IEEE.std_logic_unsigned.all;

ENTITY SubtratorPadraoH IS
	GENERIC(n: integer := 8);
	PORT(
		a : IN std_logic_vector(n-1 DOWNTO 0):=(others => '0');
		b : IN std_logic_vector(n-1 DOWNTO 0):=(others => '0');
		s : OUT std_logic_vector (n DOWNTO 0):=(others => '0')
	);	
END SubtratorPadraoH;

ARCHITECTURE funcional OF SubtratorPadraoH IS
	--SIGNAL z : std_logic_vector(n DOWNTO 0):= (others => '0');
	
	BEGIN
		s <= ('0' & a) + ((not('0' & b))+1);
		
		
--		s (n-1 downto 0) <= z(n-1 DOWNTO 0);
--		s (n) <= NOT z(n) WHEN (z(n-1) XOR z(n))='1' ELSE z(n);	
END funcional;


