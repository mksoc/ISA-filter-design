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

echo "> Running samples generator..."
cd common
python3 samples-generator.py 

echo "> Renaming samples file..."
cp py-samples.txt samples.txt

echo "> Running C model..."
cd ../C_filter
./iir_filter.exe ../common/samples.txt ../common/results-c.txt

echo "> Connecting to server..."
ssh -M -f -N -o ControlPath="$SSH_SOCKET" -p $PORT "$USER_HOST"

echo "> Copying samples to server..."
cd ..
scp -o ControlPath="$SSH_SOCKET" -P $PORT common/samples.txt "$USER_HOST":"$REMOTE_ROOT"/common

echo "> Running simulation..."
ssh -S "$SSH_SOCKET" -p $PORT "$USER_HOST" "cd lab1/sim && rm -r work && source /software/scripts/init_msim6.2g && vlib work && vsim -c -do sim-script.tcl no-gui"

echo "> Copying results from server..."
scp -o ControlPath="$SSH_SOCKET" -P $PORT "$USER_HOST":"$REMOTE_ROOT"/common/results-hw.txt common/

echo "> Closing connection..."
ssh -S "$SSH_SOCKET" -O exit "$USER_HOST"

echo "> Committing changes..."
git commit -am "Updated samples and results"

echo "> Comparing results..."
cd common
python3 compare-outputs.py results-c.txt results-hw.txt