library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity divisor_100mhz_1hz is
    Port ( clk_in : in STD_LOGIC;
           clk_out : out STD_LOGIC);
end divisor_100mhz_1hz;

architecture Behavioral of divisor_100mhz_1hz is

signal counter : integer range 0 to 99999999 := 0;
signal clk_out_2 : STD_LOGIC;

begin
    
process (clk_in)
    begin
        if rising_edge(clk_in) then
            -- Incrementa el contador
            counter <= counter + 1;
            if counter = 99999999 then
                -- Reinicia el contador y cambia   
                -- el estado de la señal de salida
                counter <= 0;
                if (clk_out_2 = '0') then
                    clk_out_2 <= '1';
                    clk_out <= clk_out_2;
                elsif (clk_out_2 = '1') then    
                    clk_out_2 <= '0';
                    clk_out <= clk_out_2;
                end if;
            end if;
        end if;
    end process;
    
end Behavioral;
