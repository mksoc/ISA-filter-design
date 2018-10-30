#!/bin/bash
# set whichever folder is the one containing src, tb, sim, syn... which you want to work on
# MIND THAT THERE'S NO "/" AT THE END OF THE PATH!!
# E.g. /home/isa22/lab1 or /home/isa22/lab1/marco or /home/isa22/lab1/pippo ...
REMOTE_ROOT="/home/isa22/lab1" 

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
C_EX_NAME="./iir_filter.exe"

echo "> Running samples generator..."
cd common
python3 samples-generator.py 
if [ "$?" -ne "0" ]; then
    exit 1
fi

echo "> Renaming samples file..."
cp py-samples.txt samples.txt

# echo "> Running C model..."
cd ../C_filter 
if [ ! -x "$C_EX_NAME" ]; then 
    echo "> Compiling C model to \"$C_EX_NAME\"..."
    g++ iir_filter.c -o "$C_EX_NAME"
fi 
echo "> Running C model..."
"$C_EX_NAME" ../common/samples.txt ../common/results-c.txt

echo "> Connecting to server..."
ssh -M -f -N -o ControlPath="$SSH_SOCKET" -p $PORT "$USER_HOST"

echo "> Copying samples to server..."
cd ..
scp -o ControlPath="$SSH_SOCKET" -P $PORT common/samples.txt "$USER_HOST":"$REMOTE_ROOT"/common

echo ">Select design to simulate:"
echo "  1) Original architecture"
echo "  2) Post-synthesis netlist"
echo "  3) Post-place and route netlist"
echo -n "Type the selected number and press enter: "
read opt
DESIGN_VAR=""
case $opt in
    1)
        DESIGN_VAR="arch"
        ;;
    2) 
        DESIGN_VAR="postsyn"
        ;;
    3) 
        DESIGN_VAR="postpr"
        ;;
    *)
        ;;
esac

echo "> Running simulation..."
ssh -S "$SSH_SOCKET" -p $PORT "$USER_HOST" /bin/bash << EOF
    cd ${REMOTE_ROOT}/sim
    source /software/scripts/init_msim6.2g
    export SIM_MODE="no-gui"
    export SIM_DESIGN=${DESIGN_VAR}
    vsim -c -do sim-script.tcl
EOF

echo "> Copying results from server..."
scp -o ControlPath="$SSH_SOCKET" -P $PORT "$USER_HOST":"$REMOTE_ROOT"/common/results-hw.txt common/

echo "> Closing connection..."
ssh -S "$SSH_SOCKET" -O exit "$USER_HOST"

echo "> Comparing results..."
cd common
python3 compare-outputs.py results-c.txt results-hw.txt