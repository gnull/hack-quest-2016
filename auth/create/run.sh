#!/bin/sh

tmp=$(mktemp)
trap "rm $tmp" EXIT

./main.pl $tmp < ./input

ncat -klp 1024 -c "./main.pl $tmp"
