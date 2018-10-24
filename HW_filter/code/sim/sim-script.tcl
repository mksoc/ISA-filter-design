# to be run inside /home/ida22/lab1/sim
if {[info exists env(SIM_MODE)]} {
    set sim_mode $env(SIM_MODE)
} else {
    set sim_mode "gui"
}

if {$sim_mode == "no-gui"} {
    puts "Running in command line mode. No waveforms will be available."
} else {
    puts "Running in GUI mode."
}

# compile the needed project files 
vcom -93 -work ./work ../src/*.vhd
vcom -93 -work ./work ../tb/*.vhd
vlog -work ./work ../tb/iir_filterTB.v

# load design
vsim work.iir_filterTB

# restart simulation
restart -force

if {$sim_mode != "no-gui"} {
    # load waves (black box signals, internal lines)
    do ./wave.do
}

# run simulation
run -all

if {$sim_mode == "no-gui"} {
    quit
}