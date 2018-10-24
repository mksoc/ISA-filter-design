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
        a     : in std_logic_vector((2*NB - 1) downto 0);
        b     : in std_logic_vector((3*NB - 1) downto 0);
        dOut  : out dataType;
        vOut  : out std_logic
    );
end entity;

architecture structure of iir_filter is
    -- components declarations
    component iir_filterDP is
        port (
            -- from external world
            clk                                                   : in std_logic;
            dIn                                                   : in dataType;
            a                                                     : in aCoeffType;
            b                                                     : in bCoeffType;
            dOut                                                  : out dataType;
            -- controls from CU
            regs_clr, reg_in_en, reg_coeff_en, reg_sw0_en, reg_sw1_en, reg_out_en : in std_logic
        );
    end component;

    component iir_filterCU is
        port (
            -- from external world
            clk, rst_n                                            : in std_logic;
            vIn                                                   : in std_logic;
            -- controls to DP
            regs_clr, reg_in_en, reg_coeff_en, reg_sw0_en, reg_sw1_en, reg_out_en : out std_logic;
            -- to external world
            vOut                                                  : out std_logic
        );
    end component;

    -- signal declarations
    signal regs_clr_int, reg_in_en_int, reg_coeff_en_int, reg_sw0_en_int, reg_sw1_en_int, reg_out_en_int: std_logic;
    signal b_int: bCoeffType;
    signal a_int: aCoeffType;

begin
    -- components instantiations
    DP : iir_filterDP
    port map(
        clk        => clk,
        dIn        => dIn,
        b          => b_int,
        a          => a_int,
        dOut       => dOut,
        regs_clr   => regs_clr_int,
        reg_in_en   => reg_in_en_int,
        reg_coeff_en => reg_coeff_en_int,
        reg_sw0_en => reg_sw0_en_int,
        reg_sw1_en => reg_sw1_en_int,
        reg_out_en  => reg_out_en_int
    );

    CU : iir_filterCU
    port map(
        clk        => clk,
        rst_n      => rst_n,
        vIn        => vIn,
        regs_clr   => regs_clr_int,
        reg_in_en   => reg_in_en_int,
        reg_coeff_en => reg_coeff_en_int,
        reg_sw0_en => reg_sw0_en_int,
        reg_sw1_en => reg_sw1_en_int,
        reg_out_en  => reg_out_en_int,
        vOut       => vOut
    );

    -- signal assignments
    b_int <= (signed(b((3*NB - 1) downto 2*NB)), signed(b((2*NB - 1) downto NB)), signed(b((NB - 1) downto 0)));
    a_int <= (signed(a((2*NB - 1) downto NB)), signed(a((NB - 1) downto 0)));

end architecture structure;