Library IEEE;
Use ieee.std_logic_1164.all;




Entity mux_16_1 is 
Generic (N : integer := 32);
port (
	E0, E1, E2, E3, E4, E5, E6, E7, E8, E9, E10, E11, E12, E13, E14, E15 : in std_logic_vector (N-1 downto 0);
	sel : in std_logic_vector (3 downto 0);
	S : out std_logic_vector (N-1 downto 0)
);
End mux_16_1;

architecture arch_mux_16_1 of mux_16_1 is 
	
	
Begin --Begin da architecture.
	process (sel, E0, E1, E2, E3, E4, E5, E6, E7, E8, E9, E10, E11, E12, E13, E14, E15)
		Begin
			case sel is
				when "0000" =>
					S <= E0;
				when "0001" =>
					S <= E1;
				when "0010" =>
					S <= E2;
				when "0011" =>
					S <= E3;	
				when "0100" =>
					S <= E4;
				when "0101" =>
					S <= E5;
				when "0110" =>
					S <= E6;
				when "0111" =>
					S <= E7;
				when "1000" =>
					S <= E8;
				when "1001" =>
					S <= E9;
				when "1010" =>
					S <= E10;
				when "1011" =>
					S <= E11;
				when "1100" =>
					S <= E12;
				when "1101" =>
					S <= E13;
				when "1110" =>
					S <= E14;
				when "1111" =>
					S <= E15;
				when others =>
					S <= E1;
			End case;
		End process;
	
End arch_mux_16_1;