#!/bin/bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Every hour from Monday to Friday
(crontab -l 2>/dev/null; echo "0 * * * 1-5 $DIR/monitor.sh") | crontab -