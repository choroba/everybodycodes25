#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;
use List::Util qw{ max };

my @crates = split /,/, <>;
chomp $crates[-1];

my %freq;
++$freq{$_} for @crates;
say max(values %freq);

__DATA__
4,51,13,64,57,51,82,57,16,88,89,48,32,49,49,2,84,65,49,43,9,13,2,3,75,72,63,48,61,14,40,77
