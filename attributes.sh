#!/bin/bash

get_attributes() {
    component=$(basename $1 | cut -d. -f1)
    curl -s $1 \
    | hq "{ COMPONENTNAME: #Codebook > div > dl | [ .info ] }" \
    | sed "s/COMPONENTNAME/${component}/" \
    | jq > "attributes/${component}.json"
}

export -f get_attributes

mkdir -p attributes
find datasets -type f -name "*.json" | xargs -I {} jq -r '.datasets | .[] | .docs' {} | parallel -j4 get_attributes {}

# After that finishes, flatten them
jq -s 'add' attributes/*.json > attributes.json