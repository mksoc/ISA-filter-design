library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use filter_pkg.all;

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

component reg is
generic (
	nBit : natural := 8 );
port (
	clk,
	rst_n : in std_logic;

	en : in std_logic;

	d : in std_logic_vector(nBit-1 downto 0);

	q : out std_logic_vector(nBit-1 downto 0) );
end component;

signal
x_k,
fb,
ff,
w,
w_b0,
sw0,
sw1,
sw0_a1,
sw0_b1,
sw1_a2,
sw1_b2,
y_k : std_logic_vector(nBin-1 downto 0);

begin

reg_in : reg 
port map (
	clk => clk,
	rst_n => rst_n,
	en => vIn,
	d => dIn,
	q => x_k );

reg_sw0 : reg 
port map (
	clk => clk,
	rst_n => rst_n,
	en => vIn,
	d => w,
	q => sw0 );

reg_sw1 : reg 
port map (
	clk => clk,
	rst_n => rst_n,
	en => vIn,
	d => sw0,
	q => sw1 );

reg_out : reg 
port map (
	clk => clk,
	rst_n => rst_n,
	en => vIn,
	d => y_k,
	q => dOut );

end architecture;