library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;

entity micro is 
	port ( 
	addrs1, addrs2: in std_logic_vector(4 downto 0);	
	op: in std_logic_vector(5 downto 0);
	result: out std_logic_vector(31 downto 0)
	);
end entity micro;

architecture rtl of micro is 
	signal MEMtoALU1, MEMtoALU2: std_logic_vector(31 downto 0);

begin
	g0: entity work.rom1(write1)
		port map(addrs1, addrs2, MEMtoALU1, MEMtoALU2);	
	
	g1: entity work.Alu1(dataflow)
		port map(MEMtoALU1, MEMtoALU2, op, result);		
				
end;
