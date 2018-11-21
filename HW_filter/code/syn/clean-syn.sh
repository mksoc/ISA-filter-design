#! /bin/bash -v
# This script cleans the syn directory, keeping only itself and other useful scripts, reports and an empty work folder
mkdir ../tmp-bak && mv -t ../tmp-bak .synopsys_dc.setup syn-script.tcl power-script.tcl clean-syn.sh generate-saif.tcl reports
rm -r *
mkdir work
mv ../tmp-bak/* ../tmp-bak/.* .
rm -r ../tmp-bak