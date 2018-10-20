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

# print welcome message
echo "This script provides automatic copy in three different ways:"
echo "          LOCAL                           SERVER"
echo "../VHDL/*.vhd            ->      ../lab1/src/"
echo "../VHDL/testbench/*      ->      ../lab1/tb/"
echo "../common/samples.txt    ->      ../lab1/common/" 
echo "../common/               <-      ../lab1/common/results-hw.txt"
echo

# create master SSH connection
ssh -M -f -N -o ControlPath="$SSH_SOCKET" -p $PORT "$USER_HOST"

# offer selection between different actions
echo 
echo "1) Copy all bidirectional" 
echo "2) Copy source files to server" 
echo "3) Copy testbench files to server" 
echo "4) Copy samples to server"
echo "5) Copy results from server"
echo -n "Type the selected number and press enter (default = 1): "
read opt
case $opt in 
    1 | "Copy all bidirectional" | "")
        echo "Copying files..."
        scp -o ControlPath="$SSH_SOCKET" -P $PORT HW_filter/VHDL/*.vhd "$USER_HOST":"$REMOTE_ROOT"/src
        scp -o ControlPath="$SSH_SOCKET" -P $PORT HW_filter/VHDL/testbench/*.vhd "$USER_HOST":"$REMOTE_ROOT"/tb
        scp -o ControlPath="$SSH_SOCKET" -P $PORT HW_filter/VHDL/testbench/*.v "$USER_HOST":"$REMOTE_ROOT"/tb
        scp -o ControlPath="$SSH_SOCKET" -P $PORT HW_filter/VHDL/testbench/*.tcl "$USER_HOST":"$REMOTE_ROOT"/sim
        scp -o ControlPath="$SSH_SOCKET" -P $PORT "$USER_HOST":"$REMOTE_ROOT"/common/results-hw.txt common/
        echo "Done."
        echo
        ;;    
    2 | "Copy source files to server")
        echo "Copying files..."
        scp -o ControlPath="$SSH_SOCKET" -P $PORT HW_filter/VHDL/*.vhd "$USER_HOST":"$REMOTE_ROOT"/src
        echo "Done."
        echo
        ;;
    3 | "Copy testbench files to server")
        echo "Copying files..."
        scp -o ControlPath="$SSH_SOCKET" -P $PORT HW_filter/VHDL/testbench/*.vhd "$USER_HOST":"$REMOTE_ROOT"/tb
        scp -o ControlPath="$SSH_SOCKET" -P $PORT HW_filter/VHDL/testbench/*.v "$USER_HOST":"$REMOTE_ROOT"/tb
        scp -o ControlPath="$SSH_SOCKET" -P $PORT HW_filter/VHDL/testbench/*.tcl "$USER_HOST":"$REMOTE_ROOT"/sim
        echo "Done."
        echo
        ;;
    4 | "Copy samples to server")
        echo "Copying files..."
        scp -o ControlPath="$SSH_SOCKET" -P $PORT common/samples.txt "$USER_HOST":"$REMOTE_ROOT"/common
        echo "Done"
        echo
        ;;
    5 | "Copy results from server")
        echo "Copying files..."
        scp -o ControlPath="$SSH_SOCKET" -P $PORT "$USER_HOST":"$REMOTE_ROOT"/common/results-hw.txt common/
        echo "Done."
        echo
        ;;
    *)
        echo "Error: invalid option."
        ;;    
esac

# close master connection
ssh -S "$SSH_SOCKET" -O exit "$USER_HOST"