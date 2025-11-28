#!/usr/bin/env python
import tarfile
import datetime
import sys
import os

directories = sys.argv[1:]
if not directories:
    print("Usage: python archive.py <directory1> <directory2> ...")
    sys.exit(1)
date_str = datetime.datetime.now().strftime("%d-%m-%Y_%H-%M")

for directory in directories:
    if os.path.exists(directory):
        archive_name = f"{os.path.basename(directory)}_{date_str}.tar.gz"
        with tarfile.open(archive_name, "w:gz") as tar:
            tar.add(directory, arcname=os.path.basename(directory))
        print(f"Created: {archive_name}")
    else:
        print(f"Error: {directory} not found")