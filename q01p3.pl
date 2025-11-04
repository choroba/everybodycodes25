#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

my @names = split /,/, <>;
chomp $names[-1];

<>;

my @instructions = split /,/, <>;
chomp $instructions[-1];

s/L/-/ for @instructions;
s/R//  for @instructions;

for my $instruction (@instructions) {
    my $i = $instruction % @names;
    @names[0, $i] = @names[$i, 0] unless 0 == $i;
}
say $names[0];

__DATA__
Vyrdax,Drakzyph,Fyrryn,Elarzris

R3,L2,R3,L3
