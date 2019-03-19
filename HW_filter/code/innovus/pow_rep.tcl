set_global _enable_mmmc_by_default_flow      $CTE::mmmc_default
suppressMessage ENCEXT-2799
getDrawView
loadWorkspace -name Physical
win
encMessage warning 0
encMessage debug 0
encMessage info 0
restoreDesign /home/isa22/lab1/innovus/iir_filter.enc.dat iir_filter
setDrawView fplan
encMessage warning 1
encMessage debug 0
encMessage info 1
reset_parasitics
extractRC
rcOut -setload iir_filter.setload -rc_corner my_rc
rcOut -setres iir_filter.setres -rc_corner my_rc
rcOut -spf iir_filter.spf -rc_corner my_rc
rcOut -spef iir_filter.spef -rc_corner my_rc
set_power_analysis_mode -reset
set_power_analysis_mode -method static -corner max -create_binary_db true -write_static_currents true -honor_negative_energy true -ignore_control_signals true
set_power_output_dir -reset
set_power_output_dir ./powReport
set_default_switching_activity -reset
set_default_switching_activity -input_activity 0.2 -period 10.0
read_activity_file -reset
read_activity_file -format VCD -scope /iir_filterTB/UUT -start {} -end {} -block {} ../vcd/design.vcd
set_power -reset
set_powerup_analysis -reset
set_dynamic_power_simulation -reset
report_power -rail_analysis_format VS -outfile ./powReport/iir_filter.rpt
report_power -outfile ./powReport/powReport.rpt -sort { total }
