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
if [ "$?" -ne "0" ]; then
    exit 1
fi

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

echo ">Select design to simulate:"
echo "  1) Original architecture"
echo "  2) Post-synthesis netlist"
echo -n "Type the selected number and press enter: "
read $opt
echo "> Running simulation..."
case $opt in
    1)
        ssh -S "$SSH_SOCKET" -p $PORT "$USER_HOST" 'cd lab1/sim && source /software/scripts/init_msim6.2g &&
    export SIM_MODE="no-gui" && export SIM_DESIGN="arch" && vsim -c -do sim-script.tcl'
        ;;
    2) 
        ssh -S "$SSH_SOCKET" -p $PORT "$USER_HOST" 'cd lab1/sim && source /software/scripts/init_msim6.2g &&
    export SIM_MODE="no-gui" && export SIM_DESIGN="netlist" && vsim -c -do sim-script.tcl'
        ;;
esac

echo "> Copying results from server..."
scp -o ControlPath="$SSH_SOCKET" -P $PORT "$USER_HOST":"$REMOTE_ROOT"/common/results-hw.txt common/

echo "> Closing connection..."
ssh -S "$SSH_SOCKET" -O exit "$USER_HOST"

echo "> Committing changes..."
git commit -am "Updated samples and results"

echo "> Comparing results..."
cd common
python3 compare-outputs.py results-c.txt results-hw.txt