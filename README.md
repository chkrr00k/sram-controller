# sram-controller
A simple sram controller and test for the altera DE1 FPGA board 

## Use

```
-- general
		CLOCK 		: in std_logic; -- clock in
		RESET_N		: in std_logic; -- reset async

-- data bus		
		DATA_IN     : in std_logic_vector(15 downto 0); -- data in (write data)
		DATA_OUT    : out std_logic_vector(15 downto 0); -- data out (read data)
 
 -- commands
		ADDR			: in std_logic_vector(17 downto 0); -- address in	
		ACTION		: in std_logic; -- operation to perform [0 - read] [1 - write]
		
 -- connect this with the FPGA connection
		SRAM_ADDR	: out std_logic_vector(17 downto 0); -- address out
		SRAM_DQ     : inout std_logic_vector(15 downto 0); -- data in/out
		SRAM_CE_N   : out std_logic; -- chip select
		SRAM_OE_N   : out std_logic; -- output enable
		SRAM_WE_N   : out std_logic; -- write enable
		SRAM_UB_N   : out std_logic; -- upper byte mask
		SRAM_LB_N   : out std_logic -- lower byte mask
    
```

### Tests
in the ./Test folder there is a sample of how this controller should be used.  
It's not certified to work "as it is" but it sould give the general idea
