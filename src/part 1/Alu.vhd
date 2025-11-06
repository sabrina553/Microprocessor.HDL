library ieee; 
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;

entity alu1 is 
	port  (   				
			a, b: in std_logic_vector(31 downto 0);
			opcode: in std_logic_vector(5 downto 0);
			c: out std_logic_vector(31 downto 0) ); 
			
end entity alu1; 

architecture dataflow of alu1 is 
	begin
	
			c <= a + b when opcode="000100"
			else a - b when opcode="001000"
			else abs(a) when opcode="001011"  
			else -a when opcode="001010"
			else abs(b) when opcode="001110"
			else -b when opcode="000110"
			else a or b when opcode="000111" 
			else not(a) when opcode="001001"
			else not(b) when opcode="001111" 
			else a and b when opcode="000010"	 
			else a xor b when opcode="000011"
			else x"FFFFFFFF";		
		
	
end architecture dataflow;

