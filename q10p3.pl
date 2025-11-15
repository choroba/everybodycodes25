#!/usr/bin/perl
use warnings;
use strict;
use experimental qw( signatures );
use feature qw{ say };

use ARGV::OrDATA;

sub serialise($dy, $dx, $sheep) {
    return "$dy $dx " . join ' ', map "@$_", @$sheep
}

my ($x, $y);
my @board;
my @sheep;
while (<>) {
    chomp;
    push @board, [split //, s/[DS]/./gr];
    $x = pos() - 1, $y = $. - 1 if /D/g;
    push @sheep, [$. - 1, pos() - 1] while /S/g;
}

my $count = 0;
my %agenda = (serialise($y, $x, \@sheep) => 1);
my %seen;
while (keys %agenda) {
    my %next;
use Data::Dumper; warn Dumper \%agenda;
    for my $config (keys %agenda) {
        next if exists $seen{$config};

        undef $seen{$config};

        my ($y, $x, $s) = split / /, $config, 3;
        my @sheep;
        push @sheep, [$1, $2] while $s =~ /([0-9]) ([0-9])/g;
        warn "Ate $agenda{$config} / ",
        $count += $agenda{$config} if ! @sheep;

        my $sheep_moved;
        for my $idx (0 .. $#sheep) {
            my $sheep = $sheep[$idx];
            my ($j, $i) = @$sheep;
            #warn("$i wins"),
            next if $j == $#board;

            if ($i != $x || $j + 1 != $y || '#' eq $board[ $j + 1 ][$i]) { 
                $sheep_moved = 1;
                ++$j;
            } else {
                next;
            }

            for my $dx (-2, -1, 1, 2) {
                for my $dy (-2, -1, 1, 2) {
                    next if abs($dx) == abs($dy);

                    my $xx = $x + $dx;
                    my $yy = $y + $dy;
                    next if $xx < 0 || $yy < 0
                         || $xx > $#{ $board[0] } || $yy > $#board;

                    #warn "D[$yy $xx] S[$idx: $j $i]";

                    my $eaten1 = $#sheep + 1;
                    if ($board[$yy][$xx] ne '#') {
                        if ($yy == $j && $xx == $i) {
                            #warn("eatA $idx"),
                            $eaten1 = $idx;
                        } else {
                            my @idx = grep $sheep[$_][0] == $yy
                                           && $sheep[$_][1] == $xx,
                                      grep $_ != $idx,
                                      0 .. $#sheep;
                            #warn("eatB $idx[0]"),
                            $eaten1 = $idx[0] if @idx;
                        }
                    }
                    my @nextsheep;
                    for my $si (0 .. $#sheep) {
                        next if $si == $eaten1;
                        push @nextsheep, $si == $idx ? [$j, $i]
                            : $sheep[$si];
                    }
                    my $ser = serialise($yy, $xx, \@nextsheep);
                    $next{$ser} += $agenda{$config};
                    warn "IDX[$idx] M[$dy $dx] + $agenda{$config} << $config -> $ser >>";
                }
            }
        } continue {
            warn("extra"),
            --$sheep[$idx][0], redo if $idx == $#sheep && ! $sheep_moved;
        }
    }
    %agenda = %next;
    sleep 1;
}

say $count;

__DATA__
SSS
..#
#.#
#D.
