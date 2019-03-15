library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.mario_package.all;

entity sramTest is
	port(
		CLOCK_50		: in std_logic;
		KEY			: in std_logic_vector(3 downto 0);
		
		GPIO_0 		: out std_logic_vector(35 downto 0);
		GPIO_1 		: in std_logic_vector(35 downto 0);
		LEDR			: out std_logic_vector(9 downto 0);
		LEDG			: out std_logic_vector(7 downto 0);
		SW          : in  std_logic_vector(9 downto 0);
		HEX0			: out std_logic_vector(6 downto 0); -- output for the HEX0 port
		HEX1 			: out std_logic_vector(6 downto 0); -- output for the HEX1 port
		HEX2			: out std_logic_vector(6 downto 0); -- output for the HEX0 port
		HEX3 			: out std_logic_vector(6 downto 0); -- output for the HEX1 port
		
		SRAM_ADDR           : out   std_logic_vector(17 downto 0);
		SRAM_DQ             : inout std_logic_vector(15 downto 0);
		SRAM_CE_N           : out   std_logic;
		SRAM_OE_N           : out   std_logic;
		SRAM_WE_N           : out   std_logic;
		SRAM_UB_N           : out   std_logic;
		SRAM_LB_N           : out   std_logic;
		
	);
end;

architecture RTL of sramTest is
	signal clock		: std_logic;
	signal clockVGA	: std_logic;
	signal RESET_N		: std_logic;
	
	signal data : std_logic_vector(7 downto 0);
	signal addr : std_logic_vector(17 downto 0);
	signal i : std_logic_vector(15 downto 0);
	signal o : std_logic_vector(15 downto 0);
	signal w : std_logic;
	
begin	
		test : entity work.test
		port map(
			CLOCK => clock,
			RESET_N => RESET_N,
					
			LEDG => LEDG,
			LEDR => LEDR,
			KEY => KEY,		
			HEX2 => HEX2,
			HEX3 => HEX3,
			DATA => data,
			SW => SW(7 downto 0),
			
			I => i,
			O => o,
			ADDR => addr,
			W => w
		);
		
		sram : entity work.sram
		port map(
			CLOCK => clock,
			RESET_N => RESET_N,
			
			ACTION => w,
			
			DATA_OUT => o,
			DATA_IN => i,
			ADDR => addr,
			
			SRAM_ADDR => SRAM_ADDR,
			SRAM_DQ   => SRAM_DQ,			
			SRAM_CE_N => SRAM_CE_N,
			SRAM_OE_N => SRAM_OE_N,
			SRAM_WE_N => SRAM_WE_N,
			SRAM_UB_N => SRAM_UB_N,
			SRAM_LB_N => SRAM_LB_N		
		);

end architecture;