#!/bin/bash

download() {
    file_name=$(basename $1)
    [ -f "downloads/doc_pages/$file_name" ] || curl -s "$1" > "downloads/doc_pages/$file_name"
}

get_attributes() {
    component=$(basename $1 | cut -d. -f1)
    cat $1 \
    | hq "{ COMPONENTNAME: #Codebook > div > dl | [ .info ] }" \
    | sed "s/COMPONENTNAME/${component}/" \
    | jq > "$2/${component}.json"
}

export -f get_attributes
export -f download

mkdir -p downloads/doc_pages
tmp_dir=$(mktemp -d)

# Download all doc files
jq -r 'flatten | .[] | .docs' Available_Datasets.json | parallel download {} "${tmp_dir}"

# Scrape attributes
find ./downloads/doc_pages -name "*.htm" -type f | parallel get_attributes {} "${tmp_dir}"

# Pool the results of all the attribute files and log the count
jq -s 'add' "${tmp_dir}"/*.json > Dataset_Attributes.json
count=$(jq 'length' Dataset_Attributes.json)
printf '[LOG] Discovered attributes for %d datasets\n' "$count"

# Store unique available attributes and log the count
jq 'flatten | unique | del(..|nulls)' Dataset_Attributes.json > Available_Attributes.json
count=$(jq 'length' Available_Attributes.json)
printf '[LOG] Discovered %d unique attributes\n' "$count"
