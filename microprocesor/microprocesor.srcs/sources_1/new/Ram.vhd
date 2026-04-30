----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/17/2026 11:17:56 AM
-- Design Name: 
-- Module Name: Ram - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;
 
-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
 
entity Ram is
  Port (address: in std_logic_vector(5 downto 0); 
        clk: in std_logic;
        wd: in std_logic_vector(31 downto 0);
        rd: out std_logic_vector(31 downto 0);
        memWrite: in std_logic;
        en: in std_logic);
end Ram;
 
architecture Behavioral of Ram is
type ram_mem is array(0 to 63) of std_logic_vector(31 downto 0);
signal ram_signal: ram_mem  := (
--        0 => X"00000005",  --v[0] = 5
--        1 => X"0000000A",  --v[0] = 10
--        2 => X"0000000F",  --v[0] = 15
          0 => X"0000000C",
          1 => X"00000008",
        others => X"00000000"
    );
    
    
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if en = '1' and memWrite = '1' then
                ram_signal(conv_integer(address)) <= wd;
            end if;
        end if;
    end process;
    rd <= ram_signal(conv_integer(address));
 
end Behavioral;