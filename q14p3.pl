#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

use constant ROUNDS => 1_000_000_000;

my @subgrid;
while (<>) {
    chomp;
    push @subgrid, $_;
}
my $subgrid = join "", @subgrid;

my @grid = map [('.') x 34], 1 .. 34;

my $last = 0;
my @seq;
for my $round (1 .. ROUNDS) {
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
    my $sub = join "", map @$_[13 .. 20], @grid[13 .. 20];
    my $add = grep '#' eq $_, map @$_, @grid;
    if ($sub eq $subgrid) { 
        push @seq, [$add, $round - $last];
        $last = $round;
        last if @seq > 2 && $seq[-1][1] == $seq[1][1];
    }
}

my $subs = $seq[0][0];
my $r = $seq[0][1];
shift @seq;
pop @seq;

while (1) {
    $r += $seq[0][1];
    last if $r > ROUNDS;

    $subs += $seq[0][0];
    push @seq, shift @seq;
}
say "$subs";

__DATA__
#......#
..#..#..
.##..##.
...##...
...##...
.##..##.
..#..#..
#......#
