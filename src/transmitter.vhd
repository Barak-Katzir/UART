-------------------------------------------------------
-- UART transmitter (C) VHDL workshop Amos Zaslavsky --
-------------------------------------------------------
library ieee ;
use ieee.std_logic_1164.all ;
use ieee.std_logic_unsigned.all ;
entity transmitter is
   generic ( clockfreq : integer := 25000000 ;
             baud      : integer := 115200 ) ;
   port ( resetN    : in     std_logic                    ;
          clk       : in     std_logic                    ;
          write_din : in     std_logic                    ;
          din       : in     std_logic_vector(7 downto 0) ;
          tx        : out std_logic                       ;
          tx_ready   : out std_logic                       ) ;
end transmitter ;

architecture arc_transmitter of transmitter is

   constant t1_count   : integer := clockfreq / baud - 2; -- 217 (215 for better accuracy)
   constant t2_count   : integer := t1_count / 2     - 2; -- 108 (106 for better accuracy)
   
   -- timer            floor(log2(t1_count)) downto 0
   signal tcount : std_logic_vector(8 downto 0) ;
   signal te     : std_logic ; -- Timer_Enable/!reset
   signal t1     : std_logic ; -- end of one time slot

   -- data counter
   signal dcount     : std_logic_vector(2 downto 0) ; -- data counter
   signal ena_dcount : std_logic                    ; -- enable this counter
   signal clr_dcount : std_logic                    ; -- clear this counter
   signal eoc        : std_logic                    ; -- end of count (7)

   -- shift register
   signal dint      : std_logic_vector(7 downto 0) ;
   signal ena_shift : std_logic                    ; -- enable shift register
   signal ena_load  : std_logic                    ; -- enable parallel load

   -- output flip-flop --
   signal clr_tx : std_logic ; -- clear  tx during start bit
   signal set_tx : std_logic ; -- set    tx during stop  bit
   signal ena_tx : std_logic ; -- enable tx from shift register during data transfer

  -- state machine
   type state is
   ( idle        ,
     write_din_start  ,
     clear_timer ,
     write_din_data   ,
     test_eoc    ,
     shift_count ,
     write_din_stop   ) ;

    signal present_state , next_state : state ;

begin

   -------------------
   -- state machine --
   -------------------
   -- sync process
   process ( resetN , clk ) 
   begin
      if resetN = '0' then
         present_state <= idle ;
      elsif rising_edge(clk) then
         present_state <= next_state ;
      end if ;
   end process ;
   -- comb process
   process ( write_din , t1 , eoc , present_state ) 
   begin
      next_state <= idle ;
      -- init outputs to zero
      set_tx <= '0';
      ena_tx <= '0';      
      clr_tx <= '0';

      ena_dcount <= '0';
      clr_dcount <= '0';
      
      te <= '0'; 
      
      ena_shift <= '0';
      ena_load <= '0';
      tx_ready <= '1';

      case present_state is
      
         when idle => 		
            tx_ready <= '1';
            ena_load <= '1';
            clr_dcount <= '1';
            if write_din = '0' then 
               next_state <= idle;
            else    
               next_state <= write_din_start;
            end if;
         
         when write_din_start =>
            tx_ready <= '0';
            te <= '1';
            clr_tx <= '1';
            if t1 = '0' then
               next_state <= write_din_start;
            else
               next_state <= clear_timer;
            end if;
            
         when clear_timer => 
            tx_ready <= '0';
            next_state <= write_din_data;
         
         when write_din_data => 
            tx_ready <= '0';
            te <= '1';
            ena_tx <= '1';
            if t1 = '0' then
               next_state <= write_din_data;
            else
               next_state <= test_eoc;
            end if;

         when test_eoc => 
            tx_ready <= '0';
            if eoc = '0' then 
               next_state <= shift_count;
            else 
               next_state <= write_din_stop;
            end if;

         when shift_count => 
            tx_ready <= '0';
            ena_shift <= '1';
            ena_dcount <= '1';
            next_state <= write_din_data;
            
         when write_din_stop => 
            tx_ready <= '0';
            te <= '1';
            set_tx <= '1';
            if t1 = '0' then
               next_state <= write_din_stop;
            else
               next_state <= idle;
            end if;      
      
         when others => next_state <= idle ;
      end case ;
   end process ;
   -----------
   -- timer --
   -----------
   process (resetN, clk)
   begin
      if resetN = '0' then
         tcount <= (others => '0');
      elsif rising_edge(clk) then
         if te = '1' then
            if tcount /= t1_count then
               tcount <= tcount + 1 ;
            end if ;
         else
            tcount <= (others => '0') ;
         end if ;
      end if;
   end process ;
   t1 <= '1' when (t1_count <= tcount) else '0';
   ------------------
   -- data counter --
   ------------------
   process (resetN, clk)
   begin
      if resetN = '0' then
         dcount <= (others => '0');
      elsif rising_edge(clk) then
         if clr_dcount = '1' then
            dcount <= (others => '0');
         elsif ena_dcount = '1' then
            dcount <= dcount + 1 ;
         end if ;
      end if;
   end process ;
   eoc <= '1' when (dcount = "111") else '0';
   --------------------
   -- shift register --
   --------------------
   process (resetN, clk)
   begin
      if resetN = '0' then
         dint <= (others => '0');
      elsif rising_edge(clk) then
         if write_din = '1' and ena_load = '1' then
            dint <= din;
         elsif ena_shift = '1' then
            dint <= '0' & dint(7 downto 1) ;
         end if ;
      end if;
   end process ;
   ----------------------
   -- output flip-flop --
   ----------------------
   process (resetN, clk)
   begin
      if resetN = '0' then
         tx <= '1';
      elsif rising_edge(clk) then
         if clr_tx = '1' then
            tx <= '0';
         elsif set_tx = '1' then
            tx <= '1';
         elsif ena_tx = '1' then
            tx <= dint(0);
         end if ;
      end if;
   end process ;
end arc_transmitter ;
