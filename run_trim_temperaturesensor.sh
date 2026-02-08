#!/bin/bash
# Run the MySQL trim script with error logging

USER="<PLACEHOLDER>"
PASSWORD="<PLACEHOLDER>"
DATABASE="<PLACEHOLDER>"
LOGFILE="/home/pi/trim.log"

echo "=== Trimming started at $(date) ===" >> "$LOGFILE"

# Run SQL script with verbose for debugging
mysql -u $USER -p$PASSWORD -v $DATABASE < /home/pi/trim_temperaturesensor.sql >> "$LOGFILE" 2>&1

# Check exit status
if [ $? -eq 0 ]; then
    echo "Trimming completed successfully at $(date)" >> "$LOGFILE"
else
    echo "ERROR: Trimming failed at $(date)" >> "$LOGFILE"
fi
