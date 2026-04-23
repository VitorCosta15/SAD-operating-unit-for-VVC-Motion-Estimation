LIBRARY ieee ;
USE ieee.std_logic_1164.all ;
USE ieee.std_logic_unsigned.ALL;
USE IEEE.std_logic_arith.all;
use work.ME_types.all;

ENTITY SqrdSad is
	generic (
		n : integer := 8 
	);
	port (
		valido                             : in  std_logic                       ;

		bSad_l1, bSad_l2, bSad_l3, bSad_l4 : in  array_1d_4_8bits                ;
		rSad_l1, rSad_l2, rSad_l3, rSad_l4 : in  array_1d_4_8bits                ;
		--saidaValida                        : out std_logic                       ;
		saida_sad                          : out std_logic_vector  (n+3 downto 0) 
	);
END entity;


ARCHITECTURE Arc_ArvoreSad OF SqrdSad IS
	COMPONENT ABSS is
		GENERIC(n: integer);
		PORT (
			inA: IN STD_LOGIC_VECTOR(n DOWNTO 0)  ;
			outA: OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT SomadorPadraoH is
		GENERIC(n: integer);
		PORT (
			a : IN std_logic_vector(n-1 DOWNTO 0);
			b : IN std_logic_vector(n-1 DOWNTO 0);
			s : OUT std_logic_vector (n DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT SubtratorPadraoH is
		GENERIC(n: integer);
		PORT (
			a : IN std_logic_vector(n-1 DOWNTO 0);
			b : IN std_logic_vector(n-1 DOWNTO 0);
			s : OUT std_logic_vector (n DOWNTO 0)
		);
	END COMPONENT;
	
	
	signal sads0Parc                          : array_1d_16_9bits;
	signal sads0L, sads0LR                    : array_1d_16_8bits;
	signal sads1L, sads1LR                    : array_1d_8_9bits ;
	signal sads2L, sads2LR                    : array_1d_4_10bits;
	signal sads3L, sads3LR                    : array_1d_2_11bits;
	--signal valido0, valido1, valido2, valido3 : std_logic        ;
begin

-- PRIMEIRO 
	subtratores0:
		for j in 1 to 4 generate
			sads0Parc( 0+j) <= ('0'&bSad_l1(j)) - ('0'&rSad_l1(j)) when valido='1' else (others => '0');
			sads0Parc( 4+j) <= ('0'&bSad_l2(j)) - ('0'&rSad_l2(j)) when valido='1' else (others => '0');
			sads0Parc( 8+j) <= ('0'&bSad_l3(j)) - ('0'&rSad_l3(j)) when valido='1' else (others => '0');
			sads0Parc(12+j) <= ('0'&bSad_l4(j)) - ('0'&rSad_l4(j)) when valido='1' else (others => '0');
		end generate;

subtratores1:
for i in 1 to 16 generate
	absoluto: ABSS generic map(8) port map(sads0Parc(i), sads0L(i));
	--sads0L(i) <= sads0Parc(i)(7 downto 0);
	sads0LR(i) <= sads0L(i);
end generate;

-- QUARTO EST�GIO
somadores3:
for i in 1 to 8 generate
	somadores2: SomadorPadraoH generic map(n) port map(sads0LR((2*i)-1), sads0LR(2*i), sads1L(i));
	sads1LR(i) <= sads1L(i);
end generate;

-- QUINTO EST�GIO
somadores4:
for i in 1 to 4 generate
	somadores2: SomadorPadraoH generic map(n+1) port map(sads1LR((2*i)-1), sads1LR(2*i), sads2L(i));
	sads2LR(i) <= sads2L(i);
end generate;

-- SEXTO EST�GIO
somadores5:
for i in 1 to 2 generate
	somadores2: SomadorPadraoH generic map(n+2) port map(sads2LR((2*i)-1), sads2LR(2*i), sads3L(i));
	sads3LR(i) <= sads3L(i);
end generate;

-- SETIMO EST�GIO BLOCO 4x4
	somadores6: SomadorPadraoH generic map(n+3) port map(sads3LR(1), sads3LR(2), saida_sad);

END Arc_ArvoreSad ;
