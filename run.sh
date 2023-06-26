#!/bin/sh

docker run --rm -it -v `pwd`:`pwd` -w `pwd` $(docker build -q .)