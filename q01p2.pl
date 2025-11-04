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

my $i = 0;
for my $instruction (@instructions) {
    $i += $instruction;
    $i %= @names;
}
say $names[$i];

__DATA__
Vyrdax,Drakzyph,Fyrryn,Elarzris

R3,L2,R3,L1
