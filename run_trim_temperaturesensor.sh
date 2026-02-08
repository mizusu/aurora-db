#!/bin/bash
# Run the MySQL trim script with error logging

USER="<PLACEHOLDER>"
PASSWORD="<PLACEHOLDER>"
DATABASE="<PLACEHOLDER>"
LOGFILE="/home/pi/trim.log"

echo "=== Trimming started at $(date) ===" | tee -a "$LOGFILE"

stdbuf -oL -eL mysql -u $USER -p$PASSWORD -v $DATABASE \
  < /home/pi/trim_temperaturesensor.sql 2>&1 | tee -a "$LOGFILE"

# Check exit status
if [ $? -eq 0 ]; then
    echo "Trimming completed successfully at $(date)" | tee -a "$LOGFILE"
else
    echo "ERROR: Trimming failed at $(date)" | tee -a "$LOGFILE"
fi