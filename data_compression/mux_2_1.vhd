LIBRARY IEEE;
USE IEEE.std_logic_1164.all;


Entity mux_2_1 is
Port(
	A: in std_logic_vector (13 downto 0);
	B: in std_logic_vector (13 downto 0);
	sel: in std_logic;
	data_out: out std_logic_vector (13 downto 0)
);
End mux_2_1;

Architecture arch_mux_2_1 of mux_2_1 is
Begin
	Process (sel, A, B)
	Begin
		if(sel = '1') then
			data_out <= B;
		Else
			data_out <= A;
		End if;
	End process;
End arch_mux_2_1;