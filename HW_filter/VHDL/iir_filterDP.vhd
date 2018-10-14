library work;
use work.filter_pkg.all;

entity iir_filterDP is
port (
	-- from external world
	clk : in std_logic;
	dIn : in dataType;
	b : in bCoeffType;
	a : in aCoeffType;
	dOut : out dataType;
	-- controls from CU
	regs_clr, inReg_en, reg_sw0_en, reg_sw1_en, outReg_en: in std_logic
);
end entity;

architecture behaviour of iir_filterDP is
	-- signal declarations (refer to scheme for the naming used)
	signal x, fb, ff, y: dataType;
	signal fb_array: aCoeffType;
	signal ff_array, sw: bCoeffType;

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
		generic map (N => NB)
		port map (
			D => std_logic_vector(w),
			clock => clk,
			clear => regs_clr,
			enable => reg_sw0_en,
			signed(Q) => sw(1)
		);

	reg_sw1: reg
		generic map (N => NB)
		port map (
			D => std_logic_vector(sw(1)),
			clock => clk,
			clear => regs_clr,
			enable => reg_sw1_en,
			signed(Q) => sw(2)
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
	fb_gen: for i in fb_array'range generate 	
		fb_array(i) <= multiplyAndRound(a(i) * sw(i));
	end generate;

	ff_gen: for i in ff_array'range generate
		ff_array(i) <= multiplyAndRound(b(i) * sw(i));
	end generate;

	fb_process: process(fb_array)
		variable sum: signed(fb'high + 1 downto 0) := (others => '0');
	begin
		for i in fb_array'range loop
			sum := sum + fb_array(i);
		end loop;	
		fb <= sum((sum'high - 1) downto 0);
	end process;

	ff_process: process(ff_array)
		variable sum: signed(ff'high + 1 downto 0) := (others => '0');
	begin
		for i in (ff_array'low + 1 to ff_array'high) loop
			sum := sum + ff_array(i);
		end loop;	
		ff <= sum((sum'high - 1) downto 0);
	end process;

	sw(0) <= x + fb;
	y <= ff_array(0) + ff;


end architecture;