#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

use constant STEPS => 2025;

my @numbers;
while (<>) {
    chomp;
    push @numbers, $_;
}

my @wheel = (1);
while (@numbers) {
    push @wheel, shift @numbers;
    unshift @wheel, shift @numbers if @numbers;
}

my $i = int($#wheel / 2);
$i += STEPS;
$i %= @wheel;
say $wheel[$i];

__DATA__
72
58
47
61
67
