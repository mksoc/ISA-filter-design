# to be run inside /home/isa22/lab1/syn
# compile the needed project files
set dir "../src"
analyze -f vhdl -lib WORK $dir/filter_pkg.vhd
set source_files [glob -directory $dir *.vhd]
foreach item $source_files {
    if {$item != "$dir/filter_pkg.vhd"} {
        analyze -f vhdl -lib WORK $item
    }    
} 

# preserve RTL names
set power_preserve_rtl_hier_names true

# elaborate design
elaborate iir_filter -arch structure -lib WORK > ./elaborate-log.txt
uniquify
link

# create symbolic clock signal (period = 11.2 ns)
create_clock -name CLOCK -period 11.2 clk
set_dont_touch_network CLOCK
set_clock_uncertainty 0.07 [get_clocks CLOCK]

# set input/output delays
set_input_delay 0.5 -max -clock CLOCK [remove_from_collection [all_inputs] CLOCK]
set_output_delay 0.5 -max -clock CLOCK [all_outputs]

# set output load capacitance
set OLOAD [load_of NangateOpenCellLibrary/BUF_X4/A]
set $OLOAD [all_outputs]

# start synthesis
compile > ./compile-log.txt

# save results
report_timing > timing-report.txt
report_area > area-report.txt

# flatten hierarchy
ungroup -all -flatten

# setup Verilog name rules
change_names -hierarchy -rules verilog

# export netlist delay file
write_sdf ../netlist/iir_filter.sdf

# export netlist file
write -f verilog -hierarchy -output ../netlist/iir_filter.v

# export Synopsys Design Constraints file
write_sdc ../netlist/iir_filter.sdc