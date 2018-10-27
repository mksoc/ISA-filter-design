# read netlist
read_verilog -netlist ../netlist/iir_filter.v 

# read switching activity
read_saif -input ../saif/iir_filter_back.saif -instance iir_filterTB/UUT -unit ns -scale 1

# create clock
create_clock -name CLOCK clk
 
# report power
report_power > ./reports/power-report.txt