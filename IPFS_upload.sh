#!/bin/bash

# Usage: ./IPFS_upload.sh <file_path>

FILE=$1
if [ -z "$FILE" ]; then
  echo "Please provide the file path to upload to IPFS."
  exit 1
fi

CID=$(ipfs add -q $FILE)
if [ $? -eq 0 ]; then
  echo "File uploaded to IPFS successfully. CID: $CID"
else
  echo "Failed to upload file to IPFS. Please check the path and retry."
fi