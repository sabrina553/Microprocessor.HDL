library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;

entity ROM_testbench is	   
end entity ROM_testbench;	

architecture test of ROM_testbench is			    
	signal in1, in2: std_logic_vector (4 downto 0);
	signal out1, out2: std_logic_vector (31 downto 0);	 	
	
begin
	g1: entity work.ROM1(write1)
		port map (romin1=>in1, romin2=>in2, romout1=>out1, romout2=>out2);
	in1 <= b"00001", b"10000" after 20 ns, b"11111" after 40ns; 
	in2 <= b"01010", b"01101" after 10ns, b"01101" after 30ns;
end architecture test;
										  	