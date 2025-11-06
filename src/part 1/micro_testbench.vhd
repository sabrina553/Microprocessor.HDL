library ieee;
use ieee.std_logic_1164.all; 
use ieee.std_logic_signed.all;


entity micro_testbench is	   
end entity micro_testbench;	

architecture test of micro_testbench is			    
	signal in1, in2: std_logic_vector (4 downto 0);	 
	signal op: std_logic_vector(5 downto 0);
	signal out1: std_logic_vector (31 downto 0); 
	
begin
	g1: entity work.micro(rtl)
	port map (addrs1=>in1, addrs2=>in2, op=>op, result=>out1);
	in1 <= b"01011", b"01111" after 20 ns, b"01000" after 40ns; 
	in2 <= b"11011", b"01101" after 30ns, b"00000" after 50ns; 
	op <= b"000100";
end architecture test;



