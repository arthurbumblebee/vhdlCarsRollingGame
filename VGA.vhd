library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


ENTITY VGA IS
PORT(
CLOCK_24: IN STD_LOGIC_VECTOR(1 downto 0);
VGA_HS,VGA_VS:OUT STD_LOGIC;
SW: STD_LOGIC_VECTOR(1 downto 0);
KEY: STD_LOGIC_VECTOR(3 DOWNTO 0);
HEXa0,HEXa1, HEXa2: OUT STD_LOGIC_VECTOR(6 downto 0);
VGA_R,VGA_B,VGA_G: OUT STD_LOGIC_VECTOR(3 downto 0);
PAUSE, resetThat: IN STD_LOGIC

);
END VGA;


ARCHITECTURE MAIN OF VGA IS
SIGNAL VGACLK,RESET:STD_LOGIC;
 COMPONENT SYNC IS
 PORT(CLK, RESET, PAUSE, resetThat: IN STD_LOGIC;
		HSYNC: OUT STD_LOGIC;
		VSYNC: OUT STD_LOGIC;
		R: OUT STD_LOGIC_VECTOR(3 downto 0);
		G	: OUT STD_LOGIC_VECTOR(3 downto 0);
		B: OUT STD_LOGIC_VECTOR(3 downto 0);
		KEYS: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		S: IN STD_LOGIC_VECTOR(1 downto 0);
		HEX0,HEX1, HEX2: OUT STD_LOGIC_VECTOR(6 downto 0)
	);
END COMPONENT SYNC;



    component pll is
        port (
            clkout_clk : out std_logic;        -- clk
            clkin_clk  : in  std_logic := 'X'; -- clk
            rst_reset  : in  std_logic := 'X'  -- reset
        );
	 END COMPONENT pll;
 BEGIN
 
 C: pll PORT MAP (VGACLK,CLOCK_24(0),RESET);
 C1: SYNC PORT MAP(VGACLK,RESET,resetThat, PAUSE,VGA_HS,VGA_VS,VGA_R,VGA_G,VGA_B,KEY,SW,HEXa0,HEXA1,HEXa2 );
 
 END MAIN;
 