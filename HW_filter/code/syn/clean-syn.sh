#! /bin/bash -v
mkdir ../tmp-bak && mv -t ../tmp-bak .synopsys_dc.setup syn-script.tcl power-script.tcl clean-syn.sh reports
rm -r *
mkdir work
mv ../tmp-bak/* ../tmp-bak/.* .
rm -r ../tmp-bak
mkdir reports && mv *report.txt reports/ 