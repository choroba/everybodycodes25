#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;
use List::Util qw{ sum };

my @crates = split /,/, <>;
chomp $crates[-1];

my %uniq;
@uniq{@crates} = ();
say sum(keys %uniq);

__DATA__
10,5,1,10,3,8,5,2,2
