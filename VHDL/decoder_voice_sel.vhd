LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY decoder_voice_sel is
PORT(	clk 			: IN STD_LOGIC; --system clock clk=50MHZ
		voice_num	: IN  INTEGER RANGE 0 TO 8;
		trig_voice	: IN STD_LOGIC;
		voice_sel	: OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
END;

ARCHITECTURE behave OF decoder_voice_sel IS
SIGNAL cnt				:INTEGER RANGE 0 TO 50350000;--1 sec clk=50Mhz
SIGNAL clr,one_shot	:BIT;
BEGIN

diff_process: process(trig_voice,clr)
begin 
	if clr='0' then one_shot<='1';
	elsif trig_voice'event and trig_voice='0' then
		one_shot<='0';
end if;
end process diff_process;

counter_process: process(clk,clr)
begin
	if clr='0' then cnt<=0;
	elsif clk'event and clk='1' then
	if one_shot='0' then cnt<=cnt+1; end if;
end if;

IF(one_shot='0')THEN
	CASE voice_num IS
		WHEN 0=> voice_sel<="11111110";--welcome
		WHEN 1=> voice_sel<="11111101";--choose a function
		WHEN 2=> voice_sel<="11111011";--choose a component
		WHEN 3=> voice_sel<="11110111";--component working
		WHEN 4=> voice_sel<="11101111";--component malfunction
		WHEN 5=> voice_sel<="11011111";--component is flipped
		WHEN 6=> voice_sel<="10111111";--no component was identified
		WHEN 7=> voice_sel<="01111111";--component was identified
		WHEN 8=> voice_sel<="11111111";--no voice record active
	END CASE;
ELSE 
	voice_sel<="11111111";--no voice record active
END IF;
end process counter_process;

clr<='0' WHEN cnt=50350000 ELSE '1'; --cnt=2517500 else '1';

END behave;