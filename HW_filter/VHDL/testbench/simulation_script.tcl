# to be run inside /home/ida22/lab1/sim
# compile the needed project files 
vcom -93 -work ./work ../src/*.vhd
vcom -93 -work ./work ../tb/*.vhd
vlog -work ./work ../tb/iir_filterTB.v

# load design
vsim work.iir_filterTB

# restart simulation
restart -force

# load waves (black box signals, internal lines)
do ./wave.do

# run simulation
run 2200 ns

# stop simulation when end_sim is asserted
quietly set stop_signal /iir_filterTB/DM/end_sim
# ...

# quit