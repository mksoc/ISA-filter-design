library ieee;
use ieee.std_logic_1164.all;

-- nBit : parallelism of data of the filter
-- fOrder : order of the filter
-- bCoeffType, aCoeffType : compact form to express the coefficients. They depend on fOrder

package filter_pkg is
	constant nBit : natural := 12;
	constant fOrder : positive := 3;

	type bCoeffType is array (0 to fOrder-1) of std_logic_vector(nBit-1 downto 0);
	type aCoeffType is array (1 to fOrder-1) of std_logic_vector(nBit-1 downto 0);

	component d_ff is
	port (
		clk,
		rst_n : in std_logic;

		en : in std_logic;

		d : in std_logic;

		q : out std_logic );
	end component;

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
end filter_pkg;