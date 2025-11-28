#!/bin/bash

DATE=$(date '+%Y-%m-%d %H:%M:%S')

CPU_LOAD=$(uptime | awk -F'load average:' '{ print $2 }' | cut -d, -f1 | xargs)

MEM_USAGE=$(free | awk '/Mem/{printf("%.2f"), $3/$2 * 100.0}')

echo "$DATE | CPU Load: $CPU_LOAD | Memory Usage: ${MEM_USAGE}%" >> "/var/log/system_monitor.log"