library ieee;
library work;
use work.Latches_Flipflops.all;
use ieee.std_logic_1164.all;

entity MBCJTAG is
  
  port (
    DEVICE : in std_logic;
    COMMAND : in std_logic_vector(9 downto 0);
    INDATA : in std_logic_vector(15 downto 0);
    STROBE : in std_logic;
    MBCTDO : in std_logic;
    INITJTAGS : in std_logic;
    WRITER : in std_logic;
    FASTCLK : in std_logic;
    SLOWCLK : in std_logic;
    RST : in std_logic;

    OUTDATA : out std_logic_vector(15 downto 0);
    DTACK : out std_logic;
    TDI : out std_logic;
    TMS : out std_logic;
    TCK : out std_logic;
    LED : out std_logic
    );

end MBCJTAG;

architecture MBCJTAG_Arch of MBCJTAG is

  --Declaring internal signals
  signal DTACK_INNER : std_logic;
  signal CMDHIGH : std_logic;
  signal SELFEB : std_logic_vector(7 downto 1);  
  signal DATASHFT,INSTSHFT,READTDO,READCFEB,RSTJTAG : std_logic;
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
  signal D_BUSY,Q_BUSY,CLR_BUSY,BUSYP1,BUSY,RDTDODK : std_logic;
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
  signal Q_SHDHEAD,PRE_CLR_SHDHEAD,CLR_SHDHEAD,D_SHDHEAD : std_logic;
  signal D_RESETJTAG,PRE_D_RESETJTAG,CLR_RESETJTAG,Q1_RESETJTAG,Q2_RESETJTAG,VCC,BADSIG : std_logic;
  signal CE_SHIH_TMS,CE_SHDH_TMS,Q1_SHIH_TMS,Q2_SHIH_TMS,Q3_SHIH_TMS,Q4_SHIH_TMS,Q5_SHIH_TMS,Q1_SHDH_TMS,Q2_SHDH_TMS,Q3_SHDH_TMS,Q4_SHDH_TMS,Q5_SHDH_TMS : std_logic;
  signal CE_RST_TMS,CE_SHT_TMS,Q1_RST_TMS,Q2_RST_TMS,Q3_RST_TMS,Q4_RST_TMS,Q5_RST_TMS,Q6_RST_TMS,Q1_SHT_TMS,Q2_SHT_TMS : std_logic;
  signal SHD_TMS,SHIH_TMS,SHDH_TMS,RST_TMS,SHT_TMS : std_logic;
  signal CE_SHIFT1,CE_SHIFT2 : std_logic;
  signal QC,Q_SHIFT2 : std_logic_vector(15 downto 0);
  signal test,test1 : std_logic;
  
begin 

  --The following could count as CREATE_DATASHFT,CREATE_INSTSHFT,CREATE_READTDO
  --CREATE_RSTJTAG

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

    if (CMDHIGH='1' and COMMAND(2)='1' and COMMAND(3)='0' and COMMAND(0)='0' and COMMAND(1)='1') then
      RSTJTAG <= '1';
    else
      RSTJTAG <= '0';
    end if;
  end process;

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


  CREATE_ENABLE: process (RESETJTAG,BUSY,ENABLE,CE_ENABLE,D_ENABLE,SLOWCLK,RST)
  begin
    CE_ENABLE <= RESETJTAG or BUSY;
    D_ENABLE <= not ENABLE;
    FDCE(D_ENABLE,SLOWCLK,CE_ENABLE,RST,ENABLE);
    TCK <= ENABLE;
  end process;

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

  CREATE_SHIFT2: process (SHDATA,ENABLE,CE_SHIFT2,SLOWCLK,RST,LOAD,INDATA,Q_SHIFT2)
  begin
    CE_SHIFT2 <= SHDATA and ENABLE;
--    SR16CLRE(SLOWCLK,CE_SHIFT1,RST,LOAD,Q_SHIFT2(0),INDATA,Q_SHIFT2,Q_SHIFT2); 
    SR16CLRE(SLOWCLK,CE_SHIFT2,RST,LOAD,Q_SHIFT2(0),INDATA,Q_SHIFT2,Q_SHIFT2); -- Guido - CE_SHIFT1 instead of CE_SHIFT2?
    TDI <= Q_SHIFT2(0);
  end process;
  
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

  CREATE_SHIHEAD: process (BUSY,IHEADEN)
  begin
    SHIHEAD <= BUSY and IHEADEN;
  end process;

  CREATE_SHDHEAD: process (BUSY,DHEADEN)  
  begin
    SHDHEAD <= BUSY and DHEADEN;
  end process;

  CREATE_TAILEN: process (INSTSHFT,DATASHFT,RST,DONETAIL,COMMAND,LOAD,CE_TAILEN,CLR_TAILEN)
  begin
    CE_TAILEN <= INSTSHFT or DATASHFT;
    CLR_TAILEN <= RST or DONETAIL;
    FDCE(COMMAND(1),LOAD,CE_TAILEN,CLR_TAILEN,TAILEN);
  end process;

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

  CREATE_SHDATA: process (BUSY,DHEADEN,IHEADEN,DONEDATA_1)  -- Also CREATE_SHDATAX
  begin  
    if (BUSY='1' and DHEADEN='0' and IHEADEN='0' and DONEDATA_1='0') then
      SHDATA <= '1';
      SHDATAX <= '1';
    else
      SHDATA <= '0';
      SHDATAX <= '0';
    end if;
  end process;

  CREATE_SHD_TMS: process (TAILEN,D2_DONEDATA,SHDATA) -- Guido - BUG!!!!!!!!!!
  begin  
    if (SHDATA='1') then
--       SHD_TMS <= TAILEN and DONEDATA_1; 
      SHD_TMS <= TAILEN and D2_DONEDATA;   -- Guido - BUG!!!!!!!!!!
    else
      SHD_TMS <= 'Z';
    end if;
  end process;

  CREATE_SHTAIL: process (BUSY,DONEDATA_1,TAILEN)
  begin
    SHTAIL <= BUSY and DONEDATA_1 and TAILEN;
  end process;

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

    FD_1(DONETAIL,C2_DONETAIL,Q_DONETAIL);
    
  end process;

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
    FDCE(Q2_LED,SLOWCLK,CE_LED,CLR_LED,Q3_LED);
    FDCE(Q3_LED,SLOWCLK,CE_LED,CLR_LED,Q4_LED);
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

  CREATE_SHIFT1: process (MBCTDO,SHDATAX,ENABLE,SLOWCLK,RST,RDTDODK)
  begin
    CE_SHIFT1 <= SHDATAX and not ENABLE;
    SR16LCE(SLOWCLK,CE_SHIFT1,RST,MBCTDO,QC,QC);
    if (RDTDODK='1') then
      OUTDATA(15 downto 0) <= QC(15 downto 0);
    else
      OUTDATA <= "ZZZZZZZZZZZZZZZZ";
    end if;
  end process;

  CREATE_RDTDODK: process(STROBE,READTDO,BUSYP1,BUSY)
  begin  
    if (STROBE='1' and READTDO='1' and BUSYP1='0' and BUSY='0') then
      RDTDODK <= '1';
    else
      RDTDODK <= '0';
    end if;
  end process;

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
      TMS <= SHD_TMS;
    elsif (SHIHEAD='1') then
      TMS <= SHIH_TMS;
    elsif (SHDHEAD='1') then
      TMS <= SHDH_TMS;
    elsif (RESETJTAG='1') then
      TMS <= RST_TMS;
    elsif (SHTAIL='1') then
      TMS <= SHT_TMS;
    else
      TMS <= 'X';
    end if;
  end process;

  SET_DTACK: process (DTACK_INNER)
  begin  
   DTACK <= DTACK_INNER;
  end process;


  
end MBCJTAG_Arch;
    
