Library IEEE;
Use ieee.std_logic_1164.all;
Use std.textio.all;


Entity sad_calculator_TB is
End sad_calculator_TB;

architecture arch_sad_calculator_TB of sad_calculator_TB is
signal bloco_preditor, area_busca : std_logic_vector (31 downto 0);
signal clock : std_logic;
signal clear : std_logic;
signal std_vector_PU : std_logic_vector (31 downto 0); 
signal std_vector_CB : std_logic_vector (31 downto 0);
signal sad_saida : std_logic_vector (11 downto 0);

Component sad_calculator
Generic (N: integer := 8); --Tamanho da bitdepth 
Port(
	clock : in std_logic;
	clear : in std_logic;
	bloco_preditor : in std_logic_vector (4*N-1 downto 0);
	area_busca : in std_logic_vector (4*N-1 downto 0);
	sad_saida : out std_logic_vector (N+3 downto 0)
);
End Component;

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
	arch: sad_calculator generic map (N => 8) port map (clock => clock, clear => clear, bloco_preditor => bloco_preditor, area_busca => area_busca, sad_saida => sad_saida);
	ciclo: process  --Embora o circuito testado não tenha clock, eu posso temporizar o teste deste mesmo circuito pelo testbench usando um clock, onde a cada intervalo predefinido de tempo eu irei ler uma nova entrada.
		begin
			clock <= '1', '0' after 1.350 ns;
			wait for 2.7 ns; 
		End process;
		
	--ciclo: process --Sinal para gerar um clock, note que esse process não para nunca de executar.
		--begin
			--while true loop
				--clock <= '0';
				--wait for 1.350 ns;
				--clock <= '1';
				--wait for 1.350 ns;
			--end loop;
		--End process;
	
	testbench: process (clock)
		variable str_type : string (32 downto 1); --tem o \0.
		variable lineType : line;

		file file_bloco_preditor : text open read_mode is "../entradasReais/sad_calculator/VVC/apenas_verticais/entrada_PU_quadrante_Tango2.txt";
		file file_area_busca : text open read_mode is "../entradasReais/sad_calculator/VVC/apenas_quadrante/entrada_CB_quadrante_Tango2.txt";
		--file file_bloco_preditor : text open read_mode is "../entradasReais/sad_calculator/VVC/apenas_quadrante/entrada_PU_quadrante_FoodMarket4.txt";
		--file file_area_busca : text open read_mode is "../entradasReais/sad_calculator/VVC/apenas_quadrante/entrada_CB_quadrante_FoodMarket4.txt";
		--file file_bloco_preditor : text open read_mode is "../entradasReais/sad_calculator/VVC/apenas_quadrante/entrada_PU_quadrante_Campfire.txt";
		--file file_area_busca : text open read_mode is "../entradasReais/sad_calculator/VVC/apenas_quadrante/entrada_CB_quadrante_Campfire.txt";
		--file file_bloco_preditor : text open read_mode is "../entradasReais/sad_calculator/VVC/apenas_quadrante/entrada_PU_quadrante_Cactus.txt";
		--file file_area_busca : text open read_mode is "../entradasReais/sad_calculator/VVC/apenas_quadrante/entrada_CB_quadrante_Cactus.txt";		
		--file file_bloco_preditor : text open read_mode is "../entradasReais/sad_calculator/VVC/apenas_quadrante/entrada_PU_quadrante_BQTerrace.txt";
		--file file_area_busca : text open read_mode is "../entradasReais/sad_calculator/VVC/apenas_quadrante/entrada_CB_quadrante_BQTerrace.txt";
		--file file_bloco_preditor : text open read_mode is "../entradasReais/sad_calculator/VVC/apenas_quadrante/entrada_PU_quadrante_BasketballDrive.txt";
		--file file_area_busca : text open read_mode is "../entradasReais/sad_calculator/VVC/apenas_quadrante/entrada_CB_quadrante_BasketballDrive.txt";
		Begin
			if (clock'event and clock = '1') then 
				if not endfile(file_bloco_preditor) then 
					readline(file_bloco_preditor, lineType);
					read(lineType, str_type);
					std_vector_PU <= str_to_stdvec(str_type);
					clear <= '0';
					bloco_preditor <= std_vector_PU(31 downto 0);					
				Else
					assert false report "end of simulation" severity failure;
				End if;
				if not endfile(file_area_busca) then 
					readline(file_area_busca, lineType);
					read(lineType, str_type);
					std_vector_CB <= str_to_stdvec(str_type);
					clear <= '0';
					area_busca <= std_vector_CB(31 downto 0);					
				Else
					assert false report "end of simulation" severity failure;
				End if;
			End if;
		End process;


End arch_sad_calculator_TB;