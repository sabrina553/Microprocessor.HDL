library ieee; 
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;

entity alu3 is 
	port  (  
			clk : in std_logic;	
			addrs1, addrs2: in std_logic_vector(31 downto 0);
			opcode: in std_logic_vector(5 downto 0);			
			pipeline_out: out std_logic_vector(31 downto 0) ); 
			
end entity alu3; 

architecture dataflow of alu3 is 
	signal op_pipeline1, op_pipeline2:  std_logic_vector(5 downto 0);
	signal c: std_logic_vector(31 downto 0);
	signal a, b: std_logic_vector(31 downto 0);
begin 	
		
	process(clk)
		BEGIN
			if (rising_edge(clk)) THEN
				op_pipeline1 <= opcode;
				
				
				a <= addrs1;
				b <= addrs2;
				
				case op_pipeline1 is
					when "000100" => c <= a + b; 
					when "001000" => c <= a - b; 	 
					when "001011" => c <= abs(a);  
					when "001010" => c <= -a; 
					when "001110" => c <= abs(b); 
					when "000110" => c <= -b; 
					when "000111" => c <= a or b; 
					when "001001" => c <= not(a); 
					when "001111" => c <= not(b); 
					when "000010" => c <= a and b; 
					when "000011" => c <= a xor b; 
					when others   => c <= x"FFFFFFFF"; 
				pipeline_out <= c;	
				end case;	
			 END IF;
		END PROCESS;
		
	
end architecture dataflow;

