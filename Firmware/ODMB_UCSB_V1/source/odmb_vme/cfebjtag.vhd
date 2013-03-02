library ieee;
library work;
use work.Latches_Flipflops.all;
use ieee.std_logic_1164.all;

entity CFEBJTAG_BGB is
  
  port (

    FASTCLK : in std_logic;
    SLOWCLK : in std_logic;
    RST : in std_logic;

    DEVICE : in std_logic;
    STROBE : in std_logic;
    COMMAND : in std_logic_vector(9 downto 0);
    WRITER : in std_logic;

    INDATA : in std_logic_vector(15 downto 0);
    OUTDATA : out std_logic_vector(15 downto 0);

    DTACK : out std_logic;
 
	  INITJTAGS : in std_logic;
    TCK : out std_logic_vector(7 downto 1);
    TDI : out std_logic;
    TMS : out std_logic;
    FEBTDO : in std_logic_vector(7 downto 1);
	  DL_RTN_SHFT_EN  : IN STD_LOGIC_VECTOR (7 downto 1);	-- BGB
	  UL_JTAG_TCK : IN STD_LOGIC_VECTOR (7 downto 1);		-- BGB				

    LED : out std_logic;
    DIAGOUT : out std_logic_vector(17 downto 0)
    );

end CFEBJTAG_BGB;

architecture CFEBJTAG_BGB_Arch of CFEBJTAG_BGB is

  --Declaring internal signals
  signal FEBTDO_INNER : std_logic_vector(7 downto 1);
  signal TCK_INNER : std_logic_vector(7 downto 1);
  signal TDI_INNER : std_logic;
  signal TMS_INNER : std_logic;
  signal DTACK_INNER : std_logic;
  signal CMDHIGH : std_logic;
  signal SELFEB : std_logic_vector(7 downto 1);  
  signal DATASHFT,INSTSHFT,READTDO,SELCFEB,READCFEB,RSTJTAG : std_logic;
  signal TEMP_SELFEB,TEMP_INDATA : std_logic;
  signal ENABLE : std_logic;
  signal TCLK : std_logic;
  signal blank1,blank2,blank3,blank4,blank5,blank6,blank7,blank8 : std_logic;
  signal D_OUTDATA,Q_OUTDATA : std_logic;
  signal DONETAIL : std_logic;
  signal SHTAIL : std_logic;
  signal CE_DONETAIL,C1_DONETAIL,C2_DONETAIL,CLR_DONETAIL,Q_DONETAIL : std_logic;
  signal Qvector_DONETAIL : std_logic_vector(3 downto 0);
  signal RESETJTAG,OKRST,RESETDONE : std_logic;
  signal CLR_DTACK : std_logic;
  signal Q_DTACK_3 : std_logic_vector(3 downto 0);
  signal D_DTACK_4,Q_DTACK_4 : std_logic;
  signal TDO : std_logic;
  signal TDOEN : std_logic_vector(7 downto 1);
  signal BUSYP1,BUSY,RDTDODK : std_logic;
  signal C_DHEADEN,CLR_DHEADEN,DHEADEN : std_logic;
  signal DONEDHEAD : std_logic;
  signal C_IHEADEN,CLR_IHEADEN,IHEADEN : std_logic;
  signal DONEIHEAD : std_logic;
  signal CE_TAILEN,CLR_TAILEN : std_logic;
  signal TAILEN : std_logic;
  signal LOAD : std_logic;
  signal D_ENABLE,CE_ENABLE : std_logic;
  signal D1_LOAD,D2_LOAD,CLR_LOAD,Q_LOAD : std_logic;
  signal D_LED,CE_LED,CLR_LED,Q1_LED,Q2_LED,Q3_LED,Q4_LED : std_logic;
  signal DONEDATA,DONEDATA_1,DONEDATA_2 : std_logic;
  signal SHIHEAD : std_logic;
  signal SHDATA,SHDATAX : std_logic;
  signal D_DONEDATA,Q_DONEDATA : std_logic_vector(3 downto 0);
  signal CE_DONEDATA,CLR_DONEDATA,UP_DONEDATA,D2_DONEDATA : std_logic;
  signal R_LOOP_DONEDHEAD,Q_LOOP_DONEDHEAD : std_logic;
  signal Qvector_LOOP_DONEDHEAD : std_logic_vector(3 downto 0);
  signal SHDHEAD : std_logic;
  signal R_LOOP_DONEIHEAD,Q_LOOP_DONEIHEAD : std_logic;
  signal Qvector_LOOP_DONEIHEAD : std_logic_vector(3 downto 0);
--  signal Q_SHDHEAD,PRE_CLR_SHDHEAD,CLR_SHDHEAD,D_SHDHEAD : std_logic;
  signal Q_BUSY,D_BUSY,CLR_BUSY : std_logic;
  signal D_RESETJTAG,PRE_D_RESETJTAG,CLR_RESETJTAG,Q1_RESETJTAG,Q2_RESETJTAG,VCC,BADSIG : std_logic;
  signal CE_SHIH_TMS,CE_SHDH_TMS,Q1_SHIH_TMS,Q2_SHIH_TMS,Q3_SHIH_TMS,Q4_SHIH_TMS,Q5_SHIH_TMS,Q1_SHDH_TMS,Q2_SHDH_TMS,Q3_SHDH_TMS,Q4_SHDH_TMS,Q5_SHDH_TMS : std_logic;
  signal CE_RST_TMS,CE_SHT_TMS,Q1_RST_TMS,Q2_RST_TMS,Q3_RST_TMS,Q4_RST_TMS,Q5_RST_TMS,Q6_RST_TMS,Q1_SHT_TMS,Q2_SHT_TMS : std_logic;
  signal SHD_TMS,SHIH_TMS,SHDH_TMS,RST_TMS,SHT_TMS : std_logic;
  signal CE_SHIFT1,CE_SHIFT2 : std_logic;
  signal D_CE_SHIFT1,DD_CE_SHIFT1 : std_logic;
  signal QC,Q_SHIFT2 : std_logic_vector(15 downto 0);
  signal test,test1 : std_logic;
  signal VDD : std_logic := '1';
  signal D1_TDO, D2_TDO, D3_TDO, D4_TDO  : std_logic;
  signal rtn_tck, rtn_shft_en : std_logic;  
 
  -----------------------------------------------------------------------------

begin 

  --The following could count as CREATE_DATASHFT,CREATE_INSTSHFT,CREATE_READTDO
  --CREATE_SELCFEB,CREATE_READCFEB,CREATE_RSTJTAG

  CREATE_CMDHIGH: process (DEVICE,COMMAND)  
  begin
     if (DEVICE='1' and COMMAND(4)='0' and COMMAND(5)='0') then
      CMDHIGH <= '1';
    else
      CMDHIGH <= '0';
    end if;
  end process;
  CREATE_DECODE: process (DEVICE,COMMAND,CMDHIGH)  
  begin
    if (CMDHIGH='1' and COMMAND(2)='0' and COMMAND(3)='0') then
      DATASHFT <= '1';
    else
      DATASHFT <= '0';
    end if;

    if (CMDHIGH='1' and COMMAND(2)='1' and COMMAND(3)='0' and COMMAND(0)='1' and COMMAND(1)='1') then
      INSTSHFT <= '1';
    else
      INSTSHFT <= '0';
    end if;

    if (CMDHIGH='1' and COMMAND(2)='1' and COMMAND(3)='0' and COMMAND(0)='1' and COMMAND(1)='0') then
      READTDO <= '1';
    else
      READTDO <= '0';
    end if;

    if (CMDHIGH='1' and COMMAND(2)='0' and COMMAND(3)='1' and COMMAND(0)='0' and COMMAND(1)='0') then
      SELCFEB <= '1';
    else
      SELCFEB <= '0';
    end if;

    if (CMDHIGH='1' and COMMAND(2)='0' and COMMAND(3)='1' and COMMAND(0)='1' and COMMAND(1)='0') then
      READCFEB <= '1';
    else
      READCFEB <= '0';
    end if;

    if (CMDHIGH='1' and COMMAND(2)='1' and COMMAND(3)='0' and COMMAND(0)='0' and COMMAND(1)='1') then
      RSTJTAG <= '1';
    else
      RSTJTAG <= '0';
    end if;
  end process;

-- 2.b
--  CREATE_BUSYP1 and CREATE_BUSY
--  begin
--    FDC(LOAD,SLOWCLK,RST,Q_SHDHEAD);
--    if (DONEDATA_1='1' and TAILEN='0') then
--      PRE_CLR_SHDHEAD <= '1';
--    else
--      PRE_CLR_SHDHEAD <= '0';
--    end if;
--    if (PRE_CLR_SHDHEAD='1' or RST='1' or DONETAIL='1') then
--      CLR_SHDHEAD <= '1';
--    else
--      CLR_SHDHEAD <= '0';
--    end if;
--    D_SHDHEAD <= Q_SHDHEAD or BUSY;
--    FDC(D_SHDHEAD,SLOWCLK,CLR_SHDHEAD,BUSY);
--    SHDHEAD <= BUSY and DHEADEN;
--    FDC(BUSY,SLOWCLK,RST,BUSYP1);
--  end process;

  CREATE_BUSY: process (LOAD,SLOWCLK,RST,DONEDATA_1,TAILEN,DONETAIL, BUSY, Q_BUSY, D_BUSY)  
  begin
    FDC(LOAD,SLOWCLK,RST,Q_BUSY);
    if (((DONEDATA_1='1') and (TAILEN='0')) or (RST='1') or (DONETAIL='1')) then
      CLR_BUSY <= '1';
    else
      CLR_BUSY <= '0';
    end if;
    D_BUSY <= Q_BUSY or BUSY;
    FDC(D_BUSY,SLOWCLK,CLR_BUSY,BUSY);
    FDC(BUSY,SLOWCLK,RST,BUSYP1);
  end process;

-- 2.c
  CREATE_ENABLE: process (RESETJTAG,BUSY,ENABLE,CE_ENABLE,D_ENABLE,SLOWCLK,RST)
  begin
--    CE_ENABLE <= RESETJTAG or BUSYP1; -- Guido - To be verified
    CE_ENABLE <= RESETJTAG or BUSY;
    D_ENABLE <= not ENABLE;
    FDCE(D_ENABLE,SLOWCLK,CE_ENABLE,RST,ENABLE); 
  end process;

-- 2.a
  CREATE_LOAD: process (DATASHFT,INSTSHFT,LOAD,RST,D1_LOAD,CLR_LOAD,STROBE,Q_LOAD,BUSY,D2_LOAD,SLOWCLK)
  begin
    D1_LOAD <= DATASHFT or INSTSHFT;
    CLR_LOAD <= LOAD or RST;
    FDC(D1_LOAD,STROBE,CLR_LOAD,Q_LOAD);
    if (Q_LOAD='1' and BUSY='0') then
      D2_LOAD <= '1';
    else
      D2_LOAD <= '0';
    end if;
    FDC(D2_LOAD,SLOWCLK,RST,LOAD);
  end process;

-- 2.d + 5.b
  CREATE_SHIFT2: process (SHDATA,ENABLE,CE_SHIFT2,SLOWCLK,RST,LOAD,INDATA,Q_SHIFT2)
  begin
    CE_SHIFT2 <= SHDATA and ENABLE;
--    SR16CLRE(SLOWCLK,CE_SHIFT1,RST,LOAD,Q_SHIFT2(0),INDATA,Q_SHIFT2,Q_SHIFT2); 
    SR16CLRE(SLOWCLK,CE_SHIFT2,RST,LOAD,Q_SHIFT2(0),INDATA,Q_SHIFT2,Q_SHIFT2); -- Guido - CE_SHIFT1 instead of CE_SHIFT2?
    TDI_INNER <= Q_SHIFT2(0);
    TDI <= TDI_INNER;
  end process;

-- 2.e + 5.c
  CREATE_DONEDATA: process (COMMAND,LOAD,SHDATA,ENABLE,RST,DONEDATA_1,DONEDATA,
                            D_DONEDATA,CE_DONEDATA,CLR_DONEDATA,SLOWCLK,Q_DONEDATA,D2_DONEDATA, 
                            DONEDATA, DONEDATA_1,UP_DONEDATA)
  begin
    D_DONEDATA <= COMMAND(9 downto 6);
    CB4CLED(SLOWCLK,CE_DONEDATA,CLR_DONEDATA,LOAD,UP_DONEDATA,D_DONEDATA,Q_DONEDATA,Q_DONEDATA,blank5,blank6);
    CE_DONEDATA <= SHDATA and ENABLE;
    if (RST='1' and DONEDATA_1='1' and DONEDATA='1') then
      CLR_DONEDATA <= '1';
    else
      CLR_DONEDATA <= '0';
    end if;
    UP_DONEDATA <= '0';
--    if (Q_DONEDATA(0)='0' and Q_DONEDATA(1)='0' and Q_DONEDATA(2)='0' and Q_DONEDATA(3)='0') then 
    if (Q_DONEDATA(0)='0' and Q_DONEDATA(1)='0' and Q_DONEDATA(2)='0' and Q_DONEDATA(3)='0') and (LOAD = '0') then -- Guido - Missing the and with not LOAD
      D2_DONEDATA <= '1';
    else
      D2_DONEDATA <= '0';
    end if;
    FDCE(D2_DONEDATA,SLOWCLK,SHDATA,LOAD,DONEDATA);
    FDC(DONEDATA,SLOWCLK,LOAD,DONEDATA_1);
    FDC(DONEDATA_1,SLOWCLK,LOAD,DONEDATA_2);
  end process;

-- 3.a
  CREATE_IHEADEN: process (STROBE,BUSY,RST,DONEIHEAD,COMMAND,INSTSHFT,C_IHEADEN,CLR_IHEADEN)
  begin
--    if (STROBE='1' and BUSY='0') then
    if (STROBE='1') then
      C_IHEADEN <= '1';
    else
      C_IHEADEN <= '0';
    end if;
    CLR_IHEADEN <= RST or DONEIHEAD;
    FDCE(COMMAND(0),C_IHEADEN,INSTSHFT,CLR_IHEADEN,IHEADEN);
  end process;

-- 3.b
  CREATE_DHEADEN: process (STROBE,BUSY,RST,DONEDHEAD,COMMAND,DATASHFT,C_DHEADEN,CLR_DHEADEN)
  begin
--    if (STROBE='1' and BUSY='0') then
    if (STROBE='1') then
      C_DHEADEN <= '1';
    else
      C_DHEADEN <= '0';
    end if;
    CLR_DHEADEN <= RST or DONEDHEAD;
    FDCE(COMMAND(0),C_DHEADEN,DATASHFT,CLR_DHEADEN,DHEADEN);
  end process;

-- 3.c
  CREATE_SHIHEAD: process (BUSY,IHEADEN)
  begin
    SHIHEAD <= BUSY and IHEADEN;
  end process;

-- 3.d
  CREATE_SHDHEAD: process (BUSY,DHEADEN)  
  begin
    SHDHEAD <= BUSY and DHEADEN;
  end process;

-- 3.e
  CREATE_TAILEN: process (INSTSHFT,DATASHFT,RST,DONETAIL,COMMAND,LOAD,CE_TAILEN,CLR_TAILEN)
  begin
    CE_TAILEN <= INSTSHFT or DATASHFT;
    CLR_TAILEN <= RST or DONETAIL;
    FDCE(COMMAND(1),LOAD,CE_TAILEN,CLR_TAILEN,TAILEN);
  end process;

-- 4.a
  CREATE_SHIH_TMS: process (SHIHEAD,ENABLE,SLOWCLK,RST,Q1_SHIH_TMS,Q2_SHIH_TMS,Q3_SHIH_TMS,Q4_SHIH_TMS,Q5_SHIH_TMS)
  begin
    CE_SHIH_TMS <= SHIHEAD and ENABLE;
    FDCE(Q5_SHIH_TMS,SLOWCLK,CE_SHIH_TMS,RST,Q1_SHIH_TMS);
    FDCE(Q1_SHIH_TMS,SLOWCLK,CE_SHIH_TMS,RST,Q2_SHIH_TMS);
    FDPE(Q2_SHIH_TMS,SLOWCLK,CE_SHIH_TMS,RST,Q3_SHIH_TMS);
    FDPE(Q3_SHIH_TMS,SLOWCLK,CE_SHIH_TMS,RST,Q4_SHIH_TMS);
    FDCE(Q4_SHIH_TMS,SLOWCLK,CE_SHIH_TMS,RST,Q5_SHIH_TMS);
    if (SHIHEAD='1') then
      SHIH_TMS <= Q5_SHIH_TMS;
    else
      SHIH_TMS <= 'Z';
    end if;
  end process;
  
-- 4.b
  CREATE_SHDH_TMS: process (SHDHEAD,ENABLE,SLOWCLK,RST,Q1_SHDH_TMS,Q2_SHDH_TMS,Q3_SHDH_TMS,Q4_SHDH_TMS,Q5_SHDH_TMS)
  begin
    CE_SHDH_TMS <= SHDHEAD and ENABLE;
    FDCE(Q5_SHDH_TMS,SLOWCLK,CE_SHDH_TMS,RST,Q1_SHDH_TMS);
    FDCE(Q1_SHDH_TMS,SLOWCLK,CE_SHDH_TMS,RST,Q2_SHDH_TMS);
    FDPE(Q2_SHDH_TMS,SLOWCLK,CE_SHDH_TMS,RST,Q3_SHDH_TMS);
    FDCE(Q3_SHDH_TMS,SLOWCLK,CE_SHDH_TMS,RST,Q4_SHDH_TMS);
    FDCE(Q4_SHDH_TMS,SLOWCLK,CE_SHDH_TMS,RST,Q5_SHDH_TMS);
    if (SHDHEAD='1') then
      SHDH_TMS <= Q5_SHDH_TMS;
    else
      SHDH_TMS <= 'Z';
    end if;
  end process;

-- 4.c
  CREATE_LOOP_DONEIHEAD: process (LOAD,RST,SHIHEAD,SLOWCLK,R_LOOP_DONEIHEAD,Qvector_LOOP_DONEIHEAD,Q_LOOP_DONEIHEAD,DONEIHEAD) 
  begin
    if (LOAD='1' or RST='1' or Q_LOOP_DONEIHEAD='1') then
      R_LOOP_DONEIHEAD <= '1';
    else
      R_LOOP_DONEIHEAD <= '0';
    end if;
    CB4RE(SLOWCLK,SHIHEAD,R_LOOP_DONEIHEAD,Qvector_LOOP_DONEIHEAD,Qvector_LOOP_DONEIHEAD,blank7,blank8);
    DONEIHEAD <= Qvector_LOOP_DONEIHEAD(1) and Qvector_LOOP_DONEIHEAD(3);
    FD(DONEIHEAD,SLOWCLK,Q_LOOP_DONEIHEAD);
  end process;

-- 4.d
  CREATE_LOOP_DONEDHEAD: process (LOAD,RST,SHDHEAD,SLOWCLK,R_LOOP_DONEDHEAD,Qvector_LOOP_DONEDHEAD,Q_LOOP_DONEDHEAD,DONEDHEAD)  
  begin
    if (LOAD='1' or RST='1' or Q_LOOP_DONEDHEAD='1') then
      R_LOOP_DONEDHEAD <= '1';
    else
      R_LOOP_DONEDHEAD <= '0';
    end if;
    CB4RE(SLOWCLK,SHDHEAD,R_LOOP_DONEDHEAD,Qvector_LOOP_DONEDHEAD,Qvector_LOOP_DONEDHEAD,blank7,blank8);
    DONEDHEAD <= Qvector_LOOP_DONEDHEAD(1) and Qvector_LOOP_DONEDHEAD(3);
    FD(DONEDHEAD,SLOWCLK,Q_LOOP_DONEDHEAD);
  end process;

-- 5.a
  CREATE_SHDATA: process (BUSY,DHEADEN,IHEADEN,DONEDATA_1)  
  begin  
    if (BUSY='1' and DHEADEN='0' and IHEADEN='0' and DONEDATA_1='0') then -- Guido - To be verified
      SHDATA <= '1';
      SHDATAX <= '1';
    else
      SHDATA <= '0';
      SHDATAX <= '0';
    end if;
   end process;

-- 5.f
--  CREATE_SHD_TMS: process (TAILEN,DONEDATA_1,SHDATA) 
  CREATE_SHD_TMS: process (TAILEN,D2_DONEDATA,SHDATA) -- Guido - BUG!!!!!!!!!!
  begin  
    if (SHDATA='1') then
--       SHD_TMS <= TAILEN and DONEDATA_1; 
      SHD_TMS <= TAILEN and D2_DONEDATA;   -- Guido - BUG!!!!!!!!!!
    else
      SHD_TMS <= 'Z';
    end if;
  end process;

-- 6.a
  CREATE_SHTAIL: process (BUSY,DONEDATA_1,TAILEN)
  begin
    SHTAIL <= BUSY and DONEDATA_1 and TAILEN;
  end process;

-- 6.b
  CREATE_SHT_TMS: process (SHTAIL,ENABLE,SLOWCLK,RST,CE_SHT_TMS,Q1_SHT_TMS,Q2_SHT_TMS)
  begin  
    CE_SHT_TMS <= SHTAIL and ENABLE;
    FDCE(Q2_SHT_TMS,SLOWCLK,CE_SHT_TMS,RST,Q1_SHT_TMS);
    FDPE(Q1_SHT_TMS,SLOWCLK,CE_SHT_TMS,RST,Q2_SHT_TMS);
    if (SHTAIL='1') then
      SHT_TMS <= Q2_SHT_TMS;
    else
      SHT_TMS <= 'Z';
    end if;
  end process;

-- 6.c
  CREATE_DONETAIL: process (SHTAIL,ENABLE,SLOWCLK,RST,DONETAIL,Q_DONETAIL,Qvector_DONETAIL,
                            C1_DONETAIL,C2_DONETAIL,CE_DONETAIL,CLR_DONETAIL)
  begin
    
    if (SHTAIL='1' and ENABLE='1') then
      CE_DONETAIL <= '1';
    else
      CE_DONETAIL <= '0';
    end if;
    if (RST='1' or Q_DONETAIL='1') then
      CLR_DONETAIL <= '1';
    else
      CLR_DONETAIL <= '0';
    end if;
    C1_DONETAIL <= SLOWCLK;
    C2_DONETAIL <= SLOWCLK;
 
    CB4CE(C1_DONETAIL,CE_DONETAIL,CLR_DONETAIL,Qvector_DONETAIL,Qvector_DONETAIL,blank1,blank2);
    DONETAIL <= Qvector_DONETAIL(1);

    FD_1(Qvector_DONETAIL(1),C2_DONETAIL,Q_DONETAIL); 
    
  end process;

-- 7.a
--    CREATE_TDOEN:  process (SELFEB,FEBTDO)         
--    begin
--    if (SELFEB(1)='1' and SELFEB(2)='0' and SELFEB(3)='0' and SELFEB(4)='0' and SELFEB(5)='0' and SELFEB(6)='0' and SELFEB(7)='0') then
--      TDOEN(1) <= '1';
--    else
--      TDOEN(1) <= '0';
--    end if;
--    if (SELFEB(1)='0' and SELFEB(2)='1' and SELFEB(3)='0' and SELFEB(4)='0' and SELFEB(5)='0' and SELFEB(6)='0' and SELFEB(7)='0') then
--      TDOEN(2) <= '1';
--    else
--      TDOEN(2) <= '0';
--    end if;
--    if (SELFEB(1)='0' and SELFEB(2)='0' and SELFEB(3)='1' and SELFEB(4)='0' and SELFEB(5)='0' and SELFEB(6)='0' and SELFEB(7)='0') then
--      TDOEN(3) <= '1';
--    else
--      TDOEN(3) <= '0';
--    end if;
--    if (SELFEB(1)='0' and SELFEB(2)='0' and SELFEB(3)='0' and SELFEB(4)='1' and SELFEB(5)='0' and SELFEB(6)='0' and SELFEB(7)='0') then
--      TDOEN(4) <= '1';
--    else
--      TDOEN(4) <= '0';
--    end if;
--    if (SELFEB(1)='0' and SELFEB(2)='0' and SELFEB(3)='0' and SELFEB(4)='0' and SELFEB(5)='1' and SELFEB(6)='0' and SELFEB(7)='0') then
--      TDOEN(5) <= '1';
--    else
--      TDOEN(5) <= '0';
--    end if;
--    if (SELFEB(1)='0' and SELFEB(2)='0' and SELFEB(3)='0' and SELFEB(4)='0' and SELFEB(5)='0' and SELFEB(6)='1' and SELFEB(7)='0') then
--      TDOEN(6) <= '1';
--    else
--      TDOEN(6) <= '0';
--    end if;
--    if (SELFEB(1)='0' and SELFEB(2)='0' and SELFEB(3)='0' and SELFEB(4)='0' and SELFEB(5)='0' and SELFEB(6)='0' and SELFEB(7)='1') then
--      TDOEN(7) <= '1';
--    else
--      TDOEN(7) <= '0';
--    end if;
--    end process;

-- 7.b
--    CREATE_TDO: process (TDOEN,FEBTDO)         
--    begin
--    if (TDOEN(1)='1') then
--      TDO <= FEBTDO(1);
--    else
--      TDO <= 'Z';
--    end if;
--    if (TDOEN(2)='1') then
--      TDO <= FEBTDO(2);
--    else
--      TDO <= 'Z';
--    end if;
--    if (TDOEN(3)='1') then
--      TDO <= FEBTDO(3);
--    else
--      TDO <= 'Z';
--    end if;
--    if (TDOEN(4)='1') then
--      TDO <= FEBTDO(4);
--    else
--      TDO <= 'Z';
--    end if;
--    if (TDOEN(5)='1') then
--      TDO <= FEBTDO(5);
--    else
--      TDO <= 'Z';
--    end if;
--    if (TDOEN(6)='1') then
--      TDO <= FEBTDO(6);
--    else
--      TDO <= 'Z';
--    end if;
--    if (TDOEN(7)='1') then
--      TDO <= FEBTDO(7);
--    else
--      TDO <= 'Z';
--    end if;
--    end process;

-- 7.b
	FEBTDO_INNER(7 DOWNTO 1) <= FEBTDO(7 DOWNTO 1);
  CREATE_TDO: process (SELFEB,FEBTDO_INNER)         
  begin
    case SELFEB is
      when "0000001" => TDO <= FEBTDO_INNER(1);
      when "0000010" => TDO <= FEBTDO_INNER(2);
      when "0000100" => TDO <= FEBTDO_INNER(3);
      when "0001000" => TDO <= FEBTDO_INNER(4);
      when "0010000" => TDO <= FEBTDO_INNER(5);
      when "0100000" => TDO <= FEBTDO_INNER(6);
      when "1000000" => TDO <= FEBTDO_INNER(7);
      when others => TDO <= '0';
    end case;
  end process;

-- 8.a
  CREATE_LED: process (DATASHFT,INSTSHFT,BUSY,STROBE,SLOWCLK,CE_LED,CLR_LED,Q1_LED,Q2_LED,Q3_LED,Q4_LED)  --also CREATE_DTACK
  begin
    D_LED <= DATASHFT or INSTSHFT;
    CE_LED <= not BUSY;
    CLR_LED <= not STROBE;
    FDCE(D_LED,SLOWCLK,CE_LED,CLR_LED,Q1_LED);
--    FDC(Q1_LED,SLOWCLK,CLR_LED,Q2_LED);
--    FD(Q2_LED,SLOWCLK,Q3_LED);
--    FD(Q3_LED,SLOWCLK,Q4_LED);
    FDCE(Q1_LED,SLOWCLK,CE_LED,CLR_LED,Q2_LED);
--    FDCE(Q2_LED,SLOWCLK,CE_LED,CLR_LED,Q3_LED);
--    FDCE(Q3_LED,SLOWCLK,CE_LED,CLR_LED,Q4_LED);
    FDE(Q2_LED,SLOWCLK,CE_LED,Q3_LED);
    FDE(Q3_LED,SLOWCLK,CE_LED,Q4_LED);
--    if (Q1_LED='1' and Q2_LED='1' and Q3_LED='1' and Q4_LED='1') then
    if (Q3_LED='1' and Q4_LED='1') then
      LED <= '0';
      DTACK_INNER <= '0';
    else
      LED <='1';
      DTACK_INNER <= 'Z';
    end if;
  end process;

  CREATE_RESETJTAG: process (STROBE,RSTJTAG,INITJTAGS,FASTCLK,RST,RESETDONE,SLOWCLK,VCC,OKRST)
  begin
    PRE_D_RESETJTAG <= STROBE and RSTJTAG;
    D_RESETJTAG <= INITJTAGS or PRE_D_RESETJTAG;
    FDC(D_RESETJTAG,FASTCLK,RST,Q1_RESETJTAG);
    FDC(Q1_RESETJTAG,FASTCLK,RST,Q2_RESETJTAG);
    OKRST <= Q1_RESETJTAG and Q2_RESETJTAG;
    CLR_RESETJTAG <= RESETDONE or RST;
    VCC <= '1';
    FDC(VCC,OKRST,CLR_RESETJTAG,BADSIG);
    FDC(BADSIG,SLOWCLK,CLR_RESETJTAG,RESETJTAG);
  end process;

  CREATE_DTACK: process (RDTDODK)
  begin
    if (RDTDODK='1') then
      DTACK_INNER <= '0';
    else
      DTACK_INNER <= 'Z';
    end if;
  end process;

  CREATE_OUTDATA: process (RST,INDATA,SELCFEB,STROBE,FASTCLK,READCFEB)  
    --Could also be called CREATE_SELFEB
  begin
    
    FDPE(INDATA(0),STROBE,SELCFEB,RST,SELFEB(1));
    FDPE(INDATA(1),STROBE,SELCFEB,RST,SELFEB(2));
    FDPE(INDATA(2),STROBE,SELCFEB,RST,SELFEB(3));
    FDPE(INDATA(3),STROBE,SELCFEB,RST,SELFEB(4));
    FDPE(INDATA(4),STROBE,SELCFEB,RST,SELFEB(5));
    FDPE(INDATA(5),STROBE,SELCFEB,RST,SELFEB(6));
    FDPE(INDATA(6),STROBE,SELCFEB,RST,SELFEB(7));
    
    if (STROBE='1' and READCFEB='1') then
      OUTDATA(6 downto 0) <= SELFEB(7 downto 1);
      D_OUTDATA <= '1';
    else
      OUTDATA(6 downto 0) <= "ZZZZZZZ";
      D_OUTDATA <= '0';
    end if;

    FD(D_OUTDATA,FASTCLK,Q_OUTDATA);
    if (Q_OUTDATA='1') then
      DTACK_INNER <= '0';
    else
      DTACK_INNER <= 'Z';
    end if;

  end process;

--  start BGB!!!

--  CREATE_SHIFT1: process (TDO,SHDATAX,ENABLE,SLOWCLK,RST,RDTDODK,QC, D1_TDO, D2_TDO, D3_TDO, CE_SHIFT1)
--  begin
--    CE_SHIFT1 <= SHDATAX and not ENABLE;
--    FDCE(CE_SHIFT1,SLOWCLK,VDD,RST,D_CE_SHIFT1); -- Guido
--    FDCE(D_CE_SHIFT1,SLOWCLK,VDD,RST,DD_CE_SHIFT1); -- Guido
--    FDCE(TDO,SLOWCLK,VDD,RST,D1_TDO); -- Guido
--    FDCE(D1_TDO,SLOWCLK,VDD,RST,D2_TDO); -- Guido
--    FDCE(D2_TDO,SLOWCLK,VDD,RST,D3_TDO); -- Guido
--    FDCE(D3_TDO,SLOWCLK,VDD,RST,D4_TDO); -- Guido
--    SR16LCE(SLOWCLK,CE_SHIFT1,RST,TDO,QC,QC);
--    -- SR16LCE(SLOWCLK,CE_SHIFT1,RST,D2_TDO,QC,QC);
--    -- SR16LCE(SLOWCLK,DD_CE_SHIFT1,RST,TDO,QC,QC); -- Guido
--    if (RDTDODK='1') then
--      OUTDATA(15 downto 0) <= QC(15 downto 0);
--    else
--      OUTDATA <= "ZZZZZZZZZZZZZZZZ";
--    end if;
--  end process;

  CREATE_RTN_SHFT_EN: process (SELFEB,DL_RTN_SHFT_EN)         
  begin
    case SELFEB is
      when "0000001" => rtn_shft_en <= DL_RTN_SHFT_EN(1);
      when "0000010" => rtn_shft_en <= DL_RTN_SHFT_EN(2);
      when "0000100" => rtn_shft_en <= DL_RTN_SHFT_EN(3);
      when "0001000" => rtn_shft_en <= DL_RTN_SHFT_EN(4);
      when "0010000" => rtn_shft_en <= DL_RTN_SHFT_EN(5);
      when "0100000" => rtn_shft_en <= DL_RTN_SHFT_EN(6);
      when "1000000" => rtn_shft_en <= DL_RTN_SHFT_EN(7);
      when others => rtn_shft_en <= '0';
    end case;
  end process;

  CREATE_RTN_TCK: process (SELFEB,UL_JTAG_TCK)         
  begin
    case SELFEB is
      when "0000001" => rtn_tck <= UL_JTAG_TCK(1);
      when "0000010" => rtn_tck <= UL_JTAG_TCK(2);
      when "0000100" => rtn_tck <= UL_JTAG_TCK(3);
      when "0001000" => rtn_tck <= UL_JTAG_TCK(4);
      when "0010000" => rtn_tck <= UL_JTAG_TCK(5);
      when "0100000" => rtn_tck <= UL_JTAG_TCK(6);
      when "1000000" => rtn_tck <= UL_JTAG_TCK(7);
      when others => rtn_tck <= '0';
    end case;
  end process;

  CREATE_SHIFT1: process (TDO,rtn_shft_en,rtn_tck,RST,RDTDODK,QC)
  begin
    SR16LCE(rtn_tck,rtn_shft_en,RST,TDO,QC,QC);
    if (RDTDODK='1') then
      OUTDATA(15 downto 0) <= QC(15 downto 0);
    else
      OUTDATA <= "ZZZZZZZZZZZZZZZZ";
    end if;
  end process;

--  end BGB!!!

--  TEST_TDI: process (Q_SHIFT2)
--  begin
--    TDI <= Q_SHIFT2(0);
--  end process;

  CREATE_RDTDODK: process(STROBE,READTDO,BUSYP1,BUSY)
  begin  
    if (STROBE='1' and READTDO='1' and BUSYP1='0' and BUSY='0') then
      RDTDODK <= '1';
    else
      RDTDODK <= '0';
    end if;
  end process;


--  start BGB!!!

--  CREATE_TCK: process (ENABLE,SELFEB,TCLK) -- Guido   
--  begin
--    TCLK <= ENABLE;
--    
--    if (TCLK='1' and SELFEB(1)='1') then
--      
--      TCK(1) <= '1';
--    else
--      TCK(1) <= '0';
--    end if;
--
--    if (TCLK='1' and SELFEB(2)='1') then
--      TCK(2) <= '1';
--    else
--      TCK(2) <= '0';
--    end if;
--
--    if (TCLK='1' and SELFEB(3)='1') then
--      TCK(3) <= '1';
--    else
--      TCK(3) <= '0';
--    end if;
--
--    if (TCLK='1' and SELFEB(4)='1') then
--      TCK(4) <= '1';
--    else
--      TCK(4) <= '0';
--    end if;
--
--    if (TCLK='1' and SELFEB(5)='1') then
--      TCK(5) <= '1';
--    else
--      TCK(5) <= '0';
--    end if;
--
--    if (TCLK='1' and SELFEB(6)='1') then
--      TCK(6) <= '1';
--    else
--      TCK(6) <= '0';
--    end if;
--
--    if (TCLK='1' and SELFEB(7)='1') then
--      TCK(7) <= '1';
--    else
--      TCK(7) <= '0';
--    end if;
--
--  end process;

TCK_INNER(1) <= SELFEB(1) and ENABLE;
TCK(1) <= TCK_INNER(1);
TCK(2) <= SELFEB(2) and ENABLE;
TCK(3) <= SELFEB(3) and ENABLE;
TCK(4) <= SELFEB(4) and ENABLE;
TCK(5) <= SELFEB(5) and ENABLE;
TCK(6) <= SELFEB(6) and ENABLE;
TCK(7) <= SELFEB(7) and ENABLE;

--  end BGB!!!


  CREATE_DTACK_3: process (RESETJTAG,SLOWCLK,OKRST,INITJTAGS)
  begin

    CLR_DTACK <= not OKRST;
    CB4CE(SLOWCLK,RESETJTAG,CLR_DTACK,Q_DTACK_3,Q_DTACK_3,blank3,blank4);
    
    if (Q_DTACK_3(2)='1' and Q_DTACK_3(3)='1') then
      RESETDONE <= '1';
    else
      RESETDONE <= '0';
    end if;

    if (RESETDONE='1' and INITJTAGS='0') then
      DTACK_INNER <= '0';
    else
      DTACK_INNER <= 'Z';
    end if;
    
  end process;


  CREATE_DTACK_4: process (SELCFEB,STROBE,FASTCLK)
  begin
    if (SELCFEB='1' and STROBE='1') then
      D_DTACK_4 <= '1';
    else
      D_DTACK_4 <= '0';
    end if;
    FD(D_DTACK_4,FASTCLK,Q_DTACK_4);
    if (Q_DTACK_4='1') then
      DTACK_INNER <= '0';
    else
      DTACK_INNER <= 'Z';
    end if;
  end process;


  CREATE_RST_TMS: process (RESETJTAG,ENABLE,SLOWCLK,RST)
  begin
    CE_RST_TMS <= RESETJTAG and ENABLE;
    
    FDCE(Q6_RST_TMS,SLOWCLK,CE_RST_TMS,RST,Q1_RST_TMS);
    FDPE(Q1_RST_TMS,SLOWCLK,CE_RST_TMS,RST,Q2_RST_TMS);
    FDPE(Q2_RST_TMS,SLOWCLK,CE_RST_TMS,RST,Q3_RST_TMS);
    FDPE(Q3_RST_TMS,SLOWCLK,CE_RST_TMS,RST,Q4_RST_TMS);
    FDPE(Q4_RST_TMS,SLOWCLK,CE_RST_TMS,RST,Q5_RST_TMS);
    FDPE(Q5_RST_TMS,SLOWCLK,CE_RST_TMS,RST,Q6_RST_TMS);
    if (RESETJTAG='1') then
      RST_TMS <= Q6_RST_TMS;
    else
      RST_TMS <= 'Z';
    end if;
  end process;


  CREATE_TMS: process (SHD_TMS,SHDATA,SHIH_TMS,SHIHEAD,SHDH_TMS,SHDHEAD,RST_TMS,RESETJTAG,SHT_TMS,SHTAIL)
  begin  
    if (SHDATA='1') then
 	   TMS_INNER <= SHD_TMS;
   elsif (SHIHEAD='1') then
 	   TMS_INNER <= SHIH_TMS;
    elsif (SHDHEAD='1') then
 	   TMS_INNER <= SHDH_TMS;
    elsif (RESETJTAG='1') then
  	   TMS_INNER <= RST_TMS;
   elsif (SHTAIL='1') then
 	   TMS_INNER <= SHT_TMS;
    else
 	   TMS_INNER <= 'Z';  -- Guido
    end if;
	 TMS <= TMS_INNER;
  end process;


  SET_DTACK: process (DTACK_INNER)
  begin  
   DTACK <= DTACK_INNER;
  end process;


--  CREATE_DIAGOUT: process (LOAD,ENABLE,BUSY,RDTDODK,DTACK_INNER,RST,TDO,SHDATAX,SLOWCLK,
--  READTDO,STROBE,DHEADEN,IHEADEN,DONEDATA_1,SHDHEAD,DONEDHEAD)
--  begin  
--     DIAGOUT(0) <= LOAD;
--     DIAGOUT(1) <= ENABLE;
--     DIAGOUT(2) <= BUSY;
--     DIAGOUT(3) <= RDTDODK;
--     DIAGOUT(4) <= DTACK_INNER;
--     DIAGOUT(5) <= RST;
--     DIAGOUT(6) <= TDO;
--     DIAGOUT(7) <= SHDATAX;
--     DIAGOUT(8) <= SLOWCLK;
--     DIAGOUT(9) <= READTDO;
--     DIAGOUT(10) <= STROBE;
--     DIAGOUT(11) <= DHEADEN;
--     DIAGOUT(12) <= IHEADEN;
--     DIAGOUT(13) <= DONEDATA_1;
--     DIAGOUT(14) <= SHDHEAD;
--     DIAGOUT(15) <= DONEDHEAD;
--     DIAGOUT(16) <= SELCFEB;
--     DIAGOUT(17) <= DEVICE;
    DIAGOUT(0) <= TCK_INNER(1);
    DIAGOUT(1) <= TDI_INNER;
    DIAGOUT(2) <= TMS_INNER;
    DIAGOUT(3) <= DL_RTN_SHFT_EN(1);
    DIAGOUT(4) <= UL_JTAG_TCK(1);
    DIAGOUT(5) <= SELFEB(1);
    DIAGOUT(6) <= TDO;
--    DIAGOUT(6) <= FEBTDO_INNER(1);
    DIAGOUT(7) <= READTDO;
    DIAGOUT(8) <= SELFEB(2);
    DIAGOUT(9) <= SELFEB(3);
    DIAGOUT(10) <= BUSY;
    DIAGOUT(11) <= ENABLE;
    DIAGOUT(12) <= SLOWCLK;
    DIAGOUT(17 downto 13) <= "00000";
--  end process;

end CFEBJTAG_BGB_Arch;
    
