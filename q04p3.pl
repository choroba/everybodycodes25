#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

use constant TIMES => 100;

my @gears;
while (<>) {
    chomp;
    push @gears, [split /\|/, $_];
}

my @turns = (TIMES);
my @mods  = (0);
for my $i (1 .. $#gears) {
    my $rotation = $turns[ $i - 1 ] * $gears[ $i - 1 ][-1] + $mods[ $i - 1 ];
    my $div = int($rotation / $gears[$i][0]);
    my $mod = $rotation % $gears[$i][0];
    push @turns, $div;
    push @mods, $mod * ($gears[$i][1] // 0) / $gears[$i][0];
}

say int $turns[-1];

__DATA__
5
7|21
18|36
27|27
10|50
10|50
11
