#!/bin/sh
docker build -t nhanescrape --build-arg USER_ID=$(id -u) --build-arg GROUP_ID=$(id -g) .
docker run -it --rm --workdir=/app -v $PWD:/app nhanescrape