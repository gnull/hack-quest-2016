#!/usr/bin/env perl6

use v6;

constant maxtoken = 10 ** 9;

constant modulus = 10**9 + 7;

constant greet = q{

 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 ~ Welcome to the most secure memo storing service ~
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

};

# Main crypto subs

sub enc(@priv, @pub, $text) {
    my @bits = $text.encode.map: {$^y.fmt: '%b'};

    @bits = @bits.map: {$^z.split('').grep(/./).Slip};

    my $len = min @pub.elems, @bits.elems;
    @pub  = @pub[^$len];
    @priv = @priv[^$len];
    @bits = @bits[^$len];

    ([+] @pub Z* @bits) mod modulus
}

sub dec(@priv, Int $m, Int $c) {
    sub mod_pow (Int $x, Int $e, Int $m) {
	if so not $e {
	    1 mod $m
	} elsif so $e %% 2 {
	    mod_pow($x, $e - 1, $m) * $x mod $m
	} else {
	    my $tmp = mod_pow($x, $e / 2, $m);
	    $tmp * $tmp mod $m
	}
    }

    $c = $c * mod_pow($m, modulus - 2, modulus); # http://e-maxx.ru/algo/reverse_element
}

sub keys {
    constant key_width = 100 * 8;	# divisible by 8
    constant seq_inc = 100;

    my $sum = 0;
    my @priv = (1..key_width).map: {
	my $new = $sum + seq_inc.rand.Int;
	$sum += $new;
	$new}

    my $m = modulus.rand.Int;
    my @pub  = @priv.map: {$^x * $m mod modulus};

    @pub, @priv, $m
}

# Shiny menus and trash

sub menu(%h, $state) {
    loop {
	say q{
 Type 'back', 'exit' or 'quit' to exit one menu level up.

 Commands availiable are:
	};
	say " * $_" for %h.keys.sort;
	say '';

	my $choice = prompt '$ ';

	if $choice ~~ %h {
	    my $var := %h{$choice};

	    if $var ~~ Sub|Block {
		$var($state)
	    } elsif $var ~~ Hash {
		return if not so menu $var, $state;
	    } else {
		die "WTF??"
	    }
	} elsif $choice eq <back quit exit>.any {
	    return True;
	} else {
	    say "No such command '$choice'. Try again.\n"
	}
    }
}

sub create(%memos) {
    my ($alias, $text) = ['Short alias for your memo', 'Memo text'].map: {prompt "$^x: "};

    my ($pub, $priv, $mult) = keys;

    %memos{$alias}<text> = enc $priv, $pub, $text;
    %memos{$alias}<key>  = $pub;

    say qq {
 Your private key sequesnce: $priv.

 Your private key multiplier is: $mult

 You will need these to decrypt your memo.
    }
};

sub list(%memos) {
    my $len = [max] (map *.chars, %memos.keys);

    for %memos.keys -> $alias {
	printf " | %{$len}s | \n", $alias
    }
};

sub read(%memos) {
    my $alias = prompt 'alias of your memo: ';

    if $alias ~~ %memos {
	# The public key is likely to be useless to user. But we give it to him
	# anyway.
	say qq {
 Your public key is: %memos{$alias}<key>
 Your ciphertext is: %memos{$alias}<text>
 ----------------------------------------
	}
    } else {
	say "No memo with such alias: '{$alias}'"
    }
};

sub MAIN() {
    say greet;

    my %memos;

    menu {
	create => &create,
	list => &list,
	read => &read
    }, %memos
}
