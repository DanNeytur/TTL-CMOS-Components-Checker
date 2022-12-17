---------------------------------------------------------------
--pin mapping for 14 pins chip:
--out_sel(0)-pin 1
--out_sel(1)-pin 2
--out_sel(2)-pin 3
--out_sel(3)-pin 4
--out_sel(4)-pin 5
--out_sel(5)-pin 6
--out_sel(6)-gnd-pin 7
--out_sel(12)-pin 8
--out_sel(13)-pin 9
--out_sel(14)-pin 10
--out_sel(15)-pin 11
--out_sel(16)-pin 12
--out_sel(17)-pin 13
--vcc_sel-pin 14

--out_sel(7)-NC
--out_sel(8)-NC
--out_sel(9)-NC
--out_sel(10)-NC
--out_sel(11)-NC


--gnd_sel(2)<='1';--pin 7 gnd
--gnd_sel(1)<='0';--NC
--gnd_sel(0)<='0';--NC
--gnd_sel(3)<='0'--NC
-------------------------------------------------------------
--pin mapping for 16 pins chip:
--out_sel(0)-pin 1
--out_sel(1)-pin 2
--out_sel(2)-pin 3
--out_sel(3)-pin 4
--out_sel(4)-pin 5
--out_sel(5)-pin 6
--out_sel(6)-pin 7
--out_sel(7)-gnd-pin 8
--out_sel(11)-pin 9
--out_sel(12)-pin 10
--out_sel(13)-pin 11
--out_sel(14)-pin 12
--out_sel(15)-pin 13
--out_sel(16)-pin 14
--out_sel(17)-pin 15
--vcc-pin 16

--out_sel(8)-NC
--out_sel(9)-NC
--out_sel(10)-NC

--gnd_sel(2)<='0';--pin 7 
--gnd_sel(1)<='1';--pin 8 gnd
--gnd_sel(0)<='0';--NC
--gnd_sel(3)<='0'--NC
-----------------------------------------------------------
--pin mapping for 20 pins chip:
--out_sel(0)-pin 1
--out_sel(1)-pin 2
--out_sel(2)-pin 3
--out_sel(3)-pin 4
--out_sel(4)-pin 5
--out_sel(5)-pin 6
--out_sel(6)-pin 7
--out_sel(7)-pin 8
--out_sel(8)-pin 9
--out_sel(9)-pin 11
--out_sel(10)-pin 12
--out_sel(11)-pin 13
--out_sel(12)-pin 14
--out_sel(13)-pin 15
--out_sel(14)-pin 16
--out_sel(15)-pin 17
--out_sel(16)-pin 18
--out_sel(17)-pin 19
--vcc-pin 20



--gnd_sel(2)<='0';--pin 7 
--gnd_sel(1)<='0';--pin 8 
--gnd_sel(0)<='0';--pin 9
--gnd_sel(3)<='1'--pin 10-gnd
-----------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY chip_sel IS
PORT(
	trig_iden		:	IN STD_LOGIC;--trigger identifying function
	trig_test		:	IN STd_LOGIC;--trigger testing function
	tested_chip_num:	IN INTEGER RANGE 0 TO 14;
	clk 				:	IN STD_LOGIC;--system clock clk=50MHZ
	flipped_detect	:	IN STD_LOGIC;--detecting if the component is flipped. '1'-not flipped '0' flipped 
	res_iden_out	:	OUT INTEGER RANGE 0 TO 14;
	res_test_out	:	OUT STD_LOGIC;--LEDR1
	out_sel 			:	INOUT STD_LOGIC_VECTOR(17 DOWNTO 0); --JP2 expansion header GPIO 1	
	gnd_sel 			:	INOUT STD_LOGIC_VECTOR(3 DOWNTO 0); --insert gnd (0v) at lower left pin accordingly to number of IC's legs	
	vcc_sel 			:	OUT STD_LOGIC); --insert vcc (5v) at upper right pin. '1'-active '0'-not active 	
END chip_sel;

ARCHITECTURE behavior OF chip_sel IS
SIGNAL chip_num			:	INTEGER RANGE 0 TO 14;--get the number of tested chip
SIGNAL chip_num_iden		:	INTEGER RANGE 0 TO 14:=1;--get the number of tested chip for identifying
SIGNAL test_res_flag 	:	STD_LOGIC;--indicates the result '1'-working '0'-malfunctiong
SIGNAL start_iden 		:	STD_LOGIC:='0';--'0'-not identifying '1'-identifying
SIGNAL cnt_iden			:	INTEGER RANGE 0 TO 2000:=0;--count clk

SIGNAL EN					:	STD_LOGIC_VECTOR(17 DOWNTO 0):="000000000000000000";--enables of tri state duffers
SIGNAL data_in, data_out:	STD_LOGIC_VECTOR(17 DOWNTO 0);--registers for reading and writing to the bi directional port

TYPE state_type IS(s0,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14,s15);
SIGNAL state:state_type;

--SIGNAL flipped: STD_LOGIC;--indicating if component is not flipped. '1'-flipped, '0'- not flipped

BEGIN

out_sel(0)<=data_out(0) WHEN EN(0)='1' ELSE 'Z';	 --in order to write EN must be high
data_in(0)<=out_sel(0);										 --always read the output/input

out_sel(1)<=data_out(1) WHEN EN(1)='1' ELSE 'Z';	 --in order to write EN must be high
data_in(1)<=out_sel(1);										 --always read the output/input

out_sel(2)<=data_out(2) WHEN EN(2)='1' ELSE 'Z';	 --in order to write EN must be high
data_in(2)<=out_sel(2);										 --always read the output/input

out_sel(3)<=data_out(3) WHEN EN(3)='1' ELSE 'Z';	 --in order to write EN must be high
data_in(3)<=out_sel(3);										 --always read the output/input

out_sel(4)<=data_out(4) WHEN EN(4)='1' ELSE 'Z';	 --in order to write EN must be high
data_in(4)<=out_sel(4);										 --always read the output/input

out_sel(5)<=data_out(5) WHEN EN(5)='1' ELSE 'Z';	 --in order to write EN must be high
data_in(5)<=out_sel(5);									 	 --always read the output/input

out_sel(6)<=data_out(6) WHEN EN(6)='1' ELSE 'Z';	 --in order to write EN must be high
data_in(6)<=out_sel(6);										 --always read the output/input

out_sel(7)<=data_out(7) WHEN EN(7)='1' ELSE 'Z';	 --in order to write EN must be high
data_in(7)<=out_sel(7);									 	 --always read the output/input

out_sel(8)<=data_out(8) WHEN EN(8)='1' ELSE 'Z'; 	 --in order to write EN must be high
data_in(8)<=out_sel(8);									 	 --always read the output/input

out_sel(9)<=data_out(9) WHEN EN(9)='1' ELSE 'Z';	 --in order to write EN must be high
data_in(9)<=out_sel(9);									 	 --always read the output/input

out_sel(10)<=data_out(10) WHEN EN(10)='1' ELSE 'Z'; --in order to write EN must be high
data_in(10)<=out_sel(10);									 --always read the output/input

out_sel(11)<=data_out(11) WHEN EN(11)='1' ELSE 'Z'; --in order to write EN must be high
data_in(11)<=out_sel(11);									 --always read the output/input

out_sel(12)<=data_out(12) WHEN EN(12)='1' ELSE 'Z'; --in order to write EN must be high
data_in(12)<=out_sel(12);									 --always read the output/input

out_sel(13)<=data_out(13) WHEN EN(13)='1' ELSE 'Z'; --in order to write EN must be high
data_in(13)<=out_sel(13);									 --always read the output/input

out_sel(14)<=data_out(14) WHEN EN(14)='1' ELSE 'Z'; --in order to write EN must be high
data_in(14)<=out_sel(14);									 --always read the output/input

out_sel(15)<=data_out(15) WHEN EN(15)='1' ELSE 'Z'; --in order to write EN must be high
data_in(15)<=out_sel(15);									 --always read the output/input

out_sel(16)<=data_out(16) WHEN EN(16)='1' ELSE 'Z'; --in order to write EN must be high
data_in(16)<=out_sel(16);									 --always read the output/input

out_sel(17)<=data_out(17) WHEN EN(17)='1' ELSE 'Z'; --in order to write EN must be high
data_in(17)<=out_sel(17);									 --always read the output/input


PROCESS(clk, tested_chip_num)
BEGIN

IF(clk'EVENT AND clk = '1') THEN

	
	IF(flipped_detect='1')THEN--component not flipped
		vcc_sel<='1';
	ELSE--IF(flipped_detect='0')--component flipped
		vcc_sel<='0';
	END IF;
	
	IF(trig_test='0' AND trig_iden='0') THEN
		state<=s0;
		EN<="000000000000000000";--unables all buffers
		gnd_sel<="0000";--unables all gnd on pins 7,8,9,10 on the ZIF socket
--		vcc_sel<='1';--unable vcc
		
		start_iden<='0';
		cnt_iden<=0;		
		
	ELSE

			--testing mode
			IF(trig_test='1' AND trig_iden='0')THEN
				chip_num<=tested_chip_num;
				res_test_out<=test_res_flag;
				
			--identifying mode
			ELSIF(trig_test='0' AND trig_iden='1')THEN
				IF(start_iden='0')THEN
					chip_num<=1;
					start_iden<='1';
				END IF;
				
				IF(cnt_iden<200) THEN --wait 200 clks
					cnt_iden<=cnt_iden+1;
				ELSIF(cnt_iden=200) THEN
					IF(test_res_flag='1')THEN--found a chip
						res_iden_out<=chip_num;	
						res_test_out<='1';
					ELSIF(test_res_flag='0')THEN--didn't dound a component				
						cnt_iden<=0;
						chip_num<=chip_num+1;
						state<=s0;
						res_test_out<='0';
						IF(chip_num=13)THEN--no component matching
							res_iden_out<=0;
							res_test_out<='0';
						END IF;
					END IF;
				END IF;
				
			END IF;

		----------------- testing 4001 -------------------
			IF(chip_num=1) THEN --4001 -quad 2 input NOR-14 dip
			
				EN(0)<='1';--enable buffer --pin 1 A1
				EN(1)<='1';--enable buffer --pin 2 B1
				EN(4)<='1';--enable buffer --pin 5 A2
				EN(5)<='1';--enable buffer --pin 6 B2
				EN(17)<='1';--enable buffer --pin 13 A3
				EN(16)<='1';--enable buffer --pin 12 B3
				EN(13)<='1';--enable buffer --pin 9 A4
				EN(12)<='1';--enable buffer --pin 8 B4
				
				EN(2)<='0';--unable buffer --pin 3 Y1
				EN(3)<='0';--unable buffer	 --pin 4 Y2
				EN(15)<='0';--unable buffer --pin 11 Y3
				EN(14)<='0';--unable buffer --pin 10 Y4		
								
				gnd_sel(2)<='1';--pin 7 gnd
--				vcc_sel<='1';--pin 14 vcc
								
				CASE state IS--truth table of 4001
					WHEN s0=> --A:='0'; B:='0';
						----NOR GATE 1:
						data_out(0)<='0';--pin 1 A1
						data_out(1)<='0';--pin 2 B1
						--data_in(2)--pin 3 Y1

						----NOR GATE 2:
						data_out(4)<='0';--pin 5 A2
						data_out(5)<='0';--pin 6 B2
						--data_in(3)--pin 4 Y2

						----NOR GATE 3:
						data_out(17)<='0';--pin 13 A3
						data_out(16)<='0';--pin 12 B3
						--data_in(15)--pin 11 Y3

						----NOR GATE 4:
						data_out(13)<='0';--pin 9 A4
						data_out(12)<='0';--pin 8 B4
						--data_in(14)--pin 10 Y4
						
						IF (data_in(2)='1')and (data_in(3)='1')and (data_in(15)='1') and (data_in(14)='1') THEN
						state<=s1; ELSE test_res_flag<='0'; END IF;	
						
					WHEN s1=> --A:='0'; B:='1';
						----NOR GATE 1:
						data_out(0)<='0';--pin 1 A1
						data_out(1)<='1';--pin 2 B1
						--data_in(2)--pin 3 Y1

						----NOR GATE 2:
						data_out(4)<='0';--pin 5 A2
						data_out(5)<='1';--pin 6 B2
						--data_in(3)--pin 4 Y2

						----NOR GATE 3:
						data_out(17)<='0';--pin 13 A3
						data_out(16)<='1';--pin 12 B3
						--data_in(15)--pin 11 Y3

						----NOR GATE 4:
						data_out(13)<='0';--pin 9 A4
						data_out(12)<='1';--pin 8 B4
						--data_in(14)--pin 10 Y4
						
						IF (data_in(2)='0')and (data_in(3)='0')and (data_in(15)='0') and (data_in(14)='0') THEN
						state<=s2; ELSE test_res_flag<='0'; END IF;
						
					WHEN s2=> --A:='1'; B:='0';
						----NOR GATE 1:
						data_out(0)<='1';--pin 1 A1
						data_out(1)<='0';--pin 2 B1
						--data_in(2)--pin 3 Y1

						----NOR GATE 2:
						data_out(4)<='1';--pin 5 A2
						data_out(5)<='0';--pin 6 B2
						--data_in(3)--pin 4 Y2

						----NOR GATE 3:
						data_out(17)<='1';--pin 13 A3
						data_out(16)<='0';--pin 12 B3
						--data_in(15)--pin 11 Y3

						----NOR GATE 4:
						data_out(13)<='1';--pin 9 A4
						data_out(12)<='0';--pin 8 B4
						--data_in(14)--pin 10 Y4
						
						IF (data_in(2)='0')and (data_in(3)='0')and (data_in(15)='0') and (data_in(14)='0') THEN
						state<=s3; ELSE test_res_flag<='0'; END IF;		

					WHEN OTHERS=> --A:='1'; B:='1';
						----NOR GATE 1:
						data_out(0)<='1';--pin 1 A1
						data_out(1)<='1';--pin 2 B1
						--data_in(2)--pin 3 Y1

						----NOR GATE 2:
						data_out(4)<='1';--pin 5 A2
						data_out(5)<='1';--pin 6 B2
						--data_in(3)--pin 4 Y2

						----NOR GATE 3:
						data_out(17)<='1';--pin 13 A3
						data_out(16)<='1';--pin 12 B3
						--data_in(15)--pin 11 Y3

						----NOR GATE 4:
						data_out(13)<='1';--pin 9 A4
						data_out(12)<='1';--pin 8 B4
						--data_in(14)--pin 10 Y4
						
						IF (data_in(2)='0')and (data_in(3)='0')and (data_in(15)='0') and (data_in(14)='0') THEN
						test_res_flag<='1'; ELSE test_res_flag<='0'; END IF;
						
				END CASE;
				
	----------------- testing 4011 -------------------
			ELSIF(chip_num=2) THEN --4011 -quad 2 input NAND-14 dip
			
				EN(0)<='1';--enable buffer --pin 1 A1
				EN(1)<='1';--enable buffer --pin 2 B1
				EN(4)<='1';--enable buffer --pin 5 A2
				EN(5)<='1';--enable buffer --pin 6 B2
				EN(17)<='1';--enable buffer --pin 13 A3
				EN(16)<='1';--enable buffer --pin 12 B3
				EN(13)<='1';--enable buffer --pin 9 A4
				EN(12)<='1';--enable buffer --pin 8 B4
				
				EN(2)<='0';--unable buffer --pin 3 Y1
				EN(3)<='0';--unable buffer	 --pin 4 Y2
				EN(15)<='0';--unable buffer --pin 11 Y3
				EN(14)<='0';--unable buffer --pin 10 Y4		
								
				gnd_sel(2)<='1';--pin 7 gnd
--				vcc_sel<='1';--pin 14 vcc				

				CASE state IS--truth table of 4011
					WHEN s0=> --A:='0'; B:='0';
						----NAND GATE 1:
						data_out(0)<='0';--pin 1 A1
						data_out(1)<='0';--pin 2 B1
						--data_in(2)--pin 3 Y1

						----NAND GATE 2:
						data_out(4)<='0';--pin 5 A2
						data_out(5)<='0';--pin 6 B2
						--data_in(3)--pin 4 Y2

						----NAND GATE 3:
						data_out(17)<='0';--pin 13 A3
						data_out(16)<='0';--pin 12 B3
						--data_in(15)--pin 11 Y3

						----NAND GATE 4:
						data_out(13)<='0';--pin 9 A4
						data_out(12)<='0';--pin 8 B4
						--data_in(14)--pin 10 Y4
						
						IF (data_in(2)='1')and (data_in(3)='1')and (data_in(15)='1') and (data_in(14)='1') THEN
						state<=s1; ELSE test_res_flag<='0'; END IF;

					WHEN s1=> --A:='0'; B:='1';
						----NAND GATE 1:
						data_out(0)<='0';--pin 1 A1
						data_out(1)<='1';--pin 2 B1
						--data_in(2)--pin 3 Y1

						----NAND GATE 2:
						data_out(4)<='0';--pin 5 A2
						data_out(5)<='1';--pin 6 B2
						--data_in(3)--pin 4 Y2

						----NAND GATE 3:
						data_out(17)<='0';--pin 13 A3
						data_out(16)<='1';--pin 12 B3
						--data_in(15)--pin 11 Y3

						----NAND GATE 4:
						data_out(13)<='0';--pin 9 A4
						data_out(12)<='1';--pin 8 B4
						--data_in(14)--pin 10 Y4
						
						IF (data_in(2)='1')and (data_in(3)='1')and (data_in(15)='1') and (data_in(14)='1') THEN
						state<=s2; ELSE test_res_flag<='0'; END IF;	
						
					WHEN s2=> --A:='1'; B:='0';
						----NAND GATE 1:
						data_out(0)<='1';--pin 1 A1
						data_out(1)<='0';--pin 2 B1
						--data_in(2)--pin 3 Y1

						----NAND GATE 2:
						data_out(4)<='1';--pin 5 A2
						data_out(5)<='0';--pin 6 B2
						--data_in(3)--pin 4 Y2

						----NAND GATE 3:
						data_out(17)<='1';--pin 13 A3
						data_out(16)<='0';--pin 12 B3
						--data_in(15)--pin 11 Y3

						----NAND GATE 4:
						data_out(13)<='1';--pin 9 A4
						data_out(12)<='0';--pin 8 B4
						--data_in(14)--pin 10 Y4
						
						IF (data_in(2)='1')and (data_in(3)='1')and (data_in(15)='1') and (data_in(14)='1') THEN
						state<=s3; ELSE test_res_flag<='0'; END IF;
						
					WHEN OTHERS=> --A:='1'; B:='1';
						----NAND GATE 1:
						data_out(0)<='1';--pin 1 A1
						data_out(1)<='1';--pin 2 B1
						--data_in(2)--pin 3 Y1

						----NAND GATE 2:
						data_out(4)<='1';--pin 5 A2
						data_out(5)<='1';--pin 6 B2
						--data_in(3)--pin 4 Y2

						----NAND GATE 3:
						data_out(17)<='1';--pin 13 A3
						data_out(16)<='1';--pin 12 B3
						--data_in(15)--pin 11 Y3

						----NAND GATE 4:
						data_out(13)<='1';--pin 9 A4
						data_out(12)<='1';--pin 8 B4
						--data_in(14)--pin 10 Y4
						
						IF (data_in(2)='0')and (data_in(3)='0')and (data_in(15)='0') and (data_in(14)='0') THEN
						test_res_flag<='1'; ELSE test_res_flag<='0';	END IF;
							
				END CASE;
				
	----------------- testing 4069 -------------------
			ELSIF(chip_num=3) THEN --4069 -hex NOT-14 dip
			
				EN(0)<='1';--enable buffer --pin 1 A1
				EN(2)<='1';--enable buffer --pin 3 A2
				EN(4)<='1';--enable buffer --pin 5 A3
				EN(17)<='1';--enable buffer --pin 13 A4
				EN(15)<='1';--enable buffer --pin 11 A5
				EN(13)<='1';--enable buffer --pin 9 A6
				
				EN(1)<='0';--unable buffer --pin 2 Y1
				EN(3)<='0';--unable buffer	 --pin 4 Y2
				EN(5)<='0';--unable buffer --pin 6 Y3 
				EN(16)<='0';--unable buffer --pin 12 Y4
				EN(14)<='0';--unable buffer --pin 10 Y5
				EN(12)<='0';--unable buffer --pin 8 Y6	
								
				gnd_sel(2)<='1';--pin 7 gnd				
--				vcc_sel<='1';--pin 14 vcc

				CASE state IS--truth table of 4069
					WHEN s0=> --A:='0'
						data_out(0)<='0';--pin 1 A1
						data_out(2)<='0';--pin 3 A2
						data_out(4)<='0';--pin 5 A3
						data_out(17)<='0';--pin 13 A4
						data_out(15)<='0';--pin 11 A5
						data_out(13)<='0';--pin 9 A6
						
						IF (data_in(1)='1')and (data_in(3)='1') and (data_in(5)='1') 
						and (data_in(16)='1') and (data_in(14)='1') and (data_in(12)='1') THEN
						state<=s1; ELSE test_res_flag<='0'; END IF;			

					WHEN OTHERS=> --A:='1'
						data_out(0)<='1';--pin 1 A1
						data_out(2)<='1';--pin 3 A2
						data_out(4)<='1';--pin 5 A3
						data_out(17)<='1';--pin 13 A4
						data_out(15)<='1';--pin 11 A5
						data_out(13)<='1';--pin 9 A6
					
						IF (data_in(1)='0')and (data_in(3)='0') and (data_in(5)='0') 
						and (data_in(16)='0') and (data_in(14)='0') and (data_in(12)='0') THEN
						test_res_flag<='1'; ELSE test_res_flag<='0'; END IF;
							
				END CASE;
				
		----------------- testing 4071 -------------------
			ELSIF(chip_num=4) THEN --4071 -quad 2 input OR-14 dip
			
				EN(0)<='1';--enable buffer --pin 1 A1
				EN(1)<='1';--enable buffer --pin 2 B1
				EN(4)<='1';--enable buffer --pin 5 A2
				EN(5)<='1';--enable buffer --pin 6 B2
				EN(17)<='1';--enable buffer --pin 13 A3
				EN(16)<='1';--enable buffer --pin 12 B3
				EN(13)<='1';--enable buffer --pin 9 A4
				EN(12)<='1';--enable buffer --pin 8 B4
				
				EN(2)<='0';--unable buffer --pin 3 Y1
				EN(3)<='0';--unable buffer	 --pin 4 Y2
				EN(15)<='0';--unable buffer --pin 11 Y3
				EN(14)<='0';--unable buffer --pin 10 Y4		
				
				gnd_sel(2)<='1';--pin 7 gnd
--				vcc_sel<='1';--pin 14 vcc
									
				CASE state IS--truth table of 4071
					WHEN s0=> --A:='0'; B:='0';
						----OR GATE 1:
						data_out(0)<='0';--pin 1 A1
						data_out(1)<='0';--pin 2 B1
						--data_in(2)--pin 3 Y1

						----OR GATE 2:
						data_out(4)<='0';--pin 5 A2
						data_out(5)<='0';--pin 6 B2
						--data_in(3)--pin 4 Y2

						----OR GATE 3:
						data_out(17)<='0';--pin 13 A3
						data_out(16)<='0';--pin 12 B3
						--data_in(15)--pin 11 Y3

						----OR GATE 4:
						data_out(13)<='0';--pin 9 A4
						data_out(12)<='0';--pin 8 B4
						--data_in(14)--pin 10 Y4
						
						IF (data_in(2)='0')and (data_in(3)='0')and (data_in(15)='0') and (data_in(14)='0') THEN
						state<=s1; ELSE test_res_flag<='0'; END IF;

					WHEN s1=> --A:='0'; B:='1';
						----OR GATE 1:
						data_out(0)<='0';--pin 1 A1
						data_out(1)<='1';--pin 2 B1
						--data_in(2)--pin 3 Y1

						----OR GATE 2:
						data_out(4)<='0';--pin 5 A2
						data_out(5)<='1';--pin 6 B2
						--data_in(3)--pin 4 Y2

						----OR GATE 3:
						data_out(17)<='0';--pin 13 A3
						data_out(16)<='1';--pin 12 B3
						--data_in(15)--pin 11 Y3

						----OR GATE 4:
						data_out(13)<='0';--pin 9 A4
						data_out(12)<='1';--pin 8 B4
						--data_in(14)--pin 10 Y4
						
						IF (data_in(2)='1')and (data_in(3)='1')and (data_in(15)='1') and (data_in(14)='1') THEN
						state<=s2; ELSE test_res_flag<='0'; END IF;		
						
					WHEN s2=> --A:='1'; B:='0';
						----OR GATE 1:
						data_out(0)<='1';--pin 1 A1
						data_out(1)<='0';--pin 2 B1
						--data_in(2)--pin 3 Y1

						----OR GATE 2:
						data_out(4)<='1';--pin 5 A2
						data_out(5)<='0';--pin 6 B2
						--data_in(3)--pin 4 Y2

						----OR GATE 3:
						data_out(17)<='1';--pin 13 A3
						data_out(16)<='0';--pin 12 B3
						--data_in(15)--pin 11 Y3

						----OR GATE 4:
						data_out(13)<='1';--pin 9 A4
						data_out(12)<='0';--pin 8 B4
						--data_in(14)--pin 10 Y4
						
						IF (data_in(2)='1')and (data_in(3)='1')and (data_in(15)='1') and (data_in(14)='1') THEN
						state<=s3; ELSE test_res_flag<='0'; END IF;	

					WHEN OTHERS=> --A:='1'; B:='1';
						----OR GATE 1:
						data_out(0)<='1';--pin 1 A1
						data_out(1)<='1';--pin 2 B1
						--data_in(2)--pin 3 Y1

						----OR GATE 2:
						data_out(4)<='1';--pin 5 A2
						data_out(5)<='1';--pin 6 B2
						--data_in(3)--pin 4 Y2

						----OR GATE 3:
						data_out(17)<='1';--pin 13 A3
						data_out(16)<='1';--pin 12 B3
						--data_in(15)--pin 11 Y3

						----OR GATE 4:
						data_out(13)<='1';--pin 9 A4
						data_out(12)<='1';--pin 8 B4
						--data_in(14)--pin 10 Y4
						
						IF (data_in(2)='1')and (data_in(3)='1')and (data_in(15)='1') and (data_in(14)='1') THEN
						test_res_flag<='1'; ELSE test_res_flag<='0'; END IF;
		
				END CASE;
				
		----------------- testing 4081 -------------------
			ELSIF(chip_num=5) THEN --4081 -quad 2 input AND-14 dip
			
				EN(0)<='1';--enable buffer --pin 1 A1
				EN(1)<='1';--enable buffer --pin 2 B1
				EN(4)<='1';--enable buffer --pin 5 A2
				EN(5)<='1';--enable buffer --pin 6 B2
				EN(17)<='1';--enable buffer --pin 13 A3
				EN(16)<='1';--enable buffer --pin 12 B3
				EN(13)<='1';--enable buffer --pin 9 A4
				EN(12)<='1';--enable buffer --pin 8 B4
				
				EN(2)<='0';--unable buffer --pin 3 Y1
				EN(3)<='0';--unable buffer	 --pin 4 Y2
				EN(15)<='0';--unable buffer --pin 11 Y3
				EN(14)<='0';--unable buffer --pin 10 Y4

				gnd_sel(2)<='1';--pin 7 gnd	
--				vcc_sel<='1';--pin 14 vcc				

				CASE state IS--truth table of 4081
					WHEN s0=> --A:='0'; B:='0';
						----AND GATE 1:
						data_out(0)<='0';--pin 1 A1
						data_out(1)<='0';--pin 2 B1
						--data_in(2)--pin 3 Y1

						----AND GATE 2:
						data_out(4)<='0';--pin 5 A2
						data_out(5)<='0';--pin 6 B2
						--data_in(3)--pin 4 Y2

						----AND GATE 3:
						data_out(17)<='0';--pin 13 A3
						data_out(16)<='0';--pin 12 B3
						--data_in(15)--pin 11 Y3

						----AND GATE 4:
						data_out(13)<='0';--pin 9 A4
						data_out(12)<='0';--pin 8 B4
						--data_in(14)--pin 10 Y4
						
						IF (data_in(2)='0')and (data_in(3)='0')and (data_in(15)='0') and (data_in(14)='0') THEN
						state<=s1; ELSE test_res_flag<='0'; END IF;

					WHEN s1=> --A:='1'; B:='1';
						----AND GATE 1:
						data_out(0)<='1';--pin 1 A1
						data_out(1)<='1';--pin 2 B1
						--data_in(2)--pin 3 Y1

						----AND GATE 2:
						data_out(4)<='1';--pin 5 A2
						data_out(5)<='1';--pin 6 B2
						--data_in(3)--pin 4 Y2

						----AND GATE 3:
						data_out(17)<='1';--pin 13 A3
						data_out(16)<='1';--pin 12 B3
						--data_in(15)--pin 11 Y3

						----AND GATE 4:
						data_out(13)<='1';--pin 9 A4
						data_out(12)<='1';--pin 8 B4
						--data_in(14)--pin 10 Y4
						
						IF (data_in(2)='1')and (data_in(3)='1')and (data_in(15)='1') and (data_in(14)='1') THEN
						state<=s2; ELSE test_res_flag<='0'; END IF;					
						
					WHEN s2=> --A:='1'; B:='0';
						----AND GATE 1:
						data_out(0)<='1';--pin 1 A1
						data_out(1)<='0';--pin 2 B1
						--data_in(2)--pin 3 Y1

						----AND GATE 2:
						data_out(4)<='1';--pin 5 A2
						data_out(5)<='0';--pin 6 B2
						--data_in(3)--pin 4 Y2

						----AND GATE 3:
						data_out(17)<='1';--pin 13 A3
						data_out(16)<='0';--pin 12 B3
						--data_in(15)--pin 11 Y3

						----AND GATE 4:
						data_out(13)<='1';--pin 9 A4
						data_out(12)<='0';--pin 8 B4
						--data_in(14)--pin 10 Y4
						
						IF (data_in(2)='0')and (data_in(3)='0')and (data_in(15)='0') and (data_in(14)='0') THEN
						state<=s3; ELSE test_res_flag<='0'; END IF;		

					WHEN OTHERS=> --A:='0'; B:='1';
						----AND GATE 1:
						data_out(0)<='0';--pin 1 A1
						data_out(1)<='1';--pin 2 B1
						--data_in(2)--pin 3 Y1

						----AND GATE 2:
						data_out(4)<='0';--pin 5 A2
						data_out(5)<='1';--pin 6 B2
						--data_in(3)--pin 4 Y2

						----AND GATE 3:
						data_out(17)<='0';--pin 13 A3
						data_out(16)<='1';--pin 12 B3
						--data_in(15)--pin 11 Y3

						----AND GATE 4:
						data_out(13)<='0';--pin 9 A4
						data_out(12)<='1';--pin 8 B4
						--data_in(14)--pin 10 Y4
						
						IF (data_in(2)='0')and (data_in(3)='0')and (data_in(15)='0') and (data_in(14)='0') THEN
						test_res_flag<='1'; ELSE test_res_flag<='0';END IF;
						
				END CASE;
				
	----------------- testing 4008 -------------------
			ELSIF(chip_num=6) THEN --4008 -4 bit binary full adder-16 dip
			
				EN(0)<='1';--enable buffer --pin 1 A4
				EN(1)<='1';--enable buffer --pin 2 B3
				EN(2)<='1';--enable buffer --pin 3 A3
				EN(3)<='1';--enable buffer	--pin 4 B2
				EN(4)<='1';--enable buffer --pin 5 A2
				EN(5)<='1';--enable buffer --pin 6 B1
				EN(6)<='1';--enable buffer --pin 7 A1
				EN(11)<='1';--enable buffer --pin 9 C1
				EN(17)<='1';--enable buffer --pin 15 B4
				
				EN(12)<='0';--unable buffer --pin 10 S1
				EN(13)<='0';--unable buffer --pin 11 S2
				EN(14)<='0';--unable buffer --pin 12 S3
				EN(15)<='0';--unable buffer --pin 13 S4 
				EN(16)<='0';--unable buffer --pin 14 CO
				EN(7) <='0';--unable buffer --pin 8 gnd
				
				gnd_sel(2)<='0';--pin 7
				gnd_sel(1)<='1';--pin 8 gnd

--				vcc_sel<='1';--pin 14 vcc				

				CASE state IS--truth table of 4008
					WHEN s0=> --A:='0000';--B:='0000';--C1:='0';
						data_out(0)<='0';--pin 1 A4
						data_out(1)<='0';--pin 2 B3
						data_out(2)<='0';--pin 3 A3
						data_out(3)<='0';--pin 4 B2
						data_out(4)<='0';--pin 5 A2
						data_out(5)<='0';--pin 6 B1
						data_out(6)<='0';--pin 7 A1
						data_out(11)<='0';--pin 9 C1
						data_out(17)<='0';--pin 15 B4		
						
						IF (data_in(12)='0') and (data_in(13)='0') and (data_in(14)='0') 
						and (data_in(15)='0')and (data_in(16)='0') THEN
						state<=s1; ELSE test_res_flag<='0'; END IF;	

					WHEN s1=>  --A:='1010';--B:='0101';--C1:='0';
						data_out(0)<='1';--pin 1 A4
						data_out(1)<='1';--pin 2 B3
						data_out(2)<='0';--pin 3 A3
						data_out(3)<='0';--pin 4 B2
						data_out(4)<='1';--pin 5 A2
						data_out(5)<='1';--pin 6 B1
						data_out(6)<='0';--pin 7 A1
						data_out(11)<='0';--pin 9 C1
						data_out(17)<='0';--pin 15 B4		
						
						IF (data_in(12)='1') and (data_in(13)='1') and (data_in(14)='1') 
						and (data_in(15)='1')and (data_in(16)='0') THEN
						state<=s2; ELSE test_res_flag<='0'; END IF;
						
					WHEN s2=>  --A:='0101';--B:='1010';--C1:='0';
						data_out(0)<='0';--pin 1 A4
						data_out(1)<='0';--pin 2 B3
						data_out(2)<='1';--pin 3 A3
						data_out(3)<='1';--pin 4 B2
						data_out(4)<='0';--pin 5 A2
						data_out(5)<='0';--pin 6 B1
						data_out(6)<='1';--pin 7 A1
						data_out(11)<='0';--pin 9 C1
						data_out(17)<='1';--pin 15 B4		
						
						IF (data_in(12)='1') and (data_in(13)='1') and (data_in(14)='1') 
						and (data_in(15)='1')and (data_in(16)='0') THEN
						state<=s3; ELSE test_res_flag<='0'; END IF;
						
					WHEN s3=>  --A:='1001';--B:='0011';--C1:='0';
						data_out(0)<='1';--pin 1 A4
						data_out(1)<='0';--pin 2 B3
						data_out(2)<='0';--pin 3 A3
						data_out(3)<='1';--pin 4 B2
						data_out(4)<='0';--pin 5 A2
						data_out(5)<='1';--pin 6 B1
						data_out(6)<='1';--pin 7 A1
						data_out(11)<='0';--pin 9 C1
						data_out(17)<='0';--pin 15 B4		
						
						IF (data_in(12)='0') and (data_in(13)='0') and (data_in(14)='1') 
						and (data_in(15)='1')and (data_in(16)='0') THEN
						state<=s4; ELSE test_res_flag<='0'; END IF;
						
					WHEN s4=>  --A:='1000';--B:='0010';--C1:='1';
						data_out(0)<='1';--pin 1 A4
						data_out(1)<='0';--pin 2 B3
						data_out(2)<='0';--pin 3 A3
						data_out(3)<='1';--pin 4 B2
						data_out(4)<='0';--pin 5 A2
						data_out(5)<='0';--pin 6 B1
						data_out(6)<='0';--pin 7 A1
						data_out(11)<='1';--pin 9 C1
						data_out(17)<='0';--pin 15 B4		
						
						IF (data_in(12)='1') and (data_in(13)='1') and (data_in(14)='0') 
						and (data_in(15)='1')and (data_in(16)='0') THEN
						state<=s5; ELSE test_res_flag<='0'; END IF;
						
					WHEN OTHERS=>  --A:='1111';--B:='0010';--C1:='1';
						data_out(0)<='1';--pin 1 A4
						data_out(1)<='0';--pin 2 B3
						data_out(2)<='1';--pin 3 A3
						data_out(3)<='1';--pin 4 B2
						data_out(4)<='1';--pin 5 A2
						data_out(5)<='0';--pin 6 B1
						data_out(6)<='1';--pin 7 A1
						data_out(11)<='1';--pin 9 C1
						data_out(17)<='0';--pin 15 B4		
						
						IF (data_in(12)='0') and (data_in(13)='1') and (data_in(14)='0') 
						and (data_in(15)='0')and (data_in(16)='1') THEN
						test_res_flag<='1'; ELSE test_res_flag<='0'; END IF;
						

				END CASE;
	----------------- testing 7400 -------------------
			ELSIF(chip_num=7) THEN--7400 -quad 2 input NAND-14 dip
			
				EN(0)<='1';--enable buffer --pin 1 A1
				EN(1)<='1';--enable buffer --pin 2 B1
				EN(3)<='1';--enable buffer --pin 4 A2
				EN(4)<='1';--enable buffer --pin 5 B2
				EN(13)<='1';--enable buffer --pin 9 A3
				EN(14)<='1';--enable buffer --pin 10 B3
				EN(16)<='1';--enable buffer --pin 12 A4
				EN(17)<='1';--enable buffer --pin 13 B4
				
				EN(2)<='0';--unable buffer --pin 3 Y1
				EN(5)<='0'; --unable buffer --pin 6 Y2
				EN(12)<='0'; --unable buffer --pin 8 Y3
				EN(15)<='0';  --unable buffer --pin 11 Y4
			
				gnd_sel(2)<='1';--pin 7 gnd
--				vcc_sel<='1';--pin 14 vcc
			
				CASE state IS --truth table of 7400
					WHEN s0=>--A:='0'; B:='0';					
						----NAND GATE 1:
						data_out(0)<='0';--pin 1 A1						
						data_out(1)<='0';--pin 2 B1						
						--data_in(2)--pin 3 Y1
						
						----NAND GATE 2:
						data_out(3)<='0';--pin 4 A2						
						data_out(4)<='0';--pin 5 B2
						--data_in(5)--pin 6 Y2
	
						----NAND GATE 3:
						data_out(13)<='0';--pin 9 A3						
						data_out(14)<='0';--pin 10 B3
						--data_in(12)--pin 8 Y3
	
						----NAND GATE 4:
						data_out(16)<='0';--pin 12 A4
						data_out(17)<='0';--pin 13 B4
						--data_in(15)--pin 11 Y4

						IF (data_in(2)='1')and (data_in(5)='1')and (data_in(12)='1') and (data_in(15)='1') THEN
						state<=s1; ELSE test_res_flag<='0'; END IF;
					
					WHEN s1=>--A:='0'; B:='1';					
						----NAND GATE 1:
						data_out(0)<='0';--pin 1 A1						
						data_out(1)<='1';--pin 2 B1						
						--data_in(2)--pin 3 Y1
						
						----NAND GATE 2:
						data_out(3)<='0';--pin 4 A2						
						data_out(4)<='1';--pin 5 B2
						--data_in(5)--pin 6 Y2
	
						----NAND GATE 3:
						data_out(13)<='0';--pin 9 A3						
						data_out(14)<='1';--pin 10 B3
						--data_in(12)--pin 8 Y3
	
						----NAND GATE 4:
						data_out(16)<='0';--pin 12 A4
						data_out(17)<='1';--pin 13 B4
						--data_in(15)--pin 11 Y4


						IF (data_in(2)='1')and (data_in(5)='1')and (data_in(12)='1') and (data_in(15)='1') THEN
						state<=s2; ELSE test_res_flag<='0'; END IF;
						
					WHEN s2=> --A:='1'; B:='0';					
						----NAND GATE 1:
						data_out(0)<='1';--pin 1 A1						
						data_out(1)<='0';--pin 2 B1						
						--data_in(2)--pin 3 Y1
						
						----NAND GATE 2:
						data_out(3)<='1';--pin 4 A2						
						data_out(4)<='0';--pin 5 B2
						--data_in(5)--pin 6 Y2
	
						----NAND GATE 3:
						data_out(13)<='1';--pin 9 A3						
						data_out(14)<='0';--pin 10 B3
						--data_in(12)--pin 8 Y3
	
						----NAND GATE 4:
						data_out(16)<='1';--pin 12 A4
						data_out(17)<='0';--pin 13 B4
						--data_in(15)--pin 11 Y4

						IF (data_in(2)='1')and (data_in(5)='1')and (data_in(12)='1') and (data_in(15)='1') THEN
						state<=s3; ELSE test_res_flag<='0'; END IF;			
	
					WHEN OTHERS=> --A:='1'; B:='1';				
						----NAND GATE 1:
						data_out(0)<='1';--pin 1 A1						
						data_out(1)<='1';--pin 2 B1						
						--data_in(2)--pin 3 Y1
						
						----NAND GATE 2:
						data_out(3)<='1';--pin 4 A2						
						data_out(4)<='1';--pin 5 B2
						--data_in(5)--pin 6 Y2
	
						----NAND GATE 3:
						data_out(13)<='1';--pin 9 A3						
						data_out(14)<='1';--pin 10 B3
						--data_in(12)--pin 8 Y3
	
						----NAND GATE 4:
						data_out(16)<='1';--pin 12 A4
						data_out(17)<='1';--pin 13 B4
						--data_in(15)--pin 11 Y4

						IF (data_in(2)='0')and (data_in(5)='0')and (data_in(12)='0') and (data_in(15)='0') THEN
						test_res_flag<='1'; ELSE test_res_flag<='0'; END IF;			
							
				END CASE;
				
		----------------- testing 7421 -------------------
			ELSIF(chip_num=8) THEN--7421 -dual 4 input AND-14 dip
			
				EN(0)<='1';--enable buffer --pin 1 1A
				EN(1)<='1';--enable buffer --pin 2 1B
				EN(3)<='1';--enable buffer --pin 4 1C
				EN(4)<='1';--enable buffer --pin 5 1D
				EN(13)<='1';--enable buffer --pin 9 2A
				EN(14)<='1';--enable buffer --pin 10 2B
				EN(16)<='1';--enable buffer --pin 12 2C
				EN(17)<='1';--enable buffer --pin 13 2D
				
				EN(5)<='0'; --unable buffer --pin 6 1Y
				EN(12)<='0'; --unable buffer --pin 8 2Y
								
				EN(2)<='0';--unable buffer --pin 3 NC
				EN(15)<='0';  --unable buffer --pin 11 NC
				
				gnd_sel(2)<='1';--pin 7 gnd
--				vcc_sel<='1';--pin 14 vcc				
			
				CASE state IS --truth table of 7421
					WHEN s0=>--A:='0'; B:='0';	C:='0'; D:='0';				
						----AND GATE 1:
						data_out(0)<='0';--pin 1 1A						
						data_out(1)<='0';--pin 2 1B
						data_out(3)<='0';--pin 4 1C					
						data_out(4)<='0';--pin 5 1D 							
						--data_in(5)--pin 6 1Y
						
						----AND GATE 2:
						data_out(13)<='0';--pin 9 2A						
						data_out(14)<='0';--pin 10 2B
						data_out(16)<='0';--pin 12 2C						
						data_out(17)<='0';--pin 13 2D
						--data_in(12)--pin 8 2Y

						IF (data_in(5)='0')and (data_in(12)='0') THEN
						state<=s1; ELSE test_res_flag<='0'; END IF;
					
					WHEN s1=>--A:='0'; B:='0';	C:='0'; D:='1';					
						----AND GATE 1:
						data_out(0)<='0';--pin 1 1A						
						data_out(1)<='0';--pin 2 1B
						data_out(3)<='0';--pin 4 1C					
						data_out(4)<='1';--pin 5 1D 							
						--data_in(5)--pin 6 1Y
						
						----AND GATE 2:
						data_out(13)<='0';--pin 9 2A						
						data_out(14)<='0';--pin 10 2B
						data_out(16)<='0';--pin 12 2C						
						data_out(17)<='1';--pin 13 2D
						--data_in(12)--pin 8 2Y

						IF (data_in(5)='0')and (data_in(12)='0') THEN
						state<=s2; ELSE test_res_flag<='0'; END IF;
						
					WHEN s2=> --A:='0'; B:='0';C:='1'; D:='0';			
						----AND GATE 1:
						data_out(0)<='0';--pin 1 1A						
						data_out(1)<='0';--pin 2 1B
						data_out(3)<='1';--pin 4 1C					
						data_out(4)<='0';--pin 5 1D 							
						--data_in(5)--pin 6 1Y
						
						----AND GATE 2:
						data_out(13)<='0';--pin 9 2A						
						data_out(14)<='0';--pin 10 2B
						data_out(16)<='1';--pin 12 2C						
						data_out(17)<='0';--pin 13 2D
						--data_in(12)--pin 8 2Y

						IF (data_in(5)='0')and (data_in(12)='0') THEN
						state<=s3; ELSE test_res_flag<='0'; END IF;	

					WHEN s3=> --A:='0'; B:='0';C:='1'; D:='1';				
						----AND GATE 1:
						data_out(0)<='0';--pin 1 1A						
						data_out(1)<='0';--pin 2 1B
						data_out(3)<='1';--pin 4 1C					
						data_out(4)<='1';--pin 5 1D 							
						--data_in(5)--pin 6 1Y
						
						----AND GATE 2:
						data_out(13)<='0';--pin 9 2A						
						data_out(14)<='0';--pin 10 2B
						data_out(16)<='1';--pin 12 2C						
						data_out(17)<='1';--pin 13 2D
						--data_in(12)--pin 8 2Y

						IF (data_in(5)='0')and (data_in(12)='0') THEN
						state<=s4; ELSE test_res_flag<='0'; END IF;	
						
					WHEN s4=> --A:='0'; B:='1';C:='0'; D:='0';				
						----AND GATE 1:
						data_out(0)<='0';--pin 1 1A						
						data_out(1)<='1';--pin 2 1B
						data_out(3)<='0';--pin 4 1C					
						data_out(4)<='0';--pin 5 1D 							
						--data_in(5)--pin 6 1Y
						
						----AND GATE 2:
						data_out(13)<='0';--pin 9 2A						
						data_out(14)<='1';--pin 10 2B
						data_out(16)<='0';--pin 12 2C						
						data_out(17)<='0';--pin 13 2D
						--data_in(12)--pin 8 2Y

						IF (data_in(5)='0')and (data_in(12)='0') THEN
						state<=s5; ELSE test_res_flag<='0'; END IF;
						
					WHEN s5=> --A:='0'; B:='1';C:='0'; D:='1';				
						----AND GATE 1:
						data_out(0)<='0';--pin 1 1A						
						data_out(1)<='1';--pin 2 1B
						data_out(3)<='0';--pin 4 1C					
						data_out(4)<='1';--pin 5 1D 							
						--data_in(5)--pin 6 1Y
						
						----AND GATE 2:
						data_out(13)<='0';--pin 9 2A						
						data_out(14)<='1';--pin 10 2B
						data_out(16)<='0';--pin 12 2C						
						data_out(17)<='1';--pin 13 2D
						--data_in(12)--pin 8 2Y

						IF (data_in(5)='0')and (data_in(12)='0') THEN
						state<=s6; ELSE test_res_flag<='0'; END IF;

					WHEN s6=> --A:='0'; B:='1';C:='1'; D:='0';				
						----AND GATE 1:
						data_out(0)<='0';--pin 1 1A						
						data_out(1)<='1';--pin 2 1B
						data_out(3)<='1';--pin 4 1C					
						data_out(4)<='0';--pin 5 1D 							
						--data_in(5)--pin 6 1Y
						
						----AND GATE 2:
						data_out(13)<='0';--pin 9 2A						
						data_out(14)<='1';--pin 10 2B
						data_out(16)<='1';--pin 12 2C						
						data_out(17)<='0';--pin 13 2D
						--data_in(12)--pin 8 2Y

						IF (data_in(5)='0')and (data_in(12)='0') THEN
						state<=s7; ELSE test_res_flag<='0'; END IF;
						
					WHEN s7=> --A:='0'; B:='1';C:='1'; D:='1';				
						----AND GATE 1:
						data_out(0)<='0';--pin 1 1A						
						data_out(1)<='1';--pin 2 1B
						data_out(3)<='1';--pin 4 1C					
						data_out(4)<='1';--pin 5 1D 							
						--data_in(5)--pin 6 1Y
						
						----AND GATE 2:
						data_out(13)<='0';--pin 9 2A						
						data_out(14)<='1';--pin 10 2B
						data_out(16)<='1';--pin 12 2C						
						data_out(17)<='1';--pin 13 2D
						--data_in(12)--pin 8 2Y

						IF (data_in(5)='0')and (data_in(12)='0') THEN
						state<=s8; ELSE test_res_flag<='0'; END IF;
						
					WHEN s8=> --A:='1'; B:='0';C:='0'; D:='0';				
						----AND GATE 1:
						data_out(0)<='1';--pin 1 1A						
						data_out(1)<='0';--pin 2 1B
						data_out(3)<='0';--pin 4 1C					
						data_out(4)<='0';--pin 5 1D 							
						--data_in(5)--pin 6 1Y
						
						----AND GATE 2:
						data_out(13)<='1';--pin 9 2A						
						data_out(14)<='0';--pin 10 2B
						data_out(16)<='0';--pin 12 2C						
						data_out(17)<='0';--pin 13 2D
						--data_in(12)--pin 8 2Y

						IF (data_in(5)='0')and (data_in(12)='0') THEN
						state<=s9; ELSE test_res_flag<='0'; END IF;	
						
					WHEN s9=> --A:='1'; B:='0';C:='0'; D:='1';				
						----AND GATE 1:
						data_out(0)<='1';--pin 1 1A						
						data_out(1)<='0';--pin 2 1B
						data_out(3)<='0';--pin 4 1C					
						data_out(4)<='1';--pin 5 1D 							
						--data_in(5)--pin 6 1Y
						
						----AND GATE 2:
						data_out(13)<='1';--pin 9 2A						
						data_out(14)<='0';--pin 10 2B
						data_out(16)<='0';--pin 12 2C						
						data_out(17)<='1';--pin 13 2D
						--data_in(12)--pin 8 2Y

						IF (data_in(5)='0')and (data_in(12)='0') THEN
						state<=s10; ELSE test_res_flag<='0'; END IF;
						
				 WHEN s10=> --A:='1'; B:='0';C:='1'; D:='0';				
						----AND GATE 1:
						data_out(0)<='1';--pin 1 1A						
						data_out(1)<='0';--pin 2 1B
						data_out(3)<='1';--pin 4 1C					
						data_out(4)<='0';--pin 5 1D 							
						--data_in(5)--pin 6 1Y
						
						----AND GATE 2:
						data_out(13)<='1';--pin 9 2A						
						data_out(14)<='0';--pin 10 2B
						data_out(16)<='1';--pin 12 2C						
						data_out(17)<='0';--pin 13 2D
						--data_in(12)--pin 8 2Y

						IF (data_in(5)='0')and (data_in(12)='0') THEN
						state<=s11; ELSE test_res_flag<='0'; END IF;	
						
					 WHEN s11=> --A:='1'; B:='0';C:='1'; D:='1';				
						----AND GATE 1:
						data_out(0)<='1';--pin 1 1A						
						data_out(1)<='0';--pin 2 1B
						data_out(3)<='1';--pin 4 1C					
						data_out(4)<='1';--pin 5 1D 							
						--data_in(5)--pin 6 1Y
						
						----AND GATE 2:
						data_out(13)<='1';--pin 9 2A						
						data_out(14)<='0';--pin 10 2B
						data_out(16)<='1';--pin 12 2C						
						data_out(17)<='1';--pin 13 2D
						--data_in(12)--pin 8 2Y

						IF (data_in(5)='0')and (data_in(12)='0') THEN
						state<=s12; ELSE test_res_flag<='0'; END IF;
						
					 WHEN s12=> --A:='1'; B:='1';C:='0'; D:='0';				
						----AND GATE 1:
						data_out(0)<='1';--pin 1 1A						
						data_out(1)<='1';--pin 2 1B
						data_out(3)<='0';--pin 4 1C					
						data_out(4)<='0';--pin 5 1D 							
						--data_in(5)--pin 6 1Y
						
						----AND GATE 2:
						data_out(13)<='1';--pin 9 2A						
						data_out(14)<='1';--pin 10 2B
						data_out(16)<='0';--pin 12 2C						
						data_out(17)<='0';--pin 13 2D
						--data_in(12)--pin 8 2Y

						IF (data_in(5)='0')and (data_in(12)='0') THEN
						state<=s13; ELSE test_res_flag<='0'; END IF;
						
					WHEN s13=> --A:='1'; B:='1';C:='0'; D:='1';				
						----AND GATE 1:
						data_out(0)<='1';--pin 1 1A						
						data_out(1)<='1';--pin 2 1B
						data_out(3)<='0';--pin 4 1C					
						data_out(4)<='1';--pin 5 1D 							
						--data_in(5)--pin 6 1Y
						
						----AND GATE 2:
						data_out(13)<='1';--pin 9 2A						
						data_out(14)<='1';--pin 10 2B
						data_out(16)<='0';--pin 12 2C						
						data_out(17)<='1';--pin 13 2D
						--data_in(12)--pin 8 2Y

						IF (data_in(5)='0')and (data_in(12)='0') THEN
						state<=s14; ELSE test_res_flag<='0'; END IF;	
						
					WHEN s14=> --A:='1'; B:='1';C:='1'; D:='0';				
						----AND GATE 1:
						data_out(0)<='1';--pin 1 1A						
						data_out(1)<='1';--pin 2 1B
						data_out(3)<='1';--pin 4 1C					
						data_out(4)<='0';--pin 5 1D 							
						--data_in(5)--pin 6 1Y
						
						----AND GATE 2:
						data_out(13)<='1';--pin 9 2A						
						data_out(14)<='1';--pin 10 2B
						data_out(16)<='1';--pin 12 2C						
						data_out(17)<='0';--pin 13 2D
						--data_in(12)--pin 8 2Y

						IF (data_in(5)='0')and (data_in(12)='0') THEN
						state<=s15; ELSE test_res_flag<='0'; END IF;	
						
					WHEN OTHERS=> --A:='1'; B:='1';C:='1'; D:='1';				
						----AND GATE 1:
						data_out(0)<='1';--pin 1 1A						
						data_out(1)<='1';--pin 2 1B
						data_out(3)<='1';--pin 4 1C					
						data_out(4)<='1';--pin 5 1D 							
						--data_in(5)--pin 6 1Y
						
						----AND GATE 2:
						data_out(13)<='1';--pin 9 2A						
						data_out(14)<='1';--pin 10 2B
						data_out(16)<='1';--pin 12 2C						
						data_out(17)<='1';--pin 13 2D
						--data_in(12)--pin 8 2Y
						
						IF (data_in(5)='1')and (data_in(12)='1') THEN
						test_res_flag<='1'; ELSE test_res_flag<='0'; END IF;	
							
				END CASE;
				
		----------------- testing 7408 -------------------
			ELSIF(chip_num=9) THEN--7408 -quad 2 input AND-14 dip
			
				EN(0)<='1';--enable buffer --pin 1 A1
				EN(1)<='1';--enable buffer --pin 2 B1
				EN(3)<='1';--enable buffer --pin 4 A2
				EN(4)<='1';--enable buffer --pin 5 B2
				EN(13)<='1';--enable buffer --pin 9 A3
				EN(14)<='1';--enable buffer --pin 10 B3
				EN(16)<='1';--enable buffer --pin 12 A4
				EN(17)<='1';--enable buffer --pin 13 B4
				
				EN(2)<='0';--unable buffer --pin 3 Y1
				EN(5)<='0'; --unable buffer --pin 6 Y2
				EN(12)<='0'; --unable buffer --pin 8 Y3
				EN(15)<='0';  --unable buffer --pin 11 Y4
			
				gnd_sel(2)<='1';--pin 7 gnd
--				vcc_sel<='1';--pin 14 vcc				
			
				CASE state IS --truth table of 7408
					WHEN s0=>--A:='0'; B:='0';			
						----AND GATE 1:
						data_out(0)<='0';--pin 1 A1						
						data_out(1)<='0';--pin 2 B1						
						--data_in(2)--pin 3 Y1
						
						----AND GATE 2:
						data_out(3)<='0';--pin 4 A2						
						data_out(4)<='0';--pin 5 B2
						--data_in(5)--pin 6 Y2
	
						----AND GATE 3:
						data_out(13)<='0';--pin 9 A3						
						data_out(14)<='0';--pin 10 B3
						--data_in(12)--pin 8 Y3
	
						----AND GATE 4:
						data_out(16)<='0';--pin 12 A4
						data_out(17)<='0';--pin 13 B4
						--data_in(15)--pin 11 Y4

						IF (data_in(2)='0')and (data_in(5)='0')and (data_in(12)='0') and (data_in(15)='0') THEN
						state<=s1; ELSE test_res_flag<='0'; END IF;	
					
					WHEN s1=>--A:='0'; B:='1';					
						----AND GATE 1:
						data_out(0)<='0';--pin 1 A1						
						data_out(1)<='1';--pin 2 B1						
						--data_in(2)--pin 3 Y1
						
						----AND GATE 2:
						data_out(3)<='0';--pin 4 A2						
						data_out(4)<='1';--pin 5 B2
						--data_in(5)--pin 6 Y2
	
						----AND GATE 3:
						data_out(13)<='0';--pin 9 A3						
						data_out(14)<='1';--pin 10 B3
						--data_in(12)--pin 8 Y3
	
						----AND GATE 4:
						data_out(16)<='0';--pin 12 A4
						data_out(17)<='1';--pin 13 B4
						--data_in(15)--pin 11 Y4

						IF (data_in(2)='0')and (data_in(5)='0')and (data_in(12)='0') and (data_in(15)='0') THEN
						state<=s2; ELSE test_res_flag<='0'; END IF;
						
					WHEN s2=> --A:='1'; B:='0'			
						----AND GATE 1:
						data_out(0)<='1';--pin 1 A1						
						data_out(1)<='0';--pin 2 B1						
						--data_in(2)--pin 3 Y1
						
						----AND GATE 2:
						data_out(3)<='1';--pin 4 A2						
						data_out(4)<='0';--pin 5 B2
						--data_in(5)--pin 6 Y2
	
						----AND GATE 3:
						data_out(13)<='1';--pin 9 A3						
						data_out(14)<='0';--pin 10 B3
						--data_in(12)--pin 8 Y3
	
						----AND GATE 4:
						data_out(16)<='1';--pin 12 A4
						data_out(17)<='0';--pin 13 B4
						--data_in(15)--pin 11 Y4

						IF (data_in(2)='0')and (data_in(5)='0')and (data_in(12)='0') and (data_in(15)='0') THEN
						state<=s3; ELSE test_res_flag<='0'; END IF;	
			
	
					WHEN OTHERS=> --A:='1'; B:='1';				
						----AND GATE 1:
						data_out(0)<='1';--pin 1 A1						
						data_out(1)<='1';--pin 2 B1						
						--data_in(2)--pin 3 Y1
						
						----AND GATE 2:
						data_out(3)<='1';--pin 4 A2						
						data_out(4)<='1';--pin 5 B2
						--data_in(5)--pin 6 Y2
	
						----AND GATE 3:
						data_out(13)<='1';--pin 9 A3						
						data_out(14)<='1';--pin 10 B3
						--data_in(12)--pin 8 Y3
	
						----AND GATE 4:
						data_out(16)<='1';--pin 12 A4
						data_out(17)<='1';--pin 13 B4
						--data_in(15)--pin 11 Y4

						IF (data_in(2)='1')and (data_in(5)='1')and (data_in(12)='1') and (data_in(15)='1') THEN
						test_res_flag<='1'; ELSE test_res_flag<='0'; END IF;
							
				END CASE;
				
	----------------- testing 7402 -------------------
			ELSIF(chip_num=10) THEN--7402 -quad 2 input NOR-14 dip
				
				EN(1)<='1';--enable buffer --pin 2 A1
				EN(2)<='1';--enable buffer --pin 3 B1
				EN(4)<='1';--enable buffer --pin 5 A2
				EN(5)<='1'; --enable buffer --pin 6 B2
				EN(12)<='1'; --enable buffer --pin 8 A3
				EN(13)<='1';--enable buffer --pin 9 B3
				EN(15)<='1'; --enable buffer --pin 11 A4
				EN(16)<='1';--enable buffer --pin 12 B4

				EN(0)<='0';--unable buffer --pin 1 Y1
				EN(3)<='0';--unable buffer --pin 4 Y2
				EN(14)<='0';--unable buffer --pin 10 Y3
				EN(17)<='0';--unable buffer --pin 13 Y4
				
				gnd_sel(2)<='1';--pin 7 gnd
--				vcc_sel<='1';--pin 14 vcc
			
				CASE state IS --truth table of 7402
					WHEN s0=>--A:='0'; B:='0';					
						----NOR GATE 1:
						data_out(1)<='0';--pin 2 A1						
						data_out(2)<='0';--pin 3 B1						
						--data_in(0)--pin 1 Y1
						
						----NOR GATE 2:
						data_out(4)<='0';--pin 5 A2						
						data_out(5)<='0';--pin 6 B2
						--data_in(3)--pin 4 Y2
	
						----NOR GATE 3:
						data_out(12)<='0';--pin 8 A3						
						data_out(13)<='0';--pin 9 B3
						--data_in(14)--pin 10 Y3
	
						----NOR GATE 4:
						data_out(15)<='0';--pin 11 A4
						data_out(16)<='0';--pin 12 B4
						--data_in(17)--pin 13 Y4

						IF (data_in(0)='1')and (data_in(3)='1')and (data_in(14)='1') and (data_in(17)='1') THEN
						state<=s1; ELSE test_res_flag<='0'; END IF;
						
					WHEN s1=>--A:='0'; B:='1';					
						----NOR GATE 1:
						data_out(1)<='0';--pin 2 A1						
						data_out(2)<='1';--pin 3 B1						
						--data_in(0)--pin 1 Y1
						
						----NOR GATE 2:
						data_out(4)<='0';--pin 5 A2						
						data_out(5)<='1';--pin 6 B2
						--data_in(3)--pin 4 Y2
	
						----NOR GATE 3:
						data_out(12)<='0';--pin 8 A3						
						data_out(13)<='1';--pin 9 B3
						--data_in(14)--pin 10 Y3
	
						----NOR GATE 4:
						data_out(15)<='0';--pin 11 A4
						data_out(16)<='1';--pin 12 B4
						--data_in(17)--pin 13 Y4

						IF (data_in(0)='0')and (data_in(3)='0')and (data_in(14)='0') and (data_in(17)='0') THEN
						state<=s2; ELSE test_res_flag<='0'; END IF;
						
					WHEN s2=> --A:='1'; B:='0';					
						----NOR GATE 1:
						data_out(1)<='1';--pin 2 A1						
						data_out(2)<='0';--pin 3 B1						
						--data_in(0)--pin 1 Y1
						
						----NOR GATE 2:
						data_out(4)<='1';--pin 5 A2						
						data_out(5)<='0';--pin 6 B2
						--data_in(3)--pin 4 Y2
	
						----NOR GATE 3:
						data_out(12)<='1';--pin 8 A3						
						data_out(13)<='0';--pin 9 B3
						--data_in(14)--pin 10 Y3
	
						----NOR GATE 4:
						data_out(15)<='1';--pin 11 A4
						data_out(16)<='0';--pin 12 B4
						--data_in(17)--pin 13 Y4

						IF (data_in(0)='0')and (data_in(3)='0')and (data_in(14)='0') and (data_in(17)='0') THEN
						state<=s3; ELSE test_res_flag<='0'; END IF;		
	
					WHEN OTHERS=> --A:='1'; B:='1';				
						----NOR GATE 1:
						data_out(1)<='1';--pin 2 A1						
						data_out(2)<='1';--pin 3 B1						
						--data_in(0)--pin 1 Y1
						
						----NOR GATE 2:
						data_out(4)<='1';--pin 5 A2						
						data_out(5)<='1';--pin 6 B2
						--data_in(3)--pin 4 Y2
	
						----NOR GATE 3:
						data_out(12)<='1';--pin 8 A3						
						data_out(13)<='1';--pin 9 B3
						--data_in(14)--pin 10 Y3
	
						----NOR GATE 4:
						data_out(15)<='1';--pin 11 A4
						data_out(16)<='1';--pin 12 B4
						--data_in(17)--pin 13 Y4

						IF (data_in(0)='0')and (data_in(3)='0')and (data_in(14)='0') and (data_in(17)='0') THEN
						test_res_flag<='1'; ELSE test_res_flag<='0'; END IF;
							
				END CASE;
				
	----------------- testing 7404 -------------------
			ELSIF(chip_num=11) THEN --7404 -hex NOT-14 dip
			
				EN(0)<='1';--enable buffer --pin 1 A1
				EN(2)<='1';--enable buffer --pin 3 A2
				EN(4)<='1';--enable buffer --pin 5 A3
				EN(17)<='1';--enable buffer --pin 13 A4
				EN(15)<='1';--enable buffer --pin 11 A5
				EN(13)<='1';--enable buffer --pin 9 A6
				
				EN(1)<='0';--unable buffer --pin 2 Y1
				EN(3)<='0';--unable buffer	 --pin 4 Y2
				EN(5)<='0';--unable buffer --pin 6 Y3 
				EN(16)<='0';--unable buffer --pin 12 Y4
				EN(14)<='0';--unable buffer --pin 10 Y5
				EN(12)<='0';--unable buffer --pin 8 Y6	
								
				gnd_sel(2)<='1';--pin 7 gnd
--				vcc_sel<='1';--pin 14 vcc

				CASE state IS--truth table of 7404
					WHEN s0=> --A:='0'
						data_out(0)<='0';--pin 1 A1
						data_out(2)<='0';--pin 3 A2
						data_out(4)<='0';--pin 5 A3
						data_out(17)<='0';--pin 13 A4
						data_out(15)<='0';--pin 11 A5
						data_out(13)<='0';--pin 9 A6
						
						IF (data_in(1)='1')and (data_in(3)='1') and (data_in(5)='1') 
						and (data_in(16)='1') and (data_in(14)='1') and (data_in(12)='1') THEN
						state<=s1; ELSE test_res_flag<='0'; END IF;				

					WHEN OTHERS=> --A:='1'
						data_out(0)<='1';--pin 1 A1
						data_out(2)<='1';--pin 3 A2
						data_out(4)<='1';--pin 5 A3
						data_out(17)<='1';--pin 13 A4
						data_out(15)<='1';--pin 11 A5
						data_out(13)<='1';--pin 9 A6
					
						IF (data_in(1)='0')and (data_in(3)='0') and (data_in(5)='0') 
						and (data_in(16)='0') and (data_in(14)='0') and (data_in(12)='0') THEN
						test_res_flag<='1'; ELSE test_res_flag<='0'; END IF;
															
				END CASE;
				
		----------------- testing 74157 -------------------
			ELSIF(chip_num=12) THEN --74157 -QUAD 2 input Multiplexer-16 dip
			
				EN(17)<='1';--enable buffer --pin 15 E
				EN(1)<='1';--enable buffer --pin 2 I0a
				EN(2)<='1';--enable buffer --pin 3 I1a
				EN(4)<='1';--enable buffer --pin 5 I0b
				EN(5)<='1';--enable buffer --pin 6 I1b
				EN(16)<='1';--enable buffer --pin 14 I0c
				EN(15)<='1';--enable buffer --pin 13 I1c
				EN(13)<='1';--enable buffer --pin 11 I0d
				EN(12)<='1';--enable buffer --pin 10 I1d
				EN(0)<='1';--enable buffer --pin 1 S
				
				EN(3)<='0';--unable buffer	--pin 4 Za			
				EN(6)<='0';--unable buffer --pin 7 Zb
				EN(14)<='0';--unable buffer --pin 12 Zc			
				EN(11)<='0';--unable buffer --pin 9 Zd			
				EN(7) <='0';--unable buffer --pin 8 gnd
				
				gnd_sel(2)<='0';--pin 7
				gnd_sel(1)<='1';--pin 8 gnd

				CASE state IS--truth table of 74157
					WHEN s0=> --E:='1' S:='0' I0:='0' I1:='0' 
						data_out(17)<='1';--pin 15 E
						data_out(1) <='0';--pin 2 I0a
						data_out(2) <='0';--pin 3 I1a
						data_out(4) <='0';--pin 5 I0b
						data_out(5) <='0';--pin 6 I1b
						data_out(16)<='0';--pin 14 I0c
						data_out(15)<='0';--pin 13 I1c
						data_out(13)<='0';--pin 11 I0d
						data_out(12)<='0';--pin 10 I1d
						data_out(0) <='0';--pin 1 S
						 
						IF (data_in(3)='0') and (data_in(6)='0') and (data_in(14)='0') and (data_in(11)='0') THEN
						state<=s1; ELSE test_res_flag<='0'; END IF;
						
					WHEN s1=> --E:='0' S:='1' I0:='0' I1:='0' 
						data_out(17)<='0';--pin 15 E
						data_out(1) <='0';--pin 2 I0a
						data_out(2) <='0';--pin 3 I1a
						data_out(4) <='0';--pin 5 I0b
						data_out(5) <='0';--pin 6 I1b
						data_out(16)<='0';--pin 14 I0c
						data_out(15)<='0';--pin 13 I1c
						data_out(13)<='0';--pin 11 I0d
						data_out(12)<='0';--pin 10 I1d
						data_out(0) <='1';--pin 1 S
						 
						IF (data_in(3)='0') and (data_in(6)='0') and (data_in(14)='0') and (data_in(11)='0') THEN
						state<=s2; ELSE test_res_flag<='0'; END IF;
					
					WHEN s2=> --E:='0' S:='1' I0:='0' I1:='1' 
						data_out(17)<='0';--pin 15 E
						data_out(1) <='0';--pin 2 I0a
						data_out(2) <='1';--pin 3 I1a
						data_out(4) <='0';--pin 5 I0b
						data_out(5) <='1';--pin 6 I1b
						data_out(16)<='0';--pin 14 I0c
						data_out(15)<='1';--pin 13 I1c
						data_out(13)<='0';--pin 11 I0d
						data_out(12)<='1';--pin 10 I1d
						data_out(0) <='1';--pin 1 S
						 
						IF (data_in(3)='1') and (data_in(6)='1') and (data_in(14)='1') and (data_in(11)='1') THEN
						state<=s3; ELSE test_res_flag<='0'; END IF;
						
					WHEN s3=> --E:='0' S:='0' I0:='0' I1:='0' 
						data_out(17)<='0';--pin 15 E
						data_out(1) <='0';--pin 2 I0a
						data_out(2) <='0';--pin 3 I1a
						data_out(4) <='0';--pin 5 I0b
						data_out(5) <='0';--pin 6 I1b
						data_out(16)<='0';--pin 14 I0c
						data_out(15)<='0';--pin 13 I1c
						data_out(13)<='0';--pin 11 I0d
						data_out(12)<='0';--pin 10 I1d
						data_out(0) <='0';--pin 1 S
						 
						IF (data_in(3)='0') and (data_in(6)='0') and (data_in(14)='0') and (data_in(11)='0') THEN
						state<=s4; ELSE test_res_flag<='0'; END IF;
						
					WHEN OTHERS=> --E:='0' S:='0' I0:='1' I1:='0' 
						data_out(17)<='0';--pin 15 E
						data_out(1) <='1';--pin 2 I0a
						data_out(2) <='0';--pin 3 I1a
						data_out(4) <='1';--pin 5 I0b
						data_out(5) <='0';--pin 6 I1b
						data_out(16)<='1';--pin 14 I0c
						data_out(15)<='0';--pin 13 I1c
						data_out(13)<='1';--pin 11 I0d
						data_out(12)<='0';--pin 10 I1d
						data_out(0) <='0';--pin 1 S
						 
						IF (data_in(3)='1') and (data_in(6)='1') and (data_in(14)='1') and (data_in(11)='1') THEN
						test_res_flag<='1'; ELSE test_res_flag<='0'; END IF;
																			
				END CASE;
				
	----------------- testing 74240 -------------------
			ELSIF(chip_num=13) THEN --74240-Octal Inverter-20 dip
	
				EN(0)<='1';--enable buffer --pin 1 1G
				EN(1)<='1';--enable buffer --pin 2 1A1
				EN(3)<='1';--enable buffer	--pin 4 1A2
				EN(5)<='1';--enable buffer --pin 6 1A3
				EN(7)<='1';--enable buffer --pin 8 1A4
				EN(9)<='1';--enable buffer --pin 11 2A1
				EN(11)<='1';--enable buffer --pin 13 2A2
				EN(13)<='1';--enable buffer --pin 15 2A3
				EN(15)<='1';--enable buffer --pin 17 2A4
				EN(17)<='1';--enable buffer --pin 19 2G
				
				EN(2)<='0';--unable buffer --pin 3 2Y4
				EN(4)<='0';--unable buffer --pin 5 2Y3
				EN(6)<='0';--unable buffer --pin 7 2Y2
				EN(8)<='0';--unable buffer --pin 9 2Y1
				EN(10)<='0';--unable buffer --pin 12 1Y4
				EN(12)<='0';--unable buffer --pin 14 1Y3
				EN(14)<='0';--unable buffer --pin 16 1Y2		
				EN(16)<='0';--unable buffer --pin 18 1Y1

				gnd_sel(2)<='0';--pin 7
				gnd_sel(1)<='0';--pin 8
				gnd_sel(0)<='0';--pin 9
				gnd_sel(3)<='1';--pin 10-gnd		

				CASE state IS--truth table of 74240
					WHEN s0=> --G:='0' A:='0' 
						data_out(0)<='0';--pin 1 1G
						data_out(1)<='0';--pin 2 1A1
						data_out(3)<='0';--pin 4 1A2
						data_out(5)<='0';--pin 6 1A3
						data_out(7)<='0';--pin 8 1A4
						data_out(9)<='0';--pin 11 2A1
						data_out(11)<='0';--pin 13 2A2
						data_out(13)<='0';--pin 15 2A3
						data_out(15)<='0';--pin 17 2A4
						data_out(17)<='0';--pin 19 2G
						 
						IF (data_in(2)='1') and (data_in(4)='1') and (data_in(6)='1') and (data_in(8)='1' and 
						data_in(10)='1') and (data_in(12)='1') and (data_in(14)='1') and (data_in(16)='1') THEN
						state<=s1; ELSE test_res_flag<='0'; END IF;
						
					WHEN s1=> --G:='0' A:='1' 
						data_out(0)<='0';--pin 1 1G
						data_out(1)<='1';--pin 2 1A1
						data_out(3)<='1';--pin 4 1A2
						data_out(5)<='1';--pin 6 1A3
						data_out(7)<='1';--pin 8 1A4
						data_out(9)<='1';--pin 11 2A1
						data_out(11)<='1';--pin 13 2A2
						data_out(13)<='1';--pin 15 2A3
						data_out(15)<='1';--pin 17 2A4
						data_out(17)<='0';--pin 19 2G
						 
						IF (data_in(2)='0') and (data_in(4)='0') and (data_in(6)='0') and (data_in(8)='0' and 
						data_in(10)='0') and (data_in(12)='0') and (data_in(14)='0') and (data_in(16)='0') THEN
						state<=s2; ELSE test_res_flag<='0'; END IF;
					
					WHEN OTHERS=> --G:='1' A:='1'  
						data_out(0)<='1';--pin 1 1G
						data_out(1)<='1';--pin 2 1A1
						data_out(3)<='1';--pin 4 1A2
						data_out(5)<='1';--pin 6 1A3
						data_out(7)<='1';--pin 8 1A4
						data_out(9)<='1';--pin 11 2A1
						data_out(11)<='1';--pin 13 2A2
						data_out(13)<='1';--pin 15 2A3
						data_out(15)<='1';--pin 17 2A4
						data_out(17)<='1';--pin 19 2G
						 
						IF (data_in(2)='1') and (data_in(4)='1') and (data_in(6)='1') and (data_in(8)='1' and 
						data_in(10)='1') and (data_in(12)='1') and (data_in(14)='1') and (data_in(16)='1') THEN
						test_res_flag<='1'; ELSE test_res_flag<='0'; END IF;
																			
				END CASE;
				
	----------------- testing 74147 -------------------
			ELSIF(chip_num=14) THEN --74147 -10 to 4 Priority Encoder-16 dip
			
				EN(0)<='1';--enable buffer --pin 1 I4
				EN(1)<='1';--enable buffer --pin 2 I5
				EN(2)<='1';--enable buffer --pin 3 I6
				EN(3)<='1';--enable buffer	--pin 4 I7
				EN(4)<='1';--enable buffer --pin 5 I8
				EN(12)<='1';--enable buffer --pin 10 I9
				EN(13)<='1';--enable buffer --pin 11 I1
				EN(14)<='1';--enable buffer --pin 12 I2
				EN(15)<='1';--enable buffer --pin 13 I3
								
				EN(5)<='0';--unable buffer --pin 6 C		
				EN(6)<='0';--unable buffer --pin 7 B
				EN(11)<='0';--unable buffer --pin 9 A	
				EN(16)<='0';--unable buffer --pin 14 D
				EN(17)<='0';--unable buffer --pin 15 NC
				EN(7) <='0';--unable buffer --pin 8 gnd
								
				gnd_sel(2)<='0';--pin 7
				gnd_sel(1)<='1';--pin 8 gnd

				CASE state IS--truth table of 74147
					WHEN s0=>  
						data_out(13)<='1';--pin 11 I1 
						data_out(14)<='1';--pin 12 I2	
						data_out(15)<='1';--pin 13 I3
						data_out(0)<='1';--pin 1 I4
						data_out(1)<='1';--pin 2 I5
						data_out(2)<='1';--pin 3 I6
						data_out(3)<='1';--pin 4 I7
						data_out(4)<='1';--pin 5 I8
						data_out(12)<='1';--pin 10 I9
						 
						IF (data_in(16)='1') and (data_in(5)='1') and (data_in(6)='1') and (data_in(11)='1') THEN
						state<=s1; ELSE test_res_flag<='0'; END IF;
						
					WHEN s1=>
						data_out(13)<='1';--pin 11 I1 
						data_out(14)<='1';--pin 12 I2	
						data_out(15)<='1';--pin 13 I3
						data_out(0)<='1';--pin 1 I4
						data_out(1)<='1';--pin 2 I5
						data_out(2)<='1';--pin 3 I6
						data_out(3)<='1';--pin 4 I7
						data_out(4)<='1';--pin 5 I8
						data_out(12)<='0';--pin 10 I9
											
						IF (data_in(16)='0') and (data_in(5)='1') and (data_in(6)='1') and (data_in(11)='0') THEN
						state<=s2; ELSE test_res_flag<='0'; END IF;
					
					WHEN s2=> 
						data_out(13)<='1';--pin 11 I1 
						data_out(14)<='1';--pin 12 I2	
						data_out(15)<='1';--pin 13 I3
						data_out(0)<='1';--pin 1 I4
						data_out(1)<='1';--pin 2 I5
						data_out(2)<='1';--pin 3 I6
						data_out(3)<='1';--pin 4 I7
						data_out(4)<='0';--pin 5 I8
						data_out(12)<='1';--pin 10 I9
						 
						IF (data_in(16)='0') and (data_in(5)='1') and (data_in(6)='1') and (data_in(11)='1') THEN
						state<=s3; ELSE test_res_flag<='0'; END IF;
						
					WHEN s3=> 
						data_out(13)<='1';--pin 11 I1 
						data_out(14)<='1';--pin 12 I2	
						data_out(15)<='1';--pin 13 I3
						data_out(0)<='1';--pin 1 I4
						data_out(1)<='1';--pin 2 I5
						data_out(2)<='1';--pin 3 I6
						data_out(3)<='0';--pin 4 I7
						data_out(4)<='1';--pin 5 I8
						data_out(12)<='1';--pin 10 I9
						 
						IF (data_in(16)='1') and (data_in(5)='0') and (data_in(6)='0') and (data_in(11)='0') THEN
						state<=s4; ELSE test_res_flag<='0'; END IF;
						
					WHEN s4=> 
						data_out(13)<='1';--pin 11 I1 
						data_out(14)<='1';--pin 12 I2	
						data_out(15)<='1';--pin 13 I3
						data_out(0)<='1';--pin 1 I4
						data_out(1)<='1';--pin 2 I5
						data_out(2)<='0';--pin 3 I6
						data_out(3)<='1';--pin 4 I7
						data_out(4)<='1';--pin 5 I8
						data_out(12)<='1';--pin 10 I9
						 
						IF (data_in(16)='1') and (data_in(5)='0') and (data_in(6)='0') and (data_in(11)='1') THEN
						state<=s5; ELSE test_res_flag<='0'; END IF;
						
					WHEN s5=> 
						data_out(13)<='1';--pin 11 I1 
						data_out(14)<='1';--pin 12 I2	
						data_out(15)<='1';--pin 13 I3
						data_out(0)<='1';--pin 1 I4
						data_out(1)<='0';--pin 2 I5
						data_out(2)<='1';--pin 3 I6
						data_out(3)<='1';--pin 4 I7
						data_out(4)<='1';--pin 5 I8
						data_out(12)<='1';--pin 10 I9
						 
						IF (data_in(16)='1') and (data_in(5)='0') and (data_in(6)='1') and (data_in(11)='0') THEN
						state<=s6; ELSE test_res_flag<='0'; END IF;
						
					WHEN s6=> 
						data_out(13)<='1';--pin 11 I1 
						data_out(14)<='1';--pin 12 I2	
						data_out(15)<='1';--pin 13 I3
						data_out(0)<='0';--pin 1 I4
						data_out(1)<='1';--pin 2 I5
						data_out(2)<='1';--pin 3 I6
						data_out(3)<='1';--pin 4 I7
						data_out(4)<='1';--pin 5 I8
						data_out(12)<='1';--pin 10 I9
						 
						IF (data_in(16)='1') and (data_in(5)='0') and (data_in(6)='1') and (data_in(11)='1') THEN
						state<=s7; ELSE test_res_flag<='0'; END IF;
						
					WHEN s7=> 
						data_out(13)<='1';--pin 11 I1 
						data_out(14)<='1';--pin 12 I2	
						data_out(15)<='0';--pin 13 I3
						data_out(0)<='1';--pin 1 I4
						data_out(1)<='1';--pin 2 I5
						data_out(2)<='1';--pin 3 I6
						data_out(3)<='1';--pin 4 I7
						data_out(4)<='1';--pin 5 I8
						data_out(12)<='1';--pin 10 I9
						 
						IF (data_in(16)='1') and (data_in(5)='1') and (data_in(6)='0') and (data_in(11)='0') THEN
						state<=s8; ELSE test_res_flag<='0'; END IF;
						
					WHEN s8=> 
						data_out(13)<='1';--pin 11 I1 
						data_out(14)<='0';--pin 12 I2	
						data_out(15)<='1';--pin 13 I3
						data_out(0)<='1';--pin 1 I4
						data_out(1)<='1';--pin 2 I5
						data_out(2)<='1';--pin 3 I6
						data_out(3)<='1';--pin 4 I7
						data_out(4)<='1';--pin 5 I8
						data_out(12)<='1';--pin 10 I9
						 
						IF (data_in(16)='1') and (data_in(5)='1') and (data_in(6)='0') and (data_in(11)='1') THEN
						state<=s9; ELSE test_res_flag<='0'; END IF;
						
					WHEN OTHERS=>
						data_out(13)<='0';--pin 11 I1 
						data_out(14)<='1';--pin 12 I2	
						data_out(15)<='1';--pin 13 I3
						data_out(0)<='1';--pin 1 I4
						data_out(1)<='1';--pin 2 I5
						data_out(2)<='1';--pin 3 I6
						data_out(3)<='1';--pin 4 I7
						data_out(4)<='1';--pin 5 I8
						data_out(12)<='1';--pin 10 I9

						IF (data_in(16)='1') and (data_in(5)='1') and (data_in(6)='1') and (data_in(11)='0') THEN
						test_res_flag<='1'; ELSE test_res_flag<='0'; END IF;
																			
				END CASE;
			
			
			ELSE 
			test_res_flag<='0';--resembling other components for now
			
			END IF;	
	END IF;
END IF;

END PROCESS;

END behavior;