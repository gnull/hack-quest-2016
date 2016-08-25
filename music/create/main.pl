#!/usr/bin/env perl

select((select(OUTPUT_HANDLE), $| = 1)[0]);

$file = <>;
open fh, $file;
for $i (<fh>) {
    print "$i";
}

