----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.05.2023 10:25:39
-- Design Name: 
-- Module Name: FrecuencyDivisor - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_signed.ALL;

entity FrequencyDivisor is
  Port (
    clk           : in  STD_LOGIC;
    reset         : in  STD_LOGIC;
    half_second   : out STD_LOGIC
  );
end FrequencyDivisor;

architecture Behavioral of FrequencyDivisor is
  constant CLK_FREQUENCY : natural := 100_000_000;  -- 100 MHz
  constant TARGET_PERIOD : natural := 50_00_000;  -- 500 ms period

  signal counter : unsigned(31 downto 0) := (others => '0');
  signal elapsed : boolean := false;
begin
  process(clk, reset)
  begin
    if reset = '1' then
      counter <= (others => '0');
      elapsed <= false;
    elsif rising_edge(clk) then
      counter <= counter + 1;

      if counter = TARGET_PERIOD - 1 then  -- -1 to account for zero-based indexing
        elapsed <= true;
        counter <= (others => '0');
      else
        elapsed <= false;
      end if;
    end if;
  end process;

  half_second <= '1' when elapsed = true else '0';
end Behavioral;