#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

my @grid;
while (<>) {
    chomp;
    push @grid, [split //];
}

my $count = 0;
for my $y (0 .. $#grid) {
    for my $x (0 .. $#{ $grid[$y] }) {
        next unless 'T' eq $grid[$y][$x];
        my @neighbours = grep $_->[0] >= 0 && $_->[0] <= $#grid
                              && $_->[1] >= 0 && $_->[1] <= $#{ $grid[0] },
                         [$y, $x + 1], [$y, $x - 1],
                         ($x + $y) % 2 ? [$y + 1, $x] : [$y - 1, $x];
        for my $n (@neighbours) {
            ++$count if 'T' eq $grid[ $n->[0] ][ $n->[1] ];
        }
    }
}

say $count / 2;

__DATA__
T#TTT###T##
.##TT#TT##.
..T###T#T..
...##TT#...
....T##....
.....#.....
