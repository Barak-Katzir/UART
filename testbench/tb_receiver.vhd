library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity tb_receiver is
end tb_receiver;

architecture behavioral of tb_receiver is
   component receiver
      generic ( clockfreq : integer := 25000000;
                baud      : integer := 115200 );
      port ( resetN     : in  std_logic;                -- a-sync reset
             clk        : in  std_logic;                -- clock
             rx         : in  std_logic;                -- serial in
             read_dout  : in  std_logic;                -- read enable
             rx_ready   : out std_logic;                -- ready signal
             dout       : out std_logic_vector(7 downto 0); -- parallel out
             dout_new   : out std_logic;
             dout_ready : out std_logic);
   end component;

   signal resetN     : std_logic;
   signal clk        : std_logic;
   signal rx         : std_logic;
   signal read_dout  : std_logic;
   signal dout       : std_logic_vector(7 downto 0);
   signal dout_new   : std_logic;
   signal dout_ready : std_logic;

   constant baud       : real := 115200.0;
   constant dt         : time := 1 sec / baud;

begin

   -- Instantiate Receiver
   eut: receiver
      generic map ( clockfreq => 25000000,
                    baud      => 115200 )
      port map ( resetN     => resetN,
                 clk        => clk,
                 rx         => rx,
                 read_dout  => read_dout,
                 rx_ready   => open,
                 dout       => dout,
                 dout_new   => dout_new,
                 dout_ready => dout_ready );

   -- Clock process (50 MHz)
   process
   begin
      clk <= '0';  wait for 20 ns;
      clk <= '1';  wait for 20 ns;
   end process;

   -- Active low reset pulse
   resetN <= '0', '1' after 40 ns;

   -- Test Vectors Process
   process
      variable d : std_logic_vector(7 downto 0); -- Moved variable here
   begin
      -- Initialize inputs
      read_dout <= '0';
      rx <= '1';  -- Idle state for UART

      wait for 100 us;

      -- Send valid data: 0xC3 (11000011b)
      d := "11000011";
      rx <= '0';  -- Start bit
      wait for dt;
      for i in 0 to 7 loop
         rx <= d(i);
         wait for dt;
      end loop;
      rx <= '1';  -- Stop bit
      wait for dt;
      read_dout <= '1' ;
      wait for dt ;
      read_dout <= '0' ;
      wait for 100 us;

      -- Send valid data: 0x0F (00001111b)
      d := "00001111";
      rx <= '0';  -- Start bit
      wait for dt;
      for i in 0 to 7 loop
         rx <= d(i);
         wait for dt;
      end loop;
      rx <= '1';  -- Stop bit
      wait for dt;
      read_dout <= '1' ;
      wait for dt ;
      read_dout <= '0' ;
      wait for 100 us;


      -- Send valid data: 0xF0 (11110000b)
      d := "11110000";
      rx <= '0';  -- Start bit
      wait for dt;
      for i in 0 to 7 loop
         rx <= d(i);
         wait for dt;
      end loop;
      rx <= '1';  -- Stop bit
      wait for dt;
      wait for 100 us;

      -- Send invalid frame: missing stop bit
      d := "11110000";
      rx <= '0';  -- Start bit
      wait for dt;
      for i in 0 to 7 loop
         rx <= d(i);
         wait for dt;
      end loop;
      rx <= '0';  -- Incorrect stop bit
      wait for dt;
      wait for 50 us;

      -- Send invalid frame: too short start pulse
      rx <= '0';  -- Start bit
      wait for dt / 4;
      rx <= '1';
      wait for dt;
      rx <= '1';
      wait for 100 us;

      report "end of test vectors" severity note;
      wait;
   end process;

end behavioral;
