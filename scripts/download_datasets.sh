#!/bin/bash

# Show file size in Mb (May be inaccurate)
# curl -sI $1 | awk '/Content-Length/ { print $2/1024/1024 }'

# Extract the file name from the URL and download the file if it doesn't already exist
download() {
    file_name=$(basename "$1")
    [ -f "downloads/datasets/$file_name" ] || curl -s "$1" > "downloads/datasets/$file_name"
}

export -f download

mkdir -p downloads/datasets

# Modify this as you see fit
#
# Current behaviour:
# - Filter by extension
# - Filter by start year (2011 or 2013)
# - Shuffle and take the first 10
# - Download
jq -r "flatten | .[] | .data" Available_Datasets.json \
| grep -i ".xpt" \
| grep -i '2011\|2013' \
| shuf \
| head -n 10 \
| parallel download {}
