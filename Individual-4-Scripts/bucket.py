#!/usr/bin/env python
import sys
import boto3

if not sys.argv[0:3]:
    print("Usage: python bucket.py <file_name> <bucket_name>")
    sys.exit(1)
file_name, bucket_name = sys.argv[1:3]
s3 = boto3.client('s3')
s3.upload_file(file_name, bucket_name, file_name)
print(f"Successfully uploaded {file_name} to {bucket_name}")