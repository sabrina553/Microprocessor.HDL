library ieee; 
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity rom1 is 
	port( 
	
	romin1, romin2: in std_logic_vector(4 downto 0);
	romout1, romout2: out std_logic_vector(31 downto 0));
	
	
end entity rom1;  

architecture write1 OF rom1 IS
	TYPE rom_array is array (0 to 31) of STD_LOGIC_VECTOR (31 downto 0);
	
	SIGNAL rom_Data: rom_array:=
	(x"00000000", x"00011388", x"0000A6A2", x"00010645", x"0000658E", x"0000658E", x"0001527A",
	 x"0000FAD3", x"0000DB03", x"00009CDF", x"0001105B", x"000070BD", x"0000E891", x"000083BE",
	 x"00005D69", x"00014C5F", x"00005945", x"000119FF", x"0001571D", x"000013B2", x"00014B94", 
	 x"0000593A", x"00012D64", x"000043D3", x"00015500", x"0000B03D", x"0001639A", x"00011D3D", 
	 x"0000DC7C", x"0000D28C", x"00013444", x"00000000");
BEGIN 
	
			romout1 <= rom_data (CONV_INTEGER (romin1) );
			romout2 <= rom_data (CONV_INTEGER (romin2) );  
		
end ARCHITECTURE;