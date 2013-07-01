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
  signal CMDDEV : std_logic_vector(4 downto 0);
begin 

	-- Decode instruction
	CMDHIGH <= '1' when (DEVICE='1' and COMMAND(4)='0' and COMMAND(5)='0') else '0';
	CMDDEV <= CMDHIGH & COMMAND(3) & COMMAND(2) & COMMAND(1) & COMMAND(0);
	
	DATASHFT <= '1' when (CMDDEV(4 downto 2)="100") else '0';
	INSTSHFT <= '1' when (CMDDEV="10111") else '0';
	READTDO  <= '1' when (CMDDEV="10101") else '0';
	RSTJTAG  <= '1' when (CMDDEV="10110") else '0';

	-- Generate BUSY
	FDC(LOAD,SLOWCLK,RST,Q_BUSY);
	CLR_BUSY <= '1' when (((DONEDATA_1='1') and (TAILEN='0')) or (RST='1') or (DONETAIL='1')) else '0';
   D_BUSY <= Q_BUSY or BUSY;
   FDC(D_BUSY,SLOWCLK,CLR_BUSY,BUSY);
   FDC(BUSY,SLOWCLK,RST,BUSYP1);

	-- Generate ENABLE
	CE_ENABLE <= RESETJTAG or BUSY;
	D_ENABLE <= not ENABLE;
   FDCE(D_ENABLE,SLOWCLK,CE_ENABLE,RST,ENABLE);
   TCK <= ENABLE;

	-- Generate LOAD
	D1_LOAD <= DATASHFT or INSTSHFT;
   CLR_LOAD <= LOAD or RST;
   FDC(D1_LOAD,STROBE,CLR_LOAD,Q_LOAD);
   D2_LOAD <= '1' when (Q_LOAD='1' and BUSY='0') else '0';
   FDC(D2_LOAD,SLOWCLK,RST,LOAD);

	-- Generate SHIFT2
   CE_SHIFT2 <= SHDATA and ENABLE;
	-- SR16CLRE(SLOWCLK,CE_SHIFT1,RST,LOAD,Q_SHIFT2(0),INDATA,Q_SHIFT2,Q_SHIFT2); 
   SR16CLRE(SLOWCLK,CE_SHIFT2,RST,LOAD,Q_SHIFT2(0),INDATA,Q_SHIFT2,Q_SHIFT2); -- Guido - CE_SHIFT1 instead of CE_SHIFT2?
   TDI <= Q_SHIFT2(0);

	-- Generate DONEDATA
   D_DONEDATA <= COMMAND(9 downto 6);
   CB4CLED(SLOWCLK,CE_DONEDATA,CLR_DONEDATA,LOAD,UP_DONEDATA,D_DONEDATA,Q_DONEDATA,Q_DONEDATA,blank5,blank6);
   CE_DONEDATA <= SHDATA and ENABLE;
	CLR_DONEDATA <= '1' when (RST='1' and DONEDATA_1='1' and DONEDATA='1') else '0';
   UP_DONEDATA <= '0';
	-- Guido - Missing the 'and' with 'not LOAD'
	D2_DONEDATA <= '1' when (Q_DONEDATA(0)='0' and Q_DONEDATA(1)='0' and Q_DONEDATA(2)='0' and Q_DONEDATA(3)='0') and (LOAD = '0') else '0';
   FDCE(D2_DONEDATA,SLOWCLK,SHDATA,LOAD,DONEDATA);
   FDC(DONEDATA,SLOWCLK,LOAD,DONEDATA_1);
   FDC(DONEDATA_1,SLOWCLK,LOAD,DONEDATA_2);

	-- Generate IHEADEN
	--C_IHEADEN <= '1' when (STROBE='1' and BUSY='0') else '0';
	C_IHEADEN <= '1' when (STROBE='1') else '0';
   CLR_IHEADEN <= RST or DONEIHEAD;
   FDCE(COMMAND(0),C_IHEADEN,INSTSHFT,CLR_IHEADEN,IHEADEN);

	-- Generate DHEADEN
	--C_DHEADEN <= '1' when (STROBE='1' and BUSY='0') else '0';
	C_DHEADEN <= '1' when (STROBE='1') else '0';
   CLR_DHEADEN <= RST or DONEDHEAD;
   FDCE(COMMAND(0),C_DHEADEN,DATASHFT,CLR_DHEADEN,DHEADEN);

	-- Generate SHIHEAD / Generate SHDHEAD
   SHIHEAD <= BUSY and IHEADEN;
   SHDHEAD <= BUSY and DHEADEN;

	-- Generate TAILEN
   CE_TAILEN <= INSTSHFT or DATASHFT;
   CLR_TAILEN <= RST or DONETAIL;
   FDCE(COMMAND(1),LOAD,CE_TAILEN,CLR_TAILEN,TAILEN);

	-- Generate SHIH_TMS
   CE_SHIH_TMS <= SHIHEAD and ENABLE;
   FDCE(Q5_SHIH_TMS,SLOWCLK,CE_SHIH_TMS,RST,Q1_SHIH_TMS);
   FDCE(Q1_SHIH_TMS,SLOWCLK,CE_SHIH_TMS,RST,Q2_SHIH_TMS);
   FDPE(Q2_SHIH_TMS,SLOWCLK,CE_SHIH_TMS,RST,Q3_SHIH_TMS);
   FDPE(Q3_SHIH_TMS,SLOWCLK,CE_SHIH_TMS,RST,Q4_SHIH_TMS);
   FDCE(Q4_SHIH_TMS,SLOWCLK,CE_SHIH_TMS,RST,Q5_SHIH_TMS);
	SHIH_TMS <= Q5_SHIH_TMS when (SHIHEAD='1') else 'Z';

	-- Generate SHDH_TMS
   CE_SHDH_TMS <= SHDHEAD and ENABLE;
   FDCE(Q5_SHDH_TMS,SLOWCLK,CE_SHDH_TMS,RST,Q1_SHDH_TMS);
   FDCE(Q1_SHDH_TMS,SLOWCLK,CE_SHDH_TMS,RST,Q2_SHDH_TMS);
   FDPE(Q2_SHDH_TMS,SLOWCLK,CE_SHDH_TMS,RST,Q3_SHDH_TMS);
   FDCE(Q3_SHDH_TMS,SLOWCLK,CE_SHDH_TMS,RST,Q4_SHDH_TMS);
   FDCE(Q4_SHDH_TMS,SLOWCLK,CE_SHDH_TMS,RST,Q5_SHDH_TMS);
	SHDH_TMS <= Q5_SHDH_TMS when  (SHDHEAD='1') else 'Z';

	-- Generate LOOP_DONEIHEAD
	R_LOOP_DONEIHEAD <= '1' when (LOAD='1' or RST='1' or Q_LOOP_DONEIHEAD='1') else '0';
   CB4RE(SLOWCLK,SHIHEAD,R_LOOP_DONEIHEAD,Qvector_LOOP_DONEIHEAD,Qvector_LOOP_DONEIHEAD,blank7,blank8);
   DONEIHEAD <= Qvector_LOOP_DONEIHEAD(1) and Qvector_LOOP_DONEIHEAD(3);
   FD(DONEIHEAD,SLOWCLK,Q_LOOP_DONEIHEAD);

	-- Generate LOOP_DONEDHEAD
	R_LOOP_DONEDHEAD <= '1' when (LOAD='1' or RST='1' or Q_LOOP_DONEDHEAD='1') else '0';
   CB4RE(SLOWCLK,SHDHEAD,R_LOOP_DONEDHEAD,Qvector_LOOP_DONEDHEAD,Qvector_LOOP_DONEDHEAD,blank7,blank8);
   DONEDHEAD <= Qvector_LOOP_DONEDHEAD(1) and Qvector_LOOP_DONEDHEAD(3);
   FD(DONEDHEAD,SLOWCLK,Q_LOOP_DONEDHEAD);

	-- Generate SHDATA
	(SHDATA, SHDATAX) <= std_logic_vector'("11") when (BUSY='1' and DHEADEN='0' and IHEADEN='0' and DONEDATA_1='0') else
								std_logic_vector'("00");

	-- Generate SHD_TMS
	-- SHD_TMS <= (TAILEN and D2_DONEDATA_1) when (SHDATA='1') else 'Z'; -- Guido - BUG!!!!!!!!!!
	SHD_TMS <= (TAILEN and D2_DONEDATA) when (SHDATA='1') else 'Z'; 

	-- Generate SHTAIL
   SHTAIL <= BUSY and DONEDATA_1 and TAILEN;

	-- Generate SHT_TMS
   CE_SHT_TMS <= SHTAIL and ENABLE;
   FDCE(Q2_SHT_TMS,SLOWCLK,CE_SHT_TMS,RST,Q1_SHT_TMS);
   FDPE(Q1_SHT_TMS,SLOWCLK,CE_SHT_TMS,RST,Q2_SHT_TMS);
	SHT_TMS <= Q2_SHT_TMS when (SHTAIL='1') else 'Z';

	-- Generate DONETAIL
	CE_DONETAIL <= '1' when (SHTAIL='1' and ENABLE='1') else '0';
	CLR_DONETAIL <= '1' when (RST='1' or Q_DONETAIL='1') else '0';
   C1_DONETAIL <= SLOWCLK;
   C2_DONETAIL <= SLOWCLK;
   CB4CE(C1_DONETAIL,CE_DONETAIL,CLR_DONETAIL,Qvector_DONETAIL,Qvector_DONETAIL,blank1,blank2);
   DONETAIL <= Qvector_DONETAIL(1);
   FD_1(DONETAIL,C2_DONETAIL,Q_DONETAIL);
    
	-- Generate DTACK / Generate LED
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
	(DTACK_INNER, LED) <= std_logic_vector'("00") when (Q3_LED='1' and Q4_LED='1') else
								 std_logic_vector'("Z1");

	DTACK_INNER <= '0' when (RDTDODK='1') else 'Z';  -- Manuel: Multiple drivers?

   CLR_DTACK <= not OKRST;
   CB4CE(SLOWCLK,RESETJTAG,CLR_DTACK,Q_DTACK_3,Q_DTACK_3,blank3,blank4);
	RESETDONE <= '1' when (Q_DTACK_3(2)='1' and Q_DTACK_3(3)='1') else '0';
	DTACK_INNER <= '0' when (RESETDONE='1' and INITJTAGS='0') else 'Z';

   DTACK <= DTACK_INNER;


	-- Generate RESETJTAG
   PRE_D_RESETJTAG <= STROBE and RSTJTAG;
   D_RESETJTAG <= INITJTAGS or PRE_D_RESETJTAG;
   FDC(D_RESETJTAG,FASTCLK,RST,Q1_RESETJTAG);
   FDC(Q1_RESETJTAG,FASTCLK,RST,Q2_RESETJTAG);
   OKRST <= Q1_RESETJTAG and Q2_RESETJTAG;
   CLR_RESETJTAG <= RESETDONE or RST;
   VCC <= '1';
   FDC(VCC,OKRST,CLR_RESETJTAG,BADSIG);
   FDC(BADSIG,SLOWCLK,CLR_RESETJTAG,RESETJTAG);

	-- Generate SHIFT1 / Generate OUTDATA
   CE_SHIFT1 <= SHDATAX and not ENABLE;
   SR16LCE(SLOWCLK,CE_SHIFT1,RST,MBCTDO,QC,QC);
	OUTDATA(15 downto 0) <= QC(15 downto 0) when (RDTDODK='1') else "ZZZZZZZZZZZZZZZZ";

	-- Generate RDTDODK
	RDTDODK <= '1' when (STROBE='1' and READTDO='1' and BUSYP1='0' and BUSY='0') else '0';


	-- Generate RST_TMS
   CE_RST_TMS <= RESETJTAG and ENABLE;
   FDCE(Q6_RST_TMS,SLOWCLK,CE_RST_TMS,RST,Q1_RST_TMS);
   FDPE(Q1_RST_TMS,SLOWCLK,CE_RST_TMS,RST,Q2_RST_TMS);
   FDPE(Q2_RST_TMS,SLOWCLK,CE_RST_TMS,RST,Q3_RST_TMS);
   FDPE(Q3_RST_TMS,SLOWCLK,CE_RST_TMS,RST,Q4_RST_TMS);
   FDPE(Q4_RST_TMS,SLOWCLK,CE_RST_TMS,RST,Q5_RST_TMS);
   FDPE(Q5_RST_TMS,SLOWCLK,CE_RST_TMS,RST,Q6_RST_TMS);
	RST_TMS <= Q6_RST_TMS when (RESETJTAG='1') else 'Z';

	-- Generate TMS
	TMS <= SHD_TMS  when (SHDATA='1') else
			 SHIH_TMS when (SHIHEAD='1') else
			 SHDH_TMS when (SHDHEAD='1') else
			 RST_TMS  when (RESETJTAG='1') else
			 SHT_TMS  when (SHTAIL='1') else
			 'X';
			 
end MBCJTAG_Arch;
    
