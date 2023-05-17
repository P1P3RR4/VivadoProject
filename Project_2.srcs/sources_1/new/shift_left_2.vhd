library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity shift_left_2_32b is
    Port ( A : in STD_LOGIC_VECTOR (31 downto 0);
           B : out STD_LOGIC_VECTOR (31 downto 0));
end shift_left_2_32b;

architecture Behavioral of shift_left_2_32b is

begin

B(31 downto 2) <= A(29 downto 0);
B(1 downto 0) <= "00";

end Behavioral;
