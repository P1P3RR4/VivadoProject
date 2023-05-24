library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux4to1_32bC is
    Port ( A : in STD_LOGIC_VECTOR (31 downto 0);
           B : in STD_LOGIC_VECTOR (31 downto 0);
           C : in STD_LOGIC_VECTOR (31 downto 0);
           D : in STD_LOGIC_VECTOR (31 downto 0);
           sel : in STD_LOGIC_VECTOR (1 downto 0);
           address : in STD_LOGIC_VECTOR (31 downto 0);
           muxOut : out STD_LOGIC_VECTOR (31 downto 0));
end mux4to1_32bC;

architecture Behavioral of mux4to1_32bC is

begin
    
    muxOut <= 
              A when sel = "00" else
              B when sel = "01" else
              C when sel = "10" else
              D when sel = "11";

end Behavioral;
