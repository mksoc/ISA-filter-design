-- file 'd_flip_flop.vhd'
-- enable and async clear
library ieee;
use ieee.std_logic_1164.all;

entity d_flip_flop is
    port (D: in std_logic;
          clock, clear, enable: in std_logic;
          Q: out std_logic;
end d_flip_flop;

architecture behavior of d_flip_flop is
begin
    process (clock, clear)
    begin
		if (clear = '0') then
			Q <= '0';
		else
			if (clock'event and clock = '1') then
				if (enable = '1') then
					Q <= D;
				end if;
			end if;
        end if;
    end process;
end behavior;