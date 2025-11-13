#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

my @nails = split /,/, <>;
chomp $nails[-1];

my $nods = 0;
my %connect;
for my $i (1 .. $#nails) {
    my $from = $nails[ $i - 1 ];
    my $to   = $nails[$i];
    ($from, $to) = ($to, $from) if $to < $from;
    ++$connect{$from}{$to};
    ++$connect{$to}{$from};
    my $add = 0;
    for my $between ($from + 1 .. $to - 1) {
        for my $target (keys %{ $connect{$between} }) {
            next if $from <= $target && $target <= $to;

            $add += $connect{$between}{$target};
        }
    }
    $nods += $add;
}
say $nods;

__DATA__
1,5,2,6,8,4,1,7,3,5,7,8,2
