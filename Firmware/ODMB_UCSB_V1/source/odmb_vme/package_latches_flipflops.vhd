-- Aug 27
library ieee ;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

package Latches_Flipflops is
  
  -----------------------------------------------------------------------------
  procedure VOTE (
    signal D0 : in std_logic;
    signal D1 : in std_logic;
    signal D2 : in std_logic;
    signal Q : out std_logic);
  -----------------------------------------------------------------------------
  procedure FD (
    signal D : in std_logic;
    signal C : in std_logic;
    signal Q : out std_logic);
  -----------------------------------------------------------------------------
  procedure REGFD (
    signal D : in std_logic;
    signal C : in std_logic;
    signal Q : out std_logic);
  -----------------------------------------------------------------------------
  procedure IFD (
    signal D : in std_logic;
    signal C : in std_logic;
    signal Q : out std_logic);
  -----------------------------------------------------------------------------
  procedure IFDI (
    signal D : in std_logic;
    signal C : in std_logic;
    signal Q : out std_logic);
  -----------------------------------------------------------------------------
 procedure FDE (
    signal D : in std_logic;
    signal C : in std_logic;
    signal CE : in std_logic;
    signal Q : out std_logic);
  -----------------------------------------------------------------------------
  procedure FD_1 (
    signal D : in std_logic;
    signal C : in std_logic;
    signal Q : out std_logic);
  -----------------------------------------------------------------------------
   procedure FDC (
    signal D: in std_logic;
    signal C: in std_logic;
    signal CLR: in std_logic;
    signal Q: out std_logic);
  -----------------------------------------------------------------------------
   procedure FDP (
    signal D: in std_logic;
    signal C: in std_logic;
    signal PRE: in std_logic;
    signal Q: out std_logic);
  -----------------------------------------------------------------------------
   procedure FDP_1 (
    signal D: in std_logic;
    signal C: in std_logic;
    signal PRE: in std_logic;
    signal Q: out std_logic);
  -----------------------------------------------------------------------------
   procedure FDR (
    signal D: in std_logic;
    signal C: in std_logic;
    signal R: in std_logic;
    signal Q: out std_logic);
  -----------------------------------------------------------------------------
  procedure FDC_1 (
    signal D: in std_logic;
    signal C: in std_logic;
    signal CLR: in std_logic;
    signal Q: out std_logic);
  -----------------------------------------------------------------------------
  procedure FDPE (
    signal D: in std_logic;
    signal C: in std_logic;
    signal CE: in std_logic;
    signal PRE: in std_logic;
    signal Q: out std_logic);
  -----------------------------------------------------------------------------
  procedure FDPE_1 (
    signal D: in std_logic;
    signal C: in std_logic;
    signal CE: in std_logic;
    signal PRE: in std_logic;
    signal Q: out std_logic);
  -----------------------------------------------------------------------------
  procedure FDCE (
    signal D: in std_logic;
    signal C: in std_logic;
    signal CE: in std_logic;
    signal CLR: in std_logic;
    signal Q: out std_logic);
  -----------------------------------------------------------------------------
  procedure FDCE_1 (
    signal D: in std_logic;
    signal C: in std_logic;
    signal CE: in std_logic;
    signal CLR: in std_logic;
    signal Q: out std_logic);
  -----------------------------------------------------------------------------
  procedure ILD6 (
    signal D: in std_logic_vector(5 downto 0);
    signal G: in std_logic;
    signal Q: out std_logic_vector(5 downto 0));
  -----------------------------------------------------------------------------
  procedure CB4CE (
    signal C       : in  std_logic;
    signal CE      : in  std_logic;
    signal CLR     : in  std_logic;
    signal Q_in : in std_logic_vector(3 downto 0);
    signal Q       : out std_logic_vector(3 downto 0);
    signal CEO : out std_logic;
    signal TC      : out std_logic);
-------------------------------------------------------------------------------
  procedure CB16CE (
    signal C       : in  std_logic;
    signal CE      : in  std_logic;
    signal CLR     : in  std_logic;
    signal Q_in : in std_logic_vector(15 downto 0);
    signal Q       : out std_logic_vector(15 downto 0);
    signal CEO : out std_logic;
    signal TC      : out std_logic);
-------------------------------------------------------------------------------
  procedure SRL16 (
    signal D       : in  std_logic;
    signal C     : in  std_logic;
    signal A       : in std_logic_vector(3 downto 0);
    signal SHR_IN : in std_logic_vector(15 downto 0);
    signal SHR_OUT : out std_logic_vector(15 downto 0);
    --signal A : in integer;
    signal Q      : out std_logic);
-------------------------------------------------------------------------------
--entity CB4CE_2 is
--port(
  --  signal C       : in  std_logic;
    --signal CE      : in  std_logic;
    --signal CLR     : in  std_logic;
    --signal Q       : out std_logic_vector(3 downto 0);
    --signal CEO : out std_logic;
    --signal TC      : out std_logic);
  --end CB4CE_2;
-------------------------------------------------------------------------------
  procedure CB8CE (
    signal C       : in  std_logic;
    signal CE      : in  std_logic;
    signal CLR     : in  std_logic;
    signal Q_in : in std_logic_vector(7 downto 0);
    signal Q       : out std_logic_vector(7 downto 0);
    signal CEO : out std_logic;
    signal TC      : out std_logic);
-------------------------------------------------------------------------------
  procedure CB8RE (
    signal C       : in  std_logic;
    signal CE      : in  std_logic;
    signal R     : in  std_logic;
    signal Q_in : in std_logic_vector(7 downto 0);
    signal Q       : out std_logic_vector(7 downto 0);
    signal CEO : out std_logic;
    signal TC      : out std_logic);
-------------------------------------------------------------------------------
  procedure CB4RE (
    signal C       : in  std_logic;
    signal CE      : in  std_logic;
    signal R     : in  std_logic;
    signal Q_in : in std_logic_vector(3 downto 0);
    signal Q       : out std_logic_vector(3 downto 0);
    signal CEO : out std_logic;
    signal TC      : out std_logic);
-------------------------------------------------------------------------------
  procedure CB4CLED (
    signal C       : in  std_logic;
    signal CE      : in  std_logic;
    signal CLR     : in  std_logic;
    signal L : in std_logic;
    signal UP : in std_logic;
    signal D : in std_logic_vector(3 downto 0);
    signal Q_in : in std_logic_vector(3 downto 0);
    signal Q       : out std_logic_vector(3 downto 0);
    signal CEO : out std_logic;
    signal TC      : out std_logic);
  -----------------------------------------------------------------------------
  procedure CB2CLED (
    signal C       : in  std_logic;
    signal CE      : in  std_logic;
    signal CLR     : in  std_logic;
    signal L : in std_logic;
    signal UP : in std_logic;
    signal D : in std_logic_vector(1 downto 0);
    signal Q_in : in std_logic_vector(1 downto 0);
    signal Q       : out std_logic_vector(1 downto 0);
    signal CEO : out std_logic;
    signal TC      : out std_logic);
  -----------------------------------------------------------------------------
  procedure SR16CLRE (
    signal C       : in  std_logic;
    signal CE      : in  std_logic;
    signal CLR     : in  std_logic;
    signal L : in std_logic;
    signal SLI : in std_logic;
    signal D : in std_logic_vector(15 downto 0);
    signal Q_in : in std_logic_vector(15 downto 0);
    signal Q       : out std_logic_vector(15 downto 0));
  -----------------------------------------------------------------------------
  procedure SR16CLE (
    signal C       : in  std_logic;
    signal CE      : in  std_logic;
    signal CLR     : in  std_logic;
    signal L : in std_logic;
    signal SLI : in std_logic;
    signal D : in std_logic_vector(15 downto 0);
    signal Q_in : in std_logic_vector(15 downto 0);
    signal Q       : out std_logic_vector(15 downto 0));
  -----------------------------------------------------------------------------
  procedure SR8CLE (
    signal C       : in  std_logic;
    signal CE      : in  std_logic;
    signal CLR     : in  std_logic;
    signal L : in std_logic;
    signal SLI : in std_logic;
    signal D : in std_logic_vector(7 downto 0);
    signal Q_in : in std_logic_vector(7 downto 0);
    signal Q       : out std_logic_vector(7 downto 0));
  -----------------------------------------------------------------------------
  procedure SR16LCE (
    signal C       : in  std_logic;
    signal CE      : in  std_logic;
    signal CLR     : in  std_logic;
    signal SLI : in std_logic;
    signal Q_in : in std_logic_vector(15 downto 0);
    signal Q       : out std_logic_vector(15 downto 0));
  -----------------------------------------------------------------------------
  procedure SR16CE (
    signal C       : in  std_logic;
    signal CE      : in  std_logic;
    signal CLR     : in  std_logic;
    signal SLI : in std_logic;
    signal Q_in : in std_logic_vector(15 downto 0);
    signal Q       : out std_logic_vector(15 downto 0));
  -----------------------------------------------------------------------------
  procedure TMPLCTDLY (
    signal DIN       : in  std_logic;
    signal CLK      : in  std_logic;
    signal DELAY : in std_logic_vector(2 downto 0);
    signal DOUT       : out std_logic);
  -----------------------------------------------------------------------------
  procedure LCTDLY (
    signal DIN       : in  std_logic;
    signal CLK      : in  std_logic;
    signal DELAY : in std_logic_vector(5 downto 0);
    signal XL1ADLY : in std_logic_vector(1 downto 0);
    signal L1FD : in std_logic_vector(3 downto 0);
    signal DOUT       : out std_logic);
  -----------------------------------------------------------------------------
  procedure PUSHDLY (
    signal DIN       : in  std_logic;
    signal CLK      : in  std_logic;
    signal DELAY : in std_logic_vector(4 downto 0);
    signal DOUT       : out std_logic);
  -----------------------------------------------------------------------------
  procedure CB10UPDN (
    signal UP     : in  std_logic;
    signal CE     : in  std_logic;
    signal C      : in  std_logic;
    signal CLR    : in  std_logic;
    signal Q      : out std_logic_vector(9 downto 0);
    signal FULL : out std_logic;
    signal EMPTY1 : out std_logic);
  -----------------------------------------------------------------------------
  procedure BXNDLY (
    signal DIN     : in  std_logic;
    signal CLK     : in  std_logic;
    signal DELAY   : in  std_logic_vector(4 downto 0);
    signal DOUT    : out std_logic);
  -----------------------------------------------------------------------------

end Latches_Flipflops;


package body Latches_Flipflops is
  -------------------------------------------------------------------------------
  procedure VOTE (
    signal D0 : in std_logic;
    signal D1 : in std_logic;
    signal D2 : in std_logic;
    signal Q : out std_logic) is
    
  begin
    if (D0=D1) then
      Q <= D0;
    elsif (D0=D2) then
      Q <= D0;
    elsif (D1=D2) then
      Q <= D1;
    else
      Q <= 'Z';
    end if;
  end VOTE;

-------------------------------------------------------------------------------
  procedure FD_1 (
    signal D : in std_logic;
    signal C : in std_logic;
    signal Q : out std_logic) is
    
  begin
    if (C='0' and C'event) then
      Q <= D;
    end if;
  end FD_1;

-------------------------------------------------------------------------------

  procedure FD (
    signal D : in std_logic;
    signal C : in std_logic;
    signal Q : out std_logic) is
    
  begin
    if (C='1' and C'event) then
      Q <= D;
    end if;
  end FD;
-------------------------------------------------------------------------------
  procedure REGFD (
    signal D : in std_logic;
    signal C : in std_logic;
    signal Q : out std_logic) is
    
  begin
    if (C='1' and C'event) then
      Q <= D;
    end if;
  end REGFD;
-------------------------------------------------------------------------------
    procedure IFD (
    signal D : in std_logic;
    signal C : in std_logic;
    signal Q : out std_logic) is
    
  begin
    if (C='1' and C'event) then
      Q <= D;
    end if;
  end IFD;
-------------------------------------------------------------------------------
    procedure IFDI (
    signal D : in std_logic;
    signal C : in std_logic;
    signal Q : out std_logic) is
    
  begin
    if (C='1' and C'event) then
      Q <= D;
    end if;
  end IFDI;
-------------------------------------------------------------------------------

  procedure FDE (
    signal D : in std_logic;
    signal C : in std_logic;
    signal CE : in std_logic;
    signal Q : out std_logic) is
    
  begin
    if (CE='1' and C='1' and C'event) then
      Q <= D;
    end if;
  end FDE;

-------------------------------------------------------------------------------
  procedure FDC_1 (
      signal D: in std_logic;
      signal C: in std_logic;
      signal CLR: in std_logic;
      signal Q: out std_logic) is
      
    begin
      if (CLR='1') then
        Q <= '0';
      else
        if (C='0' and C'event) then
          Q <= D;
        end if;
      end if;
    end FDC_1;
-------------------------------------------------------------------------------
procedure FDC (
      signal D: in std_logic;
      signal C: in std_logic;
      signal CLR: in std_logic;
      signal Q: out std_logic) is
      
    begin
      if (CLR='1') then
        Q <= '0';
      else
        if (C='1' and C'event) then
          Q <= D;
        end if;
      end if;
    end FDC;
-------------------------------------------------------------------------------
  procedure FDP_1 (
      signal D: in std_logic;
      signal C: in std_logic;
      signal PRE: in std_logic;
      signal Q: out std_logic) is
      
    begin
      if (PRE='1') then
        Q <= '1';
      else
        if (C='0' and C'event) then
          Q <= D;
        end if;
      end if;
    end FDP_1;
-------------------------------------------------------------------------------
  procedure FDP (
      signal D: in std_logic;
      signal C: in std_logic;
      signal PRE: in std_logic;
      signal Q: out std_logic) is
      
    begin
      if (PRE='1') then
        Q <= '1';
      else
        if (C='1' and C'event) then
          Q <= D;
        end if;
      end if;
    end FDP;
-------------------------------------------------------------------------------
  procedure FDR (
      signal D: in std_logic;
      signal C: in std_logic;
      signal R: in std_logic;
      signal Q: out std_logic) is
      
--  Modified by Guido!
--  begin
--      if (R='1' and C='1' and C'event) then
--        Q <= '0';
--      end if;
--      if (R='0' and C='1' and C'event) then
--        Q <= D;
--      end if;

  begin
      if (C='1' and C'event) then
			if (R='1') then
				Q <= '0';
         else
				Q <= D;
			end if;
		end if;

  end FDR;
  ------------------------------------------------------------------------------
  procedure FDCE_1 (
    signal D: in std_logic;
    signal C: in std_logic;
    signal CE: in std_logic;
    signal CLR: in std_logic;
    signal Q: out std_logic) is
  begin
    if (CLR='1') then
      Q <= '0';
    else
      if (CE='1' and C='0' and C'event) then
        Q <= D;            
      end if;
    end if;
  end FDCE_1;
 ------------------------------------------------------------------------------
  procedure FDCE (
    signal D: in std_logic;
    signal C: in std_logic;
    signal CE: in std_logic;
    signal CLR: in std_logic;
    signal Q: out std_logic) is
  begin
    if (CLR='1') then
      Q <= '0';
    else
      if (CE='1' and C='1' and C'event) then
        Q <= D;            
      end if;
    end if;
  end FDCE;
------------------------------------------------------------------------------
  procedure FDPE_1 (
    signal D: in std_logic;
    signal C: in std_logic;
    signal CE: in std_logic;
    signal PRE: in std_logic;
    signal Q: out std_logic) is
  begin
    if (PRE='1') then
      Q <= '1';
    else
      if (CE='1' and C='0' and C'event) then
        Q <= D;            
      end if;
    end if;
  end FDPE_1;
-------------------------------------------------------------------------------
  procedure FDPE (
    signal D: in std_logic;
    signal C: in std_logic;
    signal CE: in std_logic;
    signal PRE: in std_logic;
    signal Q: out std_logic) is
  begin
    if (PRE='1') then
      Q <= '1';
    else
      if (CE='1' and C='1' and C'event) then
        Q <= D;            
      end if;
    end if;
  end FDPE;
 ------------------------------------------------------------------------------
  procedure ILD6 (
    signal D: in std_logic_vector(5 downto 0);
    signal G: in std_logic;
    signal Q: out std_logic_vector(5 downto 0)) is
                 
  begin
	if (G='1') then
         Q(5 downto 0) <= D(5 downto 0);
	end if;
 --       if (G='0' and G'event) then
 --         Q(5 downto 0) <= D(5 downto 0);
 --       end if;

  end ILD6;

-------------------------------------------------------------------------------
  procedure CB4CE (
    signal C       : in  std_logic;
    signal CE      : in  std_logic;
    signal CLR     : in  std_logic;
    signal Q_in       : in std_logic_vector(3 downto 0);
    signal Q       : out std_logic_vector(3 downto 0);
    signal CEO : out std_logic;
    signal TC      : out std_logic) is
 
-- Modified by Guido!
 
--  begin
--    if (CLR='1') then
--      Q <= "0000";
--      CEO <= '0';
--      TC <= '0';
      
--    elsif (CLR='0') then
      
--      if (CE='1' and C='1' and C'event) then
--        Q <= Q_in + 1;
--        if (Q_in="1110") then
--          TC <= '1';
--          CEO <= '1';
--        else
--          TC <= '0';
--        end if;
        
--      elsif (CE='0') then
--       CEO <= '0';
--      end if;
--   end if;
	 
	 begin
  
		if (CLR='1') then
			Q <= "0000";
		elsif (CE = '1' and C='1' and C'event) then
			Q <= Q_in + 1;
		end if;
		
		if (CLR = '1') then
			TC <= '0';
		elsif (CE = '1' and C='1' and C'event and Q_in="1110") then
			TC <= '1';
		end if;
	 
		if (CLR = '1') or (CE = '0')then
			CEO <= '0';
		elsif (CE = '1' and C='1' and C'event and Q_in="1110") then
			CEO <= '1';
		end if;

  end CB4CE;
-------------------------------------------------------------------------------
  procedure CB8CE (
    signal C       : in  std_logic;
    signal CE      : in  std_logic;
    signal CLR     : in  std_logic;
    signal Q_in       : in std_logic_vector(7 downto 0);
    signal Q       : out std_logic_vector(7 downto 0);
    signal CEO : out std_logic;
    signal TC      : out std_logic) is
    
-- Modified by Guido!
 
--  begin
--    if (CLR='1') then
--      Q <= "00000000";
--      CEO <= '0';
--      TC <= '0';
      
--    elsif (CLR='0') then
      
--      if (CE='1' and C='1' and C'event) then
--        Q <= Q_in + 1;
--        if (Q_in="11111110") then
--          TC <= '1';
--          CEO <= '1';
--        else
--          TC <= '0';
--        end if;
        
--      elsif (CE='0') then
--        CEO <= '0';
--      end if;
--    end if;
 	 
	 begin
  
		if (CLR='1') then
			Q <= "00000000";
		elsif (CE = '1' and C='1' and C'event) then
			Q <= Q_in + 1;
		end if;
		
		if (CLR = '1') then
			TC <= '0';
		elsif (CE = '1' and C='1' and C'event and Q_in="11111110") then
			TC <= '1';
		end if;
	 
		if (CLR = '1') or (CE = '0')then
			CEO <= '0';
		elsif (CE = '1' and C='1' and C'event and Q_in="11111110") then
			CEO <= '1';
		end if;

 end CB8CE;
-------------------------------------------------------------------------------
  procedure CB16CE (
    signal C       : in  std_logic;
    signal CE      : in  std_logic;
    signal CLR     : in  std_logic;
    signal Q_in       : in std_logic_vector(15 downto 0);
    signal Q       : out std_logic_vector(15 downto 0);
    signal CEO : out std_logic;
    signal TC      : out std_logic) is
    
-- Modified by Guido!
 
--  begin
--    if (CLR='1') then
--      Q <= "0000000000000000";
--      CEO <= '0';
--      TC <= '0';
--      
--   elsif (CLR='0') then
--      
--      if (CE='1' and C='1' and C'event) then
--        Q <= Q_in + 1;
--        if (Q_in="1111111111111110") then
--          TC <= '1';
--          CEO <= '1';
--        else
--          TC <= '0';
--        end if;
        
--      elsif (CE='0') then
--        CEO <= '0';
--      end if;
--    end if;

	 begin
  
		if (CLR='1') then
			Q <= "0000000000000000";
		elsif (CE = '1' and C='1' and C'event) then
			Q <= Q_in + 1;
		end if;
		
		if (CLR = '1') then
			TC <= '0';
		elsif (CE = '1' and C='1' and C'event and Q_in="1111111111111110") then
			TC <= '1';
		end if;
	 
		if (CLR = '1') or (CE = '0')then
			CEO <= '0';
		elsif (CE = '1' and C='1' and C'event and Q_in="1111111111111110") then
			CEO <= '1';
		end if;

  end CB16CE;
-------------------------------------------------------------------------------
  procedure CB4RE (
    signal C       : in  std_logic;
    signal CE      : in  std_logic;
    signal R     : in  std_logic;
    signal Q_in       : in std_logic_vector(3 downto 0);
    signal Q       : out std_logic_vector(3 downto 0);
    signal CEO : out std_logic;
    signal TC      : out std_logic) is
    
-- Modified by Guido!

-- begin
--    if (R='1' and C='1' and  C'event) then
--      Q <= "0000";
--      CEO <= '0';
--      TC <= '0';
      
--    elsif (R='0') then
      
--      if (CE='1' and C='1' and C'event) then
--        Q <= Q_in + 1;
--        if (Q_in="1110") then
--          TC <= '1';
--         CEO <= '1';
--        else
--          TC <= '0';
--        end if;
        
 --     elsif (CE='0') then
 --       CEO <= '0';
 --     end if;
 --   end if;

	begin
  
		if (C='1' and C'event) then
			if (R='1') then
				Q <= "0000";
			elsif (CE='1') then    
				Q <= Q_in + 1;
			end if;
		end if;
		
		if (R = '1') then
			TC <= '0';
		elsif (Q_in="1110") then
			TC <= '1';
		end if;
	 
		if (R = '1') then
			CEO <= '0';
		elsif (CE = '1' and Q_in="1110") then
			CEO <= '1';
		end if;

 end CB4RE;
-------------------------------------------------------------------------------
    procedure CB8RE (
    signal C       : in  std_logic;
    signal CE      : in  std_logic;
    signal R     : in  std_logic;
    signal Q_in       : in std_logic_vector(7 downto 0);
    signal Q       : out std_logic_vector(7 downto 0);
    signal CEO : out std_logic;
    signal TC      : out std_logic) is
    
-- Modified by Guido!

-- begin
--    if (R='1' and C='1' and  C'event) then
--      Q <= "00000000";
--      CEO <= '0';
--      TC <= '0';
--      
--    elsif (R='0') then
--      
--      if (CE='1' and C='1' and C'event) then
--        Q <= Q_in + 1;
--        if (Q_in="11111110") then
--          TC <= '1';
--          CEO <= '1';
--        else
--          TC <= '0';
--        end if;
        
--      elsif (CE='0') then
--        CEO <= '0';
--      end if;
--    end if;

  begin
		if (C='1' and C'event) then
			if (R='1') then
				Q <= "00000000";
			elsif (CE='1') then    
				Q <= Q_in + 1;
			end if;
		end if;
		
		if (R = '1') then
			TC <= '0';
		elsif (Q_in="11111110") then
			TC <= '1';
		end if;
	 
		if (R = '1') then
			CEO <= '0';
		elsif (CE = '1' and Q_in="11111110") then
			CEO <= '1';
		end if;

  end CB8RE;
-------------------------------------------------------------------------------
   procedure CB2CLED (
    signal C       : in  std_logic;
    signal CE      : in  std_logic;
    signal CLR     : in  std_logic;
    signal L : in std_logic;
    signal UP : in std_logic;
    signal D : in std_logic_vector(1 downto 0);
    signal Q_in       : in std_logic_vector(1 downto 0);
    signal Q       : out std_logic_vector(1 downto 0);
    signal CEO : out std_logic;
    signal TC      : out std_logic) is
    
-- Modified by Guido!
   
--  begin

--    if (CLR='1') then
--      Q <= "00";
--      CEO <= '0';
--      TC <= '0';
--      
--    elsif (CLR='0') then
--      if (L='1' and C='1' and C'event) then
--        Q <= D;
--        
--      elsif (L='0') then
--        if (CE='1' and C='1' and C'event) then
--          Q <= Q_in + 1;
--          if (Q_in="10") then
--            TC <= '1';
--            CEO <= '1';
--          else
--            TC <= '0';
--          end if;
--        
--        elsif (CE='0') then
--          CEO <= '0';
--        end if;
--      end if;
--    end if;

	begin
  
		if (CLR='1') then
			Q <= "00";
		elsif (C='1' and C'event) then
			if (L='1') then
				Q <= D;
			elsif (CE='1') then    
				Q <= Q_in + 1;
			end if;
		end if;
		
		if (CLR = '1') then
			TC <= '0';
		elsif (UP = '1' and Q_in="10") then
			TC <= '1';
		elsif (UP = '0' and Q_in="00") then
			TC <= '1';
		end if;
	 
		if (CLR = '1') then
			CEO <= '0';
		elsif (CE = '1' and UP = '1' and Q_in="10") then
			CEO <= '1';
		elsif (CE = '1' and UP = '0' and Q_in="00") then
			CEO <= '1';
		end if;

  end CB2CLED;
-------------------------------------------------------------------------------
   procedure CB4CLED (
    signal C       : in  std_logic;
    signal CE      : in  std_logic;
    signal CLR     : in  std_logic;
    signal L : in std_logic;
    signal UP : in std_logic;
    signal D : in std_logic_vector(3 downto 0);
    signal Q_in       : in std_logic_vector(3 downto 0);
    signal Q       : out std_logic_vector(3 downto 0);
    signal CEO : out std_logic;
    signal TC      : out std_logic) is

-- Modified by Guido!
   
  begin
--    if (CLR='1') then
--      Q <= "0000";
--      CEO <= '0';
--      TC <= '0';
--      
--    elsif (CLR='0') then
--      if (L='1' and C='1' and C'event) then
--        Q <= D;
--        
--      elsif (L='0') then
--        if (CE='1' and C='1' and C'event) then
--          Q <= Q_in + 1;
--          if (Q_in="1110") then
--            TC <= '1';
--            CEO <= '1';
--          else
--            TC <= '0';
--          end if;
        
--        elsif (CE='0') then
--          CEO <= '0';
--        end if;
--     end if;
--    end if;
  
		if (CLR='1') then
			Q <= "0000";
		elsif (C='1' and C'event) then
			if (L='1') then
				Q <= D;
--			elsif (CE='1') then    
			elsif (CE='1') and (UP='1') then    
				Q <= Q_in + 1;
			elsif (CE='1') and (UP='0') then    
				Q <= Q_in - 1;
			end if;
		end if;
		
		if (CLR = '1') then
			TC <= '0';
		elsif (UP = '1' and Q_in="1110") then
			TC <= '1';
		elsif (UP = '0' and Q_in="0000") then
			TC <= '1';
		end if;
	 
		if (CLR = '1') then
			CEO <= '0';
		elsif (CE = '1' and UP = '1' and Q_in="1110") then
			CEO <= '1';
		elsif (CE = '1' and UP = '0' and Q_in="0000") then
			CEO <= '1';
		end if;
	 
  end CB4CLED;
-------------------------------------------------------------------------------
  procedure SR8CLE (
    signal C       : in  std_logic;
    signal CE      : in  std_logic;
    signal CLR     : in  std_logic;
    signal L : in std_logic;
    signal SLI : in std_logic;
    signal D : in std_logic_vector(7 downto 0);
    signal Q_in       : in std_logic_vector(7 downto 0);
    signal Q       : out std_logic_vector(7 downto 0)) is
    
-- Modified by Guido!
   
  begin
--    if (CLR='1') then
--      Q <= "00000000";
--      
--    elsif (CLR='0') then
--      if (L='1' and C='1' and C'event) then
--        Q <= D;
--        
--      elsif (L='0') then
--        if (CE='1' and C='1' and C'event) then
--          Q(7) <= Q_in(6);
--          Q(6) <= Q_in(5);
--          Q(5) <= Q_in(4);
--          Q(4) <= Q_in(3);
--          Q(3) <= Q_in(2);
--          Q(2) <= Q_in(1);
--          Q(1) <= Q_in(0);
--          Q(0) <= SLI;
--        end if;
--      end if;
--    end if;

    if (CLR='1') then
      Q <= "00000000";
    elsif (C='1' and C'event) then
		  if (L='1') then
			  Q <= D;
		  elsif (CE='1') then
			  Q(7) <= Q_in(6);
			  Q(6) <= Q_in(5);
        Q(5) <= Q_in(4);
        Q(4) <= Q_in(3);
        Q(3) <= Q_in(2);
        Q(2) <= Q_in(1);
        Q(1) <= Q_in(0);
        Q(0) <= SLI;
      end if;
    end if;

  end SR8CLE;
-------------------------------------------------------------------------------
  procedure SR16CLE (
    signal C       : in  std_logic;
    signal CE      : in  std_logic;
    signal CLR     : in  std_logic;
    signal L : in std_logic;
    signal SLI : in std_logic;
    signal D : in std_logic_vector(15 downto 0);
    signal Q_in       : in std_logic_vector(15 downto 0);
    signal Q       : out std_logic_vector(15 downto 0)) is
    
-- Modified by Guido!
   
  begin
--    if (CLR='1') then
--      Q <= "0000000000000000";
--      
--    elsif (CLR='0') then
--      if (L='1' and C='1' and C'event) then
--        Q <= D;
--        
--      elsif (L='0') then
--        if (CE='1' and C='1' and C'event) then
--          Q(15) <= Q_in(14);
--          Q(14) <= Q_in(13);
--          Q(13) <= Q_in(12);
--          Q(12) <= Q_in(11);
--          Q(11) <= Q_in(10);
--          Q(10) <= Q_in(9);
--          Q(9) <= Q_in(8);
--          Q(8) <= Q_in(7);
--          Q(7) <= Q_in(6);
--          Q(6) <= Q_in(5);
--          Q(5) <= Q_in(4);
--          Q(4) <= Q_in(3);
--          Q(3) <= Q_in(2);
--          Q(2) <= Q_in(1);
--          Q(1) <= Q_in(0);
--          Q(0) <= SLI;
--        end if;
--      end if;
--    end if;

    if (CLR='1') then
      Q <= "0000000000000000";
    elsif (C='1' and C'event) then
		  if (L='1') then
			  Q <= D;
		  elsif (CE='1') then
        Q(15) <= Q_in(14);
        Q(14) <= Q_in(13);
        Q(13) <= Q_in(12);
        Q(12) <= Q_in(11);
        Q(11) <= Q_in(10);
        Q(10) <= Q_in(9);
        Q(9) <= Q_in(8);
        Q(8) <= Q_in(7);
			  Q(7) <= Q_in(6);
			  Q(6) <= Q_in(5);
        Q(5) <= Q_in(4);
        Q(4) <= Q_in(3);
        Q(3) <= Q_in(2);
        Q(2) <= Q_in(1);
        Q(1) <= Q_in(0);
        Q(0) <= SLI;
      end if;
    end if;

  end SR16CLE;
-------------------------------------------------------------------------------
  procedure SRL16 (
    signal D       : in  std_logic;
    signal C     : in  std_logic;
    signal A       : in std_logic_vector(3 downto 0);
    signal SHR_IN : in std_logic_vector(15 downto 0);
    signal SHR_OUT : out std_logic_vector(15 downto 0);
    --signal A : in integer;
    signal Q      : out std_logic) is

  begin
    if (C='1' and C'event) then
      SHR_OUT(15 downto 0) <= SHR_IN(14 downto 0) & D;
    end if;
    case A is
      when "0000" => Q <= SHR_IN(0);
      when "0001" => Q <= SHR_IN(1);
      when "0010" => Q <= SHR_IN(2);
      when "0011" => Q <= SHR_IN(3);
      when "0100" => Q <= SHR_IN(4);
      when "0101" => Q <= SHR_IN(5);
      when "0110" => Q <= SHR_IN(6);
      when "0111" => Q <= SHR_IN(7);
      when "1000" => Q <= SHR_IN(8);
      when "1001" => Q <= SHR_IN(9);
      when "1010" => Q <= SHR_IN(10);
      when "1011" => Q <= SHR_IN(11);
      when "1100" => Q <= SHR_IN(12);
      when "1101" => Q <= SHR_IN(13);
      when "1110" => Q <= SHR_IN(14);
      when "1111" => Q <= SHR_IN(15);
      when others => Q <= SHR_IN(0);
    end case;
end SRL16;
 
--  procedure SRL16 (
--    signal D       : in  std_logic;
--    signal C     : in  std_logic;
--    signal A       : in std_logic_vector(3 downto 0);
--    signal COUNTER_IN : in std_logic_vector(3 downto 0);
--    signal COUNTER_OUT : out std_logic_vector(3 downto 0);
--    --signal A : in integer;
--    signal Q      : out std_logic) is
--
--  begin
--    if (C='1' and C'event) then
--      COUNTER_OUT <= COUNTER_IN + 1;
--      if ((COUNTER_IN+1) = A) then
--        Q <= D;
--        COUNTER_OUT <= "0000";
--      end if;
--    end if;
--  end SRL16;
  --procedure SRL16 (
  --  signal D       : in  std_logic;
  --  signal C     : in  std_logic;
  --  signal A       : in std_logic_vector(3 downto 0);
  --  signal COUNTER_IN : in std_logic_vector(3 downto 0);
  --  signal COUNTER_OUT : out std_logic_vector(3 downto 0);
  --  --signal A : in integer;
  --  signal Q      : out std_logic) is

  --begin
    
  --    if (C='1' and C'event) then
  --      Q <= Q_in + 1;
  --      if ((Q_in + 1) = A) then
  --        TC <= '1';
  --        CEO <= '1';
  --      else
  --        TC <= '0';
  --      end if;
        
  --    elsif (CE='0') then
  --      CEO <= '0';
  --    end if;
  --  end if;
  --end SRL16;
-------------------------------------------------------------------------------
--ARCHITECTURE CB4CE_2_ARCH of CB4CE_2 is
    
  --  signal INNER_Q: std_logic_vector (3 downto 0);
  --begin
    
    --process(C,CE,CLR)
      --begin
        --if (CLR='1') then
          --INNER_Q <= INNER_Q - INNER_Q;
          --CEO <= '0';
          --TC <= '0';
      
        --elsif (CLR='0') then
      
          --if (CE='1' and C='1' and C'event) then
            --INNER_Q <= INNER_Q + 1;
            --if (INNER_Q="1110") then
              --TC <= '1';
              --CEO <= '1';
            --else
              --TC <= '0';
            --end if;
        
          --elsif (CE='0') then
            --CEO <= '0';
          --end if;
        --end if;
      --end process;
      
      --Q <= INNER_Q;
  --end CB4CE_2_ARCH;
-------------------------------------------------------------------------------
  procedure SR16CLRE (
    signal C       : in  std_logic;
    signal CE      : in  std_logic;
    signal CLR     : in  std_logic;
    signal L : in std_logic;
    signal SLI : in std_logic;
    signal D : in std_logic_vector(15 downto 0);
    signal Q_in       : in std_logic_vector(15 downto 0);
    signal Q       : out std_logic_vector(15 downto 0)) is
    
-- Modified by Guido!
   
--  begin
--    if (CLR='1') then
--      Q <= "0000000000000000";
--      
--    elsif (CLR='0') then
--      if (L='1' and C='1' and C'event) then
--        Q <= D;
--        
--      elsif (L='0') then
--        if (CE='1' and C='1' and C'event) then
--          Q(15) <= SLI;
--          Q(14) <= Q_in(15);
--          Q(13) <= Q_in(14);
--          Q(12) <= Q_in(13);
--          Q(11) <= Q_in(12);
--          Q(10) <= Q_in(11);
--          Q(9) <= Q_in(10);
--          Q(8) <= Q_in(9);
--          Q(7) <= Q_in(8);
--          Q(6) <= Q_in(7);
--          Q(5) <= Q_in(6);
--          Q(4) <= Q_in(5);
--          Q(3) <= Q_in(4);
--          Q(2) <= Q_in(3);
--          Q(1) <= Q_in(2);
--          Q(0) <= Q_in(1);
--        end if;
--      end if;
--    end if;

  begin
    if (CLR='1') then
      Q <= "0000000000000000";
      
    elsif (C='1' and C'event) then
		if (L='1') then
			Q <= D;
      elsif (CE='1') then
			Q(15) <= SLI;          
			Q(14) <= Q_in(15);
			Q(13) <= Q_in(14);
			Q(12) <= Q_in(13);
			Q(11) <= Q_in(12);
			Q(10) <= Q_in(11);
			Q(9) <= Q_in(10);
			Q(8) <= Q_in(9);
			Q(7) <= Q_in(8);
			Q(6) <= Q_in(7);
			Q(5) <= Q_in(6);
			Q(4) <= Q_in(5);
			Q(3) <= Q_in(4);
			Q(2) <= Q_in(3);
			Q(1) <= Q_in(2);
			Q(0) <= Q_in(1);
		end if;
	end if;

  end SR16CLRE;
  -------------------------------------------------------------------------------
  procedure SR16LCE (
    signal C       : in  std_logic;
    signal CE      : in  std_logic;
    signal CLR     : in  std_logic;
    signal SLI : in std_logic;
    signal Q_in       : in std_logic_vector(15 downto 0);
    signal Q       : out std_logic_vector(15 downto 0)) is
    
-- Modified by Guido!
   
  begin
--    if (CLR='1') then
--      Q <= "0000000000000000";
--      
--    elsif (CLR='0') then
--     
--      if (CE='1' and C='1' and C'event) then
--        --Q(15) <= Q_in(14);
--        --  Q(14) <= Q_in(13);
--        --  Q(13) <= Q_in(12);
--        --  Q(12) <= Q_in(11);
--        --  Q(11) <= Q_in(10);
--        --  Q(10) <= Q_in(9);
--        --  Q(9) <= Q_in(8);
--        --  Q(8) <= Q_in(7);
--        --  Q(7) <= Q_in(6);
--        --  Q(6) <= Q_in(5);
--        --  Q(5) <= Q_in(4);
--        --  Q(4) <= Q_in(3);
--        --  Q(3) <= Q_in(2);
--        --  Q(2) <= Q_in(1);
--        --  Q(1) <= Q_in(0);
--        --  Q(0) <= SLI;

--			 Q(15) <= SLI;
--          Q(14) <= Q_in(15);
--          Q(13) <= Q_in(14);
--          Q(12) <= Q_in(13);
--          Q(11) <= Q_in(12);
--          Q(10) <= Q_in(11);
--          Q(9) <= Q_in(10);
--          Q(8) <= Q_in(9);
--          Q(7) <= Q_in(8);
--          Q(6) <= Q_in(7);
--          Q(5) <= Q_in(6);
--          Q(4) <= Q_in(5);
--          Q(3) <= Q_in(4);
--          Q(2) <= Q_in(3);
--          Q(1) <= Q_in(2);
--          Q(0) <= Q_in(1);
--      end if;
--    end if;

    if (CLR='1') then
      Q <= "0000000000000000";
    elsif (CE='1' and C='1' and C'event) then
		Q(15) <= SLI;
		Q(14) <= Q_in(15);
		Q(13) <= Q_in(14);
		Q(12) <= Q_in(13);
		Q(11) <= Q_in(12);
		Q(10) <= Q_in(11);
		Q(9) <= Q_in(10);
		Q(8) <= Q_in(9);
		Q(7) <= Q_in(8);
		Q(6) <= Q_in(7);
		Q(5) <= Q_in(6);
		Q(4) <= Q_in(5);
		Q(3) <= Q_in(4);
		Q(2) <= Q_in(3);
		Q(1) <= Q_in(2);
		Q(0) <= Q_in(1);
	 end if;
    
  end SR16LCE;
-------------------------------------------------------------------------------
  procedure SR16CE (
    signal C       : in  std_logic;
    signal CE      : in  std_logic;
    signal CLR     : in  std_logic;
    signal SLI : in std_logic;
    signal Q_in       : in std_logic_vector(15 downto 0);
    signal Q       : out std_logic_vector(15 downto 0)) is
    
  begin
    if (CLR='1') then
      Q <= "0000000000000000";
      
    elsif (CLR='0') then
      
      if (CE='1' and C='1' and C'event) then
        Q(15) <= Q_in(14);
          Q(14) <= Q_in(13);
          Q(13) <= Q_in(12);
          Q(12) <= Q_in(11);
          Q(11) <= Q_in(10);
          Q(10) <= Q_in(9);
          Q(9) <= Q_in(8);
          Q(8) <= Q_in(7);
          Q(7) <= Q_in(6);
          Q(6) <= Q_in(5);
          Q(5) <= Q_in(4);
          Q(4) <= Q_in(3);
          Q(3) <= Q_in(2);
          Q(2) <= Q_in(1);
          Q(1) <= Q_in(0);
          Q(0) <= SLI;
      end if;
    end if;
    
  end SR16CE;
  -------------------------------------------------------------------------------
  procedure TMPLCTDLY (
    signal DIN       : in  std_logic;
    signal CLK      : in  std_logic;
    signal DELAY : in std_logic_vector(2 downto 0);
    signal DOUT       : out std_logic) is
  begin
    DOUT <= DIN;
  end TMPLCTDLY;
  -------------------------------------------------------------------------------
  procedure LCTDLY (
    signal DIN       : in  std_logic;
    signal CLK      : in  std_logic;
    signal DELAY : in std_logic_vector(5 downto 0);
    signal XL1ADLY : in std_logic_vector(1 downto 0);
    signal L1FD : in std_logic_vector(3 downto 0);
    signal DOUT       : out std_logic) is
  begin
    DOUT <= DIN;
  end LCTDLY;
  -------------------------------------------------------------------------------
  procedure PUSHDLY (
    signal DIN       : in  std_logic;
    signal CLK      : in  std_logic;
    signal DELAY : in std_logic_vector(4 downto 0);
    signal DOUT       : out std_logic) is
  begin
    DOUT <= DIN;
  end PUSHDLY;
  
-------------------------------------------------------------------------------
  procedure CB10UPDN (
    signal UP     : in  std_logic;
    signal CE     : in  std_logic;
    signal C      : in  std_logic;
    signal CLR    : in  std_logic;
    signal Q      : out std_logic_vector(9 downto 0);
    signal FULL : out std_logic;
    signal EMPTY1 : out std_logic) is
  begin
    Q(9 downto 0) <= "0000000000";
    FULL <= '0';
    EMPTY1 <= '1';
  end CB10UPDN;
  -----------------------------------------------------------------------------
  procedure BXNDLY (
    signal DIN     : in  std_logic;
    signal CLK     : in  std_logic;
    signal DELAY   : in  std_logic_vector(4 downto 0);
    signal DOUT    : out std_logic) is
  begin
    DOUT <= '1';
  end BXNDLY;
  
end Latches_Flipflops;
