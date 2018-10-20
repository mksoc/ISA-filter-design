#!/bin/bash
# check if the script is run inside ../ISA-filter-design
case "$PWD" in
    *ISA-filter-design );;
    * ) 
        echo "Error: script must be run in the repository root directory"
        exit 1
        ;;
esac

# generate samples with Python script
cd common
python3 samples-generator.py 

# rename samples file
cp py-samples.txt samples.txt

# run C model
cd ../C_filter
./iir_filter.exe common/samples.txt common/results-c.txt

# copy new samples onto server

# connect to server and run HW simulation

# retrieve results from server

# commit changes

# compare results