library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity MIPSmemory is
    Port ( address : in STD_LOGIC_VECTOR (9 downto 0);
           dataIn : in STD_LOGIC_VECTOR (31 downto 0);
           dataOut : out STD_LOGIC_VECTOR (31 downto 0);
           read : in STD_LOGIC;
           write : in STD_LOGIC;
           clock : in STD_LOGIC);
end MIPSmemory;

architecture Behavioral of MIPSmemory is

type ram_type is array (0 to 1023) of STD_LOGIC_VECTOR(31 downto 0);
signal mainMemory : ram_type := (x"00000000", x"00000001", others => (others => '0'));

begin

process (clock)
begin
    dataOut <= mainMemory(conv_integer(address));
    if (clock'event and clock='1') then
        if (write='1') then
            mainMemory(conv_integer(address)) <= dataIn;
        end if;
    end if;
end process;

end Behavioral;
