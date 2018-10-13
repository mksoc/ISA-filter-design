-- file 'ff_d.vhd'
-- enable and async clear
library ieee;
use ieee.std_logic_1164.all;

entity ff_d is
    port (D: in std_logic;
          clock, clear, enable: in std_logic;
          Q: out std_logic;
end ff_d;

architecture behavior of ff_d is
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