library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity micro_testbench2 is
end entity;

architecture test2 of micro_testbench2 is
	constant ClockFreq : integer := 1000e6;
	constant ClockPeriod : time := 1000 ms / ClockFreq;	 	
	
	signal Clk :std_logic := '0'; 
	
	signal Instruction: std_logic_vector(31 downto 0);
	signal out1, outrom, memtoalu1, memtoalu2: std_logic_vector (31 downto 0); 
	
begin 
	
	clk <= not Clk after ClockPeriod / 2; 	
	
	   		
			
	g1: entity work.micro2(rtl)
	port map (clk=>clk, Instruction=>Instruction, result=>out1, romread=>outrom, romin1=>memtoalu1, romin2=>memtoalu2);
	instruction <= 
	b"00010000100001010000100000000000",	  				--000100 00100 00101 00001 00000000000 	r4+r5 -> r1
	b"00010001111011011111100000000000" after 20 ns,		--000100 01111 01101 11111 00000000000
	b"00010001000000001111100000000000" after 40ns,			--000100 01000 00000 11111 00000000000
	b"00010001010011101111100000000000" after 60ns,			--000100 01010 01110 11111 00000000000
	b"00010001001111101111100000000000" after 80ns;			--000100 01001 11110 11111 00000000000		
	
		
end architecture;	

