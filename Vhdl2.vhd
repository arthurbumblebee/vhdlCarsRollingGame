library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;
use work.our.all;


ENTITY SYNC IS
PORT(
CLK, RESET, PAUSE: IN STD_LOGIC;
HSYNC: OUT STD_LOGIC;
VSYNC: OUT STD_LOGIC;
R: OUT STD_LOGIC_VECTOR(3 downto 0);
G: OUT STD_LOGIC_VECTOR(3 downto 0);
B: OUT STD_LOGIC_VECTOR(3 downto 0);
KEYS: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
S: IN STD_LOGIC_VECTOR(1 downto 0);
resetThat: IN std_LOGIC;
HEX0,HEX1, HEX2: OUT STD_LOGIC_VECTOR(6 downto 0)
);
END SYNC;


ARCHITECTURE MAIN OF SYNC IS
-- declare components
component hexcharacters is
	port (
		abcd	   : in std_logic_vector (3 downto 0);
		result : out std_logic_vector (6 downto 0)
	);
end component;
--signals
-----1280x1024 @ 60 Hz pixel clock* 108 MHz
SIGNAL RGB: STD_LOGIC_VECTOR(3 downto 0);
--random number
signal random_num : std_logic_vector (4 downto 0);   --output vector for random number generator   
-- background
--SIGNAL SQ_X1: INTEGER RANGE 400 TO 1600:=600;
SIGNAL SQ_X1: INTEGER:= 600;
SIGNAL SQ_Y1: INTEGER RANGE 50 TO 1000:=50;
signal xChange1: IntEGER Range 0 to 1500 :=900; -- Where you declare the square size in the x direction
signal yChange1: IntEGER Range 0 to 1500 :=1050; -- Where you declare the square size in the y direction
-- player 1 car
SIGNAL SQ_X2: INTEGER RANGE 400 TO 1600:=975; -- declare signals for the object to draw this is the original y pos and above is the original x pos
SIGNAL SQ_Y2: INTEGER RANGE 50 TO 1500:=900;
signal xChange2: IntEGER Range 0 to 1500 :=150; -- Where you declare the square size in the x direction
signal yChange2: IntEGER Range 0 to 1500 :=150; -- Where you declare the square size in the y direction
-- background  far left
SIGNAL SQ_X3: INTEGER RANGE 400 TO 1600:=900;
SIGNAL SQ_Y3: INTEGER RANGE 50 TO 1000:=50;
signal xChange3: IntEGER Range 0 to 1500 :=10; -- Where you declare the square size in the x direction
signal yChange3: IntEGER Range 0 to 1500 :=1050; -- Where you declare the square size in the y direction
-- background  MIDDLE LINE   
SIGNAL SQ_X4: INTEGER RANGE 400 TO 1600:=1200;
SIGNAL SQ_Y4: INTEGER RANGE 50 TO 1000:=50;
signal xChange4: IntEGER Range 0 to 1500 :=10; -- Where you declare the square size in the x direction
signal yChange4: IntEGER Range 0 to 1500 :=1050; -- Where you declare the square size in the y direction
-- obstacle no 1
SIGNAL SQ_X5: INTEGER RANGE 400 TO 1600:=675; -- declare signals for the object to draw this is the original y pos and above is the original x pos
SIGNAL SQ_Y5: INTEGER RANGE 50 TO 1500:=50;
signal xChange5: IntEGER Range 0 to 1500 :=150; -- Where you declare the square size in the x direction
signal yChange5: IntEGER Range 0 to 1500 :=150; -- Where you declare the square size in the y direction
-- obstacle no 2
SIGNAL SQ_X6: INTEGER RANGE 400 TO 1600:=975; -- declare signals for the object to draw this is the original y pos and above is the original x pos
SIGNAL SQ_Y6: INTEGER RANGE 50 TO 1500:=50;
signal xChange6: IntEGER Range 0 to 1500 :=150; -- Where you declare the square size in the x direction
signal yChange6: IntEGER Range 0 to 1500 :=150; -- Where you declare the square size in the y direction
-- obstacle no 3
SIGNAL SQ_X7: INTEGER RANGE 400 TO 1600:=1275; -- declare signals for the object to draw this is the original y pos and above is the original x pos
SIGNAL SQ_Y7: INTEGER RANGE 50 TO 1500:=50;
signal xChange7: IntEGER Range 0 to 1500 :=150; -- Where you declare the square size in the x direction
signal yChange7: IntEGER Range 0 to 1500 :=150; -- Where you declare the square size in the y direction

SIGNAL DRAW1,DRAW2, DRAW3, DRAW4, DRAW5, DRAW6, DRAW7:STD_LOGIC:='0';  -- draw signals
SIGNAL HPOS: INTEGER RANGE 0 TO 1688:=0;
SIGNAL VPOS: INTEGER RANGE 0 TO 1066:=0;

--Counter for the movement of the player controlled car
signal carCounter:IntEGER Range 0 to 2 := 1;
signal clockCounter: IntEGER Range 0 to 100 := 0;
signal okToMove: IntEGER Range 0 to 1 := 0;

-- Signals for collision calculation
signal centerX: IntEGER Range 0 to 3000 := 0;
signal centerY: IntEGER Range 0 to 3000 := 0;
signal moveYes: std_LOGIC := '0';
signal moveYes2: std_LOGIC := '0';
signal moveYes3: std_LOGIC := '0';
signal moveYes4: std_LOGIC := '0';

-- For the random timing effect
signal redoBool: std_LOGIC := '0';
signal counterForRedo: IntEGER Range 0 to 3000 := 0;
signal redoBool2: std_LOGIC := '0';
signal counterForRedo2: IntEGER Range 0 to 3000 := 0;
signal redoBool3: std_LOGIC := '0';
signal counterForRedo3: IntEGER Range 0 to 3000 := 0;

-- For the random speed effect
signal speed1: intEGER Range 0 to 3000 := 10;
signal speed2: intEGER Range 0 to 3000 := 5;
signal speed3: intEGER Range 0 to 3000 := 5;

-- For the score, AND LIFE
signal score: unsigned (7 downto 0):= "00000000";
signal life: unsigned (3 downto 0) := "1010";

-- Collision signal so you can only collide once per cycle
signal collideYes: std_LOGIC := '0';
signal collideYes2: std_LOGIC := '0';
signal collideYes3: std_LOGIC := '0';

-- for the gameover state
signal gameOver: std_logic := '0';

BEGIN
 -- this is where you call the draw stuff
SQ2(HPOS,VPOS,SQ_X1,SQ_Y1,xChange1,yChange1, RGB,DRAW1);  -- background
SQ2(HPOS,VPOS,SQ_X3,SQ_Y3,xChange3,yChange3, RGB,DRAW3);  -- background far left
SQ2(HPOS,VPOS,SQ_X4,SQ_Y4,xChange4,yChange4, RGB,DRAW4);  -- background MIDDLE LINE
SQ2(HPOS,VPOS,SQ_X5,SQ_Y5,xChange5,yChange5, RGB,DRAW5); -- obstacle 1
SQ2(HPOS,VPOS,SQ_X6,SQ_Y6,xChange6,yChange6, RGB,DRAW6); -- obstacle 2
SQ2(HPOS,VPOS,SQ_X7,SQ_Y7,xChange7,yChange7, RGB,DRAW7); -- obstacle 3
SQ2(HPOS,VPOS,SQ_X2,SQ_Y2,xChange2,yChange2, RGB,DRAW2);  -- the car
-- portmap the circuits
viewScore0: hexcharacters
	port map (std_LOGIC_VECTOR(score(3 downto 0)), HEX0);
viewScore1: hexcharacters
	port map (std_LOGIC_VECTOR(score(7 downto 4)), HEX1);	
viewLife: hexcharacters
	port map (std_LOGIC_VECTOR(life), HEX2);
--logic for the game
-- PROCESS(CLK, RESET)
PROCESS(CLK,RESET)
BEGIN
 	--IF RESET = '1' THEN 							-- RESET CASE
	--	score<= "00000000";
	--	life<= "0100";
		--more
--	ELSIF PAUSE = '0' THEN 
--		score <= score;
--		life <= life;
		-- more 
	IF(CLK'EVENT AND CLK='1')THEN
      IF(DRAW1='1')THEN				
			R<=(others=>'1');
			G<=(others=>'1');
			B<=(others=>'0');
      END IF;
		IF(DRAW3='1')THEN				
			R<=(others=>'0'); 
			G<=(others=>'0');
			B<=(others=>'0');
      END IF;
		IF(DRAW4='1')THEN				
			R<=(others=>'0');
			G<=(others=>'0');
			B<=(others=>'0');
      END IF;
		IF(DRAW5='1')THEN				
			R<=(others=>'1');
			G<=(others=>'0');
			B<=(others=>'1');	
		IF(DRAW2='1')THEN
			R<=(others=>'1');
			G<=(others=>'0');
			B<=(others=>'0');
		END IF;
      END IF;
		IF(DRAW6='1')THEN				
			R<=(others=>'1');
			G<=(others=>'0');
			B<=(others=>'1');
      END IF;
		IF(DRAW7='1')THEN				
			R<=(others=>'1');
			G<=(others=>'0');
			B<=(others=>'1');
      END IF;
		IF(DRAW2='1')THEN
			R<=(others=>'1');
			G<=(others=>'0');
			B<=(others=>'0');
		END IF;		
		
		IF (DRAW1='0' AND DRAW2='0' AND DRAW3 = '0' AND DRAW4 = '0'  AND DRAW5 = '0'  AND DRAW6 = '0')THEN
		   R<=(others=>'0');
	      G<=(others=>'0');
	      B<=(others=>'0');
		END IF;
		IF(HPOS<1688)THEN
			HPOS<=HPOS+1;
		ELSe
			HPOS<=0;
			IF(VPOS<1066)THEN
			  VPOS<=VPOS+1;
			ELSE
				VPOS<=0; 
				   IF(KEYS(0)='0')THEN  -- MOVE RIGHT
						SQ_X2<= 1275;
						carCounter <= 2;
					ElSIF (KEYS(1)='0')THEN -- Move RigHT
						SQ_X2<= 975;
						carCounter <= 1;
					ElSIF (KEYS(2)='0')THEN -- Move Left
						SQ_X2<= 675;
						carCounter <= 0;
					END IF;
					if moveYes = '0' then		-- to move obstacles
						SQ_Y5 <= SQ_Y5 + speed1;
					END IF;
					if moveYes3 = '0' then
						SQ_Y7 <= SQ_Y7 + speed2;
					end if;
					if moveYes2 = '0' then
						SQ_Y6 <= SQ_Y6 + speed3;
					end if;
					if SQ_Y5 > 1100 and redoBool = '0'then  -- randomize 
						score <= score + 1;
						counterForRedo <= conv_integer(random_num);
						redoBool <= '1';
						moveYes <= '1';
					elsIF counterForRedo = 0 and redoBool = '1'then
						SQ_Y5 <= 50;
						redoBool <= '0';
						moveYes <= '0';
						collideYes <= '0';
						speed1 <= conv_integer(random_num);
					elsIF redoBool = '1' then
						counterForRedo <=  counterForRedo - 1;
					END IF;
					
					if SQ_Y6 > 1100 and redoBool2 = '0'then
						counterForRedo2 <= conv_integer(random_num)*4;
						redoBool2 <= '1';
						moveYes2 <= '1';
						score <= score + 1;
					elsIF counterForRedo2 = 0 and redoBool2 = '1'then
						SQ_Y6 <= 50;
						redoBool2 <= '0';
						moveYes2 <= '0';
						collideYes2 <= '0';
						speed2 <= conv_integer(random_num);
					elsIF redoBool2 = '1'then
						counterForRedo2 <=  counterForRedo2 - 1;
					END IF;
					
					if SQ_Y7 > 1100 and redoBool3 = '0'then
						score <= score + 1;
						counterForRedo3 <= conv_integer(random_num)*3;
						redoBool3 <= '1';
						moveYes3 <= '1';
					elsIF counterForRedo3 = 0 and redoBool3 = '1'then
						SQ_Y7 <= 50;
						redoBool3 <= '0';
						moveYes3 <= '0';
						collideYes3 <= '0';
						speed3 <= conv_integer(random_num);
					elsIF redoBool3 = '1'then
						counterForRedo3 <=  counterForRedo3 - 1;
					END IF;
			END IF;
		END IF;
   IF((HPOS>0 AND HPOS<408) OR (VPOS>0 AND VPOS<42))THEN
		R<=(others=>'0');
		G<=(others=>'0');
		B<=(others=>'0');
	END IF;
	--collision with obstacle 1
	if (750 < SQ_Y5 and SQ_Y5 < 1050 and SQ_X2 = 675) and collideYes = '0' then
		life <= life - 1;
		collideYes <= '1';
	--	DRAW2 <= '0'; -- something to happen when they collide
	END IF;
	--collision with obstacle 2
	if (750 < SQ_Y6 and SQ_Y6 < 1050 and SQ_X2 = 975) and collideYes2 ='0' then
		life <= life - 1;
		collideYes2 <= '1';
	end if;
	--collision with obstacle 3
	if (750 < SQ_Y7 and SQ_Y7 < 1050 and SQ_X2 = 1275) and collideYes3 = '0'then
		life <= life - 1;
		collideYes3 <= '1';
	end if;
	-- End of collision stuff
   IF(HPOS>48 AND HPOS<160)THEN----HSYNC
	   HSYNC<='0';
	ELSE
	   HSYNC<='1';
	END IF;
   IF(VPOS>0 AND VPOS<4)THEN----------vsync
	   VSYNC<='0';
	ELSE
	   VSYNC<='1';
	END IF;
	if life = 0 then
		moveYes <= '1';
		moveYes2 <= '1';
		moveYes3 <= '1';
	end if;
	if resetThat = '1' then
		moveYes <= '0';
		moveYes2 <= '0';
		moveYes3 <= '0';
		life <= "1010";
		score <= "00000000";
		SQ_Y5 <= 50;
		SQ_Y6 <= 50;
		SQ_Y7 <= 50;
	end if;
END IF;



 END PROCESS;
-- random number generator 
process(clk)
	variable rand_temp : std_logic_vector(4 downto 0):=(4 => '1',others => '0');
	variable temp : std_logic := '0';
begin
	if(rising_edge(clk)) then
		temp := rand_temp(4) xor rand_temp(3);
		rand_temp(4 downto 1) := rand_temp(3 downto 0);
		rand_temp(0) := temp;
	end if;
	random_num <= rand_temp;
end process;
 END MAIN;