library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MIPScomputer is
    Port ( reset : in STD_LOGIC;
           clock : in STD_LOGIC;
           gpi : in STD_LOGIC_VECTOR (7 downto 0);
           gpo : in STD_LOGIC_VECTOR (7 downto 0));
end MIPScomputer;

architecture Behavioral of MIPScomputer is

component MIPSprocessor
    Port ( reset : in STD_LOGIC;
           clock : in STD_LOGIC;
           read : in STD_LOGIC;
           write : in STD_LOGIC;
           dataIn : in STD_LOGIC_VECTOR (31 downto 0);
           address : out STD_LOGIC_VECTOR (31 downto 0);
           dataOut : out STD_LOGIC_VECTOR (31 downto 0));
end component;

component MIPSmemory
    Port ( address : in STD_LOGIC_VECTOR (31 downto 0);
           dataIn : in STD_LOGIC_VECTOR (31 downto 0);
           dataOut : out STD_LOGIC_VECTOR (31 downto 0);
           read : in STD_LOGIC;
           write : in STD_LOGIC;
           clock : in STD_LOGIC);
end component;

signal memAddress, dataM2P, dataP2M : STD_LOGIC_VECTOR (31 downto 0);
signal mRead, mWrite : STD_LOGIC;

begin

Processor: MIPSprocessor 
port map(
    reset => reset,
    clock => clock,
    address => memAddress,
    dataIn => dataM2P,
    dataOut => dataP2M,
    read => mRead,
    write => mWrite
); 

Memory: MIPSmemory
port map(
    address => memAddress,
    dataIn => dataP2M,
    dataOut => dataM2P,
    read => mRead,
    write => mWrite,
    clock => clock
);

end Behavioral;
