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
ls -1 datasets | xargs -I {} jq -r '.datasets | .[] | .docs' datasets/{} | parallel -j4 get_attributes {}