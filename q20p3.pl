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
}

my %rotation1;
my $maxn = 2 + $#{ $grid[0] };
my $maxcount = 2;
for my $y (0 .. $#grid) {
    $maxn -= 2;
    my $n = $maxn;
    my $count = 1;
    for my $x (0 .. $#{ $grid[0] }) {
        next if '.' eq $grid[$y][$x];

        my $ry = int(($x - $y) / 2);
        my $rx = $n;
        $rotation1{"$y $x"} = "$ry $rx";
        
        if (++$count == $maxcount) {
            $count = 0;
            --$n;
        }
    }
}

my %rotation;
for my $r (keys %rotation1) {
    $rotation{$r} = $rotation1{ $rotation1{$r} };
}

my $steps = 0;
my %agenda = ("$sy $sx" => undef);
JUMP:
while (1) {
    my %next;
    for my $s (keys %agenda) {
        my ($y, $x) = split / /, $s;
        my @neighbours = grep $_->[0] >= 0 && $_->[0] <= $#grid
                              && $_->[1] >= 0
                              && $_->[1] <= $#{ $grid[ $_->[0] ] }
                              && '.' ne $grid[ $_->[0] ][ $_->[1] ],
                         [$y, $x + 1], [$y, $x - 1],
                         ($x + $y) % 2 ? [$y + 1, $x] : [$y - 1, $x];
        push @neighbours, [$y, $x];
        for my $n (@neighbours) {
            my $r = $rotation{"$n->[0] $n->[1]"};
            my ($ry, $rx) = split / /, $r;
            last JUMP if 'E' eq $grid[$ry][$rx];
            undef $next{$r} if 'T' eq $grid[$ry][$rx];
        }
    }
    %agenda = %next;
    warn ++$steps;
}

say 1 + $steps;

__DATA__
T####T#TTT##T##T#T#
.T#####TTTT##TTT##.
..TTTT#T###TTTT#T..
...T#TTT#ETTTT##...
....#TT##T#T##T....
.....#TT####T#.....
......T#TT#T#......
.......T#TTT.......
........TT#........
.........S.........
