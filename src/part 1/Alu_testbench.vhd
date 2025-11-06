library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;

entity ALU_testbench is 
end entity ALU_testbench;

architecture test of ALU_testbench is  
	signal in1, in2, out1: std_logic_vector (31 downto 0);
	signal in3: std_logic_vector (5 downto 0); 
	
begin
	g1: entity work.alu1(dataflow)
		port map (a=>in1, b=>in2, opcode=>in3, c=>out1);
	in1 <= X"0001ffff", X"0FAFffff" after 20 ns, X"F000ffff" after 40ns; 
	in2 <= X"0100ffff", X"7FFFffff" after 10ns, X"FFFFffff" after 30ns;
	in3 <= "101000";
end architecture test;