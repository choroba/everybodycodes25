#!/usr/bin/perl
use warnings;
use strict;

use feature qw{ say };

use ARGV::OrDATA;

my ($ex, $ey, $sx, $sy);
my @grid;
while (<>) {
    chomp;
    push @grid, [split //];
    ($sy, $sx) = ($. - 1, pos() - 1) if /S/g;
    ($ey, $ex) = ($. - 1, pos() - 1) if /E/g;
}

my $steps = 0;
my %agenda = ("$sy $sx" => undef);
JUMP:
while (1) {
    my %next;
    for my $s (keys %agenda) {
        my ($y, $x) = split / /, $s;
        my @neighbours = grep $_->[0] >= 0 && $_->[0] <= $#grid
                              && $_->[1] >= 0 && $_->[1] <= $#{ $grid[0] },
                         [$y, $x + 1], [$y, $x - 1],
                         ($x + $y) % 2 ? [$y + 1, $x] : [$y - 1, $x];
        for my $n (@neighbours) {
            last JUMP if 'E' eq $grid[ $n->[0] ][ $n->[1] ];
            undef $next{"$n->[0] $n->[1]"}
                if 'T' eq $grid[ $n->[0] ][ $n->[1] ];
        }
    }
    %agenda = %next;
    ++$steps;
}

say 1 + $steps;

__DATA__
TTTTTTTTTTTTTTTTT
.TTTT#T#T#TTTTTT.
..TT#TTTETT#TTT..
...TT#T#TTT#TT...
....TTT#T#TTT....
.....TTTTTT#.....
......TT#TT......
.......#TT.......
........S........
