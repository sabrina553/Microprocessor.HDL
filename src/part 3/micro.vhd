library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;

entity micro3 is 
	port ( 
	clk : in std_logic;
	Instruction: in std_logic_vector(31 downto 0);
	result: inout std_logic_vector(31 downto 0);		
	
	romread, romin1, romin2: out std_logic_vector(31 downto 0)
	);
end entity micro3;

architecture rtl of micro3 is 
	signal MEMtoALU1, MEMtoALU2: std_logic_vector(31 downto 0);
	signal addrs1, addrs2, addrs3: std_logic_vector(4 downto 0);	
	signal op: std_logic_vector(5 downto 0);  
	signal write : std_logic_vector(31 downto 0); 
	
	

component decoder3 is	

    port(
	clk: in std_logic;
	Instruction: in std_logic_vector(31 downto 0);
	op: out std_logic_vector(5 downto 0);
	addr1: out std_logic_vector(4 downto 0);
	addr2: out std_logic_vector(4 downto 0); 
	addr3: out std_logic_vector(4 downto 0)
	);

    

end component;	

	

component ROM3 is

    port(
	clk: in std_logic;
	addrs1: in std_logic_vector(4 downto 0);
	addrs2: in std_logic_vector(4 downto 0);
	addrs3: in std_logic_vector(4 downto 0);
	result: out std_logic_vector(31 downto 0); 
	MEMtoALU1: out std_logic_vector(31 downto 0);  
	MEMtoALU2: out std_logic_vector(31 downto 0);
	write: in std_logic_vector(31 downto 0)
	);

    

end component;	
		   

component ALU3 is

    port(
	clk: in std_logic;
	MEMtoALU1: in std_logic_vector(31 downto 0);
	MEMtoALU2: inout std_logic_vector(31 downto 0);
	op: out std_logic_vector(5 downto 0);
	result: out std_logic_vector(31 downto 0)
	
	);

    

end component;	
	
	
begin 				 
		romread <= write;
		romin1 <= MEMtoALU1;
		romin2 <= MeMtoALU2;					
end architecture;



			 									 
			