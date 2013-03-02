library ieee;
library work;
use work.Latches_Flipflops.all;
use ieee.std_logic_1164.all;

entity COMMAND_MODULE is
  
  port (

    FASTCLK: in std_logic;
    SLOWCLK: in std_logic;

    GA : in std_logic_vector(5 downto 0);
    ADR : in std_logic_vector(23 downto 1);
    AM : in std_logic_vector(5 downto 0);

    AS : in std_logic;
    DS0 : in std_logic;
    DS1 : in std_logic;
    LWORD : in std_logic;
    WRITER : in std_logic; --NOTE: this is the only signal whose name was changed
    IACK : in std_logic;
    BERR : in std_logic;
    SYSFAIL : in std_logic;
    
    DEVICE   : out std_logic_vector(9 downto 0);
    STROBE   : out std_logic;
    COMMAND  : out std_logic_vector(9 downto 0);
    ADRS     : out std_logic_vector(17 downto 2);  --NOTE: output of ADRS
 
    TOVME_B    : out std_logic;
    DOE_B    : out std_logic;
 	 
    DIAGOUT  : out std_logic_vector(19 downto 0);
    LED      : out std_logic_vector(2 downto 0)
	 
    );
    
end COMMAND_MODULE;

architecture COMMAND_MODULE_Arch of COMMAND_MODULE is

  --Declaring internal signals
  signal CGA : std_logic_vector(5 downto 0);  --NOTE: replacing CGAP with CGA(5)
  signal AMS : std_logic_vector(5 downto 0);
  SIGNAL ADRS_INNER : std_logic_vector(23 downto 1);
  signal GOODAM : std_logic;
  signal VALIDAM : std_logic;
  signal VALIDGA : std_logic;
  signal SYSOK : std_logic;
  signal OLDCRATE : std_logic;
  signal PRE_BOARDENB : std_logic;
  signal BROADCAST : std_logic;
  signal BOARDENB : std_logic;
  signal BOARD_SEL_NEW : std_logic;
  signal ASYNSTRB : std_logic;
  signal ASYNSTRB_NOT : std_logic;
  signal FASTCLK_NOT : std_logic;
  signal STROBE_TEMP1 : std_logic;
  signal STROBE_TEMP2 : std_logic;
  signal ADRSHIGH : std_logic;
  signal D1,C1,Q1,D2,C2,Q2,D3,C3,Q3,D4,C4 : std_logic;
  signal D1_second,C1_second,Q1_second,D2_second,C2_second,Q2_second,D3_second,C3_second,Q3_second,D4_second,C4_second,Q4_second,D5_second,C5_second : std_logic;
  signal TOVME_INNER : std_logic;
 
  signal CE_DOE_B, CLR_DOE_B : std_logic;
  signal TIMER : std_logic_vector(7 downto 0);
  signal TOVME_INNER_B : std_logic;
  signal blank1, blank2 : std_logic;
 
  -----------------------------------------------------------------------------

begin  --Architecture

  --All processes will be called CREATE_{name of signal they create}
  --If a process creates more than one signal, one name will be used and then
  --the other possible names will be in the comments
  --This is so the reader can use ctrl+f functions to find relevant processes

  CREATE_DOE_B: process (TOVME_INNER_B, TIMER, SLOWCLK) 
  begin
    if (TOVME_INNER_B='0' and TIMER(7)='0') then
      CE_DOE_B <= '1';
    else
      CE_DOE_B <= '0';
    end if;
    
    CLR_DOE_B <= TOVME_INNER_B;
 
    CB8CE(SLOWCLK,CE_DOE_B,CLR_DOE_B,TIMER,TIMER,blank1,blank2);

	 DOE_B <= TIMER(7);
	 
  end process;
 
 -- GA[5:0]		CGA[5:0]		VALIDGA		OLDCRATE		BROADCAST	
 -- 000000		111111		0				0
 -- 000001		111110		1				0
 -- 000010		111101		1				0
 -- 000011		111100		1				0
 -- 000100		111011		1				0
 -- 000101		111010		1				0
 -- 000110		111001		1				0
 -- 000111		111000		1				0
 -- 001000		110111		1				0
 -- 001001		110110		1				0
 -- 001010		110101		1				0
 -- 001011		110100		1				0
 -- 001100		110011		1				0
 -- 001101		110010		1				0
 -- 001110		110001		1				0
 -- 001111		110000		1				0
 
 -- 111111		000000		0				1

  CREATE_VALIDGA: process (GA,CGA)
  begin  
    CGA <= not GA;
    if (CGA(0)/=CGA(1) or CGA(0)/=CGA(2) or CGA(0)/=CGA(3) or CGA(0)/=CGA(4) or CGA(0)/=CGA(5)) then
      VALIDGA <= '1';
    else
      VALIDGA <= '0';
    end if;
  end process;

  CREATE_OLDCRATE: process (CGA)
  begin  
    if (CGA="000000") then
      OLDCRATE <= '1';
    else
      OLDCRATE <= '0';
    end if;
  end process;

  CREATE_AMS: process (AM,AS)
  begin  
    ILD6(AM(5 downto 0),AS,AMS(5 downto 0));  
  end process;

  CREATE_VALIDAM: process (AMS,LWORD)   --Also could be named CREATE_GOODAM
  begin  
    if (AMS(0)/=AMS(1) and AMS(3)='1' and AMS(4)='1' and AMS(5)='1' and LWORD='1') then
      GOODAM <= '1';
      VALIDAM <= '1';
    else
      GOODAM <= '0';
      VALIDAM <= '0';
    end if;
  end process;
  
CREATE_FASTCLK_NOT: process (FASTCLK)
  begin
    FASTCLK_NOT <= not FASTCLK;
  end process;
  
  CREATE_STROBE: process (ADR,CGA,GOODAM,WRITER,VALIDGA,OLDCRATE,BROADCAST,FASTCLK,FASTCLK_NOT,ADRS_INNER, BOARD_SEL_NEW)    --Also CREATE_LED0, CREATE_LED2
  begin  
    ILD6(ADR(23 downto 18),AS,ADRS_INNER(23 downto 18));
    
    if (ADRS_INNER(23)=CGA(4) and ADRS_INNER(22)=CGA(3) and ADRS_INNER(21)=CGA(2) and ADRS_INNER(20)=CGA(1) and ADRS_INNER(19)=CGA(0)) then
      BOARD_SEL_NEW <= '1';
    else
      BOARD_SEL_NEW <= '0';
    end if;

    if (BOARD_SEL_NEW='1' and VALIDGA='1') then
      PRE_BOARDENB <= '1';
    else
      PRE_BOARDENB <= '0';
    end if;

    if (ADRS_INNER(21)='0' and ADRS_INNER(19)='1' and ADRS_INNER(22)='1' and ADRS_INNER(23)='1') then
      BROADCAST <= '1';
    else
      BROADCAST <= '0';
    end if;

    if (OLDCRATE='1' or PRE_BOARDENB='1' or BROADCAST='1') then
      BOARDENB <= '1';
    else
      BOARDENB <= '0';
    end if;
    
    if (SYSFAIL='1' and IACK='1') then
      SYSOK <= '1';
    else
      SYSOK <= '0';
    end if;

    if (GOODAM='1' and WRITER='1' and SYSOK='1' and BOARDENB='1') then
      TOVME_INNER_B <= '0';
      TOVME_B <= '0';
      LED(0) <= '1';
    else
      TOVME_INNER_B <= '1';
      TOVME_B <= '1';
      LED(0) <= '0';
    end if;

    if (SYSOK='1' and VALIDAM='1' and BOARDENB='1' and DS0='0' and DS1='0') then
      ASYNSTRB <= '1';
    else
      ASYNSTRB <= '0';
    end if;
    
    ASYNSTRB_NOT <= not ASYNSTRB;
    FDC(ASYNSTRB,FASTCLK,ASYNSTRB_NOT,STROBE_TEMP1);
    FDC_1(ASYNSTRB,FASTCLK,ASYNSTRB_NOT,STROBE_TEMP2);

    if (STROBE_TEMP1='1' and STROBE_TEMP2='1') then
      STROBE <= '1';
      LED(2) <= '0';
    else
      STROBE <= '0';
      LED(2) <= '1';
    end if;

  end process;

  CREATE_LED1: process (ASYNSTRB)
  begin
    LED(1) <= not ASYNSTRB;
  end process;
 
  
  CREATE_DIAGOUT: process (ADRS_INNER(23 downto 19),CGA,VALIDGA,SYSOK,VALIDAM,BOARD_SEL_NEW,DS0,ASYNSTRB)
  begin  
    DIAGOUT(0) <= ADRS_INNER(23);
    DIAGOUT(1) <= CGA(4);
    DIAGOUT(2) <= ADRS_INNER(21);
    DIAGOUT(3) <= CGA(2);
    DIAGOUT(4) <= ADRS_INNER(22);
    DIAGOUT(5) <= CGA(3);
    DIAGOUT(6) <= ADRS_INNER(20);
    DIAGOUT(7) <= CGA(1);
    DIAGOUT(8) <= ADRS_INNER(19);
    DIAGOUT(9) <= CGA(0);
    DIAGOUT(10) <= CGA(5);
    DIAGOUT(11) <= VALIDGA;
    DIAGOUT(12) <= SYSOK;
    DIAGOUT(13) <= VALIDAM;
    DIAGOUT(14) <= BOARD_SEL_NEW;
    DIAGOUT(15) <= DS0;
    DIAGOUT(16) <= ASYNSTRB;
    DIAGOUT(17) <= STROBE_TEMP1;
    DIAGOUT(18) <= STROBE_TEMP2;
    DIAGOUT(19) <= FASTCLK_NOT;
  end process;

  CREATE_COMMAND: process (ADRS_INNER(11 downto 2))
  begin  
    COMMAND(0) <= ADRS_INNER(2);
    COMMAND(1) <= ADRS_INNER(3);
    COMMAND(2) <= ADRS_INNER(4);
    COMMAND(3) <= ADRS_INNER(5);
    COMMAND(4) <= ADRS_INNER(6);
    COMMAND(5) <= ADRS_INNER(7);
    COMMAND(6) <= ADRS_INNER(8);
    COMMAND(7) <= ADRS_INNER(9);
    COMMAND(8) <= ADRS_INNER(10);
    COMMAND(9) <= ADRS_INNER(11);
  end process;


  CREATE_ADRS_INNER_13_18: process (ADR(18 downto 13),AS)
  begin
    ILD6(ADR(18 downto 13),AS,ADRS_INNER(18 downto 13));
  end process;
  
  CREATE_ADRS_INNER_7_12: process (ADR(12 downto 7),AS)
  begin
    ILD6(ADR(12 downto 7),AS,ADRS_INNER(12 downto 7));
  end process;
  
  CREATE_ADRS_INNER_2_6: process (ADR(6 downto 1),AS)
  begin
    ILD6(ADR(6 downto 1),AS,ADRS_INNER(6 downto 1));
  end process;

  CREATE_ADRS: process (ADRS_INNER)
  begin
    ADRS <= ADRS_INNER(17 downto 2);
  end process;

  
  
  CREATE_DEVICE: process (ADRS_INNER(18 downto 12))
  begin
    if (ADRS_INNER(18)='1' or ADRS_INNER(17)='1' or ADRS_INNER(16)='1') then
      ADRSHIGH <= '1';
    else
      ADRSHIGH <= '0';
    end if;

    if (ADRS_INNER(12)='0' and ADRS_INNER(13)='0' and ADRS_INNER(14)='0' and ADRS_INNER(15)='0' and ADRSHIGH='0') then
      DEVICE(0) <= '1';
    else
      DEVICE(0) <= '0';
    end if;

    if (ADRS_INNER(12)='1' and ADRS_INNER(13)='0' and ADRS_INNER(14)='0' and ADRS_INNER(15)='0' and ADRSHIGH='0') then
      DEVICE(1) <= '1';
    else
      DEVICE(1) <= '0';
    end if;

    if (ADRS_INNER(12)='0' and ADRS_INNER(13)='1' and ADRS_INNER(14)='0' and ADRS_INNER(15)='0' and ADRSHIGH='0') then
      DEVICE(2) <= '1';
    else
      DEVICE(2) <= '0';
    end if;

    if (ADRS_INNER(12)='1' and ADRS_INNER(13)='1' and ADRS_INNER(14)='0' and ADRS_INNER(15)='0' and ADRSHIGH='0') then
      DEVICE(3) <= '1';
    else
      DEVICE(3) <= '0';
    end if;

    if (ADRS_INNER(12)='0' and ADRS_INNER(13)='0' and ADRS_INNER(14)='1' and ADRS_INNER(15)='0' and ADRSHIGH='0') then
      DEVICE(4) <= '1';
    else
      DEVICE(4) <= '0';
    end if;

    if (ADRS_INNER(12)='1' and ADRS_INNER(13)='0' and ADRS_INNER(14)='1' and ADRS_INNER(15)='0' and ADRSHIGH='0') then
      DEVICE(5) <= '1';
    else
      DEVICE(5) <= '0';
    end if;

    if (ADRS_INNER(12)='0' and ADRS_INNER(13)='1' and ADRS_INNER(14)='1' and ADRS_INNER(15)='0' and ADRSHIGH='0') then
      DEVICE(6) <= '1';
    else
      DEVICE(6) <= '0';
    end if;

    if (ADRS_INNER(12)='1' and ADRS_INNER(13)='1' and ADRS_INNER(14)='1' and ADRS_INNER(15)='0' and ADRSHIGH='0') then
      DEVICE(7) <= '1';
    else
      DEVICE(7) <= '0';
    end if;

    if (ADRS_INNER(12)='0' and ADRS_INNER(13)='0' and ADRS_INNER(14)='0' and ADRS_INNER(15)='1' and ADRSHIGH='0') then
      DEVICE(8) <= '1';
    else
      DEVICE(8) <= '0';
    end if;

    if (ADRS_INNER(12)='1' and ADRS_INNER(13)='0' and ADRS_INNER(14)='0' and ADRS_INNER(15)='1' and ADRSHIGH='0') then
      DEVICE(9) <= '1';
    else
      DEVICE(9) <= '0';
    end if;
    
  end process;

end COMMAND_MODULE_Arch;
