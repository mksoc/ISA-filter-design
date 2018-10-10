library ieee;
use ieee.std_logic_1164.all;

package filter_pkg is
	constant nBit : natural := 12;
	constant fOrder : positive := 3;

	type bCoeffType is array (0 to fOrder-1) of std_logic_vector(nBit-1 downto 0);
	type aCoeffType is array (1 to fOrder-1) of std_logic_vector(nBit-1 downto 0);
end filter_pkg;