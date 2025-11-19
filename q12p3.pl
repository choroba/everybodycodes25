#!/usr/bin/perl
use warnings;
use strict;
use experimental qw( signatures );
use feature qw{ say };

use ARGV::OrDATA;
use List::Util qw{ max };

my @MOVES = ([0, 1], [1, 0], [-1, 0], [0, -1]);

sub count_detonated($y, $x, $barrels, $detonated) {
    my %agenda = (pack('CC', $y, $x) => undef);
    while (keys %agenda) {
        my %next;
        for my $pos (keys %agenda) {
            my ($y, $x) = unpack 'CC', $pos;
            next if exists $detonated->{$pos};

            undef $detonated->{$pos};

            for my $move (@MOVES) {
                my $yy = $y + $move->[0];
                my $xx = $x + $move->[1];
                next if $yy < 0 || $xx < 0
                     || exists $detonated->{ pack 'CC', $yy, $xx }
                     || $yy > $#$barrels || $xx > $#{ $barrels->[0] };

                undef $next{ pack 'CC', $yy, $xx }
                    if $barrels->[$yy][$xx] <= $barrels->[$y][$x];
            }
        }
        %agenda = %next;
    }
    return $detonated
}

my @barrels;
while (<>) {
    chomp;
    push @barrels, [split //];
}

my $best = {};
my $previous = {};
my $max = 0;
for (1 .. 3) {
    my %tried;
    for my $y (0 .. $#barrels) {
        for my $x (0 .. $#{ $barrels[0] }) {
            next if exists $tried{ pack 'CC', $y, $x };

            my $detonated = count_detonated($y, $x, \@barrels,
                                            {%$previous});  # No clone needed.
            @tried{ keys %$detonated } = ();
            if ($max < keys %$detonated) {
                $max = keys %$detonated;
                $best = $detonated;
            }
        }
    }
    $previous = $best;
    %tried = %$previous;
}
say $max;


__DATA__
41951111131882511179
32112222211508122215
31223333322105122219
31234444432147511128
91223333322176021892
60112222211166431583
04661111166111111746
01111119042122222177
41222108881233333219
71222127839122222196
56111026279711111507
