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

library work;
use work.filter_pkg.all;

entity iir_filter is
    port (
        clk   : in std_logic;
        rst_n : in std_logic;
        vIn   : in std_logic;
        dIn   : in dataType;
        b     : in bCoeffType;
        a     : in aCoeffType;
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
            b                                                     : in bCoeffType;
            a                                                     : in aCoeffType;
            dOut                                                  : out dataType;
            -- controls from CU
            regs_clr, inReg_en, reg_sw0_en, reg_sw1_en, outReg_en : in std_logic
        );
    end component;

    component iir_filterCU is
        port (
            -- from external world
            clk, rst_n                                            : in std_logic;
            vIn                                                   : in std_logic;
            -- controls to DP
            regs_clr, inReg_en, reg_sw0_en, reg_sw1_en, outReg_en : in std_logic;
            -- to external world
            vOut                                                  : out std_logic
        );
    end component;

    -- signal declarations
    regs_clr_int, inReg_en_int, reg_sw0_en_int, reg_sw1_en_int, outReg_en_int : in std_logic;

begin
    -- components instantiations
    DP : iir_filterDP
    port map(
        clk        => clk,
        dIn        => dIn,
        b          => b,
        a          => a,
        dOut       => dOut,
        regs_clr   => regs_clr_int,
        inReg_en   => inReg_en_int,
        reg_sw0_en => reg_sw0_en_int,
        reg_sw1_en => reg_sw1_en_int,
        outReg_en  => outReg_en_int
    );

    CU : iir_filterCU
    port map(
        clk        => clk,
        rst_n      => rst_n,
        vIn        => vIn,
        regs_clr   => regs_clr_int,
        inReg_en   => inReg_en_int,
        reg_sw0_en => reg_sw0_en_int,
        reg_sw1_en => reg_sw1_en_int,
        outReg_en  => outReg_en_int,
        vOut       => vOut
    );
end architecture structure;