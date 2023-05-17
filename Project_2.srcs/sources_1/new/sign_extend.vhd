library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sign_extend is
    Port ( A : in STD_LOGIC_VECTOR (15 downto 0);
           B : out STD_LOGIC_VECTOR (31 downto 0));
end sign_extend;

architecture Behavioral of sign_extend is

begin

process(A)
begin
    if A(15)='0' then
        B(31 downto 16) <= "0000000000000000";
        B(15 downto 0) <= A;
    else
        B(31 downto 16) <= "1111111111111111";
        B(15 downto 0) <= A;
    end if;
end process;

end Behavioral;
