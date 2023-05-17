library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MIPS_ALUcontrol is
    Port ( funct : in STD_LOGIC_VECTOR (5 downto 0);
           ALUOP : in STD_LOGIC_VECTOR (2 downto 0);
           operation : out STD_LOGIC_VECTOR (3 downto 0));
end MIPS_ALUcontrol;

architecture Behavioral of MIPS_ALUcontrol is

begin

process(funct, ALUOP)
begin
    if ALUOP="000" then operation <= "0010";
    elsif ALUOP="001" then operation <= "0110";
    elsif ALUOP="010" then
        if funct="100000" then operation <= "0010";
        elsif funct="100010" then operation <= "0110";
        elsif funct="100100" then operation <= "0000";
        elsif funct="100101" then operation <= "0001";
        elsif funct="100111" then operation <= "0011";
        elsif funct="101010" then operation <= "0111";
        elsif funct="000000" then operation <= "0100";
        elsif funct="000010" then operation <= "0101";
        end if;
    elsif ALUOP="011" then operation <= "0001";
    elsif ALUOP="100" then operation <= "0000";
    elsif ALUOP="101" then operation <= "0111";
    end if;
end process;

end Behavioral;
