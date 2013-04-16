-- CONFREGS: Loads via JTAG configuration registers
-- Used to be LOADTIME+SETFEBDLY+SETCALDLY in the old design

library unisim;
library ieee;
library work;
use unisim.vcomponents.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;

entity CONFREGS is  
  generic (
    NFEB : integer range 1 to 7 := 5  -- Number of DCFEBS, 7 in the final design
    );  
  port (
    RST : in std_logic;

    BTDI   : in std_logic;
    SEL2   : in std_logic;
    DRCK   : in std_logic;
    UPDATE : in std_logic;
    SHIFT  : in std_logic;

    FLOADDLY  : in std_logic;           -- Generates PUSH_DLY & LCT_L1A_DLY & tMB_PUSH_DLY & ALCT_PUSH_DLY
    FLOADCDLY : in std_logic;           -- Generates INJDLY & EXTDLY & CALGDLY & CALLCTDLY
    FLOADID   : in std_logic;           -- Generates CRATEID
    FLOADKILL : in std_logic;           -- Generates KILL

    TDO         : out std_logic;
    ALCT_PUSH_DLY : out std_logic_vector(4 downto 0);
    TMB_PUSH_DLY  : out std_logic_vector(4 downto 0);
    PUSH_DLY    : out std_logic_vector(4 downto 0);
    LCT_L1A_DLY : out std_logic_vector(5 downto 0);
    INJDLY      : out std_logic_vector(4 downto 0);
    EXTDLY      : out std_logic_vector(4 downto 0);
    CALGDLY     : out std_logic_vector(4 downto 0);
    CALLCTDLY   : out std_logic_vector(3 downto 0);
    KILL    : out std_logic_vector(NFEB+2 downto 1);
    CRATEID     : out std_logic_vector(6 downto 0)
    );

end CONFREGS;

architecture CONFREGS_Arch of CONFREGS is

  signal DLY_SHR_EN, DLY_DR_CLK, DLY_TDO    : std_logic;
  signal DLY_SHR                            : std_logic_vector(22 downto 1);
  signal DLY_DR                             : std_logic_vector(21 downto 1);
  signal CDLY_SHR_EN, CDLY_DR_CLK, CDLY_TDO : std_logic;
  signal CDLY_SHR                           : std_logic_vector(20 downto 1);
  signal CDLY_DR                            : std_logic_vector(19 downto 1);
  signal ID_SHR_EN, ID_DR_CLK, ID_TDO       : std_logic;
  signal ID_SHR                             : std_logic_vector(8 downto 1);
  signal ID_DR                              : std_logic_vector(7 downto 1);
  signal KILL_SHR_EN, KILL_DR_CLK, KILL_TDO : std_logic;
  signal KILL_SHR                           : std_logic_vector(NFEB+3 downto 1);
  signal KILL_DR                            : std_logic_vector(NFEB+2 downto 1);

begin  --Architecture

  -- Generate ALCT_PUSH_DLY / Generate TMB_PUSH_DLY / Generate PUSH_DLY / Generate LCT_L1A_DLY
  DLY_SHR_EN <= SHIFT and SEL2 and FLOADDLY;
  DLY_DR_CLK <= UPDATE and SEL2 and FLOADDLY;
  DLY_SHR(22) <= BTDI;
  -- In the original design, at reset DAVDLY(14:10) = PUSH_DLY was 10110  
  GEN_DLY_SHR : for I in 21 downto 1 generate
  begin
    FDPE_I : FDPE port map(DLY_SHR(I), DRCK, DLY_SHR_EN, DLY_SHR(I+1), RST);
    FDP_I  : FDP port map(DLY_DR(I), DLY_DR_CLK, DLY_SHR(I), RST);
  end generate GEN_DLY_SHR;
  LCT_L1A_DLY(5 downto 0) <= DLY_DR(6 downto 1);
  PUSH_DLY(4 downto 0)    <= DLY_DR(11 downto 7);
  TMB_PUSH_DLY(4 downto 0)    <= DLY_DR(16 downto 12);
  ALCT_PUSH_DLY(4 downto 0)    <= DLY_DR(21 downto 17);
  DLY_TDO                 <= DLY_SHR(1);


  -- Generate INJDLY / Generate EXTDLY / Generate CALGDLY / Generate CALLCTDLY
  CDLY_SHR_EN <= SHIFT and SEL2 and FLOADCDLY;
  CDLY_DR_CLK <= UPDATE and SEL2 and FLOADCDLY;
  CDLY_SHR(20) <= BTDI;
  -- In the original design, at reset DAVCDLY(14:10) = PUSH_CDLY was 10110  
  GEN_CDLY_SHR : for I in 19 downto 1 generate
  begin
    FDPE_I : FDPE port map(CDLY_SHR(I), DRCK, CDLY_SHR_EN, CDLY_SHR(I+1), RST);
    FDP_I  : FDP port map(CDLY_DR(I), CDLY_DR_CLK, CDLY_SHR(I), RST);
  end generate GEN_CDLY_SHR;
  INJDLY(4 downto 0)    <= CDLY_DR(5 downto 1);
  EXTDLY(4 downto 0)    <= CDLY_DR(10 downto 6);
  CALGDLY(4 downto 0)   <= CDLY_DR(15 downto 11);
  CALLCTDLY(3 downto 0) <= CDLY_DR(19 downto 16);
  CDLY_TDO              <= CDLY_SHR(1);


  -- Generate CRATEID
  ID_SHR_EN <= SHIFT and SEL2 and FLOADID;
  ID_DR_CLK <= UPDATE and SEL2 and FLOADID;
  ID_SHR(8) <= BTDI;
  -- In the original design, at reset CRATEID was 0011001  
  GEN_ID_SHR : for I in 7 downto 1 generate
  begin
    FDPE_I : FDPE port map(ID_SHR(I), DRCK, ID_SHR_EN, ID_SHR(I+1), RST);
    FDP_I  : FDP port map(ID_DR(I), ID_DR_CLK, ID_SHR(I), RST);
  end generate GEN_ID_SHR;
  CRATEID(6 downto 0) <= ID_DR(7 downto 1);
  ID_TDO              <= ID_SHR(1);


  -- Generate KILL
  KILL_SHR_EN <= SHIFT and SEL2 and FLOADKILL;
  KILL_DR_CLK <= UPDATE and SEL2 and FLOADKILL;
  KILL_SHR(NFEB+3) <= BTDI;
  GEN_KILL_SHR : for I in NFEB+2 downto 1 generate
  begin
    FDCE_I : FDCE port map(KILL_SHR(I), DRCK, KILL_SHR_EN, RST, KILL_SHR(I+1));
    FDC_I  : FDC port map(KILL_DR(I), KILL_DR_CLK, RST, KILL_SHR(I));
  end generate GEN_KILL_SHR;
  KILL(NFEB+2 downto 1) <= KILL_DR(NFEB+2 downto 1);
  KILL_TDO                <= KILL_SHR(1);

  TDO <= DLY_TDO when FLOADDLY = '1' else
         CDLY_TDO when FLOADCDLY = '1' else
         ID_TDO   when FLOADID = '1' else
         KILL_TDO when FLOADKILL = '1' else
         'Z';

end CONFREGS_Arch;
