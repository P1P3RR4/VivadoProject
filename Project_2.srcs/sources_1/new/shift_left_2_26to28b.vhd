library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity shift_left_2_26to28b is
    Port ( A : in STD_LOGIC_VECTOR (25 downto 0);
           B : out STD_LOGIC_VECTOR (27 downto 0));
end shift_left_2_26to28b;

architecture Behavioral of shift_left_2_26to28b is

begin

B(27 downto 2) <= A;
B(1 downto 0) <= "00";

end Behavioral;
