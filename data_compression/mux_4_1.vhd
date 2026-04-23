Library IEEE;
Use ieee.std_logic_1164.all;




Entity mux_4_1 is 
Generic (N : integer := 32);
port (
	E0, E1, E2, E3 : in std_logic_vector (N-1 downto 0);
	sel : in std_logic_vector (1 downto 0);
	S : out std_logic_vector (N-1 downto 0)
);
End mux_4_1;

architecture arch_mux_4_1 of mux_4_1 is 
	
	
Begin --Begin da architecture.
	process (sel, E0, E1, E2, E3)
		Begin
			case sel is
				when "00" =>
					S <= E0;
				when "01" =>
					S <= E1;
				when "10" =>
					S <= E2;
				when "11" =>
					S <= E3;
				when others =>
					S <= E0;
			End case;
		End process;
	
End arch_mux_4_1;