library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity MIPSregisterfile is
    Port ( reset : in STD_LOGIC;
           clock : in STD_LOGIC;
           enable : in STD_LOGIC;
           read_register_1 : in STD_LOGIC_VECTOR (4 downto 0);
           read_register_2 : in STD_LOGIC_VECTOR (4 downto 0);
           write_register : in STD_LOGIC_VECTOR (4 downto 0);
           write_data : in STD_LOGIC_VECTOR (31 downto 0);
           read_data_1 : out STD_LOGIC_VECTOR (31 downto 0);
           read_data_2 : out STD_LOGIC_VECTOR (31 downto 0));
end MIPSregisterfile;

architecture Behavioral of MIPSregisterfile is

type ram_type is array(0 to 31) of STD_LOGIC_VECTOR (31 downto 0);
signal registerMemory : ram_type;

begin

    process (clock, read_register_1, read_register_2)
    begin
        if (clock'event and clock='1') then
            if (read_register_1="00000") then
                read_data_1 <= x"00000000";
            else
                read_data_1 <= registerMemory(conv_integer(read_register_1));
            end if;
            
            if (read_register_2="00000") then
                read_data_2 <= x"00000000";
            else
                read_data_2 <= registerMemory(conv_integer(read_register_2));
            end if;
        end if;
    end process;

    --- RegWrite
    process(clock, enable, write_data, write_register)
    begin
        if (clock'event and clock='1') then
            if (enable='1') then
                registerMemory(conv_integer(write_register)) <= write_data;
            end if;
        end if;
    end process;

end Behavioral;
