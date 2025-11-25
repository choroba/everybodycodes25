#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;
use Math::BigInt only => 'GMP';
use List::Util qw{ sum };

use constant BLOCKS => 202520252025000;

my @blocks = split /,/, <>;
chomp $blocks[-1];

my %freq;
for my $n (1 .. @blocks) {
    my $d = 0;
    for (my $i = $n - 1; $i <= $#blocks; $i += $n) {
        ++$d if $blocks[$i] > 0;
    }
    if ($d == int(@blocks / $n)) {
        undef $freq{$n};
        for (my $i = $n - 1; $i <= $#blocks; $i += $n) {
            --$blocks[$i];
        }
    }
}

my @frequencies = sort { $a <=> $b } keys %freq;

my $from = 0;
my $to = BLOCKS;
my $cols = BLOCKS / 2;
my $blocks;
{
    do {
        $blocks = 'Math::BigInt'->new(0);
        $blocks += int($cols / $_) for @frequencies;
        if ($blocks > BLOCKS) {
            $to = int(($cols + $to) / 2);
        } elsif ($blocks < BLOCKS) {
            my $new_from = int(($from + $cols) / 2);
            if ($new_from != $from) {
                $from = $new_from;
            } else {
                last
            }
        } else {
            last
        }
        $cols = int(($from + $to) / 2);
    } until $from + 1 >= $to;
}

say $cols;

__DATA__
1,2,2,2,2,3,1,2,3,3,1,3,1,2,3,2,1,4,1,3,2,2,1,3,2,2
