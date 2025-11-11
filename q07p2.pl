#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;
use List::Util qw{ sum };

my @names = split /,/, <>;
chomp $names[-1];

<>;
my $rules;
while (<>) {
    my ($letter, @next) = split / > |,/;
    $rules .= "|$letter\[^" . join("", @next) . ']';
}

substr $rules, 0, 1, "";
say sum(map 1 + $_, grep $names[$_] !~ /$rules/, 0 .. $#names);

__DATA__
Xanverax,Khargyth,Nexzeth,Helther,Braerex,Tirgryph,Kharverax

r > v,e,a,g,y
a > e,v,x,r
e > r,x,v,t
h > a,e,v
g > r,y
y > p,t
i > v,r
K > h
v > e
B > r
t > h
N > e
p > h
H > e
l > t
z > e
X > a
n > v
x > z
T > i
