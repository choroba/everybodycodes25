#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

use constant WIDTH => 90;

my @frequencies = split /,/, <>;
chomp $frequencies[-1];

my $count = 0;
for my $col (1 .. WIDTH) {
    for my $frequency (@frequencies) {
        ++$count if 0 == $col % $frequency;
    }
}

say $count;

__DATA__
1,2,3,5,9
