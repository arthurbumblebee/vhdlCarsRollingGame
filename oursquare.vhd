-- OUR SQUARE

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

PACKAGE our IS
PROCEDURE SQ2(SIGNAL Xcur,Ycur,Xpos,Ypos,x, y:IN INTEGER;SIGNAL RGB:OUT STD_LOGIC_VECTOR(3 downto 0);SIGNAL DRAW: OUT STD_LOGIC);
END our;

PACKAGE BODY our IS
PROCEDURE SQ2(SIGNAL Xcur,Ycur,Xpos,Ypos,x, y:IN INTEGER;SIGNAL RGB:OUT STD_LOGIC_VECTOR(3 downto 0);SIGNAL DRAW: OUT STD_LOGIC) IS
BEGIN
 IF(Xcur>Xpos AND Xcur<(Xpos+x) AND Ycur>Ypos AND Ycur<(Ypos+y))THEN
	 RGB<="1111";
	 DRAW<='1';
	 ELSE
	 DRAW<='0';
 END IF;
 
END SQ2;
END our;