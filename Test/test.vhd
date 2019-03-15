library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.sramTest.all;

entity test is 
	port (
		CLOCK 		: in std_logic; -- clock in
		RESET_N		: in std_logic; -- reset async
		
		LEDG			: out std_logic_vector(7 downto 0);
		LEDR			: out std_logic_vector(9 downto 0);
		KEY 			: in std_logic_vector(3 downto 0);		
		HEX2 			: out std_logic_vector(6 downto 0);
		HEX3 			: out std_logic_vector(6 downto 0);
		DATA		: in std_logic_vector(7 downto 0);
		SW			: in std_logic_vector(7 downto 0);
		
		I		: out std_logic_vector(15 downto 0);
		O		: in std_logic_vector(15 downto 0);
		W		: out std_logic;
		ADDR		: out std_logic_vector(17 downto 0)
	);
end entity;

architecture behav of test is
	signal S_HC : integer range 0 to 9;
	signal S_LC : integer range 0 to 9;
	signal i_value : integer range 0 to 99;
	
	signal S_READ : std_logic_vector(15 downto 0);
begin

	Test : process(CLOCK, RESET_N)
	begin
		if rising_edge(CLOCK) then
			LEDR(0) <= '0';
			LEDR(1) <= '0';
			if KEY(0) = '0' then
				ADDR <= "0000000000" & SW;
				I <= "00000000" & DATA;
				W <= '1';
				LEDR(0) <= '1';
			elsif KEY(1) = '0' then
				ADDR <= "0000000000" & SW;
				S_READ <= O;
				W <= '0';
				LEDR(1) <= '1';
			end if;
		end if;
	end process;

	LedControl : process(CLOCK, RESET_N)
	begin
		if(RESET_N = '1') then
			LEDG <= "00000000";
			i_value <= 0;
		elsif rising_edge(CLOCK) then
			LEDG <= S_READ(7 downto 0);
			i_value <= to_integer(unsigned(SW));
		end if;
	end process;
	
	-- From the HEX lib
	LedController : process(CLOCK)
		variable SSDC0 : std_logic_vector(6 downto 0);
		variable SSDC1 : std_logic_vector(6 downto 0);
		begin
			if(rising_edge(CLOCK)) then
				SSDC0 := (convert_to_7(S_LC));
				SSDC1 := (convert_to_7(S_HC));
				HEX3 <= SSDC0;
				HEX2 <= SSDC1;
			end if;
		end process;
		
	Decomposer : process(CLOCK)
			variable HC : integer range 0 to 9;
			variable LC : integer range 0 to 9;
		begin
			if(rising_edge(CLOCK)) then
				HC := i_value rem 10;
				LC := i_value / 10;
				S_HC <= HC;
				S_LC <= LC;
			end if;
		end process;
end architecture;
