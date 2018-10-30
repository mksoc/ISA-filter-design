library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package filter_pkg is
	-- constant declarations
	constant NB : natural := 12; -- number of bits of data
	constant N : positive := 3; -- filter order
	constant insert_pause: boolean := false;

	-- types declarations
	subtype dataType is signed(NB-1 downto 0);
	type aCoeffType is array (1 to N-1) of dataType;
	type bCoeffType is array (0 to N-1) of dataType;

	-- components declarations
	component reg is
		generic (N: positive := 8);
		port (D: in std_logic_vector(N-1 downto 0);
			  clock, reset_n, enable: in std_logic;
			  Q: out std_logic_vector(N-1 downto 0));
	end component;

	-- functions declarations
	function multiplyAndRound(coeff: signed; sample: signed) return signed;
end package filter_pkg;

package body filter_pkg is
	function multiplyAndRound(coeff: signed; sample: signed) return signed is
		variable temp: signed((2*sample'length - 1) downto 0) := resize(coeff, sample'length) * sample;
		variable result: signed(coeff'range);
	begin
		result := resize(shift_right(temp, temp'length - result'length - 1), result'length);
		return result;
	end function;
end package body filter_pkg;