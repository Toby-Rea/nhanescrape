#!/bin/sh

[ $# -ne 1 ] && exit
[ -f $1 ] || exit

# Downloads the datasets
# jq -r '.datasets | .[] | .data' $1 | parallel -j4 wget {}

# Downloads the documentation
jq -r '.datasets | .[] | .docs' $1 | parallel -j4 wget {}