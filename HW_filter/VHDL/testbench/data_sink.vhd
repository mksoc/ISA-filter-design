library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;

library std;
use std.textio.all;

library work;
use work.filter_pkg.all;

entity data_sink is
    port (
        clock   : in std_logic;
        reset_n : in std_logic;
        vIn     : in std_logic;
        dIn     : in dataType;
end data_sink;

architecture behavior of data_sink is

begin -- behavior

    process (clock, reset_n)
        file res_fp       : text open WRITE_MODE is "../../common/results-hw.txt";
        variable line_out : line;
    begin -- process
        if reset_n = '0' then -- asynchronous reset (active low)
            null;
        elsif clock'event and clock = '1' then -- rising clock edge
            if (vIn = '1') then
                write(line_out, to_integer(dIn));
                writeline(res_fp, line_out);
            end if;
        end if;
    end process;

end behavior;