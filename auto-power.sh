# SET THESE VARIABLES BEFORE USING!!
REMOTE_ROOT="/home/isa22/lab1"
INIT_SYN="/software/scripts/init_synopsys"
SAIF_SCRIPT="/home/isa22/lab1/syn/generate-saif.tcl"
POW_SCRIPT="/home/isa22/lab1/syn/power-script.tcl"
REPORTS_LOCAL="./reports/lookahead_architecture/post-syn"

# SSH configuration variables
USER_HOST="isa22@led-x3850-2.polito.it"
PORT="10020"
SSH_SOCKET=~/".ssh/$USER_HOST"

# check if the script is run inside ../ISA-filter-design
case "$PWD" in
    *ISA-filter-design );;
    * ) 
        echo "Error: script must be run in the repository root directory"
        exit 1
        ;;
esac

# Connect to server using SSH 
echo "> Connecting to server..."
ssh -M -f -N -o ControlPath="$SSH_SOCKET" -p $PORT "$USER_HOST"

# Generate saif file 
echo "> Generating saif file..."
ssh -S "$SSH_SOCKET" -p $PORT "$USER_HOST" /bin/bash << EOF
    cd ${REMOTE_ROOT}/syn
    source $INIT_SYN
    
    dc_shell-xg-t -f $SAIF_SCRIPT
EOF

# Launch simulation script
echo "> Launching simulation script. Please select \"Post-synthesis netlist\" when prompted."
./auto-simulate.sh

# Report power
echo "> Reporting power with Synopsys Design Compiler..."
ssh -S "$SSH_SOCKET" -p $PORT "$USER_HOST" /bin/bash << EOF
    cd ${REMOTE_ROOT}/syn
    source $INIT_SYN
    
    dc_shell-xg-t -f $POW_SCRIPT
EOF

# Copy synthesis timing and area results
echo -n "> Do you want to copy new power report from the server? (y/n): "
read choice
case $choice in
    "y" | "yes" )
        echo "> Copying results from server to $REPORTS_LOCAL"
        scp -o ControlPath="$SSH_SOCKET" -P $PORT "$USER_HOST":"$REMOTE_ROOT"/syn/reports/power-report.txt $REPORTS_LOCAL/
        ;;
esac

# Quit session on the server
echo "> Closing connection..."
ssh -S "$SSH_SOCKET" -O exit "$USER_HOST"
