onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {External interface}
add wave -noupdate -itemcolor Cyan -label clk -radix binary /iir_filterTB/clk_i
add wave -noupdate -itemcolor Cyan -label rst_n -radix binary /iir_filterTB/rst_n_i
add wave -noupdate -label dIn -radix decimal /iir_filterTB/dIn_i
add wave -noupdate -itemcolor Gold -label vIn -radix binary /iir_filterTB/vIn_i
add wave -noupdate -label dOut -radix decimal /iir_filterTB/dOut_i
add wave -noupdate -itemcolor Gold -label vOut -radix binary /iir_filterTB/vOut_i
add wave -noupdate -itemcolor Pink -label end_sim -radix binary /iir_filterTB/end_sim_i
add wave -noupdate -divider {Internal signals}
add wave -noupdate -itemcolor Orange -label PS -radix ascii /iir_filterTB/UUT/CU/presentState
add wave -noupdate -itemcolor Gold -label input_regs_en /iir_filterTB/UUT/CU/input_regs_en
add wave -noupdate -label x -radix decimal /iir_filterTB/UUT/DP/x
add wave -noupdate -label a_int -radix decimal -childformat {{/iir_filterTB/UUT/DP/a_int(1) -radix decimal} {/iir_filterTB/UUT/DP/a_int(2) -radix decimal}} -subitemconfig {/iir_filterTB/UUT/DP/a_int(1) {-radix decimal} /iir_filterTB/UUT/DP/a_int(2) {-radix decimal}} /iir_filterTB/UUT/DP/a_int
add wave -noupdate -label b_int -radix decimal /iir_filterTB/UUT/DP/b_int
add wave -noupdate -itemcolor Gold -label sw_out_regs_en /iir_filterTB/UUT/CU/sw_out_regs_en
add wave -noupdate -label sw0_a1 -radix decimal /iir_filterTB/UUT/DP/sw0_a1
add wave -noupdate -label sw1_a2 -radix decimal /iir_filterTB/UUT/DP/sw1_a2
add wave -noupdate -label w_b0 -radix decimal /iir_filterTB/UUT/DP/w_b0
add wave -noupdate -label sw0_b1 -radix decimal /iir_filterTB/UUT/DP/sw0_b1
add wave -noupdate -label sw1_b2 -radix decimal /iir_filterTB/UUT/DP/sw1_b2
add wave -noupdate -label fb -radix decimal /iir_filterTB/UUT/DP/fb
add wave -noupdate -label ff -radix decimal /iir_filterTB/UUT/DP/ff
add wave -noupdate -label w -radix decimal /iir_filterTB/UUT/DP/w
add wave -noupdate -label sw0 -radix decimal /iir_filterTB/UUT/DP/sw0
add wave -noupdate -label sw1 -radix decimal /iir_filterTB/UUT/DP/sw1
add wave -noupdate -label y -radix decimal /iir_filterTB/UUT/DP/y
add wave -noupdate -label y_out -radix decimal /iir_filterTB/UUT/DP/y_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
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
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {250 ns}
