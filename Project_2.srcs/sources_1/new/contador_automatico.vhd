library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
-- use IEEE.std_logic_arith;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity contador_automatico is
    Port ( clock : in STD_LOGIC;
           reset : in STD_LOGIC;
           lightbulb : out STD_LOGIC_VECTOR (1 downto 0));
end contador_automatico;

architecture Behavioral of contador_automatico is

signal count, result : STD_LOGIC_VECTOR (26 downto 0);

begin

process(clock, reset)
begin
    if (clock'event and clock='1') then
        if (reset='1') then
            count <= (others => '0');
        else
            count <= result;
        end if;
    end if;
end process;

result <= count + '1';

lightbulb <= count(24);

end Behavioral;