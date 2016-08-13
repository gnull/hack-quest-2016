#!/usr/bin/env perl6
my &MAIN = sub ($m, $k, $c) {spurt $c, Buf.new($m.&slurp(:bin).list >>+^>> $k.&slurp(:bin).list), :bin}
