#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;
use List::Util qw{ min };

my @walls;
while (<>) {
    chomp;
    push @walls, [split /,/];
}

my @heights = ([0, 0]);
my $x = 0;
for my $wall (@walls) {
    my @next;
    my ($x2, $height, $width) = @$wall;
    my $distance = $x2 - $x;
    for my $yf (@heights) {
        my ($y, $flaps) = @$yf;
        for my $f (0 .. $distance) {
            my $y2 = $y + 2 * $f - $distance;
            next if $y2 < $height || $y2 > $height + $width - 1;

            push @next, [$y2, $f + $flaps];
        }
    }
    @heights = @next;
    $x = $x2;
}
say min(map $_->[1], @heights);

__DATA__
7,7,2
12,0,4
15,5,3
24,1,6
28,5,5
40,8,2
