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
		b: in bCoeffType;
		a: in aCoeffType;
		dOut: out dataType;
		-- controls from CU
		regs_clr, inReg_en, reg_sw0_en, reg_sw1_en, outReg_en: in std_logic
	);
end entity;

architecture behavior of iir_filterDP is
	-- signal declarations (refer to scheme for the naming used)
	signal x, sw0_a1, sw1_a2, w_b0, sw0_b1, sw1_b2, y: dataType;
	signal fb, ff: signed(dataType'high + 1 downto 0);
	signal w, sw0, sw1: signed(dataType'high + 2 downto 0);

begin
	-- component instantiations
	inReg: reg
		generic map (N => NB)
		port map (
			D => std_logic_vector(dIn),
			clock => clk,
			clear => regs_clr,
			enable => inReg_en,
			signed(Q) => x
		);
	
	reg_sw0: reg
		generic map (N => NB+2)
		port map (
			D => std_logic_vector(w),
			clock => clk,
			clear => regs_clr,
			enable => reg_sw0_en,
			signed(Q) => sw0
		);

	reg_sw1: reg
		generic map (N => NB+2)
		port map (
			D => std_logic_vector(sw0),
			clock => clk,
			clear => regs_clr,
			enable => reg_sw1_en,
			signed(Q) => sw1
		);

	outReg: reg
		generic map (N => NB)
		port map (
			D => std_logic_vector(y),
			clock => clk,
			clear => regs_clr,
			enable => outReg_en,
			signed(Q) => dOut
		);

	-- signal assignments 
	sw0_a1 <= multiplyAndRound(a(1), sw0);
	sw1_a2 <= multiplyAndRound(a(2), sw1);
	sw0_b1 <= multiplyAndRound(b(1), sw0);
	sw1_b2 <= multiplyAndRound(b(2), sw1);
	fb <= sw0_a1 + sw1_a2;
	ff <= sw0_b1 + sw1_b2;
	w <= x + fb;
	w_b0 <= multiplyAndRound(b(0), w);
	y <= w_b0 + ff;
	
end architecture behavior;