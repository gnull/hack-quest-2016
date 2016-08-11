#!/bin/sh

tmp=$(mktemp)
trap "rm $tmp" EXIT

./main.pl $tmp < ./input

ncat -klp 8080 -c "./main.pl $tmp"
