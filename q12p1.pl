#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

my @MOVES = ([0, 1], [1, 0], [-1, 0], [0, -1]);

my @barrels;
while (<>) {
    chomp;
    push @barrels, [split //];
}
my %detonated;
my %agenda = ('0 0' => undef);
while (keys %agenda) {
    my %next;
    for my $pos (keys %agenda) {
        my ($y, $x) = split / /, $pos;
        next if exists $detonated{$pos};

        undef $detonated{$pos};

        for my $move (@MOVES) {
            my $yy = $y + $move->[0];
            my $xx = $x + $move->[1];
            next if $yy < 0 || $xx < 0
                 || $yy > $#barrels || $xx > $#{ $barrels[0] }
                 || exists $detonated{"$yy $xx"};

            undef $next{"$yy $xx"}
                if $barrels[$yy][$xx] <= $barrels[$y][$x];
        }

    }
    %agenda = %next;
}

say scalar keys %detonated;

__DATA__
989611
857782
746543
766789
