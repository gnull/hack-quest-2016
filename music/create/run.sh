#!/bin/sh

ncat -klp 1026 -c 'echo run >&2; ./main.pl; echo done >&2'
