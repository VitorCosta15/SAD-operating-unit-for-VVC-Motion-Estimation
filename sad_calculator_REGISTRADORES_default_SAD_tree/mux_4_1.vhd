Library IEEE;
USE IEEE.std_logic_1164.all;

Entity mux_4_1 is
Generic (N : integer := 8);
Port(
	A, B, C, D : in std_logic_vector (N-1 downto 0);
	sel : in std_logic_vector (1 downto 0);
	S : out std_logic_vector (N-1 downto 0)
);
end mux_4_1;

architecture arch_mux_4_1 of mux_4_1 is
Begin
	S <= A when sel = "00" else B when sel = "01" else C when sel = "10" else D;
End arch_mux_4_1;