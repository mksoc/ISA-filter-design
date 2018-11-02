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
add wave -noupdate -expand -group Coefficients -label a_int -radix decimal /iir_filterTB/UUT/DP/a_int
add wave -noupdate -expand -group Coefficients -label b_int -radix decimal -childformat {{/iir_filterTB/UUT/DP/b_int(0) -radix decimal} {/iir_filterTB/UUT/DP/b_int(1) -radix decimal} {/iir_filterTB/UUT/DP/b_int(2) -radix decimal}} -subitemconfig {/iir_filterTB/UUT/DP/b_int(0) {-height 16 -radix decimal} /iir_filterTB/UUT/DP/b_int(1) {-height 16 -radix decimal} /iir_filterTB/UUT/DP/b_int(2) {-height 16 -radix decimal}} /iir_filterTB/UUT/DP/b_int
add wave -noupdate -expand -group Coefficients -radix decimal /iir_filterTB/UUT/DP/coeff_ret0
add wave -noupdate -expand -group Coefficients -radix decimal /iir_filterTB/UUT/DP/coeff_ret1
add wave -noupdate -expand -group Coefficients -radix decimal /iir_filterTB/UUT/DP/coeff_pipe01
add wave -noupdate -expand -group Coefficients -radix decimal /iir_filterTB/UUT/DP/coeff_pipe02
add wave -noupdate -expand -group Coefficients -radix decimal /iir_filterTB/UUT/DP/coeff_pipe03
add wave -noupdate -itemcolor Gold /iir_filterTB/UUT/CU/out_reg_en
add wave -noupdate -label w -radix decimal /iir_filterTB/UUT/DP/w
add wave -noupdate -itemcolor Gold /iir_filterTB/UUT/CU/sw_regs_en
add wave -noupdate -label sw0 -radix decimal /iir_filterTB/UUT/DP/sw0
add wave -noupdate -label sw1 -radix decimal /iir_filterTB/UUT/DP/sw1
add wave -noupdate -radix decimal /iir_filterTB/UUT/DP/sw2
add wave -noupdate -expand -group Feedback -radix decimal /iir_filterTB/UUT/DP/sw0_coeff_ret0
add wave -noupdate -expand -group Feedback -radix decimal /iir_filterTB/UUT/DP/sw1_coeff_ret1
add wave -noupdate -expand -group Feedback -radix decimal /iir_filterTB/UUT/DP/ret0
add wave -noupdate -expand -group Feedback -radix decimal /iir_filterTB/UUT/DP/ret1
add wave -noupdate -expand -group Feedback -label fb -radix decimal /iir_filterTB/UUT/DP/fb
add wave -noupdate -expand -group Feedforward -radix decimal /iir_filterTB/UUT/DP/pipe00
add wave -noupdate -expand -group Feedforward -radix decimal /iir_filterTB/UUT/DP/pipe01
add wave -noupdate -expand -group Feedforward -radix decimal /iir_filterTB/UUT/DP/pipe02
add wave -noupdate -expand -group Feedforward -radix decimal /iir_filterTB/UUT/DP/pipe03
add wave -noupdate -expand -group Feedforward -radix decimal /iir_filterTB/UUT/DP/pipe0_b0
add wave -noupdate -expand -group Feedforward -radix decimal /iir_filterTB/UUT/DP/pipe0_coeff_pipe01
add wave -noupdate -expand -group Feedforward -radix decimal /iir_filterTB/UUT/DP/pipe0_coeff_pipe02
add wave -noupdate -expand -group Feedforward -radix decimal /iir_filterTB/UUT/DP/pipe0_coeff_pipe03
add wave -noupdate -expand -group Feedforward -radix decimal /iir_filterTB/UUT/DP/pipe10
add wave -noupdate -expand -group Feedforward -radix decimal /iir_filterTB/UUT/DP/pipe11
add wave -noupdate -expand -group Feedforward -radix decimal /iir_filterTB/UUT/DP/pipe12
add wave -noupdate -expand -group Feedforward -radix decimal /iir_filterTB/UUT/DP/pipe13
add wave -noupdate -expand -group Feedforward -radix decimal /iir_filterTB/UUT/DP/ff_part
add wave -noupdate -expand -group Feedforward -label ff -radix decimal /iir_filterTB/UUT/DP/ff
add wave -noupdate -label y -radix decimal /iir_filterTB/UUT/DP/y
add wave -noupdate -label y_out -radix decimal /iir_filterTB/UUT/DP/y_out
add wave -noupdate -itemcolor Gold -subitemconfig {/iir_filterTB/UUT/delayed_controls(0) {-height 16 -itemcolor Gold -expand} /iir_filterTB/UUT/delayed_controls(0)(0) {-height 16 -itemcolor Gold} /iir_filterTB/UUT/delayed_controls(0)(1) {-height 16 -itemcolor Gold} /iir_filterTB/UUT/delayed_controls(1) {-height 16 -itemcolor Gold -expand} /iir_filterTB/UUT/delayed_controls(1)(0) {-height 16 -itemcolor Gold} /iir_filterTB/UUT/delayed_controls(1)(1) {-height 16 -itemcolor Gold} /iir_filterTB/UUT/delayed_controls(2) {-height 16 -itemcolor Gold -expand} /iir_filterTB/UUT/delayed_controls(2)(0) {-height 16 -itemcolor Gold} /iir_filterTB/UUT/delayed_controls(2)(1) {-height 16 -itemcolor Gold}} /iir_filterTB/UUT/delayed_controls
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {77416 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 395
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
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
