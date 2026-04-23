LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;



ENTITY SomadorPadraoH IS
	GENERIC(n: integer:= 8);
	PORT
	(
		a : IN std_logic_vector(n-1 DOWNTO 0):= (others => '0');
		b : IN std_logic_vector(n-1 DOWNTO 0):= (others => '0');
		s : OUT std_logic_vector (n DOWNTO 0) := (others => '0')
	);	
END SomadorPadraoH;

ARCHITECTURE funcional OF SomadorPadraoH IS
	--SIGNAL z : std_logic_vector(n DOWNTO 0):= (others => '0');
	
	BEGIN
		s <= ('0' & a) + ('0' & b);
		
--		s (n-1 downto 0) <= z(n-1 DOWNTO 0);
--		s (n) <= NOT z(n) WHEN (a(n-1) XOR b(n-1))='1' ELSE z(n);
END funcional;
