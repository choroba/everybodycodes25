#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;
use constant SIZE => ARGV::OrDATA::is_using_data() ? 8 : 256;

my @nails = split /,/, <>;
chomp $nails[-1];

my @connect;
for my $i (1 .. $#nails) {
    my $from = $nails[ $i - 1 ];
    my $to   = $nails[$i];
    ++$connect[$from]{$to};
    ++$connect[$to]{$from};
    ($from, $to) = ($to, $from) if $to < $from;
}

my $max = 0;
for my $from (1 .. SIZE - 2) {
    for my $to ($from + 2 .. SIZE) {
         my $cut = !! $connect[$from]{$to};
        for my $between ($from + 1 .. $to - 1) {
            for my $target (keys %{ $connect[$between] }) {
                next if $from <= $target && $target <= $to;

                $cut += $connect[$between]{$target};
            }
        }
        $max = $cut if $cut > $max;
    }
}

say $max;

__DATA__
1,5,2,6,8,4,1,7,3,6
