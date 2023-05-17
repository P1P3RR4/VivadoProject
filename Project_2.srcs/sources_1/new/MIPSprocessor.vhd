library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MIPSprocessor is
    Port ( reset : in STD_LOGIC;
           clock : in STD_LOGIC;
           read : in STD_LOGIC;
           write : in STD_LOGIC;
           dataIn : in STD_LOGIC_VECTOR (31 downto 0);
           address : out STD_LOGIC_VECTOR (31 downto 0);
           dataOut : out STD_LOGIC_VECTOR (31 downto 0));
end MIPSprocessor;

architecture Behavioral of MIPSprocessor is

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

component MIPSregister
    Port ( reset : in STD_LOGIC;
           clock : in STD_LOGIC;
           enable : in STD_LOGIC;
           dataIn : in STD_LOGIC_VECTOR (31 downto 0);
           dataOut : out STD_LOGIC_VECTOR (31 downto 0));
end component;

component MIPSregisterfile
    Port ( reset : in STD_LOGIC;
           clock : in STD_LOGIC;
           enable : in STD_LOGIC;
           read_register_1 : in STD_LOGIC_VECTOR (4 downto 0);
           read_register_2 : in STD_LOGIC_VECTOR (4 downto 0);
           write_register : in STD_LOGIC_VECTOR (4 downto 0);
           write_data : in STD_LOGIC_VECTOR (31 downto 0);
           read_data_1 : out STD_LOGIC_VECTOR (31 downto 0);
           read_data_2 : out STD_LOGIC_VECTOR (31 downto 0));
end component;

component MIPS_ALUcontrol
    Port ( funct : in STD_LOGIC_VECTOR (5 downto 0);
           ALUOP : in STD_LOGIC_VECTOR (2 downto 0);
           operation : out STD_LOGIC_VECTOR (3 downto 0));
end component;

component MIPS_ALU
    Port ( A : in STD_LOGIC_VECTOR (31 downto 0);
           B : in STD_LOGIC_VECTOR (31 downto 0);
           operation : in STD_LOGIC_VECTOR (3 downto 0);
           result : out STD_LOGIC_VECTOR (31 downto 0);
           zero : out STD_LOGIC);
end component;

component mux2to1_32b
    Port ( A : in STD_LOGIC_VECTOR (31 downto 0);
           B : in STD_LOGIC_VECTOR (31 downto 0);
           sel : in STD_LOGIC;
           muxOut : out STD_LOGIC_VECTOR (31 downto 0));
end component;

component mux3to1_32b
    Port ( A : in STD_LOGIC_VECTOR (31 downto 0);
           B : in STD_LOGIC_VECTOR (31 downto 0);
           C : in STD_LOGIC_VECTOR (31 downto 0);
           sel : in STD_LOGIC_VECTOR (1 downto 0);
           muxOut : out STD_LOGIC_VECTOR (31 downto 0));
end component;

component mux3to1_5b
    Port ( A : in STD_LOGIC_VECTOR (4 downto 0);
           B : in STD_LOGIC_VECTOR (4 downto 0);
           C : in STD_LOGIC_VECTOR (4 downto 0);
           sel : in STD_LOGIC_VECTOR (1 downto 0);
           muxOut : out STD_LOGIC_VECTOR (4 downto 0));
end component;

component mux4to1_32b
    Port ( A : in STD_LOGIC_VECTOR (31 downto 0);
           B : in STD_LOGIC_VECTOR (31 downto 0);
           C : in STD_LOGIC_VECTOR (31 downto 0);
           D : in STD_LOGIC_VECTOR (31 downto 0);
           sel : in STD_LOGIC_VECTOR (1 downto 0);
           muxOut : out STD_LOGIC_VECTOR (31 downto 0));
end component;

component shift_left_2_26to28b
    Port ( A : in STD_LOGIC_VECTOR (25 downto 0);
           B : out STD_LOGIC_VECTOR (27 downto 0));
end component;

component shift_left_2_32b
    Port ( A : in STD_LOGIC_VECTOR (31 downto 0);
           B : out STD_LOGIC_VECTOR (31 downto 0));
end component;

component sign_extend
    Port ( A : in STD_LOGIC_VECTOR (15 downto 0);
           B : out STD_LOGIC_VECTOR (31 downto 0));
end component;

signal PCEnable, PCWrite, IRWrite, IorD, MemRead, MemWrite, Zero,
       RegWrite, ALUSrcA, Branch : STD_LOGIC;
signal RegDst, MemToReg, ALUSrcB, PCSrc : STD_LOGIC_VECTOR (1 downto 0);
signal ALUOp : STD_LOGIC_VECTOR (2 downto 0);
signal ALUcontrol_to_ALU : STD_LOGIC_VECTOR (3 downto 0);
signal mux_RegDst_out : STD_LOGIC_VECTOR (4 downto 0);
signal shiftLeft2Out : STD_LOGIC_VECTOR (27 downto 0);
signal muxToPC, pcOut, memData, IROut, MDROut, regAin, regAout, regBin, regBout, 
       aluRegIn, aluRegOut, mux_MemToReg_out, signExtendOut, shiftAndPC,
       shiftLeft1Out, mux_ALUA_out, mux_ALUB_out, mux_PCSrc_in3 : STD_LOGIC_VECTOR (31 downto 0);

begin

ControlUnit : MIPS_ControlUnit
port map (
    reset => reset,
    clock => clock,
    opcode => IROut(31 downto 26),
    PCWrite => PCWrite,
    Branch => Branch,
    IorD => IorD,
    MemRead => MemRead,
    MemWrite => MemWrite,
    IRWrite => IRWrite,
    RegDst => RegDst,
    MemToReg => MemToReg,
    RegWrite => RegWrite,
    ALUSrcA => ALUSrcA,
    ALUSrcB => ALUSrcB,
    ALUOp => ALUOp,
    PCSrc => PCSrc
);

PCEnable <= (Zero AND Branch) OR PCWrite;

PC : MIPSregister
port map (
    reset => reset,
    clock => clock,
    enable => PCEnable,
    dataIn => muxToPC,
    dataOut => pcOut
);

mux_IorD : mux2to1_32b
port map (
    A => pcOut,
    B => aluRegOut,
    sel => IorD,
    muxOut => address
);

IR : MIPSregister
    port map (
    reset => '0',
    clock => clock,
    enable => IRWrite,
    dataIn => dataIn,
    dataOut => IROut
);

MDR : MIPSregister
    port map (
    reset => '0',
    clock => clock,
    enable => '1',
    dataIn => memData,
    dataOut => MDROut
);

mux_RegDst : mux3to1_5b
    port map (
    A => IROut(20 downto 16),
    B => IROut(15 downto 11),
    C => "11111",
    sel => RegDst,
    muxOut => mux_RegDst_out
);

mux_MemToReg : mux3to1_32b
    port map (
    A => aluRegOut,
    B => MDROut,
    C => pcOut,
    sel => MemToReg,
    muxOut => mux_MemToReg_out
);

RegFile : MIPSregisterfile
    port map(
    reset => '0',
    clock => clock,
    enable => RegWrite,
    read_register_1 => IROut(25 downto 21),
    read_register_2 => IROut(20 downto 16),
    write_register => mux_RegDst_out,
    write_data => mux_MemToReg_out,
    read_data_1 => regAin,
    read_data_2 => regBin
);

signExtend_16b : sign_extend
    port map(
    A => IROut(15 downto 0),
    B => signExtendOut
);

shiftLeft_for_ALUSrcmux : shift_left_2_32b
    port map(
    A => signExtendOut,
    B => shiftLeft1Out
);

regA : MIPSregister
    port map (
    reset => '0',
    clock => clock,
    enable => '1',
    dataIn => regAin,
    dataOut => regAout
    );
    
mux_ALUSrcA : mux2to1_32b
    port map (
    A => pcOut,
    B => regAout,
    sel => ALUSrcA,
    muxOut => mux_ALUA_out   
);

regB : MIPSregister
    port map (
    reset => '0',
    clock => clock,
    enable => '1',
    dataIn => regBin,
    dataOut => regBout 
    );

mux_ALUSrcB : mux4to1_32b
    port map(
    A => regBout,
    B => "00000000000000000000000000000100",
    C => signExtendOut,
    D => shiftLeft1Out,
    sel => ALUSrcB,
    muxOut => mux_ALUB_out
    );
    
ALUcontrol : MIPS_ALUcontrol
    port map(
    funct => IROut(5 downto 0),
    ALUOP => ALUOp,
    operation => ALUcontrol_to_ALU
    );

ALU : MIPS_ALU
    port map(
    A => mux_ALUA_out,
    B => mux_ALUB_out,
    operation => ALUcontrol_to_ALU,
    result => aluRegIn,
    zero => Zero
    );

ALUOutReg : MIPSregister
    port map (
    reset => '0',
    clock => clock,
    enable => '1',
    dataIn => aluRegIn,
    dataOut => aluRegOut
    );

shiftLeft_for_PCSrcmux : shift_left_2_26to28b
    port map (
    A => IROut(25 downto 0),
    B => shiftLeft2Out
    );

mux_PCSrc_in3 <= shiftLeft2Out & "0000";

mux_PCSrc : mux3to1_32b
    port map (
    A => aluRegIn,
    B => aluRegOut,
    C => mux_PCSrc_in3,
    sel => PCSrc,
    muxOut => muxToPC
    );

end Behavioral;
