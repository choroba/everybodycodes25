#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

use constant ROUNDS => 2025;

my @grid;
while (<>) {
    chomp;
    push @grid, [split //];
}

my $active = 0;
for (1 .. ROUNDS) {
    my @next;
    for my $y (0 .. $#grid) {
        for my $x (0 .. $#{ $grid[0] }) {
            my %neighbour;
            for my $j ($y - 1, $y + 1) {
                next if $j < 0 || $j > $#grid;

                for my $i ($x - 1, $x + 1) {
                    next if $i < 0 || $i > $#{ $grid[0] };

                    ++$neighbour{ $grid[$j][$i] };
                }
            }
            if ('#' eq $grid[$y][$x]) {
                $next[$y][$x] = ($neighbour{'#'} // 0) % 2 ? '#' : '.';
            } else {
                $next[$y][$x] = ($neighbour{'#'} // 0) % 2 ? '.' : '#';
            }
        }
    }
    @grid = @next;
    $active += grep '#' eq $_, map @$_, @grid;
}

say $active;

__DATA__
.#.##.
##..#.
..##.#
.#.##.
.###..
###.##
