#!/usr/bin/perl
use warnings;
use strict;
use experimental qw( signatures );
use feature qw{ say };

use ARGV::OrDATA;
use List::Util qw{ sum0 };

use constant STEPS => ARGV::OrDATA::is_using_data() ? 20252025 : 202520252025;

sub size ($str) {
    my ($from, $to) = split /-/, $str;
    return 1 + $to - $from
}

my @ranges;
while (<>) {
    chomp;
    push @ranges, $_;
}

my $left = 0;
my $right = 0;
my @sizes = (1);
my @order = (undef);
my $r = 0;
while ($r <= $#ranges) {
    my $rs = size($ranges[$r]);
    $right += $rs;
    push @sizes, $rs;
    push @order, $r;

    last if ++$r > $#ranges;

    my $ls = size($ranges[$r]);
    $left += $ls;
    unshift @sizes, $ls;
    unshift @order, $r;
    ++$r;
}

my $size = 1 + $left + $right;
my $pos = STEPS % $size;

unshift @sizes, splice @sizes, $#sizes / 2;
unshift @order, splice @order, $#order / 2;

my $p = 0;
for my $i (1 .. $#sizes) {
    $p += $sizes[$i];
    if ($p >= $pos) {
        my $realpos = sum0(@sizes[1 .. $i - 1]);
        if ($pos - $realpos -1 >= 0) {
            my ($first, $last) = $ranges[ $order[$i] ] =~ /(.+)-(.+)/;
            say $order[$i] % 2 ? $last  - $pos + $realpos + 1
                               : $first + $pos - $realpos - 1;
        } else {
            say 1;
        }
        last
    }
}

__DATA__
10-15
12-13
20-21
19-23
30-37
