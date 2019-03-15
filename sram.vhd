library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.sramTest.all;

entity sram is 
	port (
		CLOCK 		: in std_logic; -- clock in
		RESET_N		: in std_logic; -- reset async
		
		DATA_IN     : in std_logic_vector(15 downto 0); -- data in
		DATA_OUT    : out std_logic_vector(15 downto 0); -- data out
		ADDR			: in std_logic_vector(17 downto 0); -- address in
		
		ACTION		: in std_logic; -- operation to perform
		
		SRAM_ADDR	: out std_logic_vector(17 downto 0); -- address out
		SRAM_DQ     : inout std_logic_vector(15 downto 0); -- data in/out
		SRAM_CE_N   : out std_logic; -- chip select
		SRAM_OE_N   : out std_logic; -- output enable
		SRAM_WE_N   : out std_logic; -- write enable
		SRAM_UB_N   : out std_logic; -- upper byte mask
		SRAM_LB_N   : out std_logic -- lower byte mask
		
	);
end entity;

architecture behav of sdram is
	-- ram fsm
	type RAM_FSM_T is (
		OFF_F,
		READ_F,
		WRITE_F
	);
	signal S_RAM_STATE : RAM_FSM_T := OFF_F;
	-- controller state;
	signal S_ACTION : std_logic; -- [0 - read] [1 - write]
	signal S_READ : std_logic_vector(15 downto 0);
	
begin

	
	RamController : process(CLOCK)
	begin
		if(RESET_N = '1') then -- async reset
			S_READ <= "0000000000000000"; -- reset the data read signal
			SRAM_CE_N<='0'; -- enables the chip (all the time?)
			SRAM_LB_N<='1'; -- mask low byte
			SRAM_UB_N<='1'; -- mask high byte
			SRAM_ADDR <= (others => '-'); -- set the address as "don't care" (must preserve low the bus)
			SRAM_DQ <= (others => 'Z'); -- set the data bus as high impedance (tristate)
		elsif rising_edge(CLOCK) then -- high clock state (do something!)
			SRAM_ADDR <= (others => '-'); -- "don't care"
			SRAM_DQ <= (others => 'Z'); -- high impedance
			if ACTION = '0'  then -- READ
				S_ACTION <= '0'; -- tells the fsm to read
				SRAM_ADDR <= ADDR; -- notify the address
				SRAM_LB_N <='0'; -- unmask low byte
				SRAM_UB_N <='0'; -- unmask high byte
				DATA_OUT <= SRAM_DQ(15 downto 0); -- read the data
			elsif ACTION = '1'  then -- WRITE
				S_ACTION <= '1'; -- tells the fsm to write
				SRAM_ADDR <= ADDR; -- notify the address
				SRAM_LB_N <= '0'; -- unmask low byte
				SRAM_UB_N <= '0'; -- unmask high byte
				SRAM_DQ <= DATA_IN; -- send the data
			end if;
		end if;
	end process;
	
	FSM : process(S_ACTION)
	begin
		SRAM_OE_N <= '1'; -- output disabled
		SRAM_WE_N <= '1'; -- write disabled
		if(S_ACTION = '0') then
			--read
			S_RAM_STATE <= READ_F;
			SRAM_OE_N <= '0';
		else
			--write
			S_RAM_STATE <= WRITE_F;
			SRAM_WE_N <= '0';
		end if;
	end process;
	
end architecture;
