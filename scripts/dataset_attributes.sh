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
jq -r 'flatten | .[] | .docs' Available_Datasets.json | parallel download {} $tmp_dir

# Scrape attributes
find ./downloads/doc_pages -name "*.htm" -type f | parallel get_attributes {} $tmp_dir

# Pool the results of all the attribute files
jq -s 'add' $tmp_dir/*.json > Attributes.json

count=$(jq 'length' Attributes.json)
printf '[LOG] Scraped attributes for %d datasets\n' "$count"