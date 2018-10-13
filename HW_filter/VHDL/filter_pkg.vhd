library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- NB : parallelism of data of the filter
-- N : order of the filter
-- bCoeffType, aCoeffType : compact form to express the coefficients. They depend on N

package filter_pkg is
	constant NB : natural := 12;
	constant N : positive := 3;

	type bCoeffType is array (0 to N-1) of signed(NB-1 downto 0);
	type aCoeffType is array (1 to N-1) of signed(NB-1 downto 0);

	component d_flip_flop is
		port (D: in std_logic;
			  clock, clear, enable: in std_logic;
			  Q: out std_logic;
	end component;

	component reg is
		generic (N: positive := 8);
		port (D: in std_logic_vector(N-1 downto 0);
			  clock, clear, enable: in std_logic;
			  Q: out std_logic_vector(N-1 downto 0));
	end component;
end filter_pkg;