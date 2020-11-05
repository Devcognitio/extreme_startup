#!/bin/sh

docker run --name mymain_warmup -d -p 3000:3000 -e WARMUP=1 extreme_startup
