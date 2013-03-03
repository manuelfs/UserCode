library ieee;
library work;
use work.Latches_Flipflops.all;
use ieee.std_logic_1164.all;

entity VMEMON is
  
  port (

    SLOWCLK  : in  std_logic;
    RST      : in  std_logic;

    DEVICE   : in  std_logic;
    STROBE   : in  std_logic;
    COMMAND  : in  std_logic_vector(9 downto 0);

    INDATA   : in  std_logic_vector(15 downto 0);
    OUTDATA  : out std_logic_vector(15 downto 0);

    DTACK    : out std_logic;

    FLFCTRL  : out std_logic_vector(15 downto 0);
    FLFDATA  : in std_logic_vector(15 downto 0)
 
 );
end VMEMON;


architecture VMEMON_Arch of VMEMON is

  --Declaring internal signals
  signal CMDHIGH : std_logic;
  signal BUSY : std_logic;
  signal WRITECTRL,READCTRL,READDATA : STD_LOGIC;

  signal DTACK_INNER : std_logic;
  signal FLFCTRL_INNER : std_logic_vector(15 downto 0);
  signal D_OUTDATA_1,Q_OUTDATA_1,D_OUTDATA_2,Q_OUTDATA_2 : std_logic;
  
begin  

  CREATE_CMDHIGH: process (COMMAND,DEVICE)
  begin
    
    if (COMMAND(9)='0' and COMMAND(8)='0' and COMMAND(7)='0' and COMMAND(6)='0' and COMMAND(5)='0' and COMMAND(4)='0' and DEVICE='1') then
      CMDHIGH <= '1';
    else
      CMDHIGH <= '0';
    end if;
  end process;

  CREATE_DECODE: process (COMMAND,CMDHIGH)
  begin
    if (COMMAND(3)='0' and COMMAND(2)='0' and COMMAND(1)='0' and COMMAND(0)='0' and CMDHIGH='1') then
      WRITECTRL <= '1';
    else
      WRITECTRL <= '0';
    end if;

    if (COMMAND(3)='0' and COMMAND(2)='0' and COMMAND(1)='0' and COMMAND(0)='1' and CMDHIGH='1') then
      READCTRL <= '1';
    else
      READCTRL <= '0';
    end if;

    if (COMMAND(3)='0' and COMMAND(2)='0' and COMMAND(1)='1' and COMMAND(0)='0' and CMDHIGH='1') then
      READDATA <= '1';
    else
      READDATA <= '0';
    end if;

  end process;

  CREATE_OUTDATA_1: process (RST,INDATA,WRITECTRL,READCTRL,STROBE,SLOWCLK,FLFCTRL_INNER,D_OUTDATA_1,Q_OUTDATA_1)
  begin
    
    FDCE(INDATA(0),STROBE,WRITECTRL,RST,FLFCTRL_INNER(0));
    FDCE(INDATA(1),STROBE,WRITECTRL,RST,FLFCTRL_INNER(1));
    FDCE(INDATA(2),STROBE,WRITECTRL,RST,FLFCTRL_INNER(2));
    FDCE(INDATA(3),STROBE,WRITECTRL,RST,FLFCTRL_INNER(3));
    FDCE(INDATA(4),STROBE,WRITECTRL,RST,FLFCTRL_INNER(4));
    FDCE(INDATA(5),STROBE,WRITECTRL,RST,FLFCTRL_INNER(5));
    FDCE(INDATA(6),STROBE,WRITECTRL,RST,FLFCTRL_INNER(6));
    FDCE(INDATA(7),STROBE,WRITECTRL,RST,FLFCTRL_INNER(7));
    FDCE(INDATA(8),STROBE,WRITECTRL,RST,FLFCTRL_INNER(8));
    FDCE(INDATA(9),STROBE,WRITECTRL,RST,FLFCTRL_INNER(9));
    FDCE(INDATA(10),STROBE,WRITECTRL,RST,FLFCTRL_INNER(10));
    FDCE(INDATA(11),STROBE,WRITECTRL,RST,FLFCTRL_INNER(11));
    FDCE(INDATA(12),STROBE,WRITECTRL,RST,FLFCTRL_INNER(12));
    FDCE(INDATA(13),STROBE,WRITECTRL,RST,FLFCTRL_INNER(13));
    FDCE(INDATA(14),STROBE,WRITECTRL,RST,FLFCTRL_INNER(14));
    FDCE(INDATA(15),STROBE,WRITECTRL,RST,FLFCTRL_INNER(15));
 
 	 FLFCTRL <= FLFCTRL_INNER;
 
    if (STROBE='1' and READCTRL='1') then
      OUTDATA(15 downto 0) <= FLFCTRL_INNER(15 downto 0);
    else
      OUTDATA(15 downto 0) <= "ZZZZZZZZZZZZZZZZ";
    end if;
    
    if (STROBE='1') and ((WRITECTRL = '1') or (READCTRL='1')) then
      D_OUTDATA_1 <= '1';
    else
      D_OUTDATA_1 <= '0';
    end if;
    
    FD(D_OUTDATA_1,SLOWCLK,Q_OUTDATA_1);

    if (Q_OUTDATA_1='1') then
      DTACK_INNER <= '0';
    else
      DTACK_INNER <= 'Z';
    end if;

  end process;

  CREATE_OUTDATA_2: process (RST,INDATA,READDATA,STROBE,SLOWCLK,FLFDATA,D_OUTDATA_2,Q_OUTDATA_2)
  begin
    
    if (STROBE='1' and READDATA='1') then
      OUTDATA(15 downto 0) <= FLFDATA(15 downto 0);
      D_OUTDATA_2 <= '1';
    else
      OUTDATA(15 downto 0) <= "ZZZZZZZZZZZZZZZZ";
      D_OUTDATA_2 <= '0';
    end if;
    
    FD(D_OUTDATA_2,SLOWCLK,Q_OUTDATA_2);

    if (Q_OUTDATA_2='1') then
      DTACK_INNER <= '0';
    else
      DTACK_INNER <= 'Z';
    end if;

  end process;
 
  SET_DTACK: process (DTACK_INNER)
  begin  
   DTACK <= DTACK_INNER;
  end process;


end VMEMON_Arch;
