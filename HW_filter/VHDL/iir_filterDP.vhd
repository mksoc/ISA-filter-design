library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.filter_pkg.all;

entity iir_filterDP is
	port (
		-- from external world
		clk: in std_logic;
		dIn: in dataType;
		a: in aCoeffType;
		b: in bCoeffType;
		dOut: out dataType;
		-- controls from CU
		regs_clr, reg_in_en, reg_coeff_en, reg_sw0_en, reg_sw1_en, reg_out_en: in std_logic
	);
end entity;

architecture behavior of iir_filterDP is
	-- signal declarations (refer to scheme for the naming used)
	signal x, sw0_a1, sw1_a2, w_b0, sw0_b1, sw1_b2, fb, ff, sw0, sw1, y: dataType;
	signal w: signed(dataType'high + 1 downto 0);
	signal a_int: aCoeffType;
	signal b_int: bCoeffType;

begin
	-- component instantiations
	reg_in: reg
		generic map (N => NB)
		port map (
			D => std_logic_vector(dIn),
			clock => clk,
			clear => regs_clr,
			enable => reg_in_en,
			signed(Q) => x
		);

	reg_a_gen: for i in aCoeffType'range generate
		reg_a_i: reg
			generic map (N => NB)
			port map (
				D => std_logic_vector(a(i)),
				clock => clk,
				clear => regs_clr,
				enable => reg_coeff_en,
				signed(Q) => a_int(i)
			);
	end generate;

	reg_b_gen: for i in bCoeffType'range generate
		reg_b_i: reg
			generic map (N => NB)
			port map (
				D => std_logic_vector(b(i)),
				clock => clk,
				clear => regs_clr,
				enable => reg_coeff_en,
				signed(Q) => b_int(i)
			);
	end generate;
	
	reg_sw0: reg
		generic map (N => NB)
		port map (
			D => std_logic_vector(resize(w, NB)),
			clock => clk,
			clear => regs_clr,
			enable => reg_sw0_en,
			signed(Q) => sw0
		);

	reg_sw1: reg
		generic map (N => NB)
		port map (
			D => std_logic_vector(sw0),
			clock => clk,
			clear => regs_clr,
			enable => reg_sw1_en,
			signed(Q) => sw1
		);

	reg_out: reg
		generic map (N => NB)
		port map (
			D => std_logic_vector(y),
			clock => clk,
			clear => regs_clr,
			enable => reg_out_en,
			signed(Q) => dOut
		);

	-- signal assignments 
	sw0_a1 <= multiplyAndRound(a_int(1), sw0);
	sw1_a2 <= multiplyAndRound(a_int(2), sw1);
	sw0_b1 <= multiplyAndRound(b_int(1), sw0);
	sw1_b2 <= multiplyAndRound(b_int(2), sw1);
	fb <= sw0_a1 + sw1_a2;
	ff <= sw0_b1 + sw1_b2;
	w <= resize(x, w'length) - resize(fb, w'length);
	w_b0 <= multiplyAndRound(b_int(0), w);
	y <= w_b0 + ff;
	
end architecture behavior;