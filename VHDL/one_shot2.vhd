library ieee;
use ieee.std_logic_1164.all;
entity one_shot2 is
port( trig2,clk		 : in bit; --PB KEY1 PIN_N23
		one_shot_out2 : buffer bit);--'0' when pushed else '1' --LEDG5 -- PIN_U17
end;

architecture behave of one_shot2 is
signal cnt:integer range 0 to 50350000;--1 sec clk=50Mhz
signal clr:bit;
begin

diff_process: process(trig2,clr)
	begin 
	if clr='0' then one_shot_out2<='1';
	elsif trig2'event and trig2='0' then
	one_shot_out2<='0';
	end if;
end process diff_process;

counter_process: process(clk,clr)
		begin
		if clr='0' then cnt<=0;
		elsif clk'event and clk='1' then
		if one_shot_out2='0' then cnt<=cnt+1; end if;
		end if;
end process counter_process;

clr<='0' when cnt=50350000 else '1'; --cnt=2517500 else '1';
end behave;