----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/14/2026 05:14:47 PM
-- Design Name: 
-- Module Name: UC - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity UC is
Port ( 
        Instr : in std_logic_vector (5 downto 0);
        RegDst : out std_logic;
        Extop : out std_logic;
        ALUSrc : out std_logic;
        Branch : out std_logic;
        Branch_NE : out std_logic;
        Jump : out std_logic;
        ALUOp : out std_logic_vector (2 downto 0);
        MemWrite : out std_logic;
        MemtoReg : out std_logic;
        RegWrite : out std_logic
);
end UC;

architecture Behavioral of UC is

begin

process(Instr)
begin
    RegDst <= '0';
    Extop <= '0';
    ALUSrc <= '0';
    Branch <= '0';
    Branch_NE <= '0';
    Jump <= '0';
    MemWrite <= '0';
    MemtoReg <= '0';
    RegWrite <= '0';
    ALUOp <= "000";

    case Instr is
        when "000000" => --tip R
            RegDst<='1';
            RegWrite<='1';
            ALUOp <="000";
        when "001000" => -- addi
            Extop <= '1';
            ALUSrc <= '1';
            RegWrite <= '1';
            ALUOp <="001";
        when "100011" => -- LW
            Extop <= '1';
            ALUSrc <= '1';
            RegWrite <= '1';
            MemtoReg <= '1';
            ALUOp <="001";
        when "101011" => -- SW
            Extop <= '1';
            ALUSrc <= '1';
            MemWrite <= '1';
            ALUOp <="001";
        when "000100" => --beq
            Extop <= '1';
            Branch <= '1';
            ALUOp <="010";
        when "001010" => --slti
            Extop <= '1';
            ALUSrc <= '1';
            ALUOp <= "011";
        when "001101" => --ori
            Extop <= '1';
            ALUSrc <='1';
            ALUOp <= "100";
        when "000101" => --bne
            Extop <= '1';
            Branch_NE <= '1';
            ALUOp <= "010";
        when "000010" => --j
            Jump <= '1';

        when others =>
            null;
    end case;
            

        


            
end process;
    


end Behavioral;
