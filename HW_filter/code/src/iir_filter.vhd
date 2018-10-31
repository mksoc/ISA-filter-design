------------------
--+ iir_filter +--
------------------
-- HW representation of a iir_filter. To change the order of the filter and the
-- number of bit used to encode the signals, refer to the file filter_pkg.vhd.

-- For a schematic, see IIR_filter_schematic.pdf

--+++++++++--
--+ INPUT +--
--+++++++++--
----------------------
--- INPUT CONTROLS ---
----------------------
-- clk : the main clock
-- rst_n : asynchronous complemented reset, asserted if rst_n = '0'
-- vIn : validation signal for dIn. vIn = '1' if the sample dIn is valid and has to be sampled
------------------
--- INPUT DATA ---
------------------
-- dIn : input sample line. dIn represent a single sample of a signal, coded on NB bits in 2's complement

--++++++++++--
--+ OUTPUT +--
--++++++++++--
-----------------------
--- OUTPUT CONTROLS ---
-----------------------
-- vOut : validation signal for dOut. vOut = '1' if the sample dOut is ready
-------------------
--- OUTPUT DATA ---
-------------------
-- dOut : output sample line. dOut represent a single output of a signal, coded on NB bits in 2's complement

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.filter_pkg.all;

entity iir_filter is
    port (
        clk   : in std_logic;
        rst_n : in std_logic;
        vIn   : in std_logic;
        dIn   : in dataType;
        a     : in std_logic_vector((2 * NB - 1) downto 0);
        b     : in std_logic_vector((3 * NB - 1) downto 0);
        dOut  : out dataType;
        vOut  : out std_logic
    );
end entity;

architecture structure of iir_filter is
    -- type and constants definition
    constant PIPE_STAGES: positive := 3;
    constant NUM_OF_SIGNALS: positive := 2;
    type delay_array is array (0 to PIPE_STAGES) of std_logic_vector(0 to NUM_OF_SIGNALS-1); -- the array has one element more, otherwise reg_delay_gen would go out of bound at the last iteration (assign Q to array(i+1))

    -- components declarations
    component iir_filterDP is
        port (
            -- from external world
            clk, rst_n                    : in std_logic;
            dIn                           : in dataType;
            a                             : in aCoeffType;
            b                             : in bCoeffType;
            dOut                          : out dataType;
            -- controls from CU
            input_regs_en, sw_out_regs_en : in std_logic
        );
    end component;

    component iir_filterCU is
        port (
            -- from external world
            clk, rst_n                    : in std_logic;
            vIn                           : in std_logic;
            -- controls to DP
            input_regs_en, sw_out_regs_en : out std_logic;
            -- to external world
            vOut                          : out std_logic
        );
    end component;

    -- signal declarations
    signal input_regs_en_int: std_logic;
    signal b_int                                 : bCoeffType;
    signal a_int                                 : aCoeffType;
    signal delayed_controls: delay_array;

begin
    -- components instantiations
    DP : iir_filterDP
    port map(
        clk            => clk,
        rst_n          => rst_n,
        dIn            => dIn,
        b              => b_int,
        a              => a_int,
        dOut           => dOut,
        input_regs_en  => input_regs_en_int,
        sw_out_regs_en => delayed_controls(PIPE_STAGES)(0)
    );

    CU : iir_filterCU
    port map(
        clk            => clk,
        rst_n          => rst_n,
        vIn            => vIn,
        input_regs_en  => input_regs_en_int,
        sw_out_regs_en => delayed_controls(0)(0),
        vOut           => delayed_controls(0)(1)
    );

    -- delay registers
    reg_delay_gen: for i in 0 to (PIPE_STAGES - 1) generate
        reg_delay: reg
            generic map (N => NUM_OF_SIGNALS)
            port map (
                D => delayed_controls(i),
                clock => clk,
                reset_n => rst_n,
                enable => '1',
                Q => delayed_controls(i+1)
            );
    end generate;

    -- signal assignments
    b_int <= (signed(b((3 * NB - 1) downto 2 * NB)), signed(b((2 * NB - 1) downto NB)), signed(b((NB - 1) downto 0)));
    a_int <= (signed(a((2 * NB - 1) downto NB)), signed(a((NB - 1) downto 0)));
    vOut <= delayed_controls(PIPE_STAGES)(1);

end architecture structure;