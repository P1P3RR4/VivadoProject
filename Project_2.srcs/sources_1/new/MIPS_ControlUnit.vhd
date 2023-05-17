library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MIPS_ControlUnit is
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
end MIPS_ControlUnit;

architecture Behavioral of MIPS_ControlUnit is

signal currentState, nextState : STD_LOGIC_VECTOR(3 downto 0);

begin

process(reset, clock, opcode, nextState)
begin
    if (clock'event and clock='1') then
        -- Reset
        if (reset='1') then
            nextState <= "0001";
        end if;
    
        -- Fetch -> Decode
        if nextState = "0000" then nextState <= "0001";
        -- Decode -> ¿?
        elsif nextState = "0001" then
            -- Address Computation
            if opcode = "100011" or opcode = "101011" then --lw
                nextState <= "0010";
            -- Execute
            elsif opcode = "000000" then
                nextState <= "0110";
            -- Completion Branch
            elsif opcode = "000100" then
                nextState <= "1000";
            -- Completion Jump
            elsif opcode = "000010" then
                nextState <= "1001";
            end if;
        -- Address Computation -> ¿?
        elsif nextState = "0010" then
            -- Memory Read
            if opcode = "100011" then
                nextState <= "0011";
            -- Memory Write
            else
                nextState <= "0101";
            end if;
        -- Memory Read -> Writeback Mem-RF
        elsif nextState = "0011" then
            nextState <= "0100";
        -- Writeback Mem-RF -> Fetch
        elsif nextState = "0100" then
            nextState <= "0000";
        -- Memory Write -> Fetch
        elsif nextState = "0101" then
            nextState <= "0000";
        -- Execute -> Writeback ALU-RF
        elsif nextState = "0110" then
            nextState <= "0111";
        -- Writeback ALU-RF -> Fetch
        elsif nextState = "0111" then
            nextState <= "0000";
        -- Completion Branch -> Fetch
        elsif nextState = "1000" then
            nextState <="0000";
        -- Completion Jump -> Fetch
        elsif nextState = "1001" then
            nextState <="0000";
        end if;
    end if;
end process;

process(reset, clock, currentState, nextState)
begin
    if (clock'event and clock='1') then
        if (reset='1') then
            currentState <= "0000";
        else
            currentState <= nextState;
        end if;
    end if;
end process;

process (currentState)
begin
    -- Fetch       
    if currentState = "0000" then
        PCWrite <= '1';
        Branch <= '0';
        IorD <= '0';
        MemRead <= '1';
        MemWrite <= '0';
        IRWrite <= '1';
        MemToReg <= "00";
        PCSrc <="00";
        ALUOp <="000";
        ALUSrcB <= "01";
        ALUSrcA <='0';
        RegWrite <='0';
        RegDst <= "00";
        
    -- Decode
    elsif currentState = "0001" then
        PCWrite <= '0';
        Branch <= '0';
        IorD <= '0';
        MemRead <= '0';
        MemWrite <= '0';
        IRWrite <= '0';
        MemToReg <= "00";
        PCSrc <="00";
        ALUOp <="000";
        ALUSrcB <= "11";
        ALUSrcA <='0';
        RegWrite <='0';
        RegDst <= "00";
    
    -- Address Computation  
    elsif currentState = "0010" then
        PCWrite <= '0';
        Branch <= '0';
        IorD <= '0';
        MemRead <= '0';
        MemWrite <= '0';
        IRWrite <= '0';
        MemToReg <= "00";
        PCSrc <="00";
        ALUOp <="000";
        ALUSrcB <= "10";
        ALUSrcA <='1';
        RegWrite <='0';
        RegDst <= "00";
        
    -- Memory Read
    elsif currentState = "0011" then
        PCWrite <= '0';
        Branch <= '0';
        IorD <= '1';
        MemRead <= '1';
        MemWrite <= '0';
        IRWrite <= '0';
        MemToReg <= "00";
        PCSrc <="00";
        ALUOp <="000";
        ALUSrcB <= "00";
        ALUSrcA <='0';
        RegWrite <='0';
        RegDst <= "00";
		  
	-- Writeback Mem-RF
    elsif currentState = "0100" then
        PCWrite <= '0';
        Branch <= '0';
        IorD <= '0';
        MemRead <= '0';
        MemWrite <= '0';
        IRWrite <= '0';
        MemToReg <= "01";
        PCSrc <="00";
        ALUOp <="000";
        ALUSrcB <= "00";
        ALUSrcA <='0';
        RegWrite <='1';
        RegDst <= "00";
		  
    -- Memory Write
    elsif currentState = "0101" then
        PCWrite <= '0';
        Branch <= '0';
        IorD <= '1';
        MemRead <= '0';
        MemWrite <= '1';
        IRWrite <= '0';
        MemToReg <= "00";
        PCSrc <="00";
        ALUOp <="000";
        ALUSrcB <= "00";
        ALUSrcA <='0';
        RegWrite <='0';
        RegDst <= "00";
        
    -- Execute 
    elsif currentState = "0110" then
        PCWrite <= '0';
        Branch <= '0';
        IorD <= '0';
        MemRead <= '0';
        MemWrite <= '0';
        IRWrite <= '0';
        MemToReg <= "00";
        PCSrc <="00";
        ALUOp <="010";
        ALUSrcB <= "00";
        ALUSrcA <='1';
        RegWrite <='0';
        RegDst <= "00";
    
    -- Writeback ALU-RF
    elsif currentState = "0111" then
        PCWrite <= '0';
        Branch <= '0';
        IorD <= '0';
        MemRead <= '0';
        MemWrite <= '0';
        IRWrite <= '0';
        MemToReg <= "00";
        PCSrc <="00";
        ALUOp <="000";
        ALUSrcB <= "00";
        ALUSrcA <='0';
        RegWrite <='1';
        RegDst <= "01";
	
	-- Completion Branch
    elsif currentState = "1000" then
        PCWrite <= '0';
        Branch <= '1';
        IorD <= '0';
        MemRead <= '0';
        MemWrite <= '0';
        IRWrite <= '0';
        MemToReg <= "00";
        PCSrc <="01";
        ALUOp <="001";
        ALUSrcB <= "00";
        ALUSrcA <= '1';
        RegWrite <= '0';
        RegDst <= "00";
    
    -- Completion Jump
    elsif currentState = "1001" then
        PCWrite <= '1';
        Branch <= '0';
        IorD <= '0';
        MemRead <= '0';
        MemWrite <= '0';
        IRWrite <= '0';
        MemToReg <= "00";
        PCSrc <="10";
        ALUOp <="000";
        ALUSrcB <= "00";
        ALUSrcA <= '0';
        RegWrite <= '0';
        RegDst <= "00";
    
    -- Wrong state failsafe (Set all signals to 0)
    else
        PCWrite <= '0';
        Branch <= '0';
        IorD <= '0';
        MemRead <= '0';
        MemWrite <= '0';
        IRWrite <= '0';
        MemToReg <= "00";
        PCSrc <="00";
        ALUOp <="000";
        ALUSrcB <= "00";
        ALUSrcA <= '0';
        RegWrite <= '0';
        RegDst <= "00";
    
    end if;
end process;

end Behavioral;
