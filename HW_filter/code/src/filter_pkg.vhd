library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package filter_pkg is
	-- constant declarations
	constant NB : natural := 12; -- number of bits for input/output (Q1.11)
	constant N : positive := 3; -- filter order
	constant INSERT_PAUSE: boolean := false; -- allows pauses between input samples
	-- new coefficients are expressed on 22 bits (Q1.21)
	-- we keep the fractional part constant and allow for the integer part to grow to fill 2 bits
	-- so that the internal computation is done on Q2.21 numbers
	constant WL: natural := 24; -- WL stands for word length
	constant WL_INT: natural := 2; 
	constant WL_FRAC: natural := 22;	

	-- types declarations
	subtype dataType is signed(NB-1 downto 0);
	subtype word is signed(WL-1 downto 0);
	type aCoeffType is array (1 to N-1) of word;
	type bCoeffType is array (0 to N) of word;

	-- components declarations
	component reg is
		generic (N: positive := 8);
		port (D: in std_logic_vector(N-1 downto 0);
			  clock, reset_n, enable: in std_logic;
			  Q: out std_logic_vector(N-1 downto 0));
	end component;

	-- functions declarations
	-- multiplyAndRound() takes a coefficient expressed in Q(WL_INT).(WL_FRAC)
	-- and a sample (actually internal data) on a variable numbers of bits (in case 
	-- parallelism of the integer part is changed and tailored to each section of the filter)
	-- let's say Q(S_INT).(WL_FRAC), with S_INT >= WL_INT
	function multiplyAndRound(coeff: word; sample: signed) return word;
end package filter_pkg;

package body filter_pkg is
	function multiplyAndRound(coeff: word; sample: signed) return word is
		-- the coefficient gets resized (sign extended) to Q(S_INT).(WL_FRAC)
		-- temp is Q(2*S_INT).(2*WL_FRAC)
		variable temp: signed((2*sample'length - 1) downto 0) := resize(coeff, sample'length) * sample;
		variable result: word; -- result is again Q(WL_INT).(WL_FRAC)
	begin
		-- temp needs to be shifted right of WL_FRAC positions (e.g. Q(2*S_INT + WL_FRAC).(WL_FRAC))
		-- and then resized (leftmost part removed) to be Q(WL_INT).(WL_FRAC)
		result := resize(shift_right(temp, WL_FRAC), result'length);
		return result;
	end function;
end package body filter_pkg;