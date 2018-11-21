# SET THESE VARIABLES BEFORE USING!!
REMOTE_ROOT="/home/isa22/lab1"
INIT_PNR="/software/scripts/init_innovus17.11"
PNR_SCRIPT="/home/isa22/lab1/innovus/per.tcl"
POW_SCRIPT="/home/isa22/lab1/innovus/pow_rep.tcl"
REPORTS_LOCAL="./reports/lookahead_architecture/post-per"

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

# Perform place and route 
echo "> Performing P&R with Innovus..."
ssh -S "$SSH_SOCKET" -p $PORT "$USER_HOST" /bin/bash << EOF
    cd ${REMOTE_ROOT}/innovus
    rm innovus.*
    rm ./powReport/*
    source $INIT_PNR
    
    innovus -no_gui -file $PNR_SCRIPT
EOF

# Launch simulation script
echo "> Launching simulation script. Please select \"Post-per netlist\" when prompted."
./auto-simulate.sh

# Test if everything went fine
if [ $? -ne 0 ]; then
    echo "> ERROR: Something went wrong durig simulation... Exiting now."
    exit 1
fi

# Perform place and route 
echo "> Performing P&R with Innovus..."
ssh -S "$SSH_SOCKET" -p $PORT "$USER_HOST" /bin/bash << EOF
    cd ${REMOTE_ROOT}/innovus
    source $INIT_PNR
    
    innovus -no_gui -file $POW_SCRIPT
EOF

# Quit session on the server
echo "> Closing connection..."
ssh -S "$SSH_SOCKET" -O exit "$USER_HOST"