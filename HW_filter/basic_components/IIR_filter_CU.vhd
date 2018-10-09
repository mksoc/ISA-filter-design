library ieee;
use ieee.std_logic_1164.all;

entity IIR_filter_CU is
port (
	clk,
	rst_N : in std_logic;

	vIn : in std_logic;

	reg_en,
	reg_rst_N : out std_logic;

	vOut : out std_logic );
end entity;

architecture behaviour of IIR_filter_CU is

	type stateType is ( 
		RESET,
		IDLE,
		SAMP_0,
		SAMP_0_IDLE,
		SAMP_1,
		SAMP_1_IDLE,
		SAMP_2,
		SAMP_2_IDLE,
		OUT_VALID );

	signal 
	ps, 
	ns : stateType;

begin

ps_process : process(clk, rst_n)
	begin
		if (rst_n = '0') then
			ps <= RESET;
		else
			if (clk'event and clk = '1') then
				ps <= ns;
			end if;
		end if;
	end process;

ns_process : process(ps, vIn)
	begin
		case ps is
			when RESET => 
				ns <= IDLE;

			when IDLE =>
				if (vIn = '1') then
					ns <= SAMP_0;
				else
					ns <= IDLE;
				end if;

			when SAMP_0 =>
				if (vIn = '1') then
					ns <= SAMP_1;
				else
					ns <= SAMP_0_IDLE;
				end if;
				
			when SAMP_0_IDLE =>
				if (vIn = '1') then
					ns <= SAMP_1;
				else
					ns <= SAMP_0_IDLE;
				end if;

			when SAMP_1 =>
				if (vIn = '1') then
					ns <= SAMP_2;
				else
					ns <= SAMP_1_IDLE;
				end if;
				
			when SAMP_1_IDLE =>
				if (vIn = '1') then
					ns <= SAMP_2;
				else
					ns <= SAMP_1_IDLE;
				end if;

			when SAMP_2 =>
				if (vIn = '1') then
					ns <= SAMP_2;
				else
					ns <= SAMP_2_IDLE;
				end if;
				
			when SAMP_2_IDLE =>
				if (vIn = '1') then
					ns <= SAMP_2;
				else
					ns <= SAMP_2_IDLE;
				end if;

			when others => 
				ns <= RESET;
		end case;
	end process;

out_process : process(ps)
	begin
	
	reg_rst_n <= '1';
	reg_en <= '0';
	vOut <= '0';

		case ps is
			when RESET => 
				reg_rst_n <= '0';
				reg_en <= '0';
				vOut <= '0';

			when IDLE =>
				reg_en <= '1';
				vOut <= '0';

			when SAMP_0 =>
				reg_en <= '1';
				vOut <= '1';
				
			when SAMP_0_IDLE =>
				reg_en <= '0';
				vOut <= '1';

			when SAMP_1 =>
				reg_en <= '1';
				vOut <= '1';
				
			when SAMP_1_IDLE =>
				reg_en <= '0';
				vOut <= '1';

			when SAMP_2 =>
				reg_en <= '1';
				vOut <= '1';
				
			when SAMP_2_IDLE =>
				reg_en <= '0';
				vOut <= '1';

			when others => 
				reg_en <= '1';
				vOut <= '0';
		end case;
	end process;

end architecture;