LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY uart_test IS 
	PORT
	(
		resetN :  IN  STD_LOGIC;
		clk :  IN  STD_LOGIC;
		KEY2 :  IN  STD_LOGIC;
		RXD :  IN  STD_LOGIC;
		TXD :  OUT  STD_LOGIC;
		HEX0S :  OUT  STD_LOGIC_VECTOR(6 DOWNTO 0);
		HEX1S :  OUT  STD_LOGIC_VECTOR(6 DOWNTO 0);
		LEDG :  OUT  STD_LOGIC_VECTOR(9 DOWNTO 0)
	);
END uart_test;

ARCHITECTURE bdf_type OF uart_test IS 

COMPONENT uart
GENERIC (baud : INTEGER;
			clockfreq : INTEGER
			);
	PORT(resetN : IN STD_LOGIC;
		 clk : IN STD_LOGIC;
		 write_din : IN STD_LOGIC;
		 rx : IN STD_LOGIC;
		 read_dout : IN STD_LOGIC;
		 din : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 tx : OUT STD_LOGIC;
		 tx_ready : OUT STD_LOGIC;
		 rx_ready : OUT STD_LOGIC;
		 dout_ready : OUT STD_LOGIC;
		 dout_new : OUT STD_LOGIC;
		 dout : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;

COMPONENT hexss
	PORT(din : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 ss : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
	);
END COMPONENT;

SIGNAL	dint :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	TFF_inst1 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_0 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_1 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_2 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_3 :  STD_LOGIC;


BEGIN 
SYNTHESIZED_WIRE_2 <= '1';



b2v_inst : uart
GENERIC MAP(baud => 115200,
			clockfreq => 25000000
			)
PORT MAP(resetN => resetN,
		 clk => TFF_inst1,
		 write_din => SYNTHESIZED_WIRE_0,
		 rx => RXD,
		 read_dout => SYNTHESIZED_WIRE_1,
		 din => dint,
		 tx => TXD,
		 rx_ready => SYNTHESIZED_WIRE_3,
		 dout_ready => LEDG(9),
		 dout_new => SYNTHESIZED_WIRE_0,
		 dout => dint);


PROCESS(clk)
VARIABLE TFF_inst1_synthesized_var : STD_LOGIC;
BEGIN
IF (RISING_EDGE(clk)) THEN
	TFF_inst1_synthesized_var := TFF_inst1_synthesized_var XOR SYNTHESIZED_WIRE_2;
END IF;
	TFF_inst1 <= TFF_inst1_synthesized_var;
END PROCESS;


b2v_inst10 : hexss
PORT MAP(din => dint(3 DOWNTO 0),
		 ss => HEX0S);


LEDG(8) <= NOT(SYNTHESIZED_WIRE_3);



SYNTHESIZED_WIRE_1 <= NOT(KEY2);




b2v_inst9 : hexss
PORT MAP(din => dint(7 DOWNTO 4),
		 ss => HEX1S);

LEDG(7 DOWNTO 0) <= dint(7 DOWNTO 0);

END bdf_type;