#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;
use List::Util qw{ sum };

my @names = split /,/, <>;
chomp $names[-1];

<>;
my %rules;
while (<>) {
    chomp;
    my ($letter, @next) = split / > |,/;
    $rules{$letter} = \@next;
}

my $match = join '|',
            map "$_\[^" . join("", @{ $rules{$_} }) . ']',
            keys %rules;
@names = grep length($_) <= 11, grep ! /$match/, @names;

my %found;
my %created;
my %agenda;
@agenda{@names} = ();
while (keys %agenda) {
    @found{ grep length($_) >= 7, keys %agenda } = ();
    my %next;
    for my $prefix (keys %agenda) {
        next if 11 <= length $prefix;

        @next{ map "$prefix$_", @{ $rules{ substr $prefix, -1 } } } = ();
    }
    %agenda = %next;
}

say scalar keys %found;

__DATA__
Khara,Xaryt,Noxer,Kharax

r > v,e,a,g,y
a > e,v,x,r,g
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
