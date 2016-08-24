#!/usr/bin/env perl6

use v6;

sub doit(Str $tmpfile) {
    say q {
 Availiable commands are:
  register
  auth
    };

    my $db = $tmpfile.IO.e ?? slurp $tmpfile !! '';

    my $command = prompt '$ ';

    given $command {
	when 'register' {
	    my $login = prompt 'Desired login please: ';
	    my $token = '/dev/urandom'.IO.open.read(32).map(*.fmt: '%x').join;
	    my $flag  = prompt 'Your flag please: ';
	    dd $login, $flag;
	    say "Your token is: $token";
	    $db ~= "$token:$login:$flag\n";
	    spurt $tmpfile, $db;
	}
	when 'auth' {
	    my $token = prompt 'Your token please: ';
	    if so not so $db ~~ / <$token> ':' $<login> = (<-[:]>+) ':' $<flag> = (<-[\n]>+) / {
		say 'Wrong token. My gramma pwns better than you!!'
	    } else {
		say "Hello, '$<login>'. Your flag is '$<flag>'"
	    }
	}
	default {
	    exit 0;
	}
    }
}

sub MAIN(Str $file) { loop { doit $file } }
