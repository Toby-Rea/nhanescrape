#!/bin/sh

die() {
    echo $1; exit
}

[ $# -ne 1 ] && die "Invalid number of arguments passed"
[ -f $1 ] || die "Argument must be a file"

# Downloads the datasets
# jq -r '.datasets | .[] | .data' $1 | parallel -j4 wget {}

# Downloads the documentation
jq -r '.datasets | .[] | .docs' $1 | parallel -j4 wget {}