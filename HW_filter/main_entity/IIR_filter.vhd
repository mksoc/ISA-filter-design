library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.filter_pkg.all;

------------------
--+ IIR_filter +--
------------------
-- HW representation of a IIR_filter. To change the order of the filter and the
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
-- dIn : input sample line. dIn represent a single sample of a signal, coded on nBit bits in 2's complement

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
-- dOut : output sample line. dOut represent a single output of a signal, coded on nBit bits in 2's complement

entity IIR_filter is
	port (
	clk, 
	rst_n : in std_logic;

	dIn : in std_logic_vector(nBit-1 downto 0);
	
	vIn : in std_logic;

	b : in bCoeffType;
	a : in aCoeffType;

	dOut : out std_logic_vector(nBit-1 downto 0);

	vOut : out std_logic );
end entity;

architecture behaviour of IIR_filter is

component IIR_filter_CU
port (
	clk,
	rst_N : in std_logic;

	vIn : in std_logic;

	reg_en,
	reg_rst_N : out std_logic;

	vOut : out std_logic );
end component;

component IIR_filter_DP
port (
	clk : in std_logic;

	dIn : in std_logic_vector(nBit-1 downto 0);

	reg_en,
	reg_rst_N : in std_logic;

	dOut : out std_logic_vector(nBit-1 downto 0) );
end component;

signal
reg_en,
reg_rst_n : std_logic;

begin

CU : IIR_filter_CU
port map (
	clk => clk,
	rst_N => rst_N,
	vIn => vIn,
	reg_en => reg_en,
	reg_rst_N => reg_rst_N,
	vOut => vOut );

DP : IIR_filter_DP
port map (
	clk => clk,
	dIn => dIn,
	reg_en => reg_en,
	reg_rst_N => reg_rst_N,
	dOut => dOut );

end architecture;