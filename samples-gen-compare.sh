#!/bin/bash
# check if the script is run inside ../ISA-filter-design
case "$PWD" in
    *ISA-filter-design );;
    * ) 
        echo "Error: script must be run in the repository root directory"
        exit 1
        ;;
esac

# define constants
USER_HOST="isa22@led-x3850-2.polito.it"
PORT="10020"
SSH_SOCKET=~/".ssh/$USER_HOST"
REMOTE_ROOT="/home/isa22/lab1"

# generate samples with Python script
echo "Running samples generator..."
cd common
python3 samples-generator.py 

# rename samples file
echo "Renaming samples file..."
cp py-samples.txt samples.txt

# run C model
echo "Running C model..."
cd ../C_filter
./iir_filter.exe ../common/samples.txt ../common/results-c.txt

# create master SSH connection
ssh -M -f -N -o ControlPath="$SSH_SOCKET" -p $PORT "$USER_HOST"

# copy new samples onto server
cd ..
scp -o ControlPath="$SSH_SOCKET" -P $PORT common/samples.txt "$USER_HOST":"$REMOTE_ROOT"/common

# connect to server and run HW simulation
ssh -S "$SSH_SOCKET" -p $PORT "$USER_HOST" "cd lab1/sim && vsim -c -do simulation_script.tcl"

# retrieve results from server
scp -o ControlPath="$SSH_SOCKET" -P $PORT "$USER_HOST":"$REMOTE_ROOT"/common/results-hw.txt common/

# close master connection
ssh -S "$SSH_SOCKET" -O exit "$USER_HOST"

# commit changes
git commit -am "Updated samples and results"

# compare results
cd common
python3 compare-outputs.py results-c.txt results-hw.txt