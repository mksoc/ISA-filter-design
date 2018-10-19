library ieee;
use ieee.std_logic_1164.all;

entity iir_filterCU is
    port (
        -- from external world
        clk, rst_n: in std_logic;
        vIn: in std_logic;
        -- controls to DP
        regs_clr, reg_in_en, reg_coeff_en, reg_sw0_en, reg_sw1_en, reg_out_en: out std_logic;
        -- to external world
        vOut : out std_logic 
    );
end entity;

architecture behavior of iir_filterCU is
	type stateType is (RESET, IDLE, STEP_1, STEP_2A, STEP_2B);
	signal presentState, nextState: stateType;

begin
    ps_process: process (clk, rst_n)
        begin
            if (rst_n = '0') then
                presentState <= RESET;
            else
                if (clk'event and clk = '1') then
                    presentState <= nextState;
                end if;
            end if;
        end process;

    ns_process: process (presentState, vIn)
        begin
            case presentState is
                when RESET =>
                    nextState <= IDLE;

                when IDLE =>
                    if (vIn = '1') then
                        nextState <= STEP_1;
                    else
                        nextState <= IDLE;
                    end if;
                    
                when STEP_1 => 
                    if (vIn = '1') then
                        nextState <= STEP_2A;
                    else
                        nextState <= STEP_2B;
                    end if;       
                    
                when STEP_2A =>
                    if (vIn = '1') then
                        nextState <= STEP_2A;
                    else
                        nextState <= STEP_2B;
                    end if;  

                when STEP_2B =>
                    if (vIn = '1') then
                        nextState <= STEP_1;
                    else
                        nextState <= IDLE;
                    end if;  

                when others => 
                    nextState <= RESET;
            end case;
        end process;

    out_process: process(presentState)
        begin
            -- vIn directly to input register and coefficient register enable due to timing constraints,
            -- this avoids the need to delay of another clock cycle input data
            reg_in_en <= vIn; 
            reg_coeff_en <= vIn;
            
            -- default assignments        
            regs_clr <= '0';
            reg_sw0_en <= '0';
            reg_sw1_en <= '0';
            reg_out_en <= '0';
            vOut <= '0';

            case presentState is
                when RESET => 
                    regs_clr <= '1';

                when IDLE =>

                when STEP_1 => 
                    reg_sw0_en <= '1';
                    reg_out_en <= '1';
                    
                when STEP_2A => 
                    reg_sw0_en <= '1';
                    reg_sw1_en <= '1';
                    reg_out_en <= '1';
                    vOut <= '1';

                when STEP_2B => 
                    reg_sw1_en <= '1';
                    vOut <= '1';

            end case;
        end process;

end architecture behavior;