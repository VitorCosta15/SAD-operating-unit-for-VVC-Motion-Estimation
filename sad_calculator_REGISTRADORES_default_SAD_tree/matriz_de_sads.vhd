Library IEEE;
Use IEEE.std_logic_1164.all;


Package matriz_de_sads is 

	type matriz_SADs4x8 is array (511 downto 0) of std_logic_vector(12 downto 0); --Basicamente 512 sads de 13 bits;
	type matriz_SADs8x4 is array (511 downto 0) of std_logic_vector(12 downto 0);
	type matriz_SADs8x8 is array (255 downto 0) of std_logic_vector(13 downto 0);
	type matriz_SADs8x16 is array (127 downto 0) of std_logic_vector(14 downto 0);
	type matriz_SADs16x8 is array (127 downto 0) of std_logic_vector(14 downto 0);
	type matriz_SADs16x16 is array (63 downto 0) of std_logic_vector(15 downto 0);
	type matriz_SADs16x32 is array (31 downto 0) of std_logic_vector(16 downto 0);
	type matriz_SADs32x16 is array (31 downto 0) of std_logic_vector(16 downto 0);
	type matriz_SADs32x32 is array (15 downto 0) of std_logic_vector(17 downto 0);
	type matriz_SADs32x64 is array (7 downto 0) of std_logic_vector(18 downto 0);
	type matriz_SADs64x32 is array (7 downto 0) of std_logic_vector(18 downto 0);
	type matriz_SADs64x64 is array (3 downto 0) of std_logic_vector(19 downto 0);
	type matriz_SADs64x128 is array (1 downto 0) of std_logic_vector(20 downto 0);
	type matriz_SADs128x64 is array (1 downto 0) of std_logic_vector(20 downto 0);
	--type sad_128x128 is std_logic_vector(21 downto 0)
	
	--Ou seja o quartus não aceita criar um type durante já a declaração do signal/constante/variável.
	type array_4x8 is array (31 downto 0) of std_logic_vector(12 downto 0);
	type array_8x4 is array (31 downto 0) of std_logic_vector(12 downto 0);
	type array_8x8 is array (15 downto 0) of std_logic_vector(13 downto 0);
	type array_8x16 is array (7 downto 0) of std_logic_vector(14 downto 0);
	type array_16x8 is array (7 downto 0) of std_logic_vector(14 downto 0);
	type array_16x16 is array (3 downto 0) of std_logic_vector(15 downto 0);
	type array_16x32 is array (1 downto 0) of std_logic_vector(16 downto 0);
	type array_32x16 is array (1 downto 0) of std_logic_vector(16 downto 0);
	
	type array_32x64 is array (7 downto 0) of std_logic_vector(18 downto 0);
	type array_64x32 is array (7 downto 0) of std_logic_vector(18 downto 0);
	type array_64x64 is array (3 downto 0) of std_logic_vector(19 downto 0);
	type array_64x128 is array (1 downto 0) of std_logic_vector(20 downto 0);
	type array_128x64 is array (1 downto 0) of std_logic_vector(20 downto 0);
	
	type array_SADs_4x4 is array (63 downto 0) of std_LOGIC_VECTOR(11 downto 0); --USei esse cara lá no arquivo sads4x4_paralelizadas;

	type pair_t is record
	  i1, i2 : integer;
	end record;

	type pair_array_t is array (0 to 31) of pair_t;
	

End matriz_de_sads;