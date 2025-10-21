#!/bin/bash

# Schedule the monitoring script to run every hour from Monday to Friday using cron
echo "0 * * * 1-5 root /vagrant/scripts/system-monitor.sh" > /etc/cron.d/system-monitor
chmod 644 /etc/cron.d/system-monitor