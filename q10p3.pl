#!/usr/bin/perl
use warnings;
use strict;
use experimental qw( signatures );
use feature qw{ say };

use ARGV::OrDATA;

my ($x, $y);
my @board;
my @sheep_start;
while (<>) {
    chomp;
    push @board, [split //, s/[DS]/./gr];
    $x = pos() - 1, $y = $. - 1 if /D/g;
    push @sheep_start, [$. - 1, pos() - 1] while /S/g;
}

my $count = 0;
my %agenda = ((pack 'C*', $y, $x, map @$_, @sheep_start) => 1);
while (keys %agenda) {
    warn scalar keys %agenda;
    my %next;
    for my $config (keys %agenda) {
        my ($y, $x, @s) = unpack 'C*', $config;
        my @sheep;
        push @sheep, [splice @s, 0, 2] while @s;
        $count += $agenda{$config}, next if ! @sheep;

        my $sheep_moved;
        for my $idx (0 .. $#sheep + 1) {
            last if $idx == 1 + $#sheep && $sheep_moved;

            my ($i, $j) = (-1, -1);
            if ($idx <= $#sheep) {
                my $sheep = $sheep[$idx];
                ($j, $i) = @$sheep;
                $sheep_moved = 1, next if $j == $#board;

                if ($i != $x || $j + 1 != $y || '#' eq $board[ $j + 1 ][$i]) { 
                    $sheep_moved = 1;
                    ++$j;
                } else {
                    next
                }
            }

            for my $dx (-2, -1, 1, 2) {
                for my $dy (-2, -1, 1, 2) {
                    next if abs($dx) == abs($dy);

                    my $xx = $x + $dx;
                    my $yy = $y + $dy;
                    next if $xx < 0 || $yy < 0
                         || $xx > $#{ $board[0] } || $yy > $#board;

                    my $eaten1 = $#sheep + 1;
                    if ($board[$yy][$xx] ne '#') {
                        if ($yy == $j && $xx == $i) {
                            $eaten1 = $idx;
                        } else {
                            my @idx = grep $sheep[$_][0] == $yy
                                           && $sheep[$_][1] == $xx,
                                      grep $_ != $idx,
                                      0 .. $#sheep;
                            $eaten1 = $idx[0] if @idx;
                        }
                    }
                    my @nextsheep;
                    for my $si (0 .. $#sheep) {
                        next if $si == $eaten1;
                        push @nextsheep, $si == $idx ? ($j, $i)
                                                     : @{ $sheep[$si] };
                    }
                    my $ser = pack 'C*', $yy, $xx, @nextsheep;
                    $next{$ser} += $agenda{$config};
                }
            }
        }
    }
    %agenda = %next;
}

say $count;

__DATA__
SSS
..#
#.#
#D.
