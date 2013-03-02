library ieee;
library work;
use work.Latches_Flipflops.all;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.ALL;

entity SETCALDLY is
  
  port (
    SHIFT  : in  std_logic;
    FLXDLY   : in  std_logic;
    FLOAD   : in  std_logic;
    BTDI   : in  std_logic;
    SEL2   : in  std_logic;
    DRCK   : in  std_logic;
    UPDATE : in  std_logic;
    RST    : in  std_logic;
    CALLCTDLY   : out std_logic_vector(3 downto 0);
    CALGDLY   : out std_logic_vector(4 downto 0);     
    EXTDLY   : out std_logic_vector(4 downto 0);
    INJDLY   : out std_logic_vector(4 downto 0);
    XL1ADLY   : out std_logic_vector(1 downto 0);
    TDO    : out std_logic);
 
    
end SETCALDLY;

architecture SETCALDLY_Arch of SETCALDLY is

  --Declaring internal signals
signal D : std_logic_vector(20 downto 2);
signal DD : std_logic_vector(1 downto 0);
signal LOAD,FUPD,LOAD_FLXDLY,UPD_FLXDLY : std_logic;
-----------

begin  --Architecture

  --All processes will be called CREATE_{name of signal they create}
  --If a process creates more than one signal, one name will be used and then
  --the other possible names will be in the comments
  --This is so the reader can use ctrl+f functions to find relevant processes
  
  -----------------------------------------------------------------------------

  JTAG_SHIFT: process (RST,SHIFT,SEL2,FLOAD,FLXDLY,DRCK,LOAD,D,LOAD_FLXDLY,DD,BTDI) 

  begin

    LOAD <= SHIFT and SEL2 and FLOAD;
    LOAD_FLXDLY <= SHIFT and SEL2 and FLXDLY;

    if (RST = '1') then
      D(20 downto 2) <= "0110001100101011000";
      DD(1 downto 0) <= "01";
    elsif (LOAD = '1' and DRCK = '1' and DRCK'event) then
      for i in 2 to 19 loop
        D(i) <= D(i+1);
      end loop;
       D(20) <= BTDI;
   elsif (LOAD_FLXDLY = '1' and DRCK = '1' and DRCK'event) then
      DD(0) <= DD(1);
      DD(1) <= BTDI;
    end if;
  end process;

  JTAG_UPDATE: process (RST,UPDATE,UPD_FLXDLY,FLXDLY,FLOAD,SEL2,FUPD,D,DD) 

  begin

    FUPD <= UPDATE and SEL2 and FLOAD;
    UPD_FLXDLY <= UPDATE and SEL2 and FLXDLY;

    if (RST = '1') then
      INJDLY(4 downto 0) <= "01100";
      EXTDLY(4 downto 0) <= "01100";
      CALGDLY(4 downto 0) <= "10101";
      CALLCTDLY(3 downto 0) <= "1000";
      XL1ADLY(1 downto 0) <= "01";
    elsif (FUPD = '1' and FUPD'event) then
      INJDLY(4 downto 0) <= D(20 downto 16);
      EXTDLY(4 downto 0) <= D(15 downto 11);
      CALGDLY(4 downto 0) <= D(10 downto 6);
      CALLCTDLY(3 downto 0) <= D(5 downto 2);
    elsif (UPD_FLXDLY = '1' and UPD_FLXDLY'event) then
      XL1ADLY(1 downto 0) <= DD(1 downto 0);
    end if;
      
  end process;


  SET_TDO: process (D,LOAD)
  begin
    TDO <= D(2) and LOAD;
  end process;

end SETCALDLY_Arch;
