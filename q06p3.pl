#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

use constant {TIMES    => 1000,
              DISTANCE => 1000};

chomp( my $mentors_novices = <> );
my @chars = split //, $mentors_novices x TIMES;

my $sum = 0;
my %active = map +($_ => 0), qw( a b c );
++$active{ lc $_ } for grep /[[:upper:]]/, @chars[0 .. DISTANCE - 1];
for my $i (0 .. TIMES * length($mentors_novices) - 1) {
    if ($i > DISTANCE) {
        --$active{ lc $chars[ $i - DISTANCE - 1 ] }
            if $chars[ $i - DISTANCE - 1 ] =~ /[[:upper:]]/;
    }
    if ($i < TIMES * length($mentors_novices) - DISTANCE) {
        ++$active{ lc $chars[ $i + DISTANCE ] }
            if $chars[ $i + DISTANCE ] =~ /[[:upper:]]/;
    }

    if ($chars[$i] =~ /[[:lower:]]/) {
        $sum += $active{ $chars[$i] };
    }
}

say $sum;

__DATA__
AABCBABCABCabcabcABCCBAACBCa
