----------------------------------------------------------------------------------
-- Company: UCSB
-- Engineer/Physicist: Manuel Franco Sevilla
-- 
-- Create Date:     20:17:40 02/23/2013 
-- Project Name:    ODMB_mfs 
-- Target Devices:  Virtex-6
-- Tool versions:   ISE 12.3
-- Description:     Testing firmware for the ODMB
--
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

library UNISIM;
use UNISIM.VComponents.all;

entity ODMB_mfs is
    Port ( LEDS : out  STD_LOGIC_VECTOR (11 downto 0);
           PB   : in   STD_LOGIC_VECTOR ( 3 downto 0);
			  qpll_clk40MHz_p : in STD_LOGIC;
			  qpll_clk40MHz_n : in STD_LOGIC
			 );
end ODMB_mfs;

architecture ODMB_mfs_arch of ODMB_mfs is
signal clk40M, clk1 : STD_LOGIC;
signal counter : INTEGER := 0;

begin
	
	LEDS(0) <= clk1;
	LEDS(1) <= '0';
	LEDS(2) <= '0';
	LEDS(3) <= '0';
	LEDS(4) <= '1';
	LEDS(5) <= '1';
	LEDS(6) <= '1';
	LEDS(7) <= '1';
	LEDS(8) <=  not PB(0); -- PB2
	LEDS(9) <=  not PB(1); -- PB3
	LEDS(10) <= not PB(2); -- PB4
	LEDS(11) <= not PB(3); -- PB5

   qpll_clk40MHz_buf : IBUFDS port map (I=>qpll_clk40MHz_p, IB=>qpll_clk40MHz_n, O=>clk40M);
	
	Divide_Frequency : process(clk40M)
	begin
		if clk40M'event and clk40M='1' then
			if counter = 10000000 then
				counter <= 0;
				if clk1='1' then 
					clk1 <= '0';
				else 
					clk1 <= '1'; 
				end if;
			else
				counter <= counter + 1;
			end if;
		end if;
	end process Divide_Frequency;

end ODMB_mfs_arch;

