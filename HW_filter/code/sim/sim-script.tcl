# to be run inside /home/isa22/lab1/sim
# to run in command line mode (eg. vsim -c), please first export the SIM_MODE env variable to:
#"no-gui" 		in order to avoid waveform display
#"gui" (default)	in order to display waveform (bug checking)	

# to select which design to simulate, please first export the SIM_DESIGN env variable to :
#"arch" (default) 	for architectural simulation 
#"postsyn" 		for synopsys synthesized netlist
#"postpr"		for post place and routing netlist

#default instantiations
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
} elseif {$sim_design == "postsyn"} {
    vcom -93 -work ./work ../src/filter_pkg.vhd
    vlog -work ./work ../netlist/*.v
} elseif {$sim_design == "postpr"} {
    vcom -93 -work ./work ../src/filter_pkg.vhd
    vlog -work ./work ../innovus/netlist/*.v
}

# compile testbench 
vcom -93 -work ./work ../tb/*.vhd
if {($sim_design == "arch") || ($sim_design == "postpr")} {
    vlog -work ./work ../tb/iir_filterTB.v
} elseif {$sim_design == "postsyn"} {
    vlog -work ./work +define+SYN=1 ../tb/iir_filterTB.v
} 

# load design
if {$sim_design == "arch"} {
    vsim work.iir_filterTB
} elseif {$sim_design == "postsyn"} { 
    vsim -L /software/dk/nangate45/verilog/msim6.2g \
            -sdftyp /iir_filterTB/UUT=../netlist/iir_filter.sdf \
            -pli /software/synopsys/syn_current/auxx/syn/power/vpower/lib-linux/libvpower.so \
            work.iir_filterTB
} elseif {$sim_design == "postpr"} { 
    vsim -L /software/dk/nangate45/verilog/msim6.2g \
            -sdftyp /iir_filterTB/UUT=../innovus/netlist/iir_filter.sdf \
            work.iir_filterTB
    vcd file ../vcd/design.vcd
    vcd add /iir_filterTB/UUT/*
}

# restart simulation
restart -force

if {$sim_mode == "gui"} {
    # load waves
    do ./wave.do
}

# run simulation
run -all

if {$sim_mode == "no-gui"} {
    quit
}
