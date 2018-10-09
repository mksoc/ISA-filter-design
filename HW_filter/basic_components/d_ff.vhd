library ieee;
use ieee.std_logic_1164.all;

entity d_ff is
port (
	clk,
	rst_n : in std_logic;

	en : in std_logic;

	d : in std_logic;

	q : out std_logic );
end entity;

architecture behaviour of d_ff is
begin

beh_process : process(clk, rst_n)
begin
	if (rst_n = '0') then
		q <= '0';
	else
		if (clk'event and clk = '1') then
			if (en = '1') then
				q <= d;
			end if;
		end if;
	end if;
end process;

end architecture;