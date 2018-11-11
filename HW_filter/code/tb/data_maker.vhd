library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use ieee.math_real.all;

library std;
use std.textio.all;

library work;
use work.filter_pkg.all;

entity data_maker is
    generic (IN_PATH: string := "../common");
    port (
        clock   : in std_logic;
        reset_n : in std_logic;
        vOut    : out std_logic;    -- these are vIn and 
        dOut    : out dataType;     -- dIn of the UUT
        coeffs_fb      : out std_logic_vector(2*word'length - 1 downto 0);
        coeffs_ff       : out std_logic_vector(4*word'length - 1 downto 0);
        end_sim : out std_logic
    );
end data_maker;

architecture behavior of data_maker is
    -- signal declarations
    signal coeffs_ff_int: bCoeffType;
    signal coeffs_fb_int: aCoeffType;

    constant tco       : time := 1 ns;

    signal sEndSim     : std_logic;
    signal end_sim_int : std_logic_vector(0 to 10);

begin -- behavior
    -- assign coefficients
    coeff_proc: process
        variable a1: integer := -757;
        variable a2: integer := 401;
        variable b0: integer := 423;
        variable b1: integer := 846;
        variable b2: integer := 423;
    begin
        coeffs_fb_int <= (to_signed(- a1*a1 + a2*(2**(WL_FRAC - (NB - 1))), word'length), 
                    to_signed(- a1*a2, word'length));
        coeffs_ff_int <= (to_signed(b0*(2**(WL_FRAC - (NB - 1))), word'length), 
                    to_signed(b1*(2**(WL_FRAC - (NB - 1))) - a1*b0, word'length),
                    to_signed(b2*(2**(WL_FRAC - (NB - 1))) - a1*b1, word'length),
                    to_signed(- a1*b2, word'length));
        wait;
    end process ; 

    coeffs_fb <= std_logic_vector(coeffs_fb_int(1)) & std_logic_vector(coeffs_fb_int(2));
    coeffs_ff <= std_logic_vector(coeffs_ff_int(0))& std_logic_vector(coeffs_ff_int(1)) & std_logic_vector(coeffs_ff_int(2)) & std_logic_vector(coeffs_ff_int(3));

    read_file: process
        file fp_in          : text open READ_MODE is IN_PATH & "/samples.txt";
        variable line_in    : line;
        variable x          : integer;
        -- for random pause generator
        variable seed1, seed2: positive;
        variable rand: real;
        variable rand_range: real := 10.0;
        variable pause: integer;
    begin -- process
        if reset_n = '0' then -- asynchronous reset (active low)
            dOut    <= (others => '0') after tco;
            vOut    <= '0' after tco;
            sEndSim <= '0' after tco;
        elsif clock'event and clock = '1' then -- rising clock edge
            if not endfile(fp_in) then
                readline(fp_in, line_in);
                read(line_in, x);
                
                -- insert pauses
                if INSERT_PAUSE then
                    uniform(seed1, seed2, rand);
                    pause := integer(rand*rand_range);
                    wait_loop : for i in 0 to pause loop
                        vOut <= '0';
                        wait until clock'event and clock = '1';
                    end loop ; -- wait_loop
                end if;

                dOut    <= to_signed(x, dataType'length) after tco;
                vOut    <= '1' after tco;
                sEndSim <= '0' after tco;
            else
                vOut    <= '0' after tco;
                sEndSim <= '1' after tco;
            end if;
        end if;
        wait on clock, reset_n;
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