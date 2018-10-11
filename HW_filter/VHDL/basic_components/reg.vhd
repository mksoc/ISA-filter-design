library ieee;
use ieee.std_logic_1164.all;

entity reg is
generic (
	nBit : natural := 8 );
port (
	clk,
	rst_n : in std_logic;

	en : in std_logic;

	d : in std_logic_vector(nBit-1 downto 0);

	q : out std_logic_vector(nBit-1 downto 0) );
end entity;

architecture structure of reg is

component d_ff is
port (
	clk,
	rst_n : in std_logic;

	en : in std_logic;

	d : in std_logic;

	q : out std_logic );
end component;

begin

reg_structure : 
	for i in nBit-1 downto 0 generate
		dff : d_ff port map (
			clk => clk,
			rst_n => rst_n,
			en => en,
			d => d(i),
			q => q(i) );
	end generate;

end architecture;