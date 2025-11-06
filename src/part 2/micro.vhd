library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;

entity micro2 is 
	port ( 
	clk : in std_logic;
	Instruction: in std_logic_vector(31 downto 0);
	result: inout std_logic_vector(31 downto 0);		
	
	romread, romin1, romin2: out std_logic_vector(31 downto 0)
	);
end entity micro2;

architecture rtl of micro2 is 
	signal MEMtoALU1, MEMtoALU2: std_logic_vector(31 downto 0);
	signal addrs1, addrs2, addrs3: std_logic_vector(4 downto 0);	
	signal op: std_logic_vector(5 downto 0);  
	signal write : std_logic_vector(31 downto 0);
begin 
	g0: entity work.decoder2(simple)
		port map(Instruction, op, addrs1, addrs2, addrs3);	  	--Instruction, opcode ,addr1, addr2, addr3
	
	
	g1: entity work.ROM2(write)
		port map(clk, addrs1, addrs2, addrs3, result, MEMtoALU1, MEMtoALU2, write);	   -- clk, romin1, romin2, romin3	romwrite1			romout1, romout2, romout3: 
		romread <= write;
		romin1 <= MEMtoALU1;
		romin2 <= MeMtoALU2; 
		
	g2: entity work.ALU2(dataflow)
		port map(clk, MEMtoALU1, MEMtoALU2, op, result);	-- clk 	a, b	opcode		c 	 
					
end architecture;



			 									 
			