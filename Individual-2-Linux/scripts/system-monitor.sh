#!/bin/bash

# Date and time when running the script
DATE=$(date '+%Y-%m-%d %H:%M:%S')

# Average CPU load over the last 1 minute
CPU_LOAD=$(uptime | awk -F'load average:' '{ print $2 }' | cut -d, -f1 | xargs)

# Memory usage percentage
MEM_USAGE=$(free | awk '/Mem/{printf("%.2f"), $3/$2 * 100.0}')

# Append the data to the log file
echo "$DATE | CPU Load: $CPU_LOAD | Memory Usage: ${MEM_USAGE}%" >> "/var/log/system_monitor.log"