#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

use constant SIZE => ARGV::OrDATA::is_using_data() ? 8 : 32;

my @nails = split /,/, <>;
chomp $nails[-1];

my $center = 0;
for my $i (1 .. $#nails) {
    ++$center if abs($nails[ $i - 1 ] - $nails[$i]) == SIZE / 2;
}

say $center;

__DATA__
1,5,2,6,8,4,1,7,3
