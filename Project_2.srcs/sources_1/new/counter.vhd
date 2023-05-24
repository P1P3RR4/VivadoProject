----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.05.2023 09:49:08
-- Design Name: 
-- Module Name: counter - Behavioral
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

entity Counter is
  Port (
    reset  : in  STD_LOGIC;
    signal_in : in STD_LOGIC;
    count  : out STD_LOGIC_VECTOR(31 downto 0)
  );
end Counter;

architecture Behavioral of Counter is
  signal internal_count : unsigned(31 downto 0);
begin
  process(reset, signal_in)
  begin
    if reset = '1' then
      internal_count <= (others => '0');
    elsif rising_edge(signal_in) then
      internal_count <= internal_count + 1;
    end if;
  end process;

  count <= std_logic_vector(internal_count);
end Behavioral;
