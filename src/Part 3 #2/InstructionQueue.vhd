library ieee;
use ieee.std_logic_1164.all;

entity InstructionQueue is
    port (
        clk : in std_logic;        
        CF : in std_logic;
        current_instruction : out std_logic_vector(31 downto 0)
    );
end entity InstructionQueue;

architecture Behavioral of InstructionQueue is
    type InstructionArray is array (1 to 29) of std_logic_vector(31 downto 0);
    constant Instructions : InstructionArray :=( 
x"10220000",
x"20030000",
x"20040000",
x"10050000",
x"10060000",
x"20070000",
x"20080000",
x"10090000",
x"100A0000",
x"200B0000",
x"200C0000",
x"100D0000",
x"100E0000",
x"200F0000",
x"20100000",
x"10110000",
x"10120000",
x"20130000",
x"20140000",
x"10150000",
x"10160000",
x"20170000",
x"20180000",
x"10190000",
x"101A0000",
x"201B0000",
x"201C0000",
x"101D0000",
x"101E0000");
		

 
 signal instruction_pointer : integer := 1; 
	
begin
    process(clk)
    begin
        if rising_edge(clk) then  
            if CF = '0' then
                if instruction_pointer <= Instructions'length then
                    current_instruction <= Instructions(instruction_pointer);
					instruction_pointer <= instruction_pointer + 1;
                else 
                    current_instruction <= x"FFE00000"; 
                end if;	
            end if;			
            
        end if;
    end process;

end architecture Behavioral;