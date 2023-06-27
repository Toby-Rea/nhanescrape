#!/bin/bash

# Show file size in Mb (May be inaccurate)
# curl -sI $1 | awk '/Content-Length/ { print $2/1024/1024 }'

# Extract the file name from the URL and download the file if it doesn't already exist
download() {
    file_name=$(basename $1)
    [ -f "downloads/datasets/$file_name" ] || curl -s $1 > "downloads/datasets/$file_name"
}

export -f download

mkdir -p downloads/datasets

# Parameters
extension=".xpt"
limit=10

# Uncomment lines to modify what gets downloaded
#
# e.g. remove 'head -n ...' to remove the limit of only downloading the first X files
# e.g. remove 'grep -i ...' to remove the constraint on file type

jq -r "flatten | .[] | .data" Available_Datasets.json \
| grep -i $extension \
| head -n $limit \
| parallel download {}