library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MIPScomputer is
    Port ( reset : in STD_LOGIC;
           clock : in STD_LOGIC;
           sensor : in STD_LOGIC;
           switches : in STD_LOGIC_VECTOR (31 downto 0);
           enter : in STD_LOGIC_VECTOR (31 downto 0);
           gpo : out STD_LOGIC_VECTOR (31 downto 0));
end MIPScomputer;

architecture Behavioral of MIPScomputer is

component mux4to1_32bC is
    Port ( A : in STD_LOGIC_VECTOR (31 downto 0);
           B : in STD_LOGIC_VECTOR (31 downto 0);
           C : in STD_LOGIC_VECTOR (31 downto 0);
           D : in STD_LOGIC_VECTOR (31 downto 0);
           sel : in STD_LOGIC_VECTOR (1 downto 0);
           muxOut : out STD_LOGIC_VECTOR (31 downto 0));
end component;

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
    Port ( address : in STD_LOGIC_VECTOR (9 downto 0);
           dataIn : in STD_LOGIC_VECTOR (31 downto 0);
           dataOut : out STD_LOGIC_VECTOR (31 downto 0);
           read : in STD_LOGIC;
           write : in STD_LOGIC;
           clock : in STD_LOGIC);
end component;

component Counter is
  Port (
    reset : in  STD_LOGIC;
    signal_in : in STD_LOGIC;
    count : out STD_LOGIC_VECTOR(31 downto 0)
  );
end component;

component FrequencyDivisor is
  Port (
    clk           : in  STD_LOGIC;
    reset         : in  STD_LOGIC;
    half_second   : out STD_LOGIC
  );
end component;

component MIPSregister
    Port ( reset : in STD_LOGIC;
           clock : in STD_LOGIC;
           enable : in STD_LOGIC;
           dataIn : in STD_LOGIC_VECTOR (31 downto 0);
           dataOut : out STD_LOGIC_VECTOR (31 downto 0));
end component;

signal memAddress, dataM2P, dataP2M, mux2P, contador: STD_LOGIC_VECTOR (31 downto 0);
signal mRead, mWrite, clock_half, memOrReg, regWrite: STD_LOGIC;

begin

Processor: MIPSprocessor 
port map(
    reset => reset,
    clock => clock,
    address => memAddress,
    dataIn => mux2P,
    dataOut => dataP2M,
    read => mRead,
    write => mWrite
); 

memOrReg <= (not memAddress(13) and mWrite);

Memory: MIPSmemory
port map(
    address => memAddress(9 downto 0),
    dataIn => dataP2M,
    dataOut => dataM2P,
    read => mRead,
    write => memOrReg,
    clock => clock
);

mux_Inputs : mux4to1_32bC
port map(
    A => dataM2P,
    B => switches,
    C => contador,
    D => enter,
    sel => memAddress(13 downto 12),
    muxOut=> mux2P
);

ContadorS2M : Counter
port map(
    reset => reset,
    signal_in => sensor,
    count => contador
);

divisor : FrequencyDivisor
port map(
    clk => clock,
    reset => reset,
    half_second => clock_half
);

regWrite <= ( memAddress(13) and mWrite);

outputReg : MIPSregister
port map(
    reset => '0',
    clock => clock,
    enable => regWrite,
    dataIn => dataP2M,
    dataOut => gpo
);
end Behavioral;
