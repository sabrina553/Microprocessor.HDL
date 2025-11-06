library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;

entity ALU3 is 
   port  (  
         clk : in std_logic;   
         a, b: in std_logic_vector(31 downto 0);
         opcode: in std_logic_vector(5 downto 0);          
         result: inout std_logic_vector(31 downto 0);
		 ResultPipe: out std_logic_vector(31 downto 0);
         FLa, FLb: in std_logic
      );  
end entity ALU3; 

architecture Dataflow of ALU3 is
   signal input_a, input_b: std_logic_vector(31 downto 0);
   signal result_pipe, result_pipe2: std_logic_vector(31 downto 0);

begin
   process(clk)     
   begin  		  
      if rising_edge(clk) then 	
         --ALU operation based on opcode 
		 if FLa = '1' and FLb = '0' then 
		    case opcode is
		        when "000100" => result <= result + b;   -- Addition                         
		        when "001000" => result <= result - b;   -- Subtraction
		        when "001011" => result <= abs(result);  -- Absolute value of 'a'
		        when "001010" => result <= -result;      -- Negation of 'a'
		        when "001110" => result <= abs(b);  -- Absolute value of 'b'
		        when "000110" => result <= -b;      -- Negation of 'b'
		        when "000111" => result <= result or b;  -- Bitwise OR of 'a' and 'b'
		        when "001001" => result <= not(a);  -- Bitwise NOT of 'a'
		        when "001111" => result <= not(b);  -- Bitwise NOT of 'b'
		        when "000010" => result <= result and b; -- Bitwise AND of 'a' and 'b'
		        when "000011" => result <= result xor b; -- Bitwise XOR of 'a' and 'b'
		        when others   => result <= (others => '0');  -- Default to no op
		    end case;  
			elsif FLa = '0' and FLb = '1' then
			    case opcode is
			        when "000100" => result <= a + result;   -- Addition                         
			        when "001000" => result <= a - result;   -- Subtraction
			        when "001011" => result <= abs(a);  -- Absolute value of 'a'
			        when "001010" => result <= -a;      -- Negation of 'a'
			        when "001110" => result <= abs(result);  -- Absolute value of 'b'
			        when "000110" => result <= -result;      -- Negation of 'b'
			        when "000111" => result <= a or result;  -- Bitwise OR of 'a' and 'b'
			        when "001001" => result <= not(a);  -- Bitwise NOT of 'a'
			        when "001111" => result <= not(result);  -- Bitwise NOT of 'b'
			        when "000010" => result <= a and result; -- Bitwise AND of 'a' and 'b'
			        when "000011" => result <= a xor result; -- Bitwise XOR of 'a' and 'b'
			        when others   => result <= (others => '0');  -- Default to no op
			    end case;
			else
			    case opcode is
			        when "000100" => result <= a + b;   -- Addition                         
			        when "001000" => result <= a - b;   -- Subtraction
			        when "001011" => result <= abs(a);  -- Absolute value of 'a'
			        when "001010" => result <= -a;      -- Negation of 'a'
			        when "001110" => result <= abs(b);  -- Absolute value of 'b'
			        when "000110" => result <= -b;      -- Negation of 'b'
			        when "000111" => result <= a or b;  -- Bitwise OR of 'a' and 'b'
			        when "001001" => result <= not(a);  -- Bitwise NOT of 'a'
			        when "001111" => result <= not(b);  -- Bitwise NOT of 'b'
			        when "000010" => result <= a and b; -- Bitwise AND of 'a' and 'b'
			        when "000011" => result <= a xor b; -- Bitwise XOR of 'a' and 'b'
			        when others   => result <= (others => '0');  -- Default to no op
			    end case; 
			end if;

      end if;
	end process; 
				   
end architecture;
