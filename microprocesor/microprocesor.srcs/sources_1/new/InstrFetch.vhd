----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/03/2026 11:06:02 AM
-- Design Name: 
-- Module Name: InstrFetch - Behavioral
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
use IEEE.std_logic_unsigned.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity InstrFetch is
Port ( jump : in std_logic;
       jumpAddress : in std_logic_vector (31 downto 0);
       PCSrc : in std_logic;
       branchAddress : in std_logic_vector (31 downto 0);
       en : in std_logic;
       rst : in std_logic;
       clk : in std_logic;
       pcplus4 : out std_logic_vector (31 downto 0);
       instruction : out std_logic_vector (31 downto 0)

 );
end InstrFetch;

architecture Behavioral of InstrFetch is

signal address: std_logic_vector(4 downto 0);
signal q : std_logic_vector (31 downto 0);
signal mux_branch : std_logic_vector (31 downto 0);
signal mux_jump : std_logic_vector (31 downto 0);
type t_mem is array (0 to 31) of std_logic_vector(31 downto 0);
signal mem : t_mem :=(

b"001000_00000_00001_0000000000000000",
b"001000_00000_00010_0000000000000000",
b"100011_00000_00001_0000000000000000",
b"100011_00000_00010_0000000000000100",
b"001000_00000_00011_0000000000001000",
b"101011_00011_00001_0000000000000000",
b"001000_00011_00011_0000000000000100",
b"101011_00011_00010_0000000000000000",
b"001000_00011_00011_0000000000000100",
b"000100_00001_00010_0000000000001001",
b"000000_00001_00010_00100_00000_000110",
b"000101_00100_00000_0000000000000011",
b"000000_00001_00010_00001_00000_000001",
b"101011_00011_00001_0000000000000000",
b"000010_00000000000000000000010001",
b"000000_00010_00001_00010_00000_000001",
b"101011_00011_00010_0000000000000000",
b"001000_00011_00011_0000000000000100",
b"000010_00000000000000000000001001",
b"001000_00000_00100_0000000000000000",
b"001000_00000_00100_0000000000001000",
b"000100_00100_00011_0000000000000011",
b"100011_00100_00101_0000000000000000",
b"001000_00100_00100_0000000000000100",
b"000010_00000000000000000000010101",

others=>X"00000000"
);

begin

pcplus4 <= q + 4;

mux_branch <= branchAddress when PCSrc = '1' else (q+4);

mux_jump <= jumpAddress when  jump = '1' else mux_branch;


process(clk, rst)
begin
    if rst ='1' then
        q <= (others => '0');
    elsif rising_edge(clk) then
        if en='1' then
            q <=mux_jump;
        end if;
    end if;
end process;

address <= q(6 downto 2);
instruction<=mem(conv_integer( address ));




end Behavioral;











