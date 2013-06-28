LIBRARY ieee;
use IEEE.STD_LOGIC_UNSIGNED.all;
USE IEEE.std_logic_arith.all;
USE ieee.std_logic_1164.all;

--  Entity Declaration

ENTITY vme_outdata_sel IS
	PORT
	(

		device : IN STD_LOGIC_VECTOR(9 downto 0);
		device1_outdata : IN STD_LOGIC_VECTOR(15 downto 0);
		device2_outdata : IN STD_LOGIC_VECTOR(15 downto 0);
		device3_outdata : IN STD_LOGIC_VECTOR(15 downto 0);
		device8_outdata : IN STD_LOGIC_VECTOR(15 downto 0);
		device9_outdata : IN STD_LOGIC_VECTOR(15 downto 0);
		outdata : OUT STD_LOGIC_VECTOR(15 downto 0)
		
	);
	
END vme_outdata_sel;

--  Architecture Body

ARCHITECTURE vme_outdata_sel_architecture OF vme_outdata_sel IS

begin
  
vme_data_sel : process (device,device1_outdata,device2_outdata,device3_outdata,device8_outdata,device9_outdata)
    
begin		
					  
   	case device is

	    when "0000000010" =>	outdata <= device1_outdata;
	    when "0000000100" =>	outdata <= device2_outdata;
	    when "0000001000" =>	outdata <= device3_outdata;
	    when "0100000000" =>	outdata <= device8_outdata;
	    when "1000000000" =>	outdata <= device9_outdata;
	    when others =>	outdata <= "0000000000000000";
	      
  end case;
  
end process;

END vme_outdata_sel_architecture;
 
