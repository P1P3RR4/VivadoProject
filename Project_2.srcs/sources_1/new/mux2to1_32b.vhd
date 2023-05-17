library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux2to1_32b is
    Port ( A : in STD_LOGIC_VECTOR (31 downto 0);
           B : in STD_LOGIC_VECTOR (31 downto 0);
           sel : in STD_LOGIC;
           muxOut : out STD_LOGIC_VECTOR (31 downto 0));
end mux2to1_32b;

architecture Behavioral of mux2to1_32b is

begin

    muxOut <= A when sel = '0' else 
              B;

end Behavioral;
