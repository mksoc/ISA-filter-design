library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package filter_pkg is
	-- constant declarations
	constant NB : natural := 12; -- number of bits of data
	constant N : positive := 3; -- filter order

	-- types declarations
	type bCoeffType is array (0 to N-1) of signed(NB-1 downto 0);
	type aCoeffType is array (1 to N-1) of signed(NB-1 downto 0);

	-- components declarations
	component reg is
		generic (N: positive := 8);
		port (D: in std_logic_vector(N-1 downto 0);
			  clock, clear, enable: in std_logic;
			  Q: out std_logic_vector(N-1 downto 0));
	end component;
end filter_pkg;