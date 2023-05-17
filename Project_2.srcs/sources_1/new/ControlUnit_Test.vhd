library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ControlUnit_Test is
    Port ( reset : in STD_LOGIC;
           clock : in STD_LOGIC;
           opcode : in STD_LOGIC_VECTOR (5 downto 0);
           -- state : out STD_LOGIC_VECTOR (3 downto 0);
           output_signals : out STD_LOGIC_VECTOR (15 downto 0);
           is_clock_on : out STD_LOGIC);
end ControlUnit_Test;

architecture Behavioral of ControlUnit_Test is

component divisor_100mhz_1hz
    Port ( clk_in : in STD_LOGIC;
           clk_out : out STD_LOGIC);
end component;

component MIPS_ControlUnit
    Port ( reset : in STD_LOGIC;
           clock : in STD_LOGIC;
           opcode : in STD_LOGIC_VECTOR (5 downto 0);
           PCWrite : out STD_LOGIC;
           Branch : out STD_LOGIC;
           IorD : out STD_LOGIC;
           MemRead : out STD_LOGIC;
           MemWrite : out STD_LOGIC;
           IRWrite : out STD_LOGIC;
           RegDst : out STD_LOGIC_VECTOR (1 downto 0);
           MemToReg : out STD_LOGIC_VECTOR (1 downto 0);
           RegWrite : out STD_LOGIC;
           ALUSrcA : out STD_LOGIC;
           ALUSrcB : out STD_LOGIC_VECTOR (1 downto 0);
           ALUOp : out STD_LOGIC_VECTOR (2 downto 0);
           PCSrc : out STD_LOGIC_VECTOR (1 downto 0));
end component;

signal internal_clock : STD_LOGIC;
signal output_signals_backup : STD_LOGIC_VECTOR (18 downto 0);

begin

clkDiv : divisor_100mhz_1hz
port map (
    clk_in => clock,
    clk_out => internal_clock
);

UC : MIPS_ControlUnit
port map (
    reset => reset,
    clock => internal_clock,
    opcode => opcode,
    PCWrite => output_signals_backup(0),
    Branch => output_signals_backup(1),
    IorD => output_signals_backup(2),
    MemRead => output_signals_backup(3),
    MemWrite => output_signals_backup(4),
    IRWrite => output_signals_backup(5),
    RegDst => output_signals_backup(7 downto 6),
    MemToReg => output_signals_backup(9 downto 8),
    RegWrite => output_signals_backup(10),
    ALUSrcA => output_signals_backup(11),
    ALUSrcB => output_signals_backup(13 downto 12),
    ALUOp => output_signals_backup(16 downto 14),
    PCSrc => output_signals_backup(18 downto 17)
);

process (output_signals_backup)
begin
    output_signals (6 downto 0) <= output_signals_backup (6 downto 0);
    output_signals (7) <= output_signals_backup(8);
    output_signals (9 downto 8) <= output_signals_backup(11 downto 10);
    output_signals (10) <= output_signals_backup (12);
    output_signals (11) <= output_signals_backup (14);
    output_signals (12) <= output_signals_backup (17);
    output_signals (15 downto 13) <= "000";
end process;

is_clock_on <= '0';

process (internal_clock)
begin
    if (internal_clock'event and internal_clock='1') then
        is_clock_on <= '1';
    end if;
end process;

end Behavioral;
