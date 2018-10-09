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
y_k : std_logic_vector(nBit-1 downto 0);

begin

-- registers

reg_in : reg 
generic map (
	nBit => nBit )
port map (
	clk => clk,
	rst_n => rst_n,
	en => vIn,
	d => dIn,
	q => x_k );

reg_sw0 : reg 
generic map (
	nBit => nBit )
port map (
	clk => clk,
	rst_n => rst_n,
	en => vIn,
	d => w,
	q => sw0 );

reg_sw1 : reg 
generic map (
	nBit => nBit )
port map (
	clk => clk,
	rst_n => rst_n,
	en => vIn,
	d => sw0,
	q => sw1 );

reg_out : reg 
generic map (
	nBit => nBit )
port map (
	clk => clk,
	rst_n => rst_n,
	en => vIn,
	d => y_k,
	q => dOut );

-- multipliers

b0_mult : 
process (w, b(0))
	variable in0 : signed(nBit-1 downto 0) := signed(w);
	variable in1 : signed(nBit-1 downto 0) := signed(b(0));
	variable out0 : signed(2*nBit-1 downto 0) := in0 * in1;
begin
	out0 := in0 * in1;
	w_b0 <= std_logic_vector(out0(nBit-1 downto 0));
end process;

b1_mult : 
process (sw0, b(1))
	variable in0 : signed(nBit-1 downto 0) := signed(sw0);
	variable in1 : signed(nBit-1 downto 0) := signed(b(1));
	variable out0 : signed(2*nBit-1 downto 0) := in0 * in1;
begin
	out0 := in0 * in1;
	sw0_b1 <= std_logic_vector(out0(nBit-1 downto 0));
end process;

b2_mult : 
process (sw1, b(2))
	variable in0 : signed(nBit-1 downto 0) := signed(sw1);
	variable in1 : signed(nBit-1 downto 0) := signed(b(2));
	variable out0 : signed(2*nBit-1 downto 0) := in0 * in1;
begin
	out0 := in0 * in1;
	sw1_b2 <= std_logic_vector(out0(nBit-1 downto 0));
end process;

a0_mult :
process (sw0, a(1))
	variable in0 : signed(nBit-1 downto 0) := signed(sw0);
	variable in1 : signed(nBit-1 downto 0) := signed(a(1));
	variable out0 : signed(2*nBit-1 downto 0) := in0 * in1;
begin
	out0 := in0 * in1;
	sw0_a1 <= std_logic_vector(out0(nBit-1 downto 0));
end process;

a1_mult :
process (sw1, a(2))
	variable in0 : signed(nBit-1 downto 0) := signed(sw1);
	variable in1 : signed(nBit-1 downto 0) := signed(a(2));
	variable out0 : signed(2*nBit-1 downto 0) := in0 * in1;
begin
	out0 := in0 * in1;
	sw1_a2 <= std_logic_vector(out0(nBit-1 downto 0));
end process;

-- adders

w_add :
process (x_k, fb)
	variable in0 : signed(nBit-1 downto 0) := signed(x_k);
	variable in1 : signed(nBit-1 downto 0) := signed(fb);
	variable out0 : signed(nBit-1 downto 0) := in0 + in1;
begin
	out0 := in0 + in1;
	w <= std_logic_vector(out0);
end process;

fb_add :
process (sw0_a1, sw1_a2)
	variable in0 : signed(nBit-1 downto 0) := signed(sw0_a1);
	variable in1 : signed(nBit-1 downto 0) := signed(sw1_a2);
	variable out0 : signed(nBit-1 downto 0) := in0 + in1;
begin
	out0 := in0 + in1;
	fb <= std_logic_vector(out0);
end process;

ff_add :
process (sw0_b1, sw1_b2)
	variable in0 : signed(nBit-1 downto 0) := signed(sw0_b1);
	variable in1 : signed(nBit-1 downto 0) := signed(sw1_b2);
	variable out0 : signed(nBit-1 downto 0) := in0 + in1;
begin
	out0 := in0 + in1;
	ff <= std_logic_vector(out0);
end process;

y_k_add :
process (w_b0, ff)
	variable in0 : signed(nBit-1 downto 0) := signed(w_b0);
	variable in1 : signed(nBit-1 downto 0) := signed(ff);
	variable out0 : signed(nBit-1 downto 0) := in0 + in1;
begin
	out0 := in0 + in1;
	y_k <= std_logic_vector(out0);
end process;

end architecture;