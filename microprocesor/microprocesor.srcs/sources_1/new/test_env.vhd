----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/14/2026 04:18:06 PM
-- Design Name: 
-- Module Name: test_env - Behavioral
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
use IEEE.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity test_env is
Port ( 
        btn : in std_logic_vector (4 downto 0);
        sw : in std_logic_vector (15 downto 0);
        clk : in std_logic;
        an : out std_logic_vector (7 downto 0);
        cat : out std_logic_vector (6 downto 0);
        led : out std_logic_vector (15 downto 0)

);
end test_env;

architecture Behavioral of test_env is

component InstrFetch is
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
end component;

component SSD is
    Port ( clk : in STD_LOGIC;
           digits : in STD_LOGIC_VECTOR(31 downto 0);
           an : out STD_LOGIC_VECTOR(7 downto 0);
           cat : out STD_LOGIC_VECTOR(6 downto 0));
end component;

component MPG is
    Port ( enable : out STD_LOGIC;
           btn : in STD_LOGIC;
           clk : in STD_LOGIC);
end component;

component ID is
Port ( 
        regWrite : in std_logic;
        Instr : in std_logic_vector (25 downto 0);
        regDst : in std_logic;
        en : in std_logic;
        extOp : in std_logic;
        RD1 : out std_logic_vector (31 downto 0);
        RD2 : out std_logic_vector (31 downto 0);
        WD : in std_logic_vector (31 downto 0);
        ext_Imm : out std_logic_vector (31 downto 0);
        func : out std_logic_vector (5 downto 0);
        sa : out std_logic_vector (4 downto 0);
        clk : in std_logic
);
end component;

component UC is
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
end component;

component EX is
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
end component;

component MEM is
  Port (memWrite: in std_logic;
        aluResIn: in std_logic_vector(31 downto 0);
        rd2: in std_logic_vector(31 downto 0);
        clk: in std_logic;
        en: in std_logic;
        memData: out std_logic_vector(31 downto 0);
        aluResOut: out std_logic_vector(31 downto 0)
       );
end component;

signal en : std_logic;
signal jump_uc : std_logic;
signal instruction_if : std_logic_vector (31 downto 0);
signal pc_plus_4 : std_logic_vector (31 downto 0);
signal RegDst_uc : std_logic;
signal Extop_uc : std_logic;
signal ALUSrc_uc : std_logic;
signal Branch_uc : std_logic;
signal Branch_NE_uc : std_logic;
signal ALUOp_uc : std_logic_vector (2 downto 0);
signal MemWrite_uc : std_logic;
signal MemtoReg_uc : std_logic;
signal RegWrite_uc : std_logic;
signal RD1_ID : std_logic_vector (31 downto 0);
signal RD2_ID : std_logic_vector (31 downto 0);
signal ext_Imm_ID : std_logic_vector (31 downto 0);
signal func_ID : std_logic_vector (5 downto 0);
signal sa_ID : std_logic_vector (4 downto 0);
signal A_plus_B : std_logic_vector (31 downto 0);
signal zext_func_ID : std_logic_vector (31 downto 0);
signal zext_sa_ID : std_logic_vector (31 downto 0);
signal SSD_mux : std_logic_vector (31 downto 0);
signal zero : std_logic;
signal bne : std_logic;
signal ALURes_EX : std_logic_vector (31 downto 0);
signal branch_address_EX : std_logic_vector (31 downto 0);
signal memData_MEM : std_logic_vector (31 downto 0);
signal aluResOut_MEM : std_logic_vector (31 downto 0);
signal WB_MUX : std_logic_vector (31 downto 0);
signal jump_addr : std_logic_vector (31 downto 0);
signal PCSrc_porti : std_logic;



begin

PCSrc_porti <= (zero and Branch_uc) or (Branch_NE_uc and bne);
jump_addr <= pc_plus_4(31 downto 28) & instruction_if(25 downto 0) & "00";

empg : MPG port map(enable => en, btn => btn(0) ,clk => clk);
IFetch : InstrFetch port map(en => en, rst => btn(1), clk =>clk, PCSrc => PCSrc_porti, branchAddress =>branch_address_EX, jumpAddress =>jump_addr, jump => jump_uc, instruction => instruction_if, pcplus4 => pc_plus_4);
UControl : UC port map(Instr => instruction_if(31 downto 26), RegDst => RegDst_uc, Extop => Extop_uc, ALUSrc => ALUSrc_uc, Branch => Branch_uc, Branch_NE => Branch_NE_uc, ALUOp => ALUOp_uc, MemWrite => MemWrite_uc, MemtoReg => MemtoReg_uc, RegWrite => RegWrite_uc, jump => jump_uc);
IDecoder : ID port map(en => en, clk => clk, Instr => instruction_if(25 downto 0), regDst => RegDst_uc, extOp => Extop_uc, regWrite => RegWrite_uc, WD => WB_MUX, RD1 =>RD1_ID, RD2 =>RD2_ID, ext_Imm => ext_Imm_ID, func => func_ID, sa => sa_ID);
IExecute : EX port map(RD1 => RD1_ID, RD2 => RD2_ID, ext_imm => ext_Imm_ID, func => func_ID, sa => sa_ID, pc_plus_4 => pc_plus_4, alusrc => ALUSrc_uc, aluop => ALUOp_uc, zero => zero, ne => bne, alures => ALURes_EX, branch_address => branch_address_EX);
Memory : MEM port map(memWrite => MemWrite_uc, aluResIn => ALURes_EX, rd2 => RD2_ID, clk => clk, en => en, memData => memData_MEM, aluResOut => aluResOut_MEM);
--A_plus_B <= RD1_ID + RD2_ID;
led(11 downto 0) <= ALUOp_uc & RegDst_uc & Extop_uc & ALUSrc_uc & Branch_uc & Branch_NE_uc & jump_uc & MemWrite_uc & MemtoReg_uc & RegWrite_uc;
--zext_func_ID <= (31 downto 6 => '0') & func_ID;
--zext_sa_ID <= (31 downto 5 => '0') & sa_ID;

WB_MUX <= memData_MEM when MemtoReg_uc = '1' else aluResOut_MEM;

process(sw(7 downto 5), instruction_if, pc_plus_4, RD1_ID, RD2_ID, ext_Imm_ID, ALURes_EX, memData_MEM, WB_MUX)
begin
    case sw(7 downto 5) is
        when "000" => SSD_mux <= instruction_if;
        when "001" => SSD_mux <= pc_plus_4;
        when "010" => SSD_mux <= RD1_ID;
        when "011" => SSD_mux <= RD2_ID;
        when "100" => SSD_mux <= ext_Imm_ID;
        when "101" => SSD_mux <= ALURes_EX;
        when "110" => SSD_mux <= memData_MEM;
        when "111" => SSD_mux <= WB_MUX;
    end case;
end process;

SSD_out : SSD port map(clk => clk, digits => SSD_mux, cat => cat, an => an);

end Behavioral;
