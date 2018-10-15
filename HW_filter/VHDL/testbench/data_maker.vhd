library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric.std.all;
use ieee.std_logic_textio.all;

library std;
use std.textio.all;

library work;
use work.filter_pkg.all;

entity data_maker is
    port (
        clock   : in std_logic;
        reset_n : in std_logic;
        vOut    : out std_logic;    -- these are vIn and 
        dOut    : out dataType;     -- dIn of the UUT
        b       : out bCoeffType;
        a       : out aCoeffType;
        end_sim : out std_logic
    );
end data_maker;

architecture behavior of data_maker is

    constant tco       : time := 1 ns;

    signal sEndSim     : std_logic;
    signal end_sim_int : std_logic_vector(0 to 10);

begin -- behavior
    -- assign coefficients
    b <= (to_signed(423, dataType'length), to_signed(846, dataType'length), to_signed(423, dataType'length));
    a <= (to_signed(-757, dataType'length), to_signed(401, dataType'length));

    read_file: process (clock, reset_n)
        file fp_in       : text open READ_MODE is "../../common/samples.txt";
        variable line_in : line;
        variable x       : integer;
    begin -- process
        if reset_n = '0' then -- asynchronous reset (active low)
            dOut    <= (others => '0') after tco;
            vOut    <= '0' after tco;
            sEndSim <= '0' after tco;
        elsif clock'event and clock = '1' then -- rising clock edge
            if not endfile(fp_in) then
                readline(fp_in, line_in);
                read(line_in, x);
                dOut    <= to_signed(x, dataType'length) after tco;
                vOut    <= '1' after tco;
                sEndSim <= '0' after tco;
            else
                vOut    <= '0' after tco;
                sEndSim <= '1' after tco;
            end if;
        end if;
    end process;

    end_simulation: process (clock, reset_n)
    begin -- process
        if reset_n = '0' then -- asynchronous reset (active low)
            end_sim_int <= (others => '0') after tco;
        elsif clock'event and clock = '1' then -- rising clock edge
            end_sim_int(0)       <= sEndSim after tco;
            end_sim_int(1 to 10) <= end_sim_int(0 to 9) after tco;
        end if;
    end process;

    end_sim <= end_sim_int(10);

end behavior;