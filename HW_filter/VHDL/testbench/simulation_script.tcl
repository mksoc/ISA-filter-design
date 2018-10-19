# to be run inside /home/ida22/lab1/sim
# compile the needed project files 
vcom -93 -work ./work ../src/*.vhd

# compile the tb (VHDL)
vcom -93 -work ./work ../tb/*.vhd

# compile testbench top entity (Verilog)
vlog -work ./work ../tb/iir_filterTB.v

# load design
vsim work.iir_filterTB

# load waves (black box signals, internal lines)
do ./waves_setup_blackBox_and_intSignals.do

# run simulation
run 10 us

# print result
echo "Simulation ended"