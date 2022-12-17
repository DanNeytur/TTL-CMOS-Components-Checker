library ieee;
use ieee.std_logic_1164.all;
entity one_shot is
port( trig,clk		 : in bit; --PB KEY0 -- PIN_G26
		one_shot_out : buffer bit);--'0' when pushed else '1' -- LEDG4 -- PIN_U18
end;

architecture behave of one_shot is
signal cnt:integer range 0 to 50350000;--1 sec clk=50Mhz
signal clr:bit;
begin

diff_process: process(trig,clr)
	begin 
	if clr='0' then one_shot_out<='1';
	elsif trig'event and trig='0' then
	one_shot_out<='0';
	end if;
end process diff_process;

counter_process: process(clk,clr)
		begin
		if clr='0' then cnt<=0;
		elsif clk'event and clk='1' then
		if one_shot_out='0' then cnt<=cnt+1; end if;
		end if;
end process counter_process;

clr<='0' when cnt=50350000 else '1'; --cnt=2517500 else '1';
end behave;