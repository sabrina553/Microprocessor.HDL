library ieee; 
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity decoder3 is 
   port( 
      clk: in std_logic;
      Instruction: in std_logic_vector(31 downto 0); 
      opcode: out std_logic_vector(5 downto 0);
      addr1, addr2, addr3: out std_logic_vector(4 downto 0)
   );   
   
end entity decoder3;  

architecture simple OF decoder3 IS   

begin 
   -- Process to decode instruction and extract opcode and addresses
   process(clk)
   begin
      if (rising_edge(clk)) THEN 
        --Extract opcode from bits 31 to 26 of the instruction 	
		opcode <= instruction(31 downto 26);	
		--Extract addresses from specific bits of the instruction
		 addr1 <= instruction(25 downto 21);	
		 addr2 <= instruction(20 downto 16);
		 addr3 <= instruction(15 downto 11);
      end if;
   end process; 
end ARCHITECTURE simple;
