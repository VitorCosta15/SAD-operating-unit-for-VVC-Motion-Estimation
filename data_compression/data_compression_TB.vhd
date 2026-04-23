Library IEEE;
Use IEEE.std_logic_1164.all;
Use std.textio.all;

Entity data_compression_TB is
End data_compression_TB;

Architecture arch_data_compression_TB of data_compression_TB is
signal linha_1, linha_2, linha_3, linha_4 : std_logic_vector (31 downto 0);
signal clock : std_logic; --Só para controle interno do testbench.
signal saida : std_logic_vector (31 downto 0);


function str_to_stdvec(inp: string) return std_logic_vector is
	variable temp: std_logic_vector(inp'range);
	begin
		for i in inp'range loop
			if (inp(i) = '1') then
					temp(i):= '1';
			elsif(inp(i)='0') then
		      temp(i):= '0';
			end if;
		end loop;
		return temp; 
end function str_to_stdvec;


function stdvec_to_str(inp: std_logic_vector) return string is
		variable temp: string(inp'left+1 downto 1);
	begin
		for i in inp'reverse_range loop
			if (inp(i) = '1') then
				temp(i+1) := '1';
			elsif (inp(i) = '0') then
				temp(i+1) := '0';
			end if;
		end loop;
		return temp;
	end function stdvec_to_str;
	
	
Begin 
	arch: entity work.data_compression port map (clock => clock, linha_1 => linha_1, linha_2 => linha_2, linha_3 => linha_3, linha_4 => linha_4, saida => saida);
	ciclo: process
		begin
			clock <= '1', '0' AFTER 1.350 ns;
			Wait for 2.7 ns; --Período de 2 ns, frequência de 500MHZ Período de 2.7 ns, frequência de 370MHz
		End process;
		
	testbench: process (clock)
		variable str_type : string (32 downto 1); --tem o \0.
		variable lineType : line;
		file file_linha_1: text open read_mode is "../entradasReais/data_compression/VVC/entrada_BCU_linha_1_BQTerrace.txt";--"../entradasReais/data_compression/entrada_BCU_linha_1_FoodMarket4.txt"; --Ler arquivos sempre dessa maneira.
		file file_linha_2: text open read_mode is "../entradasReais/data_compression/VVC/entrada_BCU_linha_2_BQTerrace.txt";--"../entradasReais/data_compression/entrada_BCU_linha_2_FoodMarket4.txt";
		file file_linha_3: text open read_mode is "../entradasReais/data_compression/VVC/entrada_BCU_linha_3_BQTerrace.txt";--"../entradasReais/data_compression/entrada_BCU_linha_3_FoodMarket4.txt";
		file file_linha_4: text open read_mode is "../entradasReais/data_compression/VVC/entrada_BCU_linha_4_BQTerrace.txt";--"../entradasReais/data_compression/entrada_BCU_linha_4_FoodMarket4.txt";
		Begin
		If (clock'event and clock = '1') then 
			if not endfile(file_linha_1) then
				readline(file_linha_1, lineType);
				read(lineType, str_type);
				linha_1 <= str_to_stdvec(str_type);
			Else 
				assert false report "end of simulation" severity failure;
			End if;
			if not endfile(file_linha_2) then
				readline(file_linha_2, lineType);
				read(lineType, str_type);
				linha_2 <= str_to_stdvec(str_type);
			Else 
				assert false report "end of simulation" severity failure;
			End if;
			if not endfile(file_linha_3) then
				readline(file_linha_3, lineType);
				read(lineType, str_type);
				linha_3 <= str_to_stdvec(str_type);
			Else 
				assert false report "end of simulation" severity failure;
			End if;
			if not endfile(file_linha_4) then
				readline(file_linha_4, lineType);
				read(lineType, str_type);
				linha_4 <= str_to_stdvec(str_type);
			Else 
				assert false report "end of simulation" severity failure;
			End if;
		End if;
	End process;

End arch_data_compression_TB;

