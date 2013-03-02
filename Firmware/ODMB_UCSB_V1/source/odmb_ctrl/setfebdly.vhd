library ieee;
library work;
use work.Latches_Flipflops.all;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.ALL;

entity SETFEBDLY is
  
  port (
    FL1FDLY   : in  std_logic;
    SHIFT  : in  std_logic;
    FLOADID   : in  std_logic;
    FLOADDLY   : in  std_logic;
    FCBLDLY   : in  std_logic;
    BTDI   : in  std_logic;
    SEL2   : in  std_logic;
    DRCK   : in  std_logic;
    UPDATE : in  std_logic;
    RST    : in  std_logic;
    XL1ADLY   : out std_logic_vector(1 downto 0);
    SETKILLIN   : out std_logic_vector(2 downto 0);
    L1FINEDLY   : out std_logic_vector(3 downto 0);
    FEBCLKDLY   : out std_logic_vector(4 downto 0);
    CABLEDLY   : out std_logic_vector(7 downto 0);
    CRATEID   : out std_logic_vector(6 downto 0);
    TDO    : out std_logic);
 
    
end SETFEBDLY;

architecture SETFEBDLY_Arch of SETFEBDLY is

  --Declaring internal signals
signal D_DLY : std_logic_vector(28 downto 15);
signal D_ID : std_logic_vector(14 downto 8);
signal D_CDLY : std_logic_vector(7 downto 0);

signal LOADID,LOAD,LOADCDLY : std_logic;
signal TDOID,TDOCDLY,TDODLY : std_logic;
signal UPDATE_ID,UPDATE_DLY,UPDATE_CDLY : std_logic;
-----------

begin  --Architecture

  --All processes will be called CREATE_{name of signal they create}
  --If a process creates more than one signal, one name will be used and then
  --the other possible names will be in the comments
  --This is so the reader can use ctrl+f functions to find relevant processes
  
  -----------------------------------------------------------------------------
  
  JTAG_SHIFT: process (RST,SHIFT,SEL2,FLOADID,FLOADDLY,FCBLDLY,DRCK,LOADID,D_ID,LOAD,D_DLY,LOADCDLY,D_CDLY,BTDI) 

  begin

    LOADID <= SHIFT and SEL2 and FLOADID;
    LOAD <= SHIFT and SEL2 and FLOADDLY;
    LOADCDLY <= SHIFT and SEL2 and FCBLDLY;

    if (RST = '1') then

      D_ID(14 downto 8) <= "0011001";
      D_DLY(28 downto 15) <= "01010000111111";
      D_CDLY(7 downto 0) <= "00000000";
      elsif (LOADID = '1' and DRCK = '1' and DRCK'event) then
        for i in 8 to 13 loop
          D_ID(i) <= D_ID(i+1);
        end loop;
        D_ID(14) <= BTDI;
      elsif (LOAD = '1' and DRCK = '1' and DRCK'event) then
        for i in 15 to 27 loop
          D_DLY(i) <= D_DLY(i+1);
        end loop;
        D_DLY(28) <= BTDI;
      elsif (LOADCDLY = '1' and DRCK = '1' and DRCK'event) then
        for i in 0 to 6 loop
          D_CDLY(i) <= D_CDLY(i+1);
        end loop;
        D_CDLY(7) <= BTDI;
      end if;

  end process;

  JTAG_UPDATE: process (RST,UPDATE,SEL2,FLOADID,FLOADDLY,FCBLDLY,UPDATE_ID,UPDATE_DLY,UPDATE_CDLY,D_ID,D_DLY,D_CDLY) 

  begin

    UPDATE_ID <= UPDATE and SEL2 and FLOADID;
    UPDATE_DLY <= UPDATE and SEL2 and FLOADDLY;
    UPDATE_CDLY <= UPDATE and SEL2 and FCBLDLY;

    if (RST = '1') then
      CRATEID(6 downto 0) <= "0011001";
      L1FINEDLY(3 downto 0) <= "0101";
      SETKILLIN(2 downto 0) <= "000";
      XL1ADLY(1 downto 0) <= "01";
      FEBCLKDLY(4 downto 0) <= "11111";
      CABLEDLY(7 downto 0) <= "00000000";
    elsif (UPDATE_ID = '1' and UPDATE_ID'event) then
      CRATEID(6 downto 0) <= D_ID(14 downto 8);
    elsif (UPDATE_DLY = '1' and UPDATE_DLY'event) then
      L1FINEDLY(3 downto 0) <= D_DLY(28 downto 25);
      SETKILLIN(2 downto 0) <= D_DLY(24 downto 22);
      XL1ADLY(1 downto 0) <= D_DLY(21 downto 20);
      FEBCLKDLY(4 downto 0) <= D_DLY(19 downto 15); 
    elsif (UPDATE_CDLY = '1' and UPDATE_CDLY'event) then
      CABLEDLY(7 downto 0) <= D_CDLY(7 downto 0);
    end if;

  end process;


  SET_TDO: process (D_DLY,D_CDLY,D_ID)
  begin
    TDODLY <= D_DLY(15);
    TDOID <= D_ID(8);
    TDOCDLY <= D_CDLY(0);
    TDO <= (TDOCDLY and FCBLDLY) or (TDODLY and FLOADDLY) or (TDOID and FLOADID);
  end process;

end SETFEBDLY_Arch;
