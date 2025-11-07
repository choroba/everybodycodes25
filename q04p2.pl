#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

use constant TIMES => 10000000000000;

my @gears;
while (<>) {
    chomp;
    unshift @gears, $_;
}


my @turns = (TIMES);
my @mods  = (0);
for my $i (1 .. $#gears) {
    my $rotation = $turns[ $i - 1 ] * $gears[ $i - 1 ] + $mods[ $i - 1 ];
    my $div = int($rotation / $gears[$i]);
    my $mod = $rotation % $gears[$i];
    push @turns, $div;
    push @mods, $mod;
}

say int $turns[-1] + !! $mods[-1];

__DATA__
102
75
50
35
13
