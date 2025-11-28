#!/usr/bin/env python
import os
import time
import glob
import sys

if not sys.argv[1]:
    print("Usage: python cleanup.py <log_directory> <days> (default: 30)")
    sys.exit(1)

log_directory = sys.argv[1]
days = int(sys.argv[2]) if len(sys.argv) > 2 else 30
cutoff = time.time() - (days * 86400)
    
if os.path.isdir(log_directory):
    for log_file in glob.glob(os.path.join(log_directory, "*.log*")):
        if os.path.isfile(log_file):
            if os.path.getmtime(log_file) < cutoff:
                os.remove(log_file)
                print(f"Removed: {log_file}")
else:
  print(f"Error: {log_directory} is not a valid directory")
  sys.exit(1)