#!/usr/bin/env perl

while (1) {
    $file = <>;
    open fh, $file;
    for $i (<fh>) {
	print "$i";
    }
};

