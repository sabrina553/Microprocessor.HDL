library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;

entity controller is 
    port  (  
        clk : in std_logic;     
        Instruction: in std_logic_vector(31 downto 0);            
        a, b, c: in std_logic_vector(4 downto 0); 
        opcode: in std_logic_vector(5 downto 0); -- DOF control  
        opcode_pipe: out std_logic_vector(5 downto 0);
        CF, WE, RE, EX, FLa, FLb: out std_logic;  -- control flow (instructions), write enable, read enable (ROM), ex (result register), Forward Logic (result)  
   		result: in std_logic_vector(31 downto 0)
        );
end entity controller; 

architecture dataflow of controller is 

    signal opcode_next: std_logic_vector(5 downto 0);
    signal a_next, b_next, c_next: std_logic_vector(4 downto 0);  
    
  
    
    signal WEpipe1, WEpipe2: std_logic;     
    signal FLApipe1, FLBpipe1: std_logic; 
	
	signal instruction_pointer : integer := 1; 
	signal opcodepipe1: std_logic_vector(5 downto 0);
	
begin 

    process(clk)    
   	
    begin   	   
		CF <= '0';
		RE <= '0';
		wE <= '1';
        if rising_edge(clk) then
			opcodepipe1 <= opcode;
            opcode_pipe <= opcode;


            opcode_next <= Instruction(31 downto 26);
            a_next <= Instruction(25 downto 21);
            b_next <= Instruction(20 downto 16);
            c_next <= Instruction(15 downto 11);    
         
			--case opcode is
--				when "000100" | "001000" | "001011" | "001010" | "001110" | "000110" |
--					"000111" | "001001" | "001111" | "000010" | "000011" =>
--					WE <= '1';
--				when others =>
--					WE <= '0';
--			end case; 
--            
--            WE <= WEpipe1;
--            WE <= WEpipe2;
            
            -- Forward Logic
           	if result >= x"0000000000" then
	            if (Instruction(25 downto 21) = c) then
	                FLApipe1 <= '1';    
	                FLBpipe1 <= '0';                    
	            elsif (Instruction(20 downto 16) = c) then
	                FLApipe1 <= '0';
	                FLBpipe1 <= '1'; 
	            else 
	                FLApipe1 <= '0';
	                FLBpipe1 <= '0';                    
	            end if;              
             end if;
			instruction_pointer <= instruction_pointer +1;
            FLa <= FLApipe1;
            FLb <= FLBpipe1; 
             
			 
			
             ---- Control flow and read enable logic
--             if (c = a_next) then 
--				counter := counter + 1;
--	 			CF<= '1';
--				 if counter = 1 then  -- Changed to two-cycle pause
--                    CF <= '1';
--                    RE <= '1';						
--                end if;	 				
--                if counter = 2 then  -- Changed to two-cycle pause						
--                    CF <= '0';
--                    RE <= '0';	
--					counter := 0;
--                end if;	
--				
--            elsif (c = b_next) then
--				counter := counter + 1;	
--				CF <= '1';
--				 if counter = 1 then  -- Changed to two-cycle pause
--                    CF <= '1';
--                    RE <= '1';					
--                end if;						
--				
--                if counter = 2 then  -- Changed to two-cycle pause
--                    CF <= '0';
--                    RE <= '0';
--					counter := 0;
--                end if;    
--            else 
--                CF <= '0';
--                RE <= '0';
--                                     
--            end if;       
                          
            
        end if;
    end process; 
end architecture;
