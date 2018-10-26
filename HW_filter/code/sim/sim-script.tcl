# to be run inside /home/ida22/lab1/sim
# to run in command line mode (eg. vsim -c), please first export the SIM_MODE env variable setting it to "no-gui" (default "gui")
# to select which design to simulate, please first export the SIM_DESIGN env variable to either "arch" or "netlist" (default "arch")
if {[info exists env(SIM_MODE)]} {
    set sim_mode $env(SIM_MODE)
} else {
    set sim_mode "gui"
}

if {[info exists env(SIM_DESIGN)]} {
    set sim_design $env(SIM_DESIGN)
} else {
    set sim_design "arch"
}

if {$sim_mode == "no-gui"} {
    puts "Running in command line mode. No waveforms will be available."
} else {
    puts "Running in GUI mode."
}

# compile the design project files 
if {$sim_design == "arch"} {
    vcom -93 -work ./work ../src/*.vhd
} elseif {$sim_design == "netlist"} {
    vcom -93 -work ./work ../src/filter_pkg.vhd
    vlog -work ./work ../netlist/*.v
}

# compile testbench 
vcom -93 -work ./work ../tb/*.vhd
vlog -work ./work ../tb/iir_filterTB.v

# load design
if {$sim_design == "arch"} {
    vsim work.iir_filterTB
} elseif {$sim_design == "netlist"} {
    vsim -L /software/dk/nangate45/verilog/msim6.2g work.iir_filterTB
}

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