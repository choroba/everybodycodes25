#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;
use List::Util qw{ max };

use constant SIZE => ARGV::OrDATA::is_using_data() ? 8 : 256;

my @nails = split /,/, <>;
chomp $nails[-1];

my @cut;
for my $i (1 .. $#nails) {
    my $from = $nails[ $i - 1 ];
    my $to   = $nails[$i];
    ($from, $to) = ($to, $from) if $to < $from;
    ++$cut[$from][$to];

    for my $between ($from + 1 .. $to - 1) {
        ++($between < $_ ? $cut[$between][$_]
                         : $cut[$_][$between]
        ) for 1 .. $from - 1, $to + 1 .. SIZE;
    }
}

say max(grep defined, map @$_, grep defined, @cut);

__DATA__
1,5,2,6,8,4,1,7,3,6
