#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;
use List::Util qw{ sum };

use constant ROUNDS => 10;

chomp( my @columns = <> );

my $phase = 1;
for my $round (1 .. ROUNDS) {
    if (1 == $phase) {
        my $change = 0;
        for my $i (1 .. $#columns) {
            if ($columns[ $i - 1 ] > $columns[$i]) {
                $change = 1;
                --$columns[ $i - 1 ];
                ++$columns[$i];
            }
        }
        $phase = 2, redo unless $change;

    } else {
        for my $i (1 .. $#columns) {
            if ($columns[ $i - 1 ] < $columns[$i]) {
                ++$columns[ $i - 1 ];
                --$columns[$i];
            }
        }
    }
}
say sum(map $columns[$_] * ($_ + 1), 0 .. $#columns);

__DATA__
9
1
1
4
9
6
