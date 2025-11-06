library ieee; 
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity decoder is 
	port( 
	
	clk: in std_logic;
	Instruction: in std_logic_vector(31 downto 0); 
	opcode: out std_logic_vector(5 downto 0);
	addr1, addr2, addr3: out std_logic_vector(4 downto 0));	 
	
	
	
end entity decoder;  

architecture simple OF decoder IS	  	 
BEGIN 
	
	process(clk)
	BEGIN
		if (rising_edge(clk)) THEN	
			opcode <= instruction(31 downto 26);
			addr1 <= instruction(25 downto 21);
			addr2 <= instruction(20 downto 16);
			addr3 <= instruction(15 downto 11);		
		 END if;
	END process; 
	
END ARCHITECTURE simple;