onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {External interface}
add wave -noupdate -format Logic -itemcolor Cyan -label clk -radix binary /iir_filterTB/clk_i
add wave -noupdate -format Logic -itemcolor Cyan -label rst_N -radix binary /iir_filterTB/rst_n_i
add wave -noupdate -format Literal -label dIn -radix decimal /iir_filterTB/dIn_i
add wave -noupdate -format Logic -itemcolor Gold -label vIn -radix binary /iir_filterTB/vIn_i
add wave -noupdate -format Literal -label dOut -radix decimal /iir_filterTB/dOut_i
add wave -noupdate -format Logic -itemcolor Gold -label vOut -radix binary /iir_filterTB/vOut_i
add wave -noupdate -format Logic -itemcolor Pink -label end_sim -radix binary /iir_filterTB/end_sim_i
add wave -noupdate -divider {Internal signals}
add wave -noupdate -format Literal -itemcolor Orange -label PS -radix ascii /iir_filterTB/UUT/cu/presentstate
add wave -noupdate -format Logic -itemcolor Gold -label regs_clr /iir_filterTB/UUT/cu/regs_clr
add wave -noupdate -format Logic -itemcolor Gold -label reg_in_en /iir_filterTB/UUT/cu/reg_in_en
add wave -noupdate -format Literal -label x -radix decimal /iir_filterTB/UUT/dp/x
add wave -noupdate -format Literal -label sw0_a1 -radix decimal /iir_filterTB/UUT/dp/sw0_a1
add wave -noupdate -format Literal -label sw1_a2 -radix decimal /iir_filterTB/UUT/dp/sw1_a2
add wave -noupdate -format Literal -label w_b0 -radix decimal /iir_filterTB/UUT/dp/w_b0
add wave -noupdate -format Literal -label sw0_b1 -radix decimal /iir_filterTB/UUT/dp/sw0_b1
add wave -noupdate -format Literal -label sw1_b2 -radix decimal /iir_filterTB/UUT/dp/sw1_b2
add wave -noupdate -format Literal -label fb -radix decimal /iir_filterTB/UUT/dp/fb
add wave -noupdate -format Literal -label ff -radix decimal /iir_filterTB/UUT/dp/ff
add wave -noupdate -format Literal -label w -radix decimal /iir_filterTB/UUT/dp/w
add wave -noupdate -format Logic -itemcolor Gold -label reg_sw0_en /iir_filterTB/UUT/cu/reg_sw0_en
add wave -noupdate -format Literal -label sw0 -radix decimal /iir_filterTB/UUT/dp/sw0
add wave -noupdate -format Logic -itemcolor Gold -label reg_sw1_en /iir_filterTB/UUT/cu/reg_sw1_en
add wave -noupdate -format Literal -label sw1 -radix decimal /iir_filterTB/UUT/dp/sw1
add wave -noupdate -format Literal -label y -radix decimal /iir_filterTB/UUT/dp/y
add wave -noupdate -format Literal -label y_out -radix decimal /iir_filterTB/UUT/dp/y_out
add wave -noupdate -format Logic -itemcolor Gold -label reg_out_en /iir_filterTB/UUT/cu/reg_out_en
add wave -noupdate -format Logic -itemcolor Gold -label reg_coeff_en /iir_filterTB/UUT/cu/reg_coeff_en
add wave -noupdate -format Literal -label a_int -radix decimal /iir_filterTB/UUT/dp/a_int
add wave -noupdate -format Literal -label b_int -radix decimal /iir_filterTB/UUT/dp/b_int
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
configure wave -namecolwidth 395
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
update
WaveRestoreZoom {0 ns} {250 ns}
