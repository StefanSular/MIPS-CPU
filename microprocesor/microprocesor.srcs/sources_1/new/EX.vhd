----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/17/2026 10:36:48 AM
-- Design Name: 
-- Module Name: InstructionExecute - Behavioral
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
use IEEE.NUMERIC_STD.all;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;
 
-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
 
entity EX is
  Port (rd1: in std_logic_vector(31 downto 0);
        rd2: in std_logic_vector(31 downto 0);
        ext_imm: in std_logic_vector(31 downto 0);
        sa: in std_logic_vector(4 downto 0);
        func:in std_logic_vector(5 downto 0);
        pc_plus_4: in std_logic_vector(31 downto 0);
        alusrc: in std_logic;
        aluop: in std_logic_vector(2 downto 0);
        zero: out std_logic;
        ne : out std_logic;
        alures: out std_logic_vector(31 downto 0);
        branch_address: out std_logic_vector(31 downto 0) );
end EX;
 
architecture Behavioral of EX is
signal aluctrl_signal: std_logic_vector(2 downto 0);
signal alu: std_logic_vector(31 downto 0);
signal mux_B: std_logic_vector(31 downto 0);

begin

mux_B <= rd2 when alusrc = '0' else ext_imm;


process(aluop, func)
begin
case aluop is
    when "000" => --tip r
        case func is
            when "100000" => aluctrl_signal <= "000"; --add
            when "000001" => aluctrl_signal <= "001"; --sub
            when "000010" => aluctrl_signal <= "010"; --sll
            when "000011" => aluctrl_signal <= "011"; --srl
            when "000100" => aluctrl_signal <= "100"; --and
            when "000101" => aluctrl_signal <= "101"; --or
            when "000110" => aluctrl_signal <= "110"; --slt
            when "000111" => aluctrl_signal <= "111"; --xor
            when others => null;
 
        end case;
    when "001" => aluctrl_signal <= "000"; --cod + si add (addi, lw, sw)
    when "010" => aluctrl_signal <= "001"; --cod - si sub (beq, bneq)
    when "011" => aluctrl_signal <= "010"; --cod sll (slti)
    when "100" => aluctrl_signal <= "101"; -- cod or (ori)

    when others => aluctrl_signal <= (others => 'X');
end case;
end process;


process(aluctrl_signal, sa, rd1, mux_B)
begin
case aluctrl_signal is
    when "000" => alu <=rd1+mux_B; -- add
    when "001" => alu <=rd1-mux_B; -- subb
    when "010" => alu <= to_stdlogicvector(to_bitvector(mux_B) sll conv_integer(sa)); --sll
    when "011" => alu <= to_stdlogicvector(to_bitvector(mux_B) srl conv_integer(sa)); --srl
    when "100" => alu <= rd1 and mux_B; --and
    when "101" => alu <= rd1 or mux_B; --or
    when "110" => if signed(rd1)<signed(mux_B) then 
                        alu<=x"00000001"; 
                    else 
                        alu<=x"00000000"; end if;
    when "111" => alu <= rd1 xor mux_B; --xor
    when others => alu <=(others=>'X');
end case;
end process;

alures <= alu;



process(alu)
begin
    if alu = x"00000000" then
     zero <= '1';
    else
     zero<='0';
    end if;
end process;

process(alu)
begin
    if alu /= x"00000000" then
     ne <= '1';
    else
     ne <='0';
    end if;
end process;

branch_address <= pc_plus_4 + (ext_imm(29 downto 0) & "00");
end Behavioral;


