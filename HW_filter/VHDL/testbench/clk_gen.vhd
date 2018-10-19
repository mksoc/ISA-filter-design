library ieee;
use ieee.std_logic_1164.all;

entity clk_gen is
    port (
        end_sim   : in std_logic;
        clock     : out std_logic;
        reset_n   : out std_logic);
end clk_gen;

architecture behavior of clk_gen is

    constant Ts: time := 10 ns;

    signal clock_i: std_logic;

begin -- behavior

    clock_generation: process
    begin -- process
        if (clock_i = 'U') then
            clock_i <= '1';
        else
            clock_i <= not(clock_i);
        end if;
        wait for Ts/2;
    end process;

    clock <= clock_i and not(end_sim);

    reset_generation: process
    begin -- process
        reset_n <= '0';
        wait for 1 * Ts/2;
        reset_n <= '1';
        wait;
    end process;

end behavior;