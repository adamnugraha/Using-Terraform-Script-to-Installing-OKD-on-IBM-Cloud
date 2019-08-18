#!/bin/bash
#LOGFILE=/tmp/checkparameters.log
#exec > $LOGFILE 2>&1

echo "=================================================="
echo "= Start of check_parameters.sh"
echo "= Parameter 1 (master count) : $1"
echo "=================================================="

# Check count of Master nodes

if [ $1 -eq 1 ] || [ $1 -eq 3 ] ||[ $1 -eq 5 ] ||[ $1 -eq 5 ]; then
    echo "= Master node count equal: $1"
    echo "=================================================="

else 
    echo "= STOP :: Master node count must be 1,3, 5, or 7"
    echo "=================================================="
	exit 255
fi