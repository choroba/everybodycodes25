#!/usr/bin/perl
use warnings;
use strict;

use feature qw{ say };

use ARGV::OrDATA;
use List::Util qw{ min };

my %walls;
while (<>) {
    chomp;
    my ($x, $h, $w) = split /,/;
    $walls{$x}{$h} = $w;
}

my %heights = (0 => 0); # height => flaps
my $x = 0;
for my $x2 (sort { $a <=> $b } keys %walls) {
    my $distance = $x2 - $x;
    my %next;
    for my $height (keys %{ $walls{$x2} }) {
        my $width = $walls{$x2}{$height};
        for my $y (keys %heights) {
            my $flaps = $heights{$y};

            my $low = $height - $y + $distance;
            $low = 0 if $low < 0;
            $low += $low % 2;

            my $high = $height + $width - 1 - $y + $distance;
            $high -= $high % 2;

            for (my $f = $low / 2; $f <= $high / 2; $f += 2) {
                my $y2 = $y + 2 * $f - $distance;
                $next{$y2} = $f + $flaps if ! exists $next{$y2}
                                         || $f + $flaps < $next{$y2};
            }
        }
    }
    %heights = %next;
    $x = $x2;
}
say min(values %heights);

__DATA__
7,7,2
7,1,3
12,0,4
15,5,3
24,1,6
28,5,5
40,3,3
40,8,2
