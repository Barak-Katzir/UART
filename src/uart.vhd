-----------------------------------------------------
-- UART top level (C) VHDL workshop Amos Zaslavsky --
-----------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
entity uart is
   generic ( clockfreq : integer := 25000000 ;
             baud      : integer := 115200 ) ;
   port ( resetN        : in  std_logic                    ;
          clk           : in  std_logic                    ;
          din           : in  std_logic_vector(7 downto 0) ;
          write_din     : in  std_logic                    ;
          rx            : in  std_logic                    ;
          read_dout     : in  std_logic                    ;
          tx            : out std_logic                    ;
          tx_ready      : out std_logic                    ;
          rx_ready      : out std_logic                    ;
          dout          : out std_logic_vector(7 downto 0) ;
          dout_ready    : out std_logic                    ;
          dout_new      : out std_logic                    ) ;
end uart ;
architecture arc_uart of uart is
   component receiver
      generic ( clockfreq : integer := 25000000 ;
                baud      : integer := 115200 ) ;
      port ( resetN     : in  std_logic                    ;
             clk        : in  std_logic                    ;
             rx         : in  std_logic                    ;
             read_dout  : in  std_logic                    ;
             rx_ready   : out std_logic                    ;
             dout       : out std_logic_vector(7 downto 0) ;
             dout_new   : out std_logic                    ;
             dout_ready : out std_logic                    ) ;
   end component ;
   component transmitter
      generic ( clockfreq : integer := 25000000 ;
                baud      : integer := 115200 ) ;
      port ( resetN    : in  std_logic                    ;
             clk       : in  std_logic                    ;
             write_din : in  std_logic                    ;
             din       : in  std_logic_vector(7 downto 0) ;
             tx        : out std_logic                    ;
             tx_ready  : out std_logic                    ) ;
   end component;
begin
   ur : receiver
   generic map ( clockfreq , baud )
   port map ( resetN     => resetN     ,
              clk        => clk        ,
              rx         => rx         ,
              read_dout  => read_dout  ,
              rx_ready   => rx_ready   ,
              dout       => dout       ,
              dout_new   => dout_new   ,
              dout_ready => dout_ready ) ;
   ut : transmitter
   generic map ( clockfreq , baud )
   port map ( resetN    => resetN    ,
              clk       => clk       ,
              write_din => write_din ,
              din       => din       ,
              tx        => tx        ,
              tx_ready  => tx_ready  ) ;
end arc_uart ;
