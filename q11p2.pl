#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

chomp( my @columns = <> );

my $round = 0;
my $phase = 1;
while (1) {
    if (1 == $phase) {
        my $change = 0;
        for my $i (1 .. $#columns) {
            if ($columns[ $i - 1 ] > $columns[$i]) {
                $change = 1;
                --$columns[ $i - 1 ];
                ++$columns[$i];
            }
        }
        # warn ("PHASE 2 ($round): @columns"),
        $phase = 2, redo unless $change;

    } else {
        for my $i (1 .. $#columns) {
            if ($columns[ $i - 1 ] < $columns[$i]) {
                ++$columns[ $i - 1 ];
                --$columns[$i];
            }
        }
    }
    my %values;
    @values{@columns} = ();
    last if 1 == keys %values;
    ++$round;
}

say 1 + $round;

__DATA__
805
706
179
48
158
150
232
885
598
524
423
