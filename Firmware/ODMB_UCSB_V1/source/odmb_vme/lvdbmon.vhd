library ieee;
library work;
use work.Latches_Flipflops.all;
use ieee.std_logic_1164.all;

entity LVDBMON is
  
  port (

    SLOWCLK  : in  std_logic;
    RST      : in  std_logic;

    DEVICE   : in  std_logic;
    STROBE   : in  std_logic;
    COMMAND  : in  std_logic_vector(9 downto 0);
    WRITER   : in  std_logic;

    INDATA   : in  std_logic_vector(15 downto 0);
    OUTDATA  : out std_logic_vector(15 downto 0);

    DTACK    : out std_logic;

    LVADCEN  : out std_logic_vector(6 downto 0);
    ADCCLK   : out std_logic;
    ADCDATA  : out std_logic;
    ADCIN    : in  std_logic;

    LVTURNON : out std_logic_vector(8 downto 1);
    R_LVTURNON : in std_logic_vector(8 downto 1);
    LOADON   : out std_logic;
    
	 DIAGLVDB : out std_logic_vector(17 downto 0)
    );
end LVDBMON;


architecture LVDBMON_Arch of LVDBMON is

  --Declaring internal signals
  signal CMDHIGH : std_logic;
  signal BUSY : std_logic;
  signal WRITEADC,READMON,WRITEPOWER,READPOWER,READPOWERSTATUS,SELADC,READADC : STD_LOGIC;
  signal SELADC_vector : std_logic_vector(3 downto 1);
  signal DTACK_INNER : std_logic;
  signal LVTURNON_INNER : std_logic_vector(8 downto 1);
  signal D_OUTDATA,Q_OUTDATA,D_OUTDATA_2,Q_OUTDATA_2,D_DTACK_2,Q_DTACK_2,D_DTACK_4,Q_DTACK_4 : std_logic;
  signal C_LOADON,Q1_LOADON,Q2_LOADON : std_logic;
  signal VCC : std_logic;
  signal LOADON_INNER,ADCCLK_INNER : std_logic;
  signal CE_ADCCLK,CLR_ADCCLK : std_logic;
  signal RSTBUSY,CLKMON : std_logic;
  signal CE1_BUSY,CE2_BUSY,CLR_BUSY,Q1_BUSY,Q2_BUSY,D_BUSY,DONEMON,LOAD : std_logic;
  signal blank1,blank2 : std_logic;
  signal QTIME : std_logic_vector(7 downto 0);
  signal CLR1_LOAD,CLR2_LOAD,Q1_LOAD,Q2_LOAD,Q3_LOAD,Q4_LOAD,CE_LOAD,ASYNLOAD : std_logic;
  signal RDMONBK : std_logic;
  signal CE_OUTDATA_FULL : std_logic;
  signal Q_OUTDATA_FULL : std_logic_vector(15 downto 0);
  signal SLI_ADCDATA,L_ADCDATA,CE_ADCDATA : std_logic;
  signal D_ADCDATA,Q_ADCDATA : std_logic_vector(7 downto 0);
  
  -----------------------------------------------------------------------------

begin  --Architecture
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
      WRITEADC <= '1';
    else
      WRITEADC <= '0';
    end if;

    if (COMMAND(3)='0' and COMMAND(2)='0' and COMMAND(1)='0' and COMMAND(0)='1' and CMDHIGH='1') then
      READMON <= '1';
    else
      READMON <= '0';
    end if;

    if (COMMAND(3)='0' and COMMAND(2)='1' and COMMAND(1)='0' and COMMAND(0)='0' and CMDHIGH='1') then
      WRITEPOWER <= '1';
    else
      WRITEPOWER <= '0';
    end if;

    if (COMMAND(3)='0' and COMMAND(2)='1' and COMMAND(1)='0' and COMMAND(0)='1' and CMDHIGH='1') then
      READPOWER <= '1';
    else
      READPOWER <= '0';
    end if;

    if (COMMAND(3)='0' and COMMAND(2)='1' and COMMAND(1)='1' and COMMAND(0)='0' and CMDHIGH='1') then
      READPOWERSTATUS <= '1';
    else
      READPOWERSTATUS <= '0';
    end if;

    if (COMMAND(3)='1' and COMMAND(2)='0' and COMMAND(1)='0' and COMMAND(0)='0' and CMDHIGH='1') then
      SELADC <= '1';
    else
      SELADC <= '0';
    end if;

    if (COMMAND(3)='1' and COMMAND(2)='0' and COMMAND(1)='0' and COMMAND(0)='1' and CMDHIGH='1') then
      READADC <= '1';
    else
      READADC <= '0';
    end if;
    
  end process;

--  CREATE_OUTDATA: process (RST,INDATA,SELADC,READADC,STROBE,SLOWCLK)  --CREATE_DTACK_1 also
  CREATE_OUTDATA: process (RST,INDATA,SELADC,READADC,STROBE,SLOWCLK,D_OUTDATA,Q_OUTDATA,SELADC_vector)  --CREATE_DTACK_1 also
  begin
    
    FDCE(INDATA(0),STROBE,SELADC,RST,SELADC_vector(1));
    FDCE(INDATA(1),STROBE,SELADC,RST,SELADC_vector(2));
    FDCE(INDATA(2),STROBE,SELADC,RST,SELADC_vector(3));

    if (STROBE='1' and READADC='1') then
      OUTDATA(2 downto 0) <= SELADC_vector(3 downto 1);
      D_OUTDATA <= '1';
    else
      D_OUTDATA <= '0';
      OUTDATA(2 downto 0) <= "ZZZ";
    end if;

    FD(D_OUTDATA,SLOWCLK,Q_OUTDATA);
    if (Q_OUTDATA='1') then
      DTACK_INNER <= '0';
    else
      DTACK_INNER <= 'Z';
    end if;

  end process;


--  CREATE_DTACK_2: process (SELADC,STROBE,SLOWCLK,Q_DTACK_2)
  CREATE_DTACK_2: process (SELADC,STROBE,SLOWCLK,D_DTACK_2,Q_DTACK_2)
  begin
    D_DTACK_2 <= SELADC and STROBE;
    FD(D_DTACK_2,SLOWCLK,Q_DTACK_2);
    if (Q_DTACK_2='1') then
      DTACK_INNER <= '0';
    else
      DTACK_INNER <= 'Z';
    end if;
  end process;

--  CREATE_OUTDATA_2: process (RST,INDATA,WRITEPOWER,READPOWER,STROBE,SLOWCLK)  --CREATE_DTACK_3 also
  CREATE_OUTDATA_2: process (RST,INDATA,WRITEPOWER,READPOWER,READPOWERSTATUS,STROBE,SLOWCLK,LVTURNON_INNER,R_LVTURNON,D_OUTDATA_2,Q_OUTDATA_2)  --CREATE_DTACK_3 also
  begin
    
    FDCE(INDATA(0),STROBE,WRITEPOWER,RST,LVTURNON_INNER(1));
    FDCE(INDATA(1),STROBE,WRITEPOWER,RST,LVTURNON_INNER(2));
    FDCE(INDATA(2),STROBE,WRITEPOWER,RST,LVTURNON_INNER(3));
    FDCE(INDATA(3),STROBE,WRITEPOWER,RST,LVTURNON_INNER(4));
    FDCE(INDATA(4),STROBE,WRITEPOWER,RST,LVTURNON_INNER(5));
    FDCE(INDATA(5),STROBE,WRITEPOWER,RST,LVTURNON_INNER(6));
    FDCE(INDATA(6),STROBE,WRITEPOWER,RST,LVTURNON_INNER(7));
    FDCE(INDATA(7),STROBE,WRITEPOWER,RST,LVTURNON_INNER(8));

    if (STROBE='1' and READPOWER='1') then
      OUTDATA(7 downto 0) <= LVTURNON_INNER(8 downto 1);
      D_OUTDATA_2 <= '1';
    elsif (STROBE='1' and READPOWERSTATUS='1') then
      OUTDATA(7 downto 0) <= R_LVTURNON(8 downto 1);
      D_OUTDATA_2 <= '1';
    else
      OUTDATA(7 downto 0) <= "ZZZZZZZZ";
      D_OUTDATA_2 <= '0';
    end if;
    

    FD(D_OUTDATA_2,SLOWCLK,Q_OUTDATA_2);
    if (Q_OUTDATA_2='1') then
      DTACK_INNER <= '0';
    else
      DTACK_INNER <= 'Z';
    end if;

  end process;

  
--  CREATE_DTACK_4: process (WRITEPOWER,STROBE,SLOWCLK)
  CREATE_DTACK_4: process (WRITEPOWER,STROBE,SLOWCLK,D_DTACK_4,Q_DTACK_4)
  begin
    if (WRITEPOWER='1' and STROBE='1') then
      D_DTACK_4 <= '1';
    else
      D_DTACK_4 <= '0';
    end if;
    FD(D_DTACK_4,SLOWCLK,Q_DTACK_4);
    if (Q_DTACK_4='1') then
      DTACK_INNER <= '0';
    else
      DTACK_INNER <= 'Z';
    end if;
  end process;

  CREATE_RDMONBK: process (READMON,STROBE,BUSY)
  begin
    if (READMON='1' and STROBE='1' and BUSY='0') then
      RDMONBK <= '1';
    else
      RDMONBK <= '0';
    end if;
  end process;

  CREATE_DTACK_5: process (RDMONBK)
  begin
    if (RDMONBK='1') then
      DTACK_INNER <= '0';
    else
      DTACK_INNER <= 'Z';
    end if;
  end process;

  CREATE_LVADCEN: process (SELADC_vector)
  begin
    if (SELADC_vector(1)='0' and SELADC_vector(2)='0' and SELADC_vector(3)='0') then
      LVADCEN(0) <= '0';
    else
      LVADCEN(0) <= '1';
    end if;

    if (SELADC_vector(1)='1' and SELADC_vector(2)='0' and SELADC_vector(3)='0') then
      LVADCEN(1) <= '0';
    else
      LVADCEN(1) <= '1';
    end if;

    if (SELADC_vector(1)='0' and SELADC_vector(2)='1' and SELADC_vector(3)='0') then
      LVADCEN(2) <= '0';
    else
      LVADCEN(2) <= '1';
    end if;

    if (SELADC_vector(1)='1' and SELADC_vector(2)='1' and SELADC_vector(3)='0') then
      LVADCEN(3) <= '0';
    else
      LVADCEN(3) <= '1';
    end if;

    if (SELADC_vector(1)='0' and SELADC_vector(2)='0' and SELADC_vector(3)='1') then
      LVADCEN(4) <= '0';
    else
      LVADCEN(4) <= '1';
    end if;

    if (SELADC_vector(1)='1' and SELADC_vector(2)='0' and SELADC_vector(3)='1') then
      LVADCEN(5) <= '0';
    else
      LVADCEN(5) <= '1';
    end if;
    
    if (SELADC_vector(1)='0' and SELADC_vector(2)='1' and SELADC_vector(3)='1') then
      LVADCEN(6) <= '0';
    else
      LVADCEN(6) <= '1';
    end if;
    
  end process;

--  CREATE_LOADON: process (WRITEPOWER,STROBE,SLOWCLK)
  CREATE_LOADON: process (WRITEPOWER,STROBE,SLOWCLK,C_LOADON,Q1_LOADON,Q2_LOADON,LOADON_INNER)
  begin
    if (WRITEPOWER='1' and STROBE='1') then
      C_LOADON <= '1';
    else
      C_LOADON <= '0';
    end if;

    FDC(VCC,C_LOADON,LOADON_INNER,Q1_LOADON);
    FD(Q1_LOADON,SLOWCLK,Q2_LOADON);
    FD(Q2_LOADON,SLOWCLK,LOADON_INNER);
  end process;


  CREATE_OUTDATA_FULL: process (BUSY,RSTBUSY,CLKMON,ADCIN,SLOWCLK,RST,RDMONBK,CE_OUTDATA_FULL,Q_OUTDATA_FULL)
  begin
    if (BUSY='1' and RSTBUSY='0' and CLKMON='0') then
      CE_OUTDATA_FULL <= '1';
    else
      CE_OUTDATA_FULL <= '0';
    end if;

    SR16CE(SLOWCLK,CE_OUTDATA_FULL,RST,ADCIN,Q_OUTDATA_FULL,Q_OUTDATA_FULL);

    if (RDMONBK='1') then
      OUTDATA(15 downto 0) <= Q_OUTDATA_FULL(15 downto 0);
    else
      OUTDATA(15 downto 0) <= "ZZZZZZZZZZZZZZZZ";
    end if;
  end process;

 --    SLI_ADCDATA <= '0';
     SLI_ADCDATA <= 'L';
   
  CREATE_ADCDATA: process (INDATA,LOAD,CLKMON,BUSY,SLOWCLK,RST,L_ADCDATA,CE_ADCDATA,Q_ADCDATA,SLI_ADCDATA)

  begin
    if (LOAD='1' and CLKMON='0') then
      L_ADCDATA <= '1';
    else
      L_ADCDATA <= '0';
    end if;

    if (BUSY='1' and CLKMON='0') then
      CE_ADCDATA <= '1';
    else
      CE_ADCDATA <= '0';
    end if;

    SR8CLE(SLOWCLK,CE_ADCDATA,RST,L_ADCDATA,SLI_ADCDATA,INDATA(7 downto 0),Q_ADCDATA,Q_ADCDATA);
   ADCDATA <= Q_ADCDATA(7);
 end process;

--  CREATE_ADCCLK: process (BUSY,RSTBUSY,RST,SLOWCLK,ADCCLK_INNER)  --CREATE_CLKMON too
  CREATE_ADCCLK: process (BUSY,RSTBUSY,RST,SLOWCLK,ADCCLK_INNER,CE_ADCCLK,CLR_ADCCLK,CLKMON)  --CREATE_CLKMON too
  begin
    if (BUSY='1' and RSTBUSY='0') then
      CE_ADCCLK <= '1';
    else
      CE_ADCCLK <= '0';
    end if;
    
    if (BUSY='0' or RST='1') then
      CLR_ADCCLK <= '1';
    else
      CLR_ADCCLK <= '0';
    end if;

    FDCE(ADCCLK_INNER,SLOWCLK,CE_ADCCLK,CLR_ADCCLK,CLKMON);
    ADCCLK_INNER <= not CLKMON;
  end process;

--  CREATE_BUSY: process (RST,CLKMON,SLOWCLK,BUSY)  --CREATE_RSTBUSY too
  CREATE_BUSY: process (RST,CLKMON,SLOWCLK,BUSY,CE1_BUSY,CLR_BUSY,QTIME,DONEMON,CE2_BUSY,Q1_BUSY,Q2_BUSY,D_BUSY)  --CREATE_RSTBUSY too
  begin
    if (BUSY='1' and CLKMON='0') then
      CE1_BUSY <= '1';
    else
      CE1_BUSY <= '0';
    end if;
    
    CLR_BUSY <= Q2_BUSY or RST;

    CB8CE(SLOWCLK,CE1_BUSY,CLR_BUSY,QTIME,QTIME,blank1,blank2);

    if (QTIME(4)='1' and QTIME(3)='1' and QTIME(1)='1') then
      DONEMON <= '1';
    else
      DONEMON <= '0';
    end if;

    CE2_BUSY <= BUSY and CLKMON;

    FDCE(DONEMON,SLOWCLK,CE2_BUSY,CLR_BUSY,Q1_BUSY);
    FD(Q1_BUSY,SLOWCLK,Q2_BUSY);

    RSTBUSY <= RST or Q1_BUSY;

    D_BUSY <= LOAD or BUSY;

    FDR(D_BUSY,SLOWCLK,RSTBUSY,BUSY);
    
  end process;

--  CREATE_LOAD: process (STROBE,WRITEADC,BUSY,RST,CLKMON,SLOWCLK,VCC,ASYNLOAD)  --CREATE_DTACK too
  CREATE_LOAD: process (STROBE,WRITEADC,BUSY,Q2_BUSY,RST,Q1_LOAD,Q2_LOAD,Q3_LOAD,Q4_LOAD,CLR1_LOAD,CLR2_LOAD,CLKMON,SLOWCLK,VCC,ASYNLOAD,LOAD,CE_LOAD)  --CREATE_DTACK too
  begin
    if (STROBE='1' and WRITEADC='1' and BUSY='0') then
      ASYNLOAD <= '1';
    else
      ASYNLOAD <= '0';
    end if;

    CLR1_LOAD <= RST or Q2_LOAD;

    FDC(VCC,ASYNLOAD,CLR1_LOAD,Q1_LOAD);
    FDC(Q1_LOAD,SLOWCLK,RST,LOAD);

    if (BUSY='1' and CLKMON='0') then
      CE_LOAD <= '1';
    else
      CE_LOAD <= '0';
    end if;

    FDCE(LOAD,SLOWCLK,CE_LOAD,RST,Q2_LOAD);
    FDC(Q2_LOAD,SLOWCLK,RST,Q3_LOAD);

-- Guido: to bring DTACK high after the end of the ADC acquisition (otherwise we need to wait for another code)
--    if (RST='1' or WRITEADC='0') then
    if (RST='1' or WRITEADC='0' or BUSY='0') then
      CLR2_LOAD <= '1';
    else
      CLR2_LOAD <= '0';
    end if;

    FDC(VCC,Q3_LOAD,CLR2_LOAD,Q4_LOAD);

    if (Q4_LOAD='1') then
      DTACK <= '0';
    else
      DTACK <= 'Z';
    end if;
  end process;

  SET_LOADON: process (LOADON_INNER)
  begin
    LOADON <= LOADON_INNER;
  end process;
  
  SET_DTACK: process (DTACK_INNER)
  begin
    DTACK <= DTACK_INNER;
  end process;
  SET_VCC: process (VCC)
  begin
    VCC <= '1';
  end process;
  SET_LVTURNON: process (LVTURNON_INNER)
  begin
    LVTURNON <= LVTURNON_INNER;
  end process;
  SET_ADCCLK: process (ADCCLK_INNER)
  begin
    ADCCLK <= ADCCLK_INNER;
  end process;

    DIAGLVDB(0) <= SLOWCLK;
    DIAGLVDB(1) <= CE_ADCDATA;
    DIAGLVDB(2) <= CLKMON;
    DIAGLVDB(3) <= ADCCLK_INNER;
    DIAGLVDB(4) <= BUSY;
    DIAGLVDB(5) <= L_ADCDATA;
    DIAGLVDB(17 downto 6) <= "000000000000";   
  
end LVDBMON_Arch;
