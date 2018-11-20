#!/bin/bash
# set whichever folder is the one containing src, tb, sim, syn... which you want to work on
# MIND THAT THERE'S NO "/" AT THE END OF THE PATH!!
# E.g. /home/isa22/lab1 or /home/isa22/lab1/marco or /home/isa22/lab1/pippo ...

# SET THESE VARIABLES BEFORE USING!!
REMOTE_ROOT="/home/isa22/lab1"
INIT_SYN="/software/scripts/init_synopsys"
SYN_SCRIPT="/home/isa22/lab1/syn/syn-script.tcl"
REPORTS_LOCAL="./reports/lookahead_architecture/post-syn"

# SSH configuration variables
USER_HOST="isa22@led-x3850-2.polito.it"
PORT="10020"
SSH_SOCKET=~/".ssh/$USER_HOST"

# Current minimum clock period (maximum frequency) in ns:
T_DEFAULT=5.8

# check if the script is run inside ../ISA-filter-design
case "$PWD" in
    *ISA-filter-design );;
    * ) 
        echo "Error: script must be run in the repository root directory"
        exit 1
        ;;
esac

echo -n "> Set the target clock period to simulate with (default is $T_DEFAULT): "
read T_TARGET
case $T_TARGET in
    "")
        T_TARGET=$T_DEFAULT
        ;;
esac

echo "> Target clock period for synthesis set to ${T_TARGET} ns..."

# Connect to server using SSH 
echo "> Connecting to server..."
ssh -M -f -N -o ControlPath="$SSH_SOCKET" -p $PORT "$USER_HOST"

# Clear synthesis directory (clean-syn.sh)
echo -n "> Do you want to clear synthesis directory? (y,n): "
read choice
case $choice in 
    "y" | "yes" )
        echo "> Executing clean-syn.sh"
        ssh -S ssh -S "$SSH_SOCKET" -p $PORT "$USER_HOST" /bin/bash << EOF
            cd ${REMOTE_ROOT}/syn
            ./clean-syn.sh
EOF
        ;;
esac

# Run synthesis
echo "> Running synthesis..."
ssh -S "$SSH_SOCKET" -p $PORT "$USER_HOST" /bin/bash << EOF
    cd ${REMOTE_ROOT}/syn
    source $INIT_SYN
    export T_TARGET=$T_TARGET
    
    dc_shell-xg-t -f $SYN_SCRIPT
EOF

# Copy synthesis timing and area results
echo -n "> Do you want to copy new timing and area reports from the server? (y/n): "
read choice
case $choice in
    "y" | "yes" )
        echo "> Copying results from server to $REPORTS_LOCAL"
        scp -o ControlPath="$SSH_SOCKET" -P $PORT "$USER_HOST":"$REMOTE_ROOT"/syn/reports/\{area-report.txt,timing-report.txt\} $REPORTS_LOCAL/
        ;;
esac

# Quit session on the server
echo "> Closing connection..."
ssh -S "$SSH_SOCKET" -O exit "$USER_HOST"
