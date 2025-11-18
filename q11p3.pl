#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;
use List::Util qw{ sum };

chomp( my @columns = <> );

my $sum = sum(@columns);
my $avg = $sum / @columns;

say +(ARGV::OrDATA::is_using_data() ? 861 : 0)
    + sum(map $avg - $_, grep $_ < $avg, @columns);

# Input generated from part 2.

__DATA__
325
325
325
325
326
326
326
607
607
608
608
