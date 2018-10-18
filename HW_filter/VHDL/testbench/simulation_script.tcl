# Script to setup simulation after compile
# to be run inside /home/ida22/lab1/sim

# compile the needed project files 
vcom -93 -work ./work ../src/*.vhd

# compile the tb
vcom -93 -work ./work ../tb/*.vhd

# load design
vsim work.iir_filterTB

# add black box signals
add wave sim:/iir_filterTB/clk_i
add wave sim:/iir_filterTB/rst_n_i
add wave sim:/iir_filterTB/dIn_i
add wave sim:/iir_filterTB/vIn_i
add wave sim:/iir_filterTB/b_i
add wave sim:/iir_filterTB/a_i
add wave sim:/iir_filterTB/dOut_i
add wave sim:/iir_filterTB/vOut_i
add wave sim:/iir_filterTB/end_sim_i

# run simulation
run 10 us

# print result
echo "Simulation ended"
