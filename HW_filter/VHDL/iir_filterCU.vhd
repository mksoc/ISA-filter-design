library ieee;
use ieee.std_logic_1164.all;

entity iir_filterCU is
    port (
        -- from external world
        clk, rst_n: in std_logic;
        vIn: in std_logic;
        -- controls to DP
        regs_clr, inReg_en, reg_sw0_en, reg_sw1_en, outReg_en: in std_logic;
        -- to external world
        vOut : out std_logic 
    );
end entity;

architecture behavior of iir_filterCU is
	type stateType is (RESET, STEP1, STEP2_A, STEP2_B, STEP3_A, STEP3_B, STEP3_C, STEP3_D, STEP4_A, STEP4_B, STEP4_C, STEP4_D, STEP4_E, STEP4_F, STEP4_G, STEP4_H);
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
                    if (vIn = '1') then
                        nextState <= STEP1;
                    else
                        nextState <= RESET;
                    end if;

                when STEP1 => 
                    if (vIn = '1') then
                        nextState <= STEP2_A;
                    else
                        nextState <= STEP2_B;
                    end if;       
                    
                when STEP2_A => 
                    if (vIn = '1') then
                        nextState <= STEP3_A;
                    else
                        nextState <= STEP3_B;
                    end if;  

                when STEP2_B => 
                    if (vIn = '1') then
                        nextState <= STEP3_C;
                    else
                        nextState <= STEP3_D;
                    end if;  

                when STEP3_A => 
                    if (vIn = '1') then
                        nextState <= STEP4_A;
                    else
                        nextState <= STEP4_B;
                    end if;  

                when STEP3_B => 
                    if (vIn = '1') then
                        nextState <= STEP4_C;
                    else
                        nextState <= STEP4_D;
                    end if;  

                when STEP3_C => 
                    if (vIn = '1') then
                        nextState <= STEP4_E;
                    else
                        nextState <= STEP4_F;
                    end if;  

                when STEP3_D => 
                    if (vIn = '1') then
                        nextState <= STEP4_G;
                    else
                        nextState <= STEP4_H;
                    end if;  

                when STEP4_A => 
                    if (vIn = '1') then
                        nextState <= STEP4_A;
                    else
                        nextState <= STEP4_B;
                    end if;  

                when STEP4_B => 
                    if (vIn = '1') then
                        nextState <= STEP4_C;
                    else
                        nextState <= STEP4_D;
                    end if;  

                when STEP4_C => 
                    if (vIn = '1') then
                        nextState <= STEP4_E;
                    else
                        nextState <= STEP4_F;
                    end if;  

                when STEP4_D => 
                    if (vIn = '1') then
                        nextState <= STEP4_G;
                    else
                        nextState <= STEP4_H;
                    end if;  

                when STEP4_E => 
                    if (vIn = '1') then
                        nextState <= STEP3_A;
                    else
                        nextState <= STEP3_B;
                    end if;  

                when STEP4_F => 
                    if (vIn = '1') then
                        nextState <= STEP3_C;
                    else
                        nextState <= STEP3_D;
                    end if;  

                when STEP4_G => 
                    if (vIn = '1') then
                        nextState <= STEP2_A;
                    else
                        nextState <= STEP2_B;
                    end if;  

                when STEP4_H => 
                    if (vIn = '1') then
                        nextState <= STEP1;
                    else
                        nextState <= RESET;
                    end if;  

                when others => 
                    nextState <= RESET;
            end case;
        end process;

    out_process: process(presentState)
        begin
            -- default assignments        
            regs_clr <= '0';
            inReg_en <= vIn; -- vIn directly to input register enable due to timing constraints
            reg_sw0_en <= '0';
            reg_sw1_en <= '0';
            outReg_en <= '0';
            vOut <= '0';

            case presentState is
                when RESET => 
                    regs_clr <= '1';

                when STEP1 => 
                    reg_sw0_en <= '1'; 
                    
                when STEP2_A => 
                    reg_sw0_en <= '1';
                    reg_sw1_en <= '1';

                when STEP2_B => 
                    reg_sw1_en <= '1';

                when STEP3_A => 
                    reg_sw0_en <= '1';
                    reg_sw1_en <= '1';
                    outReg_en <= '1';

                when STEP3_B => 
                    reg_sw1_en <= '1';
                    outReg_en <= '1';

                when STEP3_C => 
                    reg_sw0_en <= '1';
                    outReg_en <= '1';

                when STEP3_D => 
                    outReg_en <= '1';

                when STEP4_A => 
                    reg_sw0_en <= '1';
                    reg_sw1_en <= '1';
                    outReg_en <= '1';
                    vOut <= '1';

                when STEP4_B => 
                    reg_sw1_en <= '1';
                    outReg_en <= '1';
                    vOut <= '1';

                when STEP4_C => 
                    reg_sw0_en <= '1';
                    outReg_en <= '1';
                    vOut <= '1';

                when STEP4_D => 
                    outReg_en <= '1';
                    vOut <= '1';

                when STEP4_E => 
                    reg_sw0_en <= '1';
                    reg_sw1_en <= '1';
                    vOut <= '1';

                when STEP4_F => 
                    reg_sw1_en <= '1';
                    vOut <= '1';

                when STEP4_G => 
                    reg_sw0_en <= '1';
                    vOut <= '1';

                when STEP4_H => 
                    vOut <= '1';
            end case;
        end process;

end architecture behavior;