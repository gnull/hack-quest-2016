#!/bin/sh

ghc main.hs

ncat -klp 8080 -c ./main
