#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

my $MOVES = ARGV::OrDATA::is_using_data() ? 3 : 20;

my ($x, $y);
my @board;
while (<>) {
    chomp;
    push @board, [split //];
    $x = pos() - 1, $y = $. - 1 if /D/g;
}
$board[$y][$x] = '.';
my $eaten = 0;
my %agenda = ("$x $y" => undef);
for my $move (1 .. $MOVES) {
    my %next;
    for my $pos (keys %agenda) {
        ($x, $y) = split ' ', $pos;
        for my $dx (-2, -1, 1, 2) {
            for my $dy (-2, -1, 1, 2) {
                next if abs($dx) == abs($dy);

                my $xx = $x + $dx;
                my $yy = $y + $dy;
                next if $xx < 0 || $yy < 0
                     || $xx > $#{ $board[0] } || $yy > $#board;

                undef $next{"$xx $yy"};
                if ('S' eq $board[$yy][$xx]) {
                    $board[$yy][$xx] = '.';
                    ++$eaten;
                }
            }
        }
    }

    for my $y (reverse 0 .. $#board) {
        for my $x (0 .. $#{ $board[0] }) {
            next unless $board[$y][$x] =~ /[SH]/;

            $board[$y][$x] =~ tr/SH/.#/;
            if ($y < $#board) {
                $board[ $y + 1 ][$x] =~ tr/.#/SH/;
                if ('S' eq $board[ $y + 1][$x]
                    && exists $next{ "$x " . ($y + 1) }
                ) {
                    $board[ $y + 1][$x] = '.';
                    ++$eaten;
                }
            }
        }
    }




    %agenda = %next;
    say $move, ' ', $eaten;
    say @$_ for @board;

}

say $eaten;

__DATA__
...SSS##.....
.S#.##..S#SS.
..S.##.S#..S.
.#..#S##..SS.
..SSSS.#.S.#.
.##..SS.#S.#S
SS##.#D.S.#..
S.S..S..S###.
.##.S#.#....S
.SSS.#SS..##.
..#.##...S##.
.#...#.S#...S
SS...#.S.#S..
