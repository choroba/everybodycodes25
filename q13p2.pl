#!/usr/bin/perl
use warnings;
use strict;
use experimental qw( signatures );
use feature qw{ say };

use ARGV::OrDATA;

use constant STEPS => 20252025;

sub range ($str) {
    my ($from, $to) = split /-/, $str;
    return $from .. $to
}

my @ranges;
while (<>) {
    chomp;
    push @ranges, $_;
}

my $pos = 0;
my @wheel = (1);
while (@ranges) {
    push @wheel, range(shift @ranges);
    my $before = @wheel;
    unshift @wheel, reverse range(shift @ranges) if @ranges;
    my $after = @wheel;
    $pos += $after - $before;
}

$pos += STEPS;
$pos %= @wheel;
say $wheel[$pos];

__DATA__
10-15
12-13
20-21
19-23
30-37
