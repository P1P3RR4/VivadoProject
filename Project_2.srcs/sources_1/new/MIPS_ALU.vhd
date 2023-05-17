library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity MIPS_ALU is
    Port ( A : in STD_LOGIC_VECTOR (31 downto 0);
           B : in STD_LOGIC_VECTOR (31 downto 0);
           operation : in STD_LOGIC_VECTOR (3 downto 0);
           result : out STD_LOGIC_VECTOR (31 downto 0);
           zero : out STD_LOGIC);
end MIPS_ALU;

architecture Behavioral of MIPS_ALU is

signal shift : STD_LOGIC_VECTOR (31 downto 0);

begin

process(A, B, operation)
begin
    if (operation="0000") then result <= A AND B;
    elsif (operation="0001") then result <= A OR B;
    elsif (operation="0010") then result <= A + B;
    elsif (operation="0011") then result <= A NOR B;
    elsif (operation="0100") then -- SLL
        shift <= STD_LOGIC_VECTOR(shift_left(unsigned(A), to_integer(unsigned(B))));
        result <= shift;
    elsif (operation="0101") then -- SRL
        shift <= STD_LOGIC_VECTOR(shift_right(unsigned(A), to_integer(unsigned(B))));
        result <= shift;
    elsif (operation="0110") then result <= A - B;
    elsif (operation="0111") then --- SLT
        if (A<B) then result <= "00000000000000000000000000000001";
        else result <= "00000000000000000000000000000000";
        end if;
    end if;
end process;

end Behavioral;
