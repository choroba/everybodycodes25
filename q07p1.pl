#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

my @names = split /,/, <>;
chomp $names[-1];

<>;
my $rules;
while (<>) {
    my ($letter, @next) = split / > |,/;
    $rules .= "|$letter\[^" . join("", @next) . ']';
}

substr $rules, 0, 1, "";
say for grep ! /$rules/, @names;

__DATA__
Oronris,Urakris,Oroneth,Uraketh

r > a,i,o
i > p,w
n > e,r
o > n,m
k > f,r
a > k
U > r
e > t
O > r
t > h
