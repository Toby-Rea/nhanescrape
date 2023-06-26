#!/bin/sh

docker run --rm -it -v `pwd`:`pwd` -w `pwd` -u $(id -u):$(id -g) $(docker build -q .)