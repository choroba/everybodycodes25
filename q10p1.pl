#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

my $MOVES = ARGV::OrDATA::is_using_data() ? 3 : 4;

my ($x, $y);
my @board;
while (<>) {
    chomp;
    push @board, [split //];
    $x = pos() - 1, $y = $. - 1 if /D/g;
}

my $sheep = 0;
my %agenda = ("$x $y" => undef);
for my $move (0 .. $MOVES) {
    my %next;
    for my $pos (keys %agenda) {
        ($x, $y) = split ' ', $pos;
        $board[$y][$x] = 'X', ++$sheep if 'S' eq $board[$y][$x];
        for my $dx (-2, -1, 1, 2) {
            for my $dy (-2, -1, 1, 2) {
                next if abs($dx) == abs($dy);

                my $xx = $x + $dx;
                my $yy = $y + $dy;
                next if $xx < 0 || $yy < 0
                     || $xx > $#{ $board[0] } || $yy > $#board;

                undef $next{"$xx $yy"};
            }
        }
        %agenda = %next;
    }
    # say $move;
    # say @$_ for @board;
}

say $sheep;

__DATA__
...SSS.......
.S......S.SS.
..S....S...S.
..........SS.
..SSSS...S...
.....SS..S..S
SS....D.S....
S.S..S..S....
....S.......S
.SSS..SS.....
.........S...
.......S....S
SS.....S..S..
