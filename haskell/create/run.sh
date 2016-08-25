#!/bin/sh

ghc main.hs

ncat -klp 1025 -c ./main
