library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.filter_pkg.all;

entity iir_filterDP is
	port (
		-- from external world
		clk, rst_n: in std_logic;
		dIn: in dataType;
		coeffs_fb: in aCoeffType;
		coeffs_ff: in bCoeffType;
		dOut: out dataType;
		-- controls from CU
		input_regs_en, sw_regs_en, out_reg_en: in std_logic
	);
end entity;

architecture behavior of iir_filterDP is
	-- signal declarations (refer to scheme for the naming used)
	signal x, y_out: dataType;
	signal ret0, ret1, pipe0_coeff_pipe00, pipe0_coeff_pipe01, pipe0_coeff_pipe02, pipe0_coeff_pipe03, pipe10, pipe11, pipe12, pipe13, sw0_coeff_ret0, sw1_coeff_ret1, fb, ff_part, w, sw0, sw1, sw2, pipe00, pipe01, pipe02, pipe03, ff, y: word;
	signal coeffs_fb_int: aCoeffType;
	signal coeffs_ff_int: bCoeffType;
begin
	-----------------------------
	-- component instantiations
	-----------------------------

	-- input registers
	reg_in: reg
		generic map (N => x'length)
		port map (
			D => std_logic_vector(dIn),
			clock => clk,
			reset_n => rst_n,
			enable => input_regs_en,
			signed(Q) => x
		);
	reg_coeff_fb_gen: for i in aCoeffType'range generate
		reg_coeff_fb_i: reg
			generic map (N => coeffs_fb_int(i)'length)
			port map (
				D => std_logic_vector(coeffs_fb(i)),
				clock => clk,
				reset_n => rst_n,
				enable => input_regs_en,
				signed(Q) => coeffs_fb_int(i)
			);
	end generate;
	reg_b_gen: for i in bCoeffType'range generate
		reg_b_i: reg
			generic map (N => coeffs_ff_int(i)'length)
			port map (
				D => std_logic_vector(coeffs_ff(i)),
				clock => clk,
				reset_n => rst_n,
				enable => input_regs_en,
				signed(Q) => coeffs_ff_int(i)
			);
	end generate;
	
	-- delay line registers
	reg_sw0: reg
		generic map (N => sw0'length)
		port map (
			D => std_logic_vector(w),
			clock => clk,
			reset_n => rst_n,
			enable => sw_regs_en,
			signed(Q) => sw0
		);
	reg_sw1: reg
		generic map (N => sw1'length)
		port map (
			D => std_logic_vector(sw0),
			clock => clk,
			reset_n => rst_n,
			enable => sw_regs_en,
			signed(Q) => sw1
		);
	reg_sw2: reg
		generic map (N => sw2'length)
		port map (
			D => std_logic_vector(sw1),
			clock => clk,
			reset_n => rst_n,
			enable => sw_regs_en,
			signed(Q) => sw2
		);

	-- retiming registers
	reg_ret0: reg
		generic map (N => ret0'length)
		port map (
			D => std_logic_vector(sw0_coeff_ret0),
			clock => clk,
			reset_n => rst_n,
			enable => '1',
			signed(Q) => ret0
		);
	reg_ret1: reg
		generic map (N => ret1'length)
		port map (
			D => std_logic_vector(sw1_coeff_ret1),
			clock => clk,
			reset_n => rst_n,
			enable => '1',
			signed(Q) => ret1
		);

	-- pipeline registers
	reg_pipe00: reg
		generic map (N => pipe00'length)
		port map (
			D => std_logic_vector(w),
			clock => clk,
			reset_n => rst_n,
			enable => '1',
			signed(Q) => pipe00
		);
	reg_pipe01: reg
		generic map (N => pipe01'length)
		port map (
			D => std_logic_vector(sw0),
			clock => clk,
			reset_n => rst_n,
			enable => '1',
			signed(Q) => pipe01
		);
	reg_pipe02: reg
		generic map (N => pipe02'length)
		port map (
			D => std_logic_vector(sw1),
			clock => clk,
			reset_n => rst_n,
			enable => '1',
			signed(Q) => pipe02
		);
	reg_pipe03: reg
		generic map (N => pipe03'length)
		port map (
			D => std_logic_vector(sw2),
			clock => clk,
			reset_n => rst_n,
			enable => '1',
			signed(Q) => pipe03
		);
	reg_pipe10: reg
		generic map (N => pipe10'length)
		port map (
			D => std_logic_vector(pipe0_coeff_pipe00),
			clock => clk,
			reset_n => rst_n,
			enable => '1',
			signed(Q) => pipe10
		);
	reg_pipe11: reg
		generic map (N => pipe11'length)
		port map (
			D => std_logic_vector(pipe0_coeff_pipe01),
			clock => clk,
			reset_n => rst_n,
			enable => '1',
			signed(Q) => pipe11
		);
	reg_pipe12: reg
		generic map (N => pipe12'length)
		port map (
			D => std_logic_vector(pipe0_coeff_pipe02),
			clock => clk,
			reset_n => rst_n,
			enable => '1',
			signed(Q) => pipe12
		);
	reg_pipe13: reg
		generic map (N => pipe13'length)
		port map (
			D => std_logic_vector(pipe0_coeff_pipe03),
			clock => clk,
			reset_n => rst_n,
			enable => '1',
			signed(Q) => pipe13
		);

	-- output register
	reg_out: reg
		generic map (N => dOut'length)
		port map (
			D => std_logic_vector(y_out),
			clock => clk,
			reset_n => rst_n,
			enable => out_reg_en,
			signed(Q) => dOut
		);

	-----------------------------
	-- signal assignments 
	-----------------------------

	-- compute products
	sw0_coeff_ret0 <= multiplyAndRound(coeffs_fb_int(1), sw0);
	sw1_coeff_ret1 <= multiplyAndRound(coeffs_fb_int(2), sw1);
	pipe0_coeff_pipe00 <= multiplyAndRound(coeffs_ff_int(0), pipe00);
	pipe0_coeff_pipe01 <= multiplyAndRound(coeffs_ff_int(1), pipe01);
	pipe0_coeff_pipe02 <= multiplyAndRound(coeffs_ff_int(2), pipe02);
	pipe0_coeff_pipe03 <= multiplyAndRound(coeffs_ff_int(3), pipe03);

	-- compute forward and backward sums
	-- all these resize() (but the one on 'x') are useless as long as 
	-- the parallelism is the same for all internal nodes, 
	-- but they're kept for future development
	fb <= resize(ret0, fb'length) + resize(ret1, fb'length);
	ff_part <= resize(pipe12, ff_part'length) + resize(pipe13, ff_part'length);
	ff <= resize(pipe11, ff'length) + resize(ff_part, ff'length);
	w <= resize(x & "00000000000", w'length) - resize(fb, w'length); -- shift left input sample to be Q1.22

	-- compute output sample with saturation
	-- remove the rightmost fractional part to end up
	-- with a Q(WL_INT).(11) number, and then check if 
	-- saturation is needed (overflow occurred and didn't resolve internally)
	y <= shift_right(resize(pipe10, y'length) + resize(ff, y'length), NB - 1); -- y is Q(WL_INT + 11).(11)
	sat_process: process(y)
	begin
		if (to_integer(y) >  2**(NB - 1) - 1) then
			y_out <= to_signed(2**(NB - 1) - 1, NB);
		elsif (to_integer(y) < -2**(NB - 1)) then
			y_out <= to_signed(-2**(NB - 1), NB);
		else
			y_out <= resize(y, NB);
		end if;
	end process ; -- sat_process
end architecture behavior;