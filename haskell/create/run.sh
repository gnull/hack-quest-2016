#!/bin/sh

ghc main.hs

ncat -klp 1025 -c 'x=$(head -1); printf "%s" "$x" | ./main'

