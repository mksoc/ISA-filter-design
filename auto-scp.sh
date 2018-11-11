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
SRC_DIR="HW_filter/code/src"
TB_DIR="HW_filter/code/tb"
SIM_DIR="HW_filter/code/sim"
NET_DIR="HW_filter/code/netlist"

# define loop variables
declare -i loop_end=0

# print welcome message
echo "This script provides automatic copy in three different ways:"
echo "          LOCAL                           SERVER"
echo "1) ../HW_filter/code/{src, tb, sim}      ->      ../lab1/{src, tb, sim}"
echo "2) ../HW_filter/code/src/*               ->      ../lab1/src/"
echo "3) ../HW_filter/code/tb/*                ->      ../lab1/tb/"
echo "4) ../HW_filter/code/sim/*               ->      ../lab1/sim/"  
echo "5) ../common/samples.txt                 ->      ../lab1/common/" 
echo "6) ../common/                            <-      ../lab1/common/results-hw.txt"
echo "7) ../HW_filter/code/netlist/            <-      ../lab1/netlist/iir_filter.v"
echo "8) ../HW_filter/code/netlist/post_per    <-      ../lab1/innovus/netlist/iir_filter.v"
echo "   ../reports/post_per                   <-      ../lab1/innovus/{areaReport,RC_timing,timingReports,ver}"
echo

# create master SSH connection
ssh -M -f -N -o ControlPath="$SSH_SOCKET" -p $PORT "$USER_HOST"

while (( loop_end == 0 )); do
	# offer selection between different actionse
	echo
	echo 
	echo "Make your choice:"
	echo 
	echo "1) Copy all bidirectional" 
	echo "2) Copy source files to server" 
	echo "3) Copy testbench files to server" 
	echo "4) Copy simulation files to server"
	echo "5) Copy samples to server"
	echo "6) Copy results from server"
	echo "7) Copy netlist from server"
	echo "8) Copy innovus reports and netlist from server"
    echo "9) Copy a file/directory from server to a local directory"
	echo "10) Quit"
	echo -n "Type the selected number and press enter (default = 1): "
	echo
	echo
	read opt
	case $opt in 
	    1 | "1) Copy all bidirectional" | "")
	        echo "Copying files..."
	        scp -o ControlPath="$SSH_SOCKET" -P $PORT $SRC_DIR/* "$USER_HOST":"$REMOTE_ROOT"/src
	        scp -o ControlPath="$SSH_SOCKET" -P $PORT $TB_DIR/* "$USER_HOST":"$REMOTE_ROOT"/tb
	        scp -o ControlPath="$SSH_SOCKET" -P $PORT $SIM_DIR/*.tcl "$USER_HOST":"$REMOTE_ROOT"/sim
	        scp -o ControlPath="$SSH_SOCKET" -P $PORT common/samples.txt "$USER_HOST":"$REMOTE_ROOT"/common
	        scp -o ControlPath="$SSH_SOCKET" -P $PORT "$USER_HOST":"$REMOTE_ROOT"/common/results-hw.txt common/
	        scp -o ControlPath="$SSH_SOCKET" -P $PORT "$USER_HOST":"$REMOTE_ROOT"/netlist/*.v $NET_DIR
	        echo "Done."
	        echo
	        ;;    
	    2 | "2) Copy source files to server")
	        echo "Copying files..."
	        scp -o ControlPath="$SSH_SOCKET" -P $PORT $SRC_DIR/* "$USER_HOST":"$REMOTE_ROOT"/src
	        echo "Done."
	        echo
	        ;;
	    3 | "3) Copy testbench files to server")
	        echo "Copying files..."
	        scp -o ControlPath="$SSH_SOCKET" -P $PORT $TB_DIR/* "$USER_HOST":"$REMOTE_ROOT"/tb
	        echo "Done."
	        echo
	        ;;
	    4 | "4) Copy simulation files to server")
	        echo "Copying files..."
	        scp -o ControlPath="$SSH_SOCKET" -P $PORT $SIM_DIR/{*.tcl,*.do} "$USER_HOST":"$REMOTE_ROOT"/sim
	        echo "Done."
	        echo
	        ;;    
	    5 | "5) Copy samples to server")
	        echo "Copying files..."
	        scp -o ControlPath="$SSH_SOCKET" -P $PORT common/samples.txt "$USER_HOST":"$REMOTE_ROOT"/common
	        echo "Done"
	        echo
	        ;;
	    6 | "6) Copy results from server")
	        echo "Copying files..."
	        scp -o ControlPath="$SSH_SOCKET" -P $PORT "$USER_HOST":"$REMOTE_ROOT"/common/results-hw.txt common/
	        echo "Done."
	        echo
	        ;;
	    7 | "7) Copy netlist from server")
	        echo "Copying files..."
	        scp -o ControlPath="$SSH_SOCKET" -P $PORT "$USER_HOST":"$REMOTE_ROOT"/netlist/*.v $NET_DIR
	        echo "Done."
	        echo
	        ;;
	    8 | "8) Copy innovus reports and netlist from server")
	        echo "Copying files..."
	        scp -r -o ControlPath="$SSH_SOCKET" -P $PORT "$USER_HOST":"$REMOTE_ROOT"/innovus/\{areaReport,RC_timing,timingReports,ver\} reports/post_per
	        scp  -o ControlPath="$SSH_SOCKET" -P $PORT "$USER_HOST":"$REMOTE_ROOT"/innovus/netlist/*.v "$NET_DIR"/post_per
	        echo "Done."
	        echo
	        ;;
        9 | "9) Copy a file/directory from server to a local directory")
            echo "Specify a file/directory to copy from $REMOTE_ROOT"
            read SOURCE;
            echo "Specify destination in the repository"
            read DRAIN;
            scp -r -o ControlPath="$SSH_SOCKET" -P $PORT "$USER_HOST":"$REMOTE_ROOT"/"$SOURCE" $DRAIN
            echo "Done."
            echo
            ;;            
	    10 | "10) QUIT")
			loop_end=1
			echo "Quitting... bye bye!"
			;;
	    *)
	        echo "Error: invalid option."
	        ;;    
	esac
done

# close master connection
ssh -S "$SSH_SOCKET" -O exit "$USER_HOST"
