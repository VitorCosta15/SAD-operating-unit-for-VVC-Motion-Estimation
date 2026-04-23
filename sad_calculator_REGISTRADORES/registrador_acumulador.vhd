library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity registrador_acumulador is
Generic (N: integer := 8);
    Port (
        clock       : in  std_logic;
        clear     : in  std_logic;           -- Reset assíncrono
        load    : in  std_logic;           -- Habilita acumulação
        sample_in : in  std_logic_vector(N+3 downto 0); -- Entrada (12 bits)
        acc_out   : out std_logic_vector(N+6 downto 0)  -- Saída acumulada (15 bits)
    );
end registrador_acumulador;

architecture arch_acumulador of registrador_acumulador is
    signal acc_reg : unsigned(14 downto 0) := (others => '0'); -- registrador acumulador
    --signal counter : unsigned(2 downto 0) := (others => '0');  -- conta até 7 (8 amostras)
begin
    process(clock, clear, load)
    begin
        if clear = '1' then
            acc_reg <= (others => '0');
            --counter <= (others => '0');
        elsif clock' event and clock = '1' and load = '1' then
                --if counter < 7 then
			  acc_reg <= acc_reg + unsigned(sample_in);
			  --counter <= counter + 1;
                --else
                    -- Opcional: trava após 8 somas
                    --counter <= counter; -- mantém
                    --acc_reg <= acc_reg; -- mantém valor acumulado
		   --end if;
        end if;
    end process;

    acc_out <= std_logic_vector(acc_reg);
end arch_acumulador;
