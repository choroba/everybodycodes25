#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;
use List::Util qw{ product };

my @blocks = split /,/, <>;
chomp $blocks[-1];

my %freq;
for my $n (1 .. @blocks) {
    my $d = 0;
    for (my $i = $n - 1; $i <= $#blocks; $i += $n) {
        ++$d if $blocks[$i] > 0;
    }
    if ($d == int(@blocks / $n)) {
        undef $freq{$n};
        for (my $i = $n - 1; $i <= $#blocks; $i += $n) {
            --$blocks[$i];
        }
    }
}

say product(keys %freq);


__DATA__
1,2,2,2,2,3,1,2,3,3,1,3,1,2,3,2,1,4,1,3,2,2,1,3,2,2
