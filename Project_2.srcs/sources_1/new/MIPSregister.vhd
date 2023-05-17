library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MIPSregister is
    Port ( reset : in STD_LOGIC;
           clock : in STD_LOGIC;
           enable : in STD_LOGIC;
           dataIn : in STD_LOGIC_VECTOR (31 downto 0);
           dataOut : out STD_LOGIC_VECTOR (31 downto 0));
end MIPSregister;

architecture Behavioral of MIPSregister is

begin

    process (clock)
    begin
        if (clock'event and clock='1') then
            if (reset='1') then
                dataOut <= x"00000000";
            elsif (enable='1') then
                dataOut <= dataIn;
            end if;
        end if;
    end process;

end Behavioral;
