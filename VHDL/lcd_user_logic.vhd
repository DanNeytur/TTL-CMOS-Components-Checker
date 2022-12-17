---------------------------------------------------------------------
-- lcd_bus(9)=rs , rs : command/data select, 0=command 1=data	
-- lcd_bus(8)=rw , rw : read/write select, 0=write 1=read
--writing the characters to be displayed on the LCD display while rs <= 1 -data mode and rw <= 0 -write mode
--characters code:
--"1000110000"; --0
--"1000110001"; --1
--"1000110010"; --2
--"1000110011"; --3 
--"1000110100"; --4
--"1000110101"; --5
--"1000110110"; --6
--"1000110111"; --7
--"1000111000"; --8
--"1000111001"; --9

--"1001000001"; --A
--"1001000010"; --B
--"1001000011"; --C
--"1001000100"; --D 
--"1001000101"; --E
--"1001000110"; --F
--"1001000111"; --G
--"1001001000"; --H
--"1001001001"; --I
--"1001001010"; --J
--"1001001011"; --K
--"1001001100"; --L
--"1001001101"; --M
--"1001001110"; --N
--"1001001111"; --O 
--"1001010000"; --P
--"1001010001"; --Q
--"1001010010"; --R
--"1001010011"; --S
--"1001010100"; --T
--"1001010101"; --U
--"1001010110"; --V
--"1001010111"; --W
--"1001011000"; --X
--"1001011001"; --Y
--"1001011010"; --Z

--"1000100000"; --spacebar
--"1000100001"; --!
--"1000111111"; --?
--"1000111010"; --:
--"1000101111"; --/
--"1000101101"; -- -
--"1000101001"; --)

--"0000000001"; --clear display

--"0010000000"; -- Force cursor to beginning of 1nd line
--"0010000001"; -- Force cursor to line 1, colmun 2
--"0010000010"; -- Force cursor to line 1, colmun 3
--"0010000011"; -- Force cursor to line 1, colmun 4
--"0010000100"; -- Force cursor to line 1, colmun 5
--"0010000101"; -- Force cursor to line 1, colmun 6
--"0010000110"; -- Force cursor to line 1, colmun 7
--"0010000111"; -- Force cursor to line 1, colmun 8
--"0010001000"; -- Force cursor to line 1, colmun 9
--"0010001001"; -- Force cursor to line 1, colmun 10
--"0010001010"; -- Force cursor to line 1, colmun 11
--"0010001011"; -- Force cursor to line 1, colmun 12
--"0010001100"; -- Force cursor to line 1, colmun 13
--"0010001101"; -- Force cursor to line 1, colmun 14
--"0010001110"; -- Force cursor to line 1, colmun 15
--"0010001111"; -- Force cursor to line 1, colmun 16		

--"0011000000"; -- Force cursor to beginning of 2nd line
--"0011000001"; -- Force cursor to line 2, colmun 2
--"0011000010"; -- Force cursor to line 2, colmun 3
--"0011000011"; -- Force cursor to line 2, colmun 4
--"0011000100"; -- Force cursor to line 2, colmun 5
--"0011000101"; -- Force cursor to line 2, colmun 6
--"0011000110"; -- Force cursor to line 2, colmun 7
--"0011000111"; -- Force cursor to line 2, colmun 8
--"0011001000"; -- Force cursor to line 2, colmun 9
--"0011001001"; -- Force cursor to line 2, colmun 10
--"0011001010"; -- Force cursor to line 2, colmun 11
--"0011001011"; -- Force cursor to line 2, colmun 12
--"0011001100"; -- Force cursor to line 2, colmun 13
--"0011001101"; -- Force cursor to line 2, colmun 14
--"0011001110"; -- Force cursor to line 2, colmun 15
--"0011001111"; -- Force cursor to line 2, colmun 16	
 --------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY lcd_user_logic IS
PORT(
	lcd_busy : IN STD_LOGIC; --lcd controller busy/idle feedback
	clk 		: IN STD_LOGIC; --system clock clk=50MHZ
	test_res : IN STD_LOGIC;--'1'= working component '0'= malfunctioning component
	iden_res : IN INTEGER RANGE 0 TO 14;--test of identifying function
	key3 		: IN STD_LOGIC; 	
	key2 		: IN STD_LOGIC; 
	key1 		: IN STD_LOGIC; 
	key0 		: IN STD_LOGIC;
	flipped_detect: IN STD_LOGIC;
 	
	voice_sel	: OUT INTEGER RANGE 0 TO 8;--number of voice recording
	trig_voice	: OUT STD_LOGIC;
	lcd_clk 		: OUT STD_LOGIC;
	reset_n 		: OUT STD_LOGIC;
	lcd_enable	: buffer STD_LOGIC; --lcd enable received from lcd controller
	lcd_bus 		: OUT STD_LOGIC_VECTOR(9 DOWNTO 0); --data and control signals
	-- lcd_bus(9)=rs , rs : command/data select , 0=command 1=data	--- data mode
	-- lcd_bus(8)=rw , rw : read/write select , 0=write 1=read		--- write mode
	-- The other 8 bits are the data bits.
	tested_chip		: OUT INTEGER RANGE 0 TO 14;
	trig_test_out	: OUT STD_LOGIC:='0';--trigger a test function 
	trig_iden_out	: OUT STD_LOGIC:='0');--trigger an identifying function
END lcd_user_logic;

ARCHITECTURE behavior OF lcd_user_logic IS
CONSTANT Num_Chars : INTEGER := 34; --number of characters to be displayed (including newline and reseting)
SIGNAL char : INTEGER RANGE 0 TO Num_Chars:= 0;

SIGNAL testing_chars_part : INTEGER RANGE 1 TO 3:=1;--indicates which part of testing screen
SIGNAL iden_chars_part : INTEGER RANGE 1 TO 2:=1;--indicates which part of identifying screen

SIGNAL cnt:integer  RANGE 0 TO 55350000:=0; 

SIGNAL tested_chip_num: integer RANGE 0 TO 14;--14 diffrent chips can be tested
SIGNAL testing_flag: STD_LOGIC:='0';
SIGNAL flipped_detect_flag: STD_LOGIC;

TYPE state_type IS(s0,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12);
SIGNAL state:state_type:=s0;

BEGIN


main_process: PROCESS(clk,test_res)
BEGIN	

IF(clk'EVENT AND clk = '1') THEN
	IF(lcd_busy = '0' AND lcd_enable = '0') THEN
		lcd_enable <= '1';
		
	
	CASE state IS
--=================================state s0 welcome screen================================================================
	WHEN s0=> --welcome screen
	 -----delay for 1 sec-------
		IF(cnt<55350000) THEN 
			lcd_enable <= '0';
			cnt<=cnt+1;
			trig_voice<='1';
		ELSE
		voice_sel<=0;--welcome voice record
		trig_voice<='0';--trigger the voice recorder
		
		------switching to s1 mode - choosing testing/indentifying screen-------
		IF(key3='0' and char=Num_Chars) THEN 
			char<=0;	
			cnt<=0;
			state<=s1;
		END IF;
		
		-----counting the characters to be displayed-------
		IF		(char<Num_Chars) THEN --start welcome screen
			char <= char + 1;
		ELSIF (char=Num_Chars)	THEN --done welcome screen
			char<=0;
		END IF;
			
			------		displaying: "WELCOME TO TTL/CMOS CHECKER" on display		---------
			CASE char IS	 
			--writing the characters to be displayed on the LCD display
				WHEN 1 => lcd_bus <= "0010000000"; -- Force cursor to beginning of 1nd line
				WHEN 2 => lcd_bus <= "1001010111"; --W
				WHEN 3 => lcd_bus <= "1001000101"; --E
				WHEN 4 => lcd_bus <= "1001001100"; --L
				WHEN 5 => lcd_bus <= "1001000011"; --C
				WHEN 6 => lcd_bus <= "1001001111"; --O  
				WHEN 7 => lcd_bus <= "1001001101"; --M
				WHEN 8 => lcd_bus <= "1001000101"; --E
				
				WHEN 9 => lcd_bus <= "1000100000"; --spacebar 
				
				WHEN 10 => lcd_bus <= "1001010100"; --T
				WHEN 11 => lcd_bus <= "1001001111"; --O
				
				WHEN 12 => lcd_bus<= "1000100000"; --spacebar 
				WHEN 13 => lcd_bus<= "1000100000"; --spacebar 
				WHEN 14 => lcd_bus<= "1000100000"; --spacebar 
				WHEN 15 => lcd_bus<= "1000100000"; --spacebar 
				WHEN 16 => lcd_bus<= "1000100000"; --spacebar
				WHEN 17 => lcd_bus<= "1000100000"; --spacebar 
				 
				WHEN 18 => lcd_bus<= "0011000000"; -- Force cursor to beginning of 2nd line
				
				WHEN 19 => lcd_bus<= "1001010100"; --T 
				WHEN 20 => lcd_bus<= "1001010100"; --T
				WHEN 21 => lcd_bus<= "1001001100"; --L
				WHEN 22 => lcd_bus<= "1000101111"; --/
				WHEN 23 => lcd_bus<= "1001000011"; --C
				WHEN 24 => lcd_bus<= "1001001101"; --M
				WHEN 25 => lcd_bus<= "1001001111"; --O
				WHEN 26 => lcd_bus<= "1001010011"; --S
				
				WHEN 27 => lcd_bus<= "1000100000"; --spacebar
				
				WHEN 28 => lcd_bus<= "1001000011"; --C
				WHEN 29 => lcd_bus<= "1001001000"; --H
				WHEN 30 => lcd_bus<= "1001000101"; --E
				WHEN 31 => lcd_bus<= "1001000011"; --C
				WHEN 32 => lcd_bus<= "1001001011"; --K
				WHEN 33 => lcd_bus<= "1001000101"; --E
				WHEN 34 => lcd_bus<= "1001010010"; --R 
				
				WHEN OTHERS => lcd_enable <= '0';
			END CASE;
		END IF;

--==============================state s1 choosing testing/indentifying screen=============================================
	WHEN s1=>
	 -----delay for 1 sec-------
		IF(cnt<55350000) THEN
			lcd_enable <= '0';
			cnt<=cnt+1;
			trig_voice<='1';
		ELSE
	voice_sel<=1;--choose a function voice record
	trig_voice<='0';--trigger the voice recorder

	---------switching to s2 mode - testing mode or s10 mode - identifying mode-------------
		IF(key3='0' and char=Num_Chars) THEN --switching to s10 mode -identifying mode
			char<=0;
			cnt<=0;
			trig_iden_out<='1';
			state<=s11; --s11 indentifying
		ELSIF(key2='0' and char=Num_Chars) THEN --switching to s3 mode - testing mode 
			char<=0;
			cnt<=0;
			state<=s2; --s2 testing 
		END IF;
		
		
		-----counting the characters to be displayed-------
		IF		(char<Num_Chars) THEN 
			char <= char + 1;
		ELSIF (char=Num_Chars)	THEN 
			char<=0;
		END IF;
			
			------		displaying: "KEY3 FOR IDENTIF KEY2 FOR TESTING" on display		---------
			CASE char IS	 
			--writing the characters to be displayed on the LCD display
				WHEN 1 => lcd_bus <= "0010000000"; -- Force cursor to beginning of 1nd line
				WHEN 2 => lcd_bus <= "1001001011"; --K
				WHEN 3 => lcd_bus <= "1001000101"; --E 
				WHEN 4 => lcd_bus <= "1001011001"; --Y
				WHEN 5 => lcd_bus <= "1000110011"; --3 
				
				WHEN 6 => lcd_bus <= "1000100000"; --spacebar 
				
				WHEN 7 => lcd_bus <= "1001000110"; --F
				WHEN 8 => lcd_bus <= "1001001111"; --O
				WHEN 9 => lcd_bus <= "1001010010"; --R
				
				WHEN 10 => lcd_bus <= "1000100000"; --spacebar 
				
				WHEN 11 => lcd_bus<= "1001001001"; --I 
				WHEN 12 => lcd_bus<= "1001000100"; --D 
				WHEN 13 => lcd_bus<= "1001000101"; --E
				WHEN 14 => lcd_bus<= "1001001110"; --N
				WHEN 15 => lcd_bus<= "1001010100"; --T
				WHEN 16 => lcd_bus<= "1001001001"; --I
				WHEN 17 => lcd_bus<= "1001000110"; --F
				
				WHEN 18 => lcd_bus<= "0011000000"; -- Force cursor to beginning of 2nd line
				
				WHEN 19 => lcd_bus<= "1001001011"; --K
				WHEN 20 => lcd_bus<= "1001000101"; --E
				WHEN 21 => lcd_bus<= "1001011001"; --Y
				WHEN 22 => lcd_bus<= "1000110010"; --2
				
				WHEN 23 => lcd_bus<= "1000100000"; --spacebar 
				
				WHEN 24 => lcd_bus<= "1001000110"; --F
				WHEN 25 => lcd_bus<= "1001001111"; --O
				WHEN 26 => lcd_bus<= "1001010010"; --R
				
				WHEN 27 => lcd_bus<= "1000100000"; --spacebar 
				
				WHEN 28 => lcd_bus<= "1001010100"; --T 
				WHEN 29 => lcd_bus<= "1001000101"; --E
				WHEN 30 => lcd_bus<= "1001010011"; --S
				WHEN 31 => lcd_bus<= "1001010100"; --T 

				WHEN 32 => lcd_bus<= "1000100000"; --spacebar
				WHEN 33 => lcd_bus<= "1000100000"; --spacebar
				WHEN 34 => lcd_bus<= "1000100000"; --spacebar
				
				WHEN OTHERS => lcd_enable <= '0';
			END CASE;
			
		END IF;
		
		
--============================state s2 choosing between 40XX/74XXX========================================================
	WHEN s2=>
	 -----delay for 1 sec-------
		IF(cnt<55350000) THEN
			lcd_enable <= '0';
			cnt<=cnt+1;
			trig_voice<='1';
		ELSE
		voice_sel<=2;--choose a component voice record
		trig_voice<='0';--trigger the voice recorder

	---------switching to s3 mode - testing 40XX or s6 mode - testing 74XXX-------------
		IF(key3='0' and char=Num_Chars) THEN --switching to s3 mode - testing 40XX
			char<=0;
			cnt<=0;
			state<=s3; --s3 testing 40XX
		ELSIF(key2='0' and char=Num_Chars) THEN --switching to s6 mode - testing 74XXX
			char<=0;
			cnt<=0;
			state<=s6; --s6 testing 74XXX
		END IF;
		
		
		-----counting the characters to be displayed-------
		IF		(char<Num_Chars) THEN 
			char <= char + 1;
		ELSIF (char=Num_Chars)	THEN 
			char<=0;
		END IF;
			
			------		displaying: "KEY3- TEST 40XX KEY2- TEST 74XXX" on display		---------
			CASE char IS	 
			--writing the characters to be displayed on the LCD display
				WHEN 1 => lcd_bus <= "0010000000"; -- Force cursor to beginning of 1nd line
				WHEN 2 => lcd_bus <= "1001001011"; --K
				WHEN 3 => lcd_bus <= "1001000101"; --E 
				WHEN 4 => lcd_bus <= "1001011001"; --Y
				WHEN 5 => lcd_bus <= "1000110011"; --3 
				
				WHEN 6 => lcd_bus <= "1000101101"; -- - 
				WHEN 7 => lcd_bus <= "1000100000"; --spacebar 
				
				WHEN 8 => lcd_bus<= "1001010100"; --T 
				WHEN 9 => lcd_bus<= "1001000101"; --E
				WHEN 10 => lcd_bus<= "1001010011"; --S
				WHEN 11 => lcd_bus<= "1001010100"; --T 
				
				WHEN 12 => lcd_bus<= "1000100000"; --spacebar 

				WHEN 13 => lcd_bus<= "1000110100"; --4
				WHEN 14 => lcd_bus<= "1000110000"; --0
				WHEN 15 => lcd_bus<= "1001011000"; --X
				WHEN 16 => lcd_bus<= "1001011000"; --X
				
				WHEN 17 => lcd_bus<= "1000100000"; --spacebar
				WHEN 18 => lcd_bus<= "0011000000"; -- Force cursor to beginning of 2nd line
				
				WHEN 19 => lcd_bus<= "1001001011"; --K
				WHEN 20 => lcd_bus<= "1001000101"; --E
				WHEN 21 => lcd_bus<= "1001011001"; --Y
				WHEN 22 => lcd_bus<= "1000110010"; --2
				
				WHEN 23 => lcd_bus <= "1000101101"; -- - 
				WHEN 24 => lcd_bus<= "1000100000"; --spacebar 
				
				WHEN 25 => lcd_bus<= "1001010100"; --T 
				WHEN 26 => lcd_bus<= "1001000101"; --E
				WHEN 27 => lcd_bus<= "1001010011"; --S
				WHEN 28 => lcd_bus<= "1001010100"; --T 
				
				WHEN 29 => lcd_bus<= "1000100000"; --spacebar 
				
				WHEN 30 => lcd_bus<= "1000110111"; --7
				WHEN 31 => lcd_bus<= "1000110100"; --4
				WHEN 32 => lcd_bus<= "1001011000"; --X
				WHEN 33 => lcd_bus<= "1001011000"; --X
				WHEN 34 => lcd_bus<= "1001011000"; --X
				
				WHEN OTHERS => lcd_enable <= '0';
			END CASE;
			
		END IF;
--==============================state s3 choosing which 40XX to test(2/6)=======================================================
	WHEN s3=>
	 -----delay for 1 sec-------
		IF(cnt<55350000) THEN
			lcd_enable <= '0';
			cnt<=cnt+1;
		ELSE
	
	---------switching modes-------------
		IF(key0='0' and char=34) THEN 
			char<=0;
			cnt<=0;
			state<=s4; --scroll down to next two 40XX chips
		ELSIF(key1='0' and char=34) THEN  
			char<=0;
			cnt<=0;
			state<=s5; --scroll up to next two 40XX chips
		ELSIF(key3='0' and char=34) THEN --first chip selected 
			char<=0;
			cnt<=0;
			tested_chip_num<=1; --4001-quad 2 input NOR-14 dip
			trig_test_out<='1';
			state<=s10; --testing state
		ELSIF(key2='0' and char=34) THEN --second chip selected 
			char<=0;
			cnt<=0;
			tested_chip_num<=2; --4011-quad 2 input NAND-14 dip
			trig_test_out<='1';
			state<=s10; --testing state
		END IF;
		
		
		-----counting the characters to be displayed-------
		IF		(char<Num_Chars) THEN --start welcome screen
			char <= char + 1;
		ELSIF (char=Num_Chars)	THEN --done welcome screen
			char<=0;
		END IF;
			
			------		displaying: "1) 4001 2) 4011" on display		---------
			CASE char IS	 
			--writing the characters to be displayed on the LCD display
				WHEN 1 => lcd_bus <= "0010000000"; -- Force cursor to beginning of 1nd line
				WHEN 2 => lcd_bus <= "1000110001"; --1
				WHEN 3 => lcd_bus <= "1000101001"; --)
				
				WHEN 4 => lcd_bus <= "1000100000"; --spacebar 
				
				WHEN 5 => lcd_bus <= "1000110100"; --4  
				WHEN 6 => lcd_bus <= "1000110000"; --0 
				WHEN 7 => lcd_bus <= "1000110000"; --0 
				WHEN 8 => lcd_bus <= "1000110001"; --1
				
				WHEN 9 => lcd_bus <= "1000100000"; --spacebar 
				WHEN 10 => lcd_bus<= "1000100000"; --spacebar 
				WHEN 11 => lcd_bus<= "1000100000"; --spacebar 
				WHEN 12 => lcd_bus<= "1000100000"; --spacebar 
				WHEN 13 => lcd_bus<= "1000100000"; --spacebar 
				WHEN 14 => lcd_bus<= "1000100000"; --spacebar 
				WHEN 15 => lcd_bus<= "1000100000"; --spacebar 
				WHEN 16 => lcd_bus<= "1000100000"; --spacebar
				WHEN 17 => lcd_bus<= "0011000000"; -- Force cursor to beginning of 2nd line
				
				WHEN 18 => lcd_bus<= "1000110010"; --2
				WHEN 19 => lcd_bus <= "1000101001"; --)

				WHEN 20 => lcd_bus<= "1000100000"; --spacebar 
				
				WHEN 21 => lcd_bus <= "1000110100"; --4
				WHEN 22 => lcd_bus <= "1000110000"; --0 
				WHEN 23 => lcd_bus <= "1000110001"; --1
				WHEN 24 => lcd_bus <= "1000110001"; --1
				
				WHEN 25 => lcd_bus <= "1000100000"; --spacebar
				WHEN 26 => lcd_bus <= "1000100000"; --spacebar
				WHEN 27 => lcd_bus<= "1000100000"; --spacebar 
				WHEN 28 => lcd_bus<= "1000100000"; --spacebar 
				WHEN 29 => lcd_bus<= "1000100000"; --spacebar
				WHEN 30 => lcd_bus<= "1000100000"; --spacebar
				WHEN 31 => lcd_bus<= "1000100000"; --spacebar
				WHEN 32 => lcd_bus<= "1000100000"; --spacebar
				WHEN 33 => lcd_bus<= "1000100000"; --spacebar
				WHEN 34 => lcd_bus<= "1000100000"; --spacebar
				
				WHEN OTHERS => lcd_enable <= '0';
			END CASE;
			
		END IF;
		
--==============================state s4 choosing which 40XX to test(4/6)=======================================================
	WHEN s4=>
	 -----delay for 1 sec-------
		IF(cnt<55350000) THEN
			lcd_enable <= '0';
			cnt<=cnt+1;
		ELSE
	
	---------switching modes-------------
		IF(key0='0' and char=34) THEN 
			char<=0;
			cnt<=0;
			state<=s5; --scroll down to next two 40XX chips
		ELSIF(key1='0' and char=34) THEN 
			char<=0;
			cnt<=0;
			state<=s3; --scroll up to next two 40XX chips
		ELSIF(key3='0' and char=34) THEN --first chip selected 
			char<=0;
			cnt<=0;
			tested_chip_num<=3; --4069--hex NOT-14 dip
			trig_test_out<='1';
			state<=s10;--testing state 
		ELSIF(key2='0' and char=34) THEN --second chip selected 
			char<=0;
			cnt<=0;
			tested_chip_num<=4; --4071--quad 2 input OR-14 dip
			trig_test_out<='1';
			state<=s10;--testing state 
		END IF;
		
		
		-----counting the characters to be displayed-------
		IF		(char<Num_Chars) THEN 
			char <= char + 1;
		ELSIF (char=Num_Chars)	THEN 
			char<=0;
		END IF;
			
			------		displaying: "3) 4069 4) 4071" on display		---------
			CASE char IS	 
			--writing the characters to be displayed on the LCD display
				WHEN 1 => lcd_bus <= "0010000000"; -- Force cursor to beginning of 1nd line
				WHEN 2 => lcd_bus <= "1000110011"; --3 
				WHEN 3 => lcd_bus <= "1000101001"; --)
				
				WHEN 4 => lcd_bus <= "1000100000"; --spacebar 
				
				WHEN 5 => lcd_bus <= "1000110100"; --4 
				WHEN 6 => lcd_bus <= "1000110000"; --0 
				WHEN 7 => lcd_bus <= "1000110110"; --6 
				WHEN 8 => lcd_bus <= "1000111001"; --9
				
				WHEN 9 => lcd_bus <= "1000100000"; --spacebar 
				WHEN 10 => lcd_bus<= "1000100000"; --spacebar 
				WHEN 11 => lcd_bus<= "1000100000"; --spacebar 
				WHEN 12 => lcd_bus<= "1000100000"; --spacebar 
				WHEN 13 => lcd_bus<= "1000100000"; --spacebar 
				WHEN 14 => lcd_bus<= "1000100000"; --spacebar 
				WHEN 15 => lcd_bus<= "1000100000"; --spacebar 
				WHEN 16 => lcd_bus<= "1000100000"; --spacebar
				WHEN 17 => lcd_bus<= "0011000000"; -- Force cursor to beginning of 2nd line
				
				WHEN 18 => lcd_bus<= "1000110100"; --4
				WHEN 19 => lcd_bus <= "1000101001"; --)

				WHEN 20 => lcd_bus<= "1000100000"; --spacebar 
				
				WHEN 21 => lcd_bus <= "1000110100"; --4
				WHEN 22 => lcd_bus <= "1000110000"; --0 
				WHEN 23 => lcd_bus <= "1000110111"; --7
				WHEN 24 => lcd_bus <= "1000110001"; --1
				
				WHEN 25 => lcd_bus <= "1000100000"; --spacebar 
				WHEN 26 => lcd_bus <= "1000100000"; --spacebar 
				WHEN 27 => lcd_bus<= "1000100000"; --spacebar 
				WHEN 28 => lcd_bus<= "1000100000"; --spacebar 
				WHEN 29 => lcd_bus<= "1000100000"; --spacebar
				WHEN 30 => lcd_bus<= "1000100000"; --spacebar
				WHEN 31 => lcd_bus<= "1000100000"; --spacebar
				WHEN 32 => lcd_bus<= "1000100000"; --spacebar
				WHEN 33 => lcd_bus<= "1000100000"; --spacebar
				WHEN 34 => lcd_bus<= "1000100000"; --spacebar
				
				WHEN OTHERS => lcd_enable <= '0';
			END CASE;
			
		END IF;

--==============================state s5 choosing which 40XX to test(6/6)=======================================================
	WHEN s5=>
	 -----delay for 1 sec-------
		IF(cnt<55350000) THEN
			lcd_enable <= '0';
			cnt<=cnt+1;
		ELSE
	
	---------switching modes-------------
		IF(key0='0' and char=34) THEN 
			char<=0;
			cnt<=0;
			state<=s3; --scroll down to next two 40XX chips
		ELSIF(key1='0' and char=34) THEN 
			char<=0;
			cnt<=0;
			state<=s4; --scroll up to next two 40XX chips
		ELSIF(key3='0' and char=34) THEN --first chip selected 
			char<=0;
			cnt<=0;
			tested_chip_num<=5; --4081--quad 2 input AND-14 dip
			trig_test_out<='1';
			state<=s10; --testing state
		ELSIF(key2='0' and char=34) THEN --second chip selected 
			char<=0;
			cnt<=0;
			tested_chip_num<=6; --4008--4 bit binary full adder-16 dip
			trig_test_out<='1';
			state<=s10; --testing state
		END IF;
		
		
		-----counting the characters to be displayed-------
		IF		(char<Num_Chars) THEN 
			char <= char + 1;
		ELSIF (char=Num_Chars)	THEN 
			char<=0;
		END IF;
			
			------		displaying: "5) 4081 6) 4008" on display		---------
			CASE char IS	 
			--writing the characters to be displayed on the LCD display
				WHEN 1 => lcd_bus <= "0010000000"; -- Force cursor to beginning of 1nd line
				WHEN 2 => lcd_bus <= "1000110101"; --5
				WHEN 3 => lcd_bus <= "1000101001"; --)
				
				WHEN 4 => lcd_bus <= "1000100000"; --spacebar 
				
				WHEN 5 => lcd_bus <= "1000110100"; --4
				WHEN 6 => lcd_bus <= "1000110000"; --0 
				WHEN 7 => lcd_bus <= "1000111000"; --8
				WHEN 8 => lcd_bus <= "1000110001"; --1
				
				WHEN 9 => lcd_bus <= "1000100000"; --spacebar
				WHEN 10 => lcd_bus<= "1000100000"; --spacebar
				WHEN 11 => lcd_bus<= "1000100000"; --spacebar 
				WHEN 12 => lcd_bus<= "1000100000"; --spacebar 
				WHEN 13 => lcd_bus<= "1000100000"; --spacebar 
				WHEN 14 => lcd_bus<= "1000100000"; --spacebar 
				WHEN 15 => lcd_bus<= "1000100000"; --spacebar 
				WHEN 16 => lcd_bus<= "1000100000"; --spacebar
				WHEN 17 => lcd_bus<= "0011000000"; -- Force cursor to beginning of 2nd line
				
				WHEN 18 => lcd_bus<= "1000110110"; --6
				WHEN 19 => lcd_bus <= "1000101001"; --)

				WHEN 20 => lcd_bus<= "1000100000"; --spacebar 
				
				WHEN 21 => lcd_bus <= "1000110100"; --4  
				WHEN 22 => lcd_bus <= "1000110000"; --0 
				WHEN 23 => lcd_bus <= "1000110000"; --0
				WHEN 24 => lcd_bus <= "1000111000"; --8
				
				WHEN 25 => lcd_bus <= "1000100000"; --spacebar 
				WHEN 26 => lcd_bus <= "1000100000"; --spacebar 
				WHEN 27 => lcd_bus<= "1000100000"; --spacebar 
				WHEN 28 => lcd_bus<= "1000100000"; --spacebar 
				WHEN 29 => lcd_bus<= "1000100000"; --spacebar
				WHEN 30 => lcd_bus<= "1000100000"; --spacebar
				WHEN 31 => lcd_bus<= "1000100000"; --spacebar
				WHEN 32 => lcd_bus<= "1000100000"; --spacebar
				WHEN 33 => lcd_bus<= "1000100000"; --spacebar
				WHEN 34 => lcd_bus<= "1000100000"; --spacebar
				
				WHEN OTHERS => lcd_enable <= '0';
			END CASE;
			
		END IF;	
	
--==============================state s6 choosing which 74XXX to test(2/8)=======================================================
	WHEN s6=>
	 -----delay for 1 sec-------
		IF(cnt<55350000) THEN
			lcd_enable <= '0';
			cnt<=cnt+1;
		ELSE
	
		---------switching modes-------------
		IF(key0='0' and char=34) THEN
			char<=0;
			cnt<=0;
			state<=s7; --scroll down to next two 74XXX chips
		ELSIF(key1='0' and char=34) THEN 
			char<=0;
			cnt<=0;
			state<=s9; --scroll up to next two 74XXX chips
		ELSIF(key3='0' and char=34) THEN --first chip selected
			char<=0;
			cnt<=0;
			tested_chip_num<=7; --7400--quad 2 input NAND-14 dip
			trig_test_out<='1';
			state<=s10;--testing state
		ELSIF(key2='0' and char=34) THEN --second chip selected
			char<=0;
			cnt<=0;
			tested_chip_num<=8; --7421--dual 4 input AND-14 dip
			trig_test_out<='1';
			state<=s10;--testing state
		END IF;
		
		
		-----counting the characters to be displayed-------
		IF		(char<Num_Chars) THEN 
			char <= char + 1;
		ELSIF (char=Num_Chars)	THEN 
			char<=0;
		END IF;
			
			------		displaying: "1) 7400 2) 7421" on display		---------
			CASE char IS	 
			--writing the characters to be displayed on the LCD display
				WHEN 1 => lcd_bus <= "0010000000"; -- Force cursor to beginning of 1nd line
				WHEN 2 => lcd_bus <= "1000110001"; --1
				WHEN 3 => lcd_bus <= "1000101001"; --)
				
				WHEN 4 => lcd_bus <= "1000100000"; --spacebar 
				
				WHEN 5 => lcd_bus <= "1000110111"; --7
				WHEN 6 => lcd_bus <= "1000110100"; --4 
				WHEN 7 => lcd_bus <= "1000110000"; --0
				WHEN 8 => lcd_bus <= "1000110000"; --0
				
				WHEN 9 => lcd_bus <= "1000100000"; --spacebar
				WHEN 10 => lcd_bus<= "1000100000"; --spacebar
				WHEN 11 => lcd_bus<= "1000100000"; --spacebar 
				WHEN 12 => lcd_bus<= "1000100000"; --spacebar 
				WHEN 13 => lcd_bus<= "1000100000"; --spacebar 
				WHEN 14 => lcd_bus<= "1000100000"; --spacebar 
				WHEN 15 => lcd_bus<= "1000100000"; --spacebar 
				WHEN 16 => lcd_bus<= "1000100000"; --spacebar
				WHEN 17 => lcd_bus<= "0011000000"; -- Force cursor to beginning of 2nd line
				
				WHEN 18 => lcd_bus<= "1000110010"; --2
				WHEN 19 => lcd_bus<= "1000101001"; --)

				WHEN 20 => lcd_bus<= "1000100000"; --spacebar 
				
				WHEN 21 => lcd_bus<= "1000110111"; --7
				WHEN 22 => lcd_bus<= "1000110100"; --4 
				WHEN 23 => lcd_bus<= "1000110010"; --2
				WHEN 24 => lcd_bus<= "1000110001"; --1
				
				WHEN 25 => lcd_bus<= "1000100000"; --spacebar 
				WHEN 26 => lcd_bus<= "1000100000"; --spacebar 
				WHEN 27 => lcd_bus<= "1000100000"; --spacebar 
				WHEN 28 => lcd_bus<= "1000100000"; --spacebar 
				WHEN 29 => lcd_bus<= "1000100000"; --spacebar
				WHEN 30 => lcd_bus<= "1000100000"; --spacebar
				WHEN 31 => lcd_bus<= "1000100000"; --spacebar
				WHEN 32 => lcd_bus<= "1000100000"; --spacebar
				WHEN 33 => lcd_bus<= "1000100000"; --spacebar
				WHEN 34 => lcd_bus<= "1000100000"; --spacebar
				
				WHEN OTHERS => lcd_enable <= '0';
			END CASE;
			
		END IF;
		
--==============================state s7 choosing which 74XXX to test(4/8)=======================================================
	WHEN s7=>
	 -----delay for 1 sec-------
		IF(cnt<55350000) THEN
			lcd_enable <= '0';
			cnt<=cnt+1;
		ELSE
	
		---------switching modes-------------
		IF(key0='0' and char=34) THEN
			char<=0;
			cnt<=0;
			state<=s8; --scroll down to next two 74XXX chips
		ELSIF(key1='0' and char=34) THEN 
			char<=0;
			cnt<=0;
			state<=s6; --scroll up to next two 74XXX chips
		ELSIF(key3='0' and char=34) THEN --first chip selected
			char<=0;
			cnt<=0;
			tested_chip_num<=9; --7408--quad 2 input AND-14 dip
			trig_test_out<='1';
			state<=s10;--testing state
		ELSIF(key2='0' and char=34) THEN --second chip selected
			char<=0;
			cnt<=0;
			tested_chip_num<=10; --7402--quad 2 input NOR-14 dip
			trig_test_out<='1';
			state<=s10;--testing state
		END IF;
		
		
		-----counting the characters to be displayed-------
		IF		(char<Num_Chars) THEN 
			char <= char + 1;
		ELSIF (char=Num_Chars)	THEN 
			char<=0;
		END IF;
			
			------		displaying: "3) 7408 4) 7402" on display		---------
			CASE char IS	 
			--writing the characters to be displayed on the LCD display
				WHEN 1 => lcd_bus <= "0010000000"; -- Force cursor to beginning of 1nd line
				WHEN 2 => lcd_bus <= "1000110011"; --3 
				WHEN 3 => lcd_bus <= "1000101001"; --)
				
				WHEN 4 => lcd_bus <= "1000100000"; --spacebar 
				
				WHEN 5 => lcd_bus <= "1000110111"; --7
				WHEN 6 => lcd_bus <= "1000110100"; --4 
				WHEN 7 => lcd_bus <= "1000110000"; --0
				WHEN 8 => lcd_bus <= "1000111000"; --8
				
				WHEN 9 => lcd_bus <= "1000100000"; --spacebar 
				WHEN 10 => lcd_bus<= "1000100000"; --spacebar 
				WHEN 11 => lcd_bus<= "1000100000"; --spacebar 
				WHEN 12 => lcd_bus<= "1000100000"; --spacebar 
				WHEN 13 => lcd_bus<= "1000100000"; --spacebar 
				WHEN 14 => lcd_bus<= "1000100000"; --spacebar 
				WHEN 15 => lcd_bus<= "1000100000"; --spacebar 
				WHEN 16 => lcd_bus<= "1000100000"; --spacebar
				WHEN 17 => lcd_bus<= "0011000000"; -- Force cursor to beginning of 2nd line
				
				WHEN 18 => lcd_bus<= "1000110100"; --4 
				WHEN 19 => lcd_bus <= "1000101001"; --)

				WHEN 20 => lcd_bus<= "1000100000"; --spacebar 
				
				WHEN 21 => lcd_bus <= "1000110111"; --7
				WHEN 22 => lcd_bus <= "1000110100"; --4 
				WHEN 23 => lcd_bus <= "1000110000"; --0
				WHEN 24 => lcd_bus <= "1000110010"; --2
				
				WHEN 25 => lcd_bus <= "1000100000"; --spacebar 
				WHEN 26 => lcd_bus <= "1000100000"; --spacebar 
				WHEN 27 => lcd_bus<= "1000100000"; --spacebar 
				WHEN 28 => lcd_bus<= "1000100000"; --spacebar 
				WHEN 29 => lcd_bus<= "1000100000"; --spacebar
				WHEN 30 => lcd_bus<= "1000100000"; --spacebar
				WHEN 31 => lcd_bus<= "1000100000"; --spacebar
				WHEN 32 => lcd_bus<= "1000100000"; --spacebar
				WHEN 33 => lcd_bus<= "1000100000"; --spacebar
				WHEN 34 => lcd_bus<= "1000100000"; --spacebar
				
				WHEN OTHERS => lcd_enable <= '0';
			END CASE;
			
		END IF;
		
--==============================state s8 choosing which 74XXX to test(6/8)=======================================================
	WHEN s8=>
	 -----delay for 1 sec-------
		IF(cnt<55350000) THEN
			lcd_enable <= '0';
			cnt<=cnt+1;
		ELSE
	
		---------switching modes-------------
		IF(key0='0' and char=34) THEN
			char<=0;
			cnt<=0;
			state<=s9; --scroll down to next two 74XXX chips
		ELSIF(key1='0' and char=34) THEN 
			char<=0;
			cnt<=0;
			state<=s7; --scroll up to next two 74XXX chips
		ELSIF(key3='0' and char=34) THEN --first chip selected
			char<=0;
			cnt<=0;
			tested_chip_num<=11; --7404--hex NOT-14 dip
			trig_test_out<='1';
			state<=s10;--testing state
		ELSIF(key2='0' and char=34) THEN --second chip selected
			char<=0;
			cnt<=0;
			tested_chip_num<=12; --74157--QUAD 2 input Multiplexer-16 dip
			trig_test_out<='1';
			state<=s10;--testing state
		END IF;
		
		
		-----counting the characters to be displayed-------
		IF		(char<Num_Chars) THEN 
			char <= char + 1;
		ELSIF (char=Num_Chars)	THEN
			char<=0;
		END IF;
			
			------		displaying: "5) 7404 6) 74157" on display		---------
			CASE char IS	 
			--writing the characters to be displayed on the LCD display
				WHEN 1 => lcd_bus <= "0010000000"; -- Force cursor to beginning of 1nd line
				WHEN 2 => lcd_bus <= "1000110101"; --5
				WHEN 3 => lcd_bus <= "1000101001"; --)
				
				WHEN 4 => lcd_bus <= "1000100000"; --spacebar 
				
				WHEN 5 => lcd_bus <= "1000110111"; --7
				WHEN 6 => lcd_bus <= "1000110100"; --4 
				WHEN 7 => lcd_bus <= "1000110000"; --0
				WHEN 8 => lcd_bus <= "1000110100"; --4
				
				WHEN 9 => lcd_bus <= "1000100000"; --spacebar 
				WHEN 10 => lcd_bus<= "1000100000"; --spacebar 
				WHEN 11 => lcd_bus<= "1000100000"; --spacebar 
				WHEN 12 => lcd_bus<= "1000100000"; --spacebar 
				WHEN 13 => lcd_bus<= "1000100000"; --spacebar 
				WHEN 14 => lcd_bus<= "1000100000"; --spacebar 
				WHEN 15 => lcd_bus<= "1000100000"; --spacebar 
				WHEN 16 => lcd_bus<= "1000100000"; --spacebar
				WHEN 17 => lcd_bus<= "0011000000"; -- Force cursor to beginning of 2nd line
				
				WHEN 18 => lcd_bus<= "1000110110"; --6
				WHEN 19 => lcd_bus <= "1000101001"; --)

				WHEN 20 => lcd_bus<= "1000100000"; --spacebar 
				
				WHEN 21 => lcd_bus <= "1000110111"; --7
				WHEN 22 => lcd_bus <= "1000110100"; --4 
				WHEN 23 => lcd_bus <= "1000110001"; --1
				WHEN 24 => lcd_bus <= "1000110101"; --5
				WHEN 25 => lcd_bus <= "1000110111"; --7 
				
				WHEN 26 => lcd_bus <= "1000100000"; --spacebar 
				WHEN 27 => lcd_bus<= "1000100000"; --spacebar 
				WHEN 28 => lcd_bus<= "1000100000"; --spacebar 
				WHEN 29 => lcd_bus<= "1000100000"; --spacebar
				WHEN 30 => lcd_bus<= "1000100000"; --spacebar
				WHEN 31 => lcd_bus<= "1000100000"; --spacebar
				WHEN 32 => lcd_bus<= "1000100000"; --spacebar
				WHEN 33 => lcd_bus<= "1000100000"; --spacebar
				WHEN 34 => lcd_bus<= "1000100000"; --spacebar
				
				WHEN OTHERS => lcd_enable <= '0';
			END CASE;
			
		END IF;	
			
		
--==============================state s9 choosing which 74XXX to test(8/8)=======================================================
	WHEN s9=>
	 -----delay for 1 sec-------
		IF(cnt<55350000) THEN
			lcd_enable <= '0';
			cnt<=cnt+1;
		ELSE
	
		---------switching modes-------------
		IF(key0='0' and char=34) THEN
			char<=0;
			cnt<=0;
			state<=s6; --scroll down to next two 74XXX chips
		ELSIF(key1='0' and char=34) THEN 
			char<=0;
			cnt<=0;
			state<=s8; --scroll up to next two 74XXX chips
		ELSIF(key3='0' and char=34) THEN --first chip selected
			char<=0;
			cnt<=0;
			tested_chip_num<=13; --74240-Octal Inverter-20 dip
			trig_test_out<='1';
			state<=s10;--testing state
		ELSIF(key2='0' and char=34) THEN --second chip selected
			char<=0;
			cnt<=0;
			tested_chip_num<=14; --74147-10 to 0 priority encoder- 16 dip
			trig_test_out<='1';
			state<=s10;--testing state
		END IF;
		
		
		-----counting the characters to be displayed-------
		IF		(char<Num_Chars) THEN 
			char <= char + 1;
		ELSIF (char=Num_Chars)	THEN
			char<=0;
		END IF;
			
			------		displaying: "7) 74240 8) 74147" on display		---------
			CASE char IS	 
			--writing the characters to be displayed on the LCD display
				WHEN 1 => lcd_bus <= "0010000000"; -- Force cursor to beginning of 1nd line
				WHEN 2 => lcd_bus <= "1000110111"; --7
				WHEN 3 => lcd_bus <= "1000101001"; --)
				
				WHEN 4 => lcd_bus <= "1000100000"; --spacebar 
				
				WHEN 5 => lcd_bus <= "1000110111"; --7
				WHEN 6 => lcd_bus <= "1000110100"; --4 
				WHEN 7 => lcd_bus <= "1000110010"; --2
				WHEN 8 => lcd_bus <= "1000110100"; --4
				WHEN 9 => lcd_bus <= "1000110000"; --0 
				
				WHEN 10 => lcd_bus<= "1000100000"; --spacebar 
				WHEN 11 => lcd_bus<= "1000100000"; --spacebar 
				WHEN 12 => lcd_bus<= "1000100000"; --spacebar 
				WHEN 13 => lcd_bus<= "1000100000"; --spacebar 
				WHEN 14 => lcd_bus<= "1000100000"; --spacebar 
				WHEN 15 => lcd_bus<= "1000100000"; --spacebar 
				WHEN 16 => lcd_bus<= "1000100000"; --spacebar
				WHEN 17 => lcd_bus<= "0011000000"; -- Force cursor to beginning of 2nd line
				
				WHEN 18 => lcd_bus<= "1000111000"; --8
				WHEN 19 => lcd_bus <= "1000101001"; --)

				WHEN 20 => lcd_bus<= "1000100000"; --spacebar 
				
				WHEN 21 => lcd_bus <= "1000110111"; --7
				WHEN 22 => lcd_bus <= "1000110100"; --4 
				WHEN 23 => lcd_bus <= "1000110001"; --1
				WHEN 24 => lcd_bus <= "1000110100"; --4
				WHEN 25 => lcd_bus <= "1000110111"; --7 
				
				WHEN 26 => lcd_bus <= "1000100000"; --spacebar 
				WHEN 27 => lcd_bus<= "1000100000"; --spacebar 
				WHEN 28 => lcd_bus<= "1000100000"; --spacebar 
				WHEN 29 => lcd_bus<= "1000100000"; --spacebar
				WHEN 30 => lcd_bus<= "1000100000"; --spacebar
				WHEN 31 => lcd_bus<= "1000100000"; --spacebar
				WHEN 32 => lcd_bus<= "1000100000"; --spacebar
				WHEN 33 => lcd_bus<= "1000100000"; --spacebar
				WHEN 34 => lcd_bus<= "1000100000"; --spacebar
				
				WHEN OTHERS => lcd_enable <= '0';
			END CASE;
			
		END IF;	
			
		
--==============================state s10 testing and result screen=======================================================
	WHEN s10=>
	 -----delay for 1 sec-------
		IF(cnt<55350000) THEN 
			lcd_enable <= '0';
			cnt<=cnt+1;
			trig_voice<='1';
			flipped_detect_flag<=flipped_detect;
		ELSE
		
		trig_test_out<='0';
		
		---------switching to s12 mode - component flipped screen-----------
		IF(flipped_detect_flag='0') THEN--component is flipped
--			char<=0;
--			cnt<=0;
			state<=s12;--component flipped screen
		ELSE--component is not flipped	
		
				---------switching to s1 mode - choosing testing/indentifying screen-----------
		IF(key3='0' and char=9 and testing_chars_part=3) THEN
			char<=0;
			cnt<=0;
			testing_chars_part<=1;
			state<=s1;--choosing testing/indentifying screen
--		ELSIF(key2='0' and char=9 and testing_chars_part=3) THEN
--			char<=0;
--			cnt<=0;
--			testing_chars_part<=1;
--			state<=s12;--malfunctioning legs screen
		END IF;
		
		
		-----counting the characters to be displayed-------
		IF		(char<9 and testing_chars_part=1) THEN--start beginning
					char <= char + 1;
		ELSIF (char=9 and testing_chars_part=1)	THEN --done beginning
					testing_chars_part<=2; 
					char<=0;
		ELSIF	(char<17 and testing_chars_part=2) THEN--start middle
					char <= char + 1;
		ELSIF (char=17 and testing_chars_part=2)	THEN --done middle
					testing_chars_part<=3; 
					char<=0;
		ELSIF (char <9 and testing_chars_part=3)	THEN --writing result
					char <= char + 1;
		ELSIF (char =9 and testing_chars_part=3)	THEN --writing result
					char <=0;
		END IF;
		
		
		CASE testing_chars_part IS

		WHEN 1=>
		------		displaying: tested component name on display		----------
			CASE tested_chip_num IS
			WHEN 0=>
			tested_chip_num<=0;
			
			WHEN 1=> --tested_chip_num=1 --4001
				CASE char IS
				--displaying: "4001" on display
				WHEN 1 => lcd_bus <= "0010000000"; -- Force cursor to beginning of 1nd line
				WHEN 2 => lcd_bus <= "1000110100"; --4 
				WHEN 3 => lcd_bus <= "1000110000"; --0
				WHEN 4 => lcd_bus <= "1000110000"; --0
				WHEN 5 => lcd_bus <= "1000110001"; --1
				WHEN 6 => lcd_bus <= "1000100000"; --spacebar
				WHEN 7 => lcd_bus <= "1000100000"; --spacebar
				WHEN 8 => lcd_bus <= "1000100000"; --spacebar
				WHEN 9 => lcd_bus <= "1000100000"; --spacebar
				WHEN OTHERS => lcd_enable <= '0';
				END CASE;
				
			WHEN 2 => --tested_chip_num=2 --4011
				CASE char IS
				--displaying: "4011 " on display
				WHEN 1 => lcd_bus<= "0010000000"; -- Force cursor to beginning of 1nd line	
				WHEN 2 => lcd_bus <= "1000110100"; --4 
				WHEN 3 => lcd_bus <= "1000110000"; --0
				WHEN 4 => lcd_bus <= "1000110001"; --1
				WHEN 5 => lcd_bus <= "1000110001"; --1
				WHEN 6 => lcd_bus <= "1000100000"; --spacebar
				WHEN 7 => lcd_bus <= "1000100000"; --spacebar
				WHEN 8 => lcd_bus <= "1000100000"; --spacebar
				WHEN 9 => lcd_bus <= "1000100000"; --spacebar
				WHEN OTHERS => lcd_enable <= '0';
				END CASE;
				
			WHEN 3=> --tested_chip_num=3 --4069
				CASE char IS
				--displaying: "4069" on display
				WHEN 1 => lcd_bus <= "0010000000"; -- Force cursor to beginning of 1nd line
				WHEN 2 => lcd_bus <= "1000110100"; --4 
				WHEN 3 => lcd_bus <= "1000110000"; --0
				WHEN 4 => lcd_bus <= "1000110110"; --6
				WHEN 5 => lcd_bus <= "1000111001"; --9
				WHEN 6 => lcd_bus <= "1000100000"; --spacebar
				WHEN 7 => lcd_bus <= "1000100000"; --spacebar
				WHEN 8 => lcd_bus <= "1000100000"; --spacebar
				WHEN 9 => lcd_bus <= "1000100000"; --spacebar
				WHEN OTHERS => lcd_enable <= '0';
				END CASE;
				
			WHEN 4 => --tested_chip_num=4 --4071
				CASE char IS
				--displaying: "4071 " on display
				WHEN 1 => lcd_bus<= "0010000000"; -- Force cursor to beginning of 1nd line	
				WHEN 2 => lcd_bus <= "1000110100"; --4 
				WHEN 3 => lcd_bus <= "1000110000"; --0
				WHEN 4 => lcd_bus <= "1000110111"; --7
				WHEN 5 => lcd_bus <= "1000110001"; --1
				WHEN 6 => lcd_bus <= "1000100000"; --spacebar
				WHEN 7 => lcd_bus <= "1000100000"; --spacebar
				WHEN 8 => lcd_bus <= "1000100000"; --spacebar
				WHEN 9 => lcd_bus <= "1000100000"; --spacebar
				WHEN OTHERS => lcd_enable <= '0';
				END CASE;
				
			WHEN 5=> --tested_chip_num=5 --4081
				CASE char IS
				--displaying: "4081" on display
				WHEN 1 => lcd_bus <= "0010000000"; -- Force cursor to beginning of 1nd line
				WHEN 2 => lcd_bus <= "1000110100"; --4 
				WHEN 3 => lcd_bus <= "1000110000"; --0
				WHEN 4 => lcd_bus <= "1000111000"; --8
				WHEN 5 => lcd_bus <= "1000110001"; --1
				WHEN 6 => lcd_bus <= "1000100000"; --spacebar
				WHEN 7 => lcd_bus <= "1000100000"; --spacebar
				WHEN 8 => lcd_bus <= "1000100000"; --spacebar
				WHEN 9 => lcd_bus <= "1000100000"; --spacebar
				WHEN OTHERS => lcd_enable <= '0';
				END CASE;
				
			WHEN 6 => --tested_chip_num=6 --4008
				CASE char IS
				--displaying: "4008" on display
				WHEN 1 => lcd_bus<= "0010000000"; -- Force cursor to beginning of 1nd line	 
				WHEN 2 => lcd_bus <= "1000110100"; --4 
				WHEN 3 => lcd_bus <= "1000110000"; --0
				WHEN 4 => lcd_bus <= "1000110000"; --0
				WHEN 5 => lcd_bus <= "1000111000"; --8
				WHEN 6 => lcd_bus <= "1000100000"; --spacebar
				WHEN 7 => lcd_bus <= "1000100000"; --spacebar
				WHEN 8 => lcd_bus <= "1000100000"; --spacebar
				WHEN 9 => lcd_bus <= "1000100000"; --spacebar
				WHEN OTHERS => lcd_enable <= '0';
				END CASE;	
				
			WHEN 7 => --tested_chip_num=7 --7400 
				CASE char IS
				--displaying: "7400" on display
				WHEN 1 => lcd_bus <= "0010000000"; -- Force cursor to beginning of 1nd line
				WHEN 2 => lcd_bus <= "1000110111"; --7
				WHEN 3 => lcd_bus <= "1000110100"; --4
				WHEN 4 => lcd_bus <= "1000110000"; --0 
				WHEN 5 => lcd_bus <= "1000110000"; --0
				WHEN 6 => lcd_bus <= "1000100000"; --spacebar
				WHEN 7 => lcd_bus <= "1000100000"; --spacebar
				WHEN 8 => lcd_bus <= "1000100000"; --spacebar
				WHEN 9 => lcd_bus <= "1000100000"; --spacebar
				WHEN OTHERS => lcd_enable <= '0';
				END CASE;
				
			WHEN 8 => --tested_chip_num=8 --7421
				CASE char IS
				--displaying: "7421" on display
				WHEN 1 => lcd_bus <= "0010000000"; -- Force cursor to beginning of 1nd line
				WHEN 2 => lcd_bus <= "1000110111"; --7
				WHEN 3 => lcd_bus <= "1000110100"; --4
				WHEN 4 => lcd_bus <= "1000110010"; --2 
				WHEN 5 => lcd_bus <= "1000110001"; --1
				WHEN 6 => lcd_bus <= "1000100000"; --spacebar
				WHEN 7 => lcd_bus <= "1000100000"; --spacebar
				WHEN 8 => lcd_bus <= "1000100000"; --spacebar
				WHEN 9 => lcd_bus <= "1000100000"; --spacebar
				WHEN OTHERS => lcd_enable <= '0';
				END CASE;
				
			WHEN 9 => --tested_chip_num=9 --7408 
				CASE char IS
				--displaying: "7408" on display
				WHEN 1 => lcd_bus <= "0010000000"; -- Force cursor to beginning of 1nd line
				WHEN 2 => lcd_bus <= "1000110111"; --7
				WHEN 3 => lcd_bus <= "1000110100"; --4
				WHEN 4 => lcd_bus <= "1000110000"; --0 
				WHEN 5 => lcd_bus <= "1000111000"; --8
				WHEN 6 => lcd_bus <= "1000100000"; --spacebar
				WHEN 7 => lcd_bus <= "1000100000"; --spacebar
				WHEN 8 => lcd_bus <= "1000100000"; --spacebar
				WHEN 9 => lcd_bus <= "1000100000"; --spacebar
				WHEN OTHERS => lcd_enable <= '0';
				END CASE;
				
			WHEN 10 => --tested_chip_num=10 --7402
				CASE char IS
				--displaying: "7402" on display
				WHEN 1 => lcd_bus <= "0010000000"; -- Force cursor to beginning of 1nd line
				WHEN 2 => lcd_bus <= "1000110111"; --7
				WHEN 3 => lcd_bus <= "1000110100"; --4
				WHEN 4 => lcd_bus <= "1000110000"; --0 
				WHEN 5 => lcd_bus <= "1000110010"; --2 
				WHEN 6 => lcd_bus <= "1000100000"; --spacebar
				WHEN 7 => lcd_bus <= "1000100000"; --spacebar
				WHEN 8 => lcd_bus <= "1000100000"; --spacebar
				WHEN 9 => lcd_bus <= "1000100000"; --spacebar
				WHEN OTHERS => lcd_enable <= '0';
				END CASE;
			
			WHEN 11 => --tested_chip_num=11 --7404 
				CASE char IS
				--displaying: "7404" on display
				WHEN 1 => lcd_bus <= "0010000000"; -- Force cursor to beginning of 1nd line
				WHEN 2 => lcd_bus <= "1000110111"; --7
				WHEN 3 => lcd_bus <= "1000110100"; --4
				WHEN 4 => lcd_bus <= "1000110000"; --0 
				WHEN 5 => lcd_bus <= "1000110100"; --4
				WHEN 6 => lcd_bus <= "1000100000"; --spacebar
				WHEN 7 => lcd_bus <= "1000100000"; --spacebar
				WHEN 8 => lcd_bus <= "1000100000"; --spacebar
				WHEN 9 => lcd_bus <= "1000100000"; --spacebar
				WHEN OTHERS => lcd_enable <= '0';
				END CASE;
				
			WHEN 12 => --tested_chip_num=12 --74157
				CASE char IS
				--displaying: "74157" on display
				WHEN 1 => lcd_bus <= "0010000000"; -- Force cursor to beginning of 1nd line
				WHEN 2 => lcd_bus <= "1000110111"; --7
				WHEN 3 => lcd_bus <= "1000110100"; --4
				WHEN 4 => lcd_bus <= "1000110001"; --1
				WHEN 5 => lcd_bus <= "1000110101"; --5
				WHEN 6 => lcd_bus <= "1000110111"; --7
				WHEN 7 => lcd_bus <= "1000100000"; --spacebar
				WHEN 8 => lcd_bus <= "1000100000"; --spacebar
				WHEN 9 => lcd_bus <= "1000100000"; --spacebar
				WHEN OTHERS => lcd_enable <= '0';
				END CASE;
			
			WHEN 13 => --tested_chip_num=13 --74240
				CASE char IS
				--displaying: "74240" on display
				WHEN 1 => lcd_bus <= "0010000000"; -- Force cursor to beginning of 1nd line
				WHEN 2 => lcd_bus <= "1000110111"; --7
				WHEN 3 => lcd_bus <= "1000110100"; --4
				WHEN 4 => lcd_bus <= "1000110010"; --2 
				WHEN 5 => lcd_bus <= "1000110100"; --4
				WHEN 6 => lcd_bus <= "1000110000"; --0
				WHEN 7 => lcd_bus <= "1000100000"; --spacebar
				WHEN 8 => lcd_bus <= "1000100000"; --spacebar
				WHEN 9 => lcd_bus <= "1000100000"; --spacebar
				WHEN OTHERS => lcd_enable <= '0';
				END CASE;
				
			WHEN 14 => --tested_chip_num=14 --74147
				CASE char IS
				--displaying: "74147" on display
				WHEN 1 => lcd_bus <= "0010000000"; -- Force cursor to beginning of 1nd line
				WHEN 2 => lcd_bus <= "1000110111"; --7
				WHEN 3 => lcd_bus <= "1000110100"; --4
				WHEN 4 => lcd_bus <= "1000110001"; --1
				WHEN 5 => lcd_bus <= "1000110100"; --4
				WHEN 6 => lcd_bus <= "1000110111"; --7
				WHEN 7 => lcd_bus <= "1000100000"; --spacebar
				WHEN 8 => lcd_bus <= "1000100000"; --spacebar
				WHEN 9 => lcd_bus <= "1000100000"; --spacebar
				WHEN OTHERS => lcd_enable <= '0';
				END CASE;
				
			END CASE;
	
		WHEN 2=>
		------		displaying: "TEST RESULT: " on display		----------
			CASE char IS	 
			--writing the characters to be displayed on the LCD display
				WHEN 1 => lcd_bus <= "0010000110"; -- Force cursor to line 1, colmun 7
				WHEN 2 => lcd_bus <= "1001010100"; --T
				WHEN 3 => lcd_bus <= "1001000101"; --E
				WHEN 4 => lcd_bus <= "1001010011"; --S
				WHEN 5 => lcd_bus <= "1001010100"; --T
				
				WHEN 6 => lcd_bus <= "1000100000"; --spacebar
				WHEN 7 => lcd_bus <= "1000100000"; --spacebar
				WHEN 8 => lcd_bus <= "1000100000"; --spacebar
				 
				WHEN 9 => lcd_bus <= "0011000000"; -- Force cursor to beginning of 2nd line
				
				WHEN 10 => lcd_bus<= "1001010010"; --R 
				WHEN 11 => lcd_bus<= "1001000101"; --E
				WHEN 12 => lcd_bus<= "1001010011"; --S
				WHEN 13 => lcd_bus<= "1001010101"; --U
				WHEN 14 => lcd_bus<= "1001001100"; --L
				WHEN 15 => lcd_bus<= "1001010100"; --T
				WHEN 16 => lcd_bus<= "1000111010"; --:
				
				WHEN 17 => lcd_bus<= "1000100000"; --spacebar
				WHEN OTHERS => lcd_enable <= '0';
			END CASE;
	
		WHEN 3=>
		------		displaying: test result on display		----------
			CASE test_res IS
			WHEN '1'=> --test_res=1 --working
				voice_sel<=3;--component working voice record
				trig_voice<='0';--trigger the voice recorder
				CASE char IS
				--displaying: "WORKING" on display
				WHEN 1 => lcd_bus<= "0011001000"; -- Force cursor to line 2, colmun 9
				WHEN 2 => lcd_bus<= "1001010111"; --W
				WHEN 3 => lcd_bus<= "1001001111"; --O 
				WHEN 4 => lcd_bus<= "1001010010"; --R
				WHEN 5 => lcd_bus<= "1001001011"; --K 
				WHEN 6 => lcd_bus<= "1001001001"; --I
				WHEN 7 => lcd_bus<= "1001001110"; --N
				WHEN 8 => lcd_bus<= "1001010010"; --R
				WHEN 9 => lcd_bus<= "1001000111"; --G
				WHEN OTHERS => lcd_enable <= '0';
				END CASE;
				
			WHEN OTHERS => --test_res=0 --malfunction
				voice_sel<=4;--component malfunction voice record
				trig_voice<='0';--trigger the voice recorder
				CASE char IS
				--displaying: "MALFUNC " on display
				WHEN 1 => lcd_bus<= "0011001000"; -- Force cursor to line 2, colmun 9	
				WHEN 2 => lcd_bus<= "1001001101"; --M
				WHEN 3 => lcd_bus<= "1001000001"; --A 
				WHEN 4 => lcd_bus<= "1001001100"; --L
				WHEN 5 => lcd_bus<= "1001000110"; --F 
				WHEN 6 => lcd_bus<= "1001010101"; --U
				WHEN 7 => lcd_bus<= "1001001110"; --N
				WHEN 8 => lcd_bus<= "1001000011"; --C
				WHEN 9 => lcd_bus<= "1000100000"; --spacebar
				WHEN OTHERS => lcd_enable <= '0';
				END CASE;
				
			END CASE;
			
		END CASE;
		END IF;
		END IF;
		
--==============================state s11 indentifying screen==========================================================
	WHEN s11=>
		 -----delay for 1 sec-------
		IF(cnt<55350000) THEN 
			lcd_enable <= '0';
			cnt<=cnt+1;
			trig_voice<='1';
			flipped_detect_flag<=flipped_detect;
		ELSE
		
		trig_iden_out<='0';
		
				---------switching to s12 mode - component flipped screen-----------
		IF(flipped_detect_flag='0') THEN--component is flipped
--			char<=0;
--			cnt<=0;
			state<=s12;--component flipped screen
		ELSE--component is not flipped
		
						---------switching to s1 mode - choosing testing/indentifying screen-----------
		IF(key3='0' and char=9 and iden_chars_part=2) THEN
			char<=0;
			cnt<=0;
			iden_chars_part<=1;
			state<=s1;--choosing testing/indentifying screen
		END IF;	
		
		
				-----counting the characters to be displayed-------
		IF		(char<25 and iden_chars_part=1) THEN--start beginning
					char <= char + 1;
		ELSIF (char=25 and iden_chars_part=1)	THEN --done beginning
					iden_chars_part<=2; 
					char<=0;
		ELSIF	(char<10 and iden_chars_part=2) THEN--start ending
					char <= char + 1;
		ELSIF (char=10 and iden_chars_part=2)	THEN --done ending
					char<=0;
		END IF;
		
		
		
		CASE iden_chars_part IS

		WHEN 1=>
		------		displaying: identidying test result on display		----------
				CASE char IS
				--displaying: "IDENFITYING RESULT:" on display
				WHEN 1 => lcd_bus <= "0010000000"; -- Force cursor to beginning of 1nd line
				WHEN 2 => lcd_bus <= "1001001001"; --I
				WHEN 3 => lcd_bus <= "1001000100"; --D
				WHEN 4 => lcd_bus <= "1001000101"; --E
				WHEN 5 => lcd_bus <= "1001001110"; --N
				WHEN 6 => lcd_bus <= "1001010100"; --T
				WHEN 7 => lcd_bus <= "1001001001"; --I
				WHEN 8 => lcd_bus <= "1001000110"; --F
				WHEN 9 => lcd_bus <= "1001011001"; --Y
				WHEN 10 => lcd_bus <= "1001001001"; --I
				WHEN 11 => lcd_bus <= "1001001110"; --N
				WHEN 12 => lcd_bus <= "1001000111"; --G
				WHEN 13 => lcd_bus <= "1000100000"; --spacebar
				WHEN 14 => lcd_bus <= "1000100000"; --spacebar
				WHEN 15 => lcd_bus <= "1000100000"; --spacebar
				WHEN 16 => lcd_bus <= "1000100000"; --spacebar
				WHEN 17 => lcd_bus <= "1000100000"; --spacebar
				
				WHEN 18 => lcd_bus <= "0011000000"; -- Force cursor to beginning of 2nd line
				
				WHEN 19 => lcd_bus<= "1001010010"; --R 
				WHEN 20 => lcd_bus<= "1001000101"; --E
				WHEN 21 => lcd_bus<= "1001010011"; --S
				WHEN 22 => lcd_bus<= "1001010101"; --U
				WHEN 23 => lcd_bus<= "1001001100"; --L
				WHEN 24 => lcd_bus<= "1001010100"; --T
				WHEN 25 => lcd_bus<= "1000111010"; --:
				
--				WHEN 26 => lcd_bus<= "1000100000"; --spacebar
				WHEN OTHERS => lcd_enable <= '0';
				END CASE;
				
			WHEN 2=>
				IF(iden_res=0)THEN voice_sel<=6;	ELSE	voice_sel<=7;END IF;
				trig_voice<='0';--trigger the voice recorder

				CASE iden_res IS
				WHEN 0=>
					CASE char IS
					--displaying: "NONE" on display
					WHEN 1 => lcd_bus <= "0011000111"; -- Force cursor to line 2, colmun 8
					WHEN 2 => lcd_bus <= "1000100000"; --spacebar
					WHEN 3 => lcd_bus <= "1001001110"; --N
					WHEN 4 => lcd_bus <= "1001001111"; --O
					WHEN 5 => lcd_bus <= "1001001110"; --N
					WHEN 6 => lcd_bus <= "1001000101"; --E
					WHEN 7 => lcd_bus <= "1000100000"; --spacebar
					WHEN 8 => lcd_bus <= "1000100000"; --spacebar
					WHEN 9 => lcd_bus <= "1000100000"; --spacebar
					WHEN 10 =>lcd_bus <= "1000100000"; --spacebar
					WHEN OTHERS => lcd_enable <= '0';
					END CASE;
				
				WHEN 1=> --iden_res=1 --4001
					CASE char IS
					--displaying: "4001" on display
					WHEN 1 => lcd_bus <= "0011000111"; -- Force cursor to line 2, colmun 8
					WHEN 2 => lcd_bus <= "1000100000"; --spacebar
					WHEN 3 => lcd_bus <= "1000110100"; --4 
					WHEN 4 => lcd_bus <= "1000110000"; --0
					WHEN 5 => lcd_bus <= "1000110000"; --0
					WHEN 6 => lcd_bus <= "1000110001"; --1
					WHEN 7 => lcd_bus <= "1000100000"; --spacebar
					WHEN 8 => lcd_bus <= "1000100000"; --spacebar
					WHEN 9 => lcd_bus <= "1000100000"; --spacebar
					WHEN 10 => lcd_bus <= "1000100000"; --spacebar
					WHEN OTHERS => lcd_enable <= '0';
					END CASE;
					
				WHEN 2 => --iden_res=2 --4011
					CASE char IS
					--displaying: "4011 " on display
					WHEN 1 => lcd_bus <= "0011000111"; -- Force cursor to line 2, colmun 8
					WHEN 2 => lcd_bus <= "1000100000"; --spacebar					
					WHEN 3 => lcd_bus <= "1000110100"; --4 
					WHEN 4 => lcd_bus <= "1000110000"; --0
					WHEN 5 => lcd_bus <= "1000110001"; --1
					WHEN 6 => lcd_bus <= "1000110001"; --1
					WHEN 7 => lcd_bus <= "1000100000"; --spacebar
					WHEN 8 => lcd_bus <= "1000100000"; --spacebar
					WHEN 9 => lcd_bus <= "1000100000"; --spacebar
					WHEN 10 => lcd_bus <= "1000100000"; --spacebar
					WHEN OTHERS => lcd_enable <= '0';
					END CASE;
					
				WHEN 3=> --iden_res=3 --4069					
					CASE char IS
					--displaying: "7404/4069" on display
					WHEN 1 => lcd_bus <= "0011000111"; -- Force cursor to line 2, colmun 8
					WHEN 2 => lcd_bus <= "1000110111"; --7					
					WHEN 3 => lcd_bus <= "1000110100"; --4
					WHEN 4 => lcd_bus <= "1000110000"; --0
					WHEN 5 => lcd_bus <= "1000110100"; --4
					WHEN 6 => lcd_bus <= "1000101111"; --/
					WHEN 7 => lcd_bus <= "1000110100"; --4
					WHEN 8 => lcd_bus <= "1000110000"; --0
					WHEN 9 => lcd_bus <= "1000110110"; --6
					WHEN 10 => lcd_bus<= "1000111001"; --9
					WHEN OTHERS => lcd_enable <= '0';
					END CASE;
					
				WHEN 4 => --iden_res=4 --4071
					CASE char IS
					--displaying: "4071" on display
					WHEN 1 => lcd_bus <= "0011000111"; -- Force cursor to line 2, colmun 8
					WHEN 2 => lcd_bus <= "1000100000"; --spacebar					
					WHEN 3 => lcd_bus <= "1000110100"; --4 
					WHEN 4 => lcd_bus <= "1000110000"; --0
					WHEN 5 => lcd_bus <= "1000110111"; --7
					WHEN 6 => lcd_bus <= "1000110001"; --1
					WHEN 7 => lcd_bus <= "1000100000"; --spacebar
					WHEN 8 => lcd_bus <= "1000100000"; --spacebar
					WHEN 9 => lcd_bus <= "1000100000"; --spacebar
					WHEN 10 => lcd_bus <= "1000100000"; --spacebar
					WHEN OTHERS => lcd_enable <= '0';
					END CASE;
					
				WHEN 5=> --iden_res=5 --4081
					CASE char IS
					--displaying: "4081" on display
					WHEN 1 => lcd_bus <= "0011000111"; -- Force cursor to line 2, colmun 8
					WHEN 2 => lcd_bus <= "1000100000"; --spacebar					
					WHEN 3 => lcd_bus <= "1000110100"; --4 
					WHEN 4 => lcd_bus <= "1000110000"; --0
					WHEN 5 => lcd_bus <= "1000111000"; --8
					WHEN 6 => lcd_bus <= "1000110001"; --1
					WHEN 7 => lcd_bus <= "1000100000"; --spacebar
					WHEN 8 => lcd_bus <= "1000100000"; --spacebar
					WHEN 9 => lcd_bus <= "1000100000"; --spacebar
					WHEN 10 => lcd_bus <= "1000100000"; --spacebar
					WHEN OTHERS => lcd_enable <= '0';
					END CASE;
					
				WHEN 6 => --iden_res=6 --4008
					CASE char IS
					--displaying: "4008" on display
					WHEN 1 => lcd_bus <= "0011000111"; -- Force cursor to line 2, colmun 8
					WHEN 2 => lcd_bus <= "1000100000"; --spacebar					
					WHEN 3 => lcd_bus <= "1000110100"; --4 
					WHEN 4 => lcd_bus <= "1000110000"; --0
					WHEN 5 => lcd_bus <= "1000110000"; --0
					WHEN 6 => lcd_bus <= "1000111000"; --8
					WHEN 7 => lcd_bus <= "1000100000"; --spacebar
					WHEN 8 => lcd_bus <= "1000100000"; --spacebar
					WHEN 9 => lcd_bus <= "1000100000"; --spacebar
					WHEN 10 => lcd_bus <= "1000100000"; --spacebar
					WHEN OTHERS => lcd_enable <= '0';
					END CASE;	
					
				WHEN 7 => --iden_res=7 --7400
					CASE char IS
					--displaying: "7400 " on display
					WHEN 1 => lcd_bus <= "0011000111"; -- Force cursor to line 2, colmun 8
					WHEN 2 => lcd_bus <= "1000100000"; --spacebar					
					WHEN 3 => lcd_bus <= "1000110111"; --7
					WHEN 4 => lcd_bus <= "1000110100"; --4
					WHEN 5 => lcd_bus <= "1000110000"; --0 
					WHEN 6 => lcd_bus <= "1000110000"; --0
					WHEN 7 => lcd_bus <= "1000100000"; --spacebar
					WHEN 8 => lcd_bus <= "1000100000"; --spacebar
					WHEN 9 => lcd_bus <= "1000100000"; --spacebar
					WHEN 10 => lcd_bus <= "1000100000"; --spacebar
					WHEN OTHERS => lcd_enable <= '0';
					END CASE;
					
				WHEN 8 => --iden_res=8 --7421
					CASE char IS
					--displaying: "7421 " on display
					WHEN 1 => lcd_bus <= "0011000111"; -- Force cursor to line 2, colmun 8
					WHEN 2 => lcd_bus <= "1000100000"; --spacebar					
					WHEN 3 => lcd_bus <= "1000110111"; --7
					WHEN 4 => lcd_bus <= "1000110100"; --4
					WHEN 5 => lcd_bus <= "1000110010"; --2 
					WHEN 6 => lcd_bus <= "1000110001"; --1
					WHEN 7 => lcd_bus <= "1000100000"; --spacebar
					WHEN 8 => lcd_bus <= "1000100000"; --spacebar
					WHEN 9 => lcd_bus <= "1000100000"; --spacebar
					WHEN 10 => lcd_bus <= "1000100000"; --spacebar
					WHEN OTHERS => lcd_enable <= '0';
					END CASE;
					
				WHEN 9 => --iden_res=9 --7408 
					CASE char IS
					--displaying: "7408 " on display
					WHEN 1 => lcd_bus <= "0011000111"; -- Force cursor to line 2, colmun 8
					WHEN 2 => lcd_bus <= "1000100000"; --spacebar					
					WHEN 3 => lcd_bus <= "1000110111"; --7
					WHEN 4 => lcd_bus <= "1000110100"; --4
					WHEN 5 => lcd_bus <= "1000110000"; --0 
					WHEN 6 => lcd_bus <= "1000111000"; --8
					WHEN 7 => lcd_bus <= "1000100000"; --spacebar
					WHEN 8 => lcd_bus <= "1000100000"; --spacebar
					WHEN 9 => lcd_bus <= "1000100000"; --spacebar
					WHEN 10 => lcd_bus <= "1000100000"; --spacebar
					WHEN OTHERS => lcd_enable <= '0';
					END CASE;
					
				WHEN 10 => --iden_res=10 --7402
					CASE char IS
					--displaying: "7402 " on display
					WHEN 1 => lcd_bus <= "0011000111"; -- Force cursor to line 2, colmun 8
					WHEN 2 => lcd_bus <= "1000100000"; --spacebar					
					WHEN 3 => lcd_bus <= "1000110111"; --7
					WHEN 4 => lcd_bus <= "1000110100"; --4
					WHEN 5 => lcd_bus <= "1000110000"; --0 
					WHEN 6 => lcd_bus <= "1000110010"; --2 
					WHEN 7 => lcd_bus <= "1000100000"; --spacebar
					WHEN 8 => lcd_bus <= "1000100000"; --spacebar
					WHEN 9 => lcd_bus <= "1000100000"; --spacebar
					WHEN 10 => lcd_bus <= "1000100000"; --spacebar
					WHEN OTHERS => lcd_enable <= '0';
					END CASE;
				
				WHEN 11 => --iden_res=11 --7404 
					CASE char IS
					--displaying: "7404/4069" on display
					WHEN 1 => lcd_bus <= "0011000111"; -- Force cursor to line 2, colmun 8
					WHEN 2 => lcd_bus <= "1000110111"; --7					
					WHEN 3 => lcd_bus <= "1000110100"; --4
					WHEN 4 => lcd_bus <= "1000110000"; --0
					WHEN 5 => lcd_bus <= "1000110100"; --4
					WHEN 6 => lcd_bus <= "1000101111"; --/
					WHEN 7 => lcd_bus <= "1000110100"; --4
					WHEN 8 => lcd_bus <= "1000110000"; --0
					WHEN 9 => lcd_bus <= "1000110110"; --6
					WHEN 10 => lcd_bus<= "1000111001"; --9
					WHEN OTHERS => lcd_enable <= '0';
					END CASE;
					
				WHEN 12 => --iden_res=12 --74157
					CASE char IS
					--displaying: "74157 " on display
					WHEN 1 => lcd_bus <= "0011000111"; -- Force cursor to line 2, colmun 8
					WHEN 2 => lcd_bus <= "1000100000"; --spacebar					
					WHEN 3 => lcd_bus <= "1000110111"; --7
					WHEN 4 => lcd_bus <= "1000110100"; --4
					WHEN 5 => lcd_bus <= "1000110001"; --1
					WHEN 6 => lcd_bus <= "1000110101"; --5
					WHEN 7 => lcd_bus <= "1000110111"; --7
					WHEN 8 => lcd_bus <= "1000100000"; --spacebar
					WHEN 9 => lcd_bus <= "1000100000"; --spacebar
					WHEN 10 => lcd_bus <= "1000100000"; --spacebar
					WHEN OTHERS => lcd_enable <= '0';
					END CASE;
					
				WHEN 13 => --iden_res=13 --74240
					CASE char IS
					--displaying: "74240 " on display
					WHEN 1 => lcd_bus <= "0011000111"; -- Force cursor to line 2, colmun 8
					WHEN 2 => lcd_bus <= "1000100000"; --spacebar					
					WHEN 3 => lcd_bus <= "1000110111"; --7
					WHEN 4 => lcd_bus <= "1000110100"; --4
					WHEN 5 => lcd_bus <= "1000110010"; --2 
					WHEN 6 => lcd_bus <= "1000110100"; --4
					WHEN 7 => lcd_bus <= "1000110000"; --0
					WHEN 8 => lcd_bus <= "1000100000"; --spacebar
					WHEN 9 => lcd_bus <= "1000100000"; --spacebar
					WHEN 10 => lcd_bus <= "1000100000"; --spacebar
					WHEN OTHERS => lcd_enable <= '0';
					END CASE;
					
				WHEN 14 => --iden_res=14 --74147
					CASE char IS
					--displaying: "74147 " on display
					WHEN 1 => lcd_bus <= "0011000111"; -- Force cursor to line 2, colmun 8
					WHEN 2 => lcd_bus <= "1000100000"; --spacebar					
					WHEN 3 => lcd_bus <= "1000110111"; --7
					WHEN 4 => lcd_bus <= "1000110100"; --4
					WHEN 5 => lcd_bus <= "1000110001"; --1
					WHEN 6 => lcd_bus <= "1000110100"; --4
					WHEN 7 => lcd_bus <= "1000110111"; --7
					WHEN 8 => lcd_bus <= "1000100000"; --spacebar
					WHEN 9 => lcd_bus <= "1000100000"; --spacebar
					WHEN 10 => lcd_bus <= "1000100000"; --spacebar
					WHEN OTHERS => lcd_enable <= '0';
					END CASE;
					
				END CASE;
				
		END CASE;
		END IF;
		END IF;
		
--==============================state s12 componenet flipped screen==========================================================
	WHEN s12=>
	 -----delay for 1 sec-------
		IF(cnt<55350000) THEN 
			lcd_enable <= '0';
			cnt<=cnt+1;
			trig_voice<='1';
		ELSE
		voice_sel<=5;--component is flipped voice record
		trig_voice<='0';--trigger the voice recorder
		
				---------switching to s1 mode - choosing testing/indentifying screen-----------
		IF(key3='0' and char=Num_Chars) THEN
			char<=0;
			cnt<=0;
			state<=s1;--choosing testing/indentifying screen
		END IF;	
		
		-----counting the characters to be displayed-------
		IF		(char<Num_Chars) THEN --start welcome screen
			char <= char + 1;
		ELSIF (char=Num_Chars)	THEN --done welcome screen
			char<=0;
		END IF;
			
			------		displaying: "COMPONENT IS FLIPPED" on display		---------
			CASE char IS	 
			--writing the characters to be displayed on the LCD display
				WHEN 1 => lcd_bus <= "0010000000"; -- Force cursor to beginning of 1nd line
				WHEN 2 => lcd_bus <= "1001000011"; --C
				WHEN 3 => lcd_bus <= "1001001111"; --O
				WHEN 4 => lcd_bus <= "1001001101"; --M
				WHEN 5 => lcd_bus <= "1001010000"; --P
				WHEN 6 => lcd_bus <= "1001001111"; --O  
				WHEN 7 => lcd_bus <= "1001001110"; --N
				WHEN 8 => lcd_bus <= "1001000101"; --E
				WHEN 9 => lcd_bus <= "1001001110"; --N 
				WHEN 10 => lcd_bus <= "1001010100"; --T
				
				WHEN 11 => lcd_bus <= "1000100000"; --spacebar 
				
				WHEN 12 => lcd_bus<= "1001001001"; --I
				WHEN 13 => lcd_bus<= "1001010011"; --S
				
				WHEN 14 => lcd_bus<= "1000100000"; --spacebar 
				WHEN 15 => lcd_bus<= "1000100000"; --spacebar	
				WHEN 16 => lcd_bus<= "1000100000"; --spacebar
				WHEN 17 => lcd_bus<= "1000100000"; --spacebar 
				 
				WHEN 18 => lcd_bus<= "0011000000"; -- Force cursor to beginning of 2nd line
				
				WHEN 19 => lcd_bus<= "1001000110"; --F 
				WHEN 20 => lcd_bus<= "1001001100"; --L
				WHEN 21 => lcd_bus<= "1001001001"; --I
				WHEN 22 => lcd_bus<= "1001010000"; --P
				WHEN 23 => lcd_bus<= "1001010000"; --P
				WHEN 24 => lcd_bus<= "1001000101"; --E
				WHEN 25 => lcd_bus<= "1001000100"; --D
				WHEN 26 => lcd_bus<= "1000100001"; --!
				
				WHEN 27 => lcd_bus<= "1000100000"; --spacebar
				WHEN 28 => lcd_bus<= "1000100000"; --spacebar
				WHEN 29 => lcd_bus<= "1000100000"; --spacebar
				WHEN 30 => lcd_bus<= "1000100000"; --spacebar
				WHEN 31 => lcd_bus<= "1000100000"; --spacebar
				WHEN 32 => lcd_bus<= "1000100000"; --spacebar
				WHEN 33 => lcd_bus<= "1000100000"; --spacebar
				WHEN 34 => lcd_bus<= "1000100000"; --spacebar
				
				WHEN OTHERS => lcd_enable <= '0';
			END CASE;
		END IF;

		
		
	END CASE;	
	
		ELSE
			lcd_enable <= '0';
		END IF;
	END IF;
END PROCESS main_process;

	tested_chip<=tested_chip_num;
		
	reset_n <= '1';
	lcd_clk <= clk;
END behavior;