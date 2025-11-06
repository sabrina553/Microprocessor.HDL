library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity programme is
end entity;

architecture test of programme is
	constant ClockFreq : integer := 1e6;
	constant ClockPeriod : time := 1000 ms / ClockFreq;	 	
	
	signal Clk :std_logic := '0';  	
	
	signal Instruction, out1, outrom, memtoalu1, memtoalu2: std_logic_vector (31 downto 0); 
	
	
	
	TYPE programme_array  is array (0 to 31) of STD_LOGIC_VECTOR (31 downto 0);
	CONSTANT program_Instruction: programme_array:=	(b"00010000000000010000000000000000",
b"00010000000000100000000000000000",
b"00010000000001010000000000000000",
b"00010000000001100000000000000000",
b"00010000000010010000000000000000",
b"00010000000010100000000000000000",
b"00010000000011010000000000000000",
b"00010000000011100000000000000000",
b"00010000000100010000000000000000",
b"00010000000100100000000000000000",
b"00010000000101010000000000000000",
b"00010000000101100000000000000000",
b"00010000000110010000000000000000",
b"00010000000110100000000000000000",
b"00010000000111010000000000000000",
b"00010000000111100000000000000000",
b"00010011111000111111100000000000",
b"00010011111001001111100000000000",
b"00010011111001111111100000000000",
b"00010011111010001111100000000000",
b"00010011111010111111100000000000",
b"00010011111011001111100000000000",
b"00010011111011111111100000000000",
b"00010011111100001111100000000000",
b"00010011111100111111100000000000",
b"00010011111101001111100000000000",
b"00010011111101111111100000000000",
b"00010011111110001111100000000000",
b"00010011111110111111100000000000",
b"00010011111111001111100000000000",
b"00100000000111111111100000000000",
b"00100000000000000000000000000000"); 
		

component micro3 is

    port(
	clk: in std_logic;
	Instruction: in std_logic_vector(31 downto 0);
	result: inout std_logic_vector(31 downto 0);
	romread: out std_logic_vector(31 downto 0);
	romin1: out std_logic_vector(31 downto 0); 
	romin2: out std_logic_vector(31 downto 0)
	);

    

end component;		 
		 
		 
 	 
	 
begin 
	dut: micro3 port map(
		clk => clk,
		Instruction => Instruction,
		result => out1,
		romread => outrom,
		romin1 => memtoalu1,
		romin2 => memtoalu2

	);
	clk <= not Clk after ClockPeriod / 2; 	
	
	process(clk)
	variable i : integer := 0;
		BEGIN
			if (rising_edge(clk) and i < 32) THEN
				Instruction <= program_Instruction(i);	
				
				
				i := i +1;
				
			END IF;
		END PROCESS;	



	
		
end architecture;	



























