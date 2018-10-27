#! /bin/bash
rm -r work
mkdir work && mv -t work .synopsys_dc.setup syn-script.tcl clean-syn.sh
rm *
mv work/* .