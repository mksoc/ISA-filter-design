# Script to setup simulation after compile
# to be run inside /home/ida22/lab1/sim

# load design
vsim work.iir_filterTB

# run simulation
run 10 us
