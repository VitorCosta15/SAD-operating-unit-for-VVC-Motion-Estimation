LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
Entity registrador_1bit is
Port(
	entrada, clock, load, clear: IN std_logic;
	q, notq: OUT std_logic
);
End registrador_1bit;

architecture arch_registrador_1bit of registrador_1bit is
	Begin --Begin da architecture
	Process(clock, clear, load)
		Begin
			IF clock' event and clock = '1' THEN 
				If clear = '1' Then --ISSO É UM RESET SÍNCRONO!!
					q <= '0';
					notq <= '1';
				elsif load = '1' THEN
					q <= entrada;
					notq <= not entrada;
				End IF;
			End if; 
	End Process;
	End arch_registrador_1bit;