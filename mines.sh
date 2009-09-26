#!/bin/sh

# Usage: ./mines.sh <yyyy-mm-dd> <home,coords> 33,-116 34,-117 ...

date=$1
home=$2

shift 2

echo "distance	coordinates"
./geohash.pl $date | xargs -I {} ./distance.pl 100000 $home {} $* | sort -n
