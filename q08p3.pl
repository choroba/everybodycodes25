#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;
use List::Util qw{ max };

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

    for my $between ($from + 1 .. $to - 1) {
        ++$connect[$between]{$_}, ++$connect[$_]{$between}
            for 1 .. $from - 1, $to + 1 .. SIZE;
    }
}

say max(map values %$_, grep defined, @connect);

__DATA__
1,5,2,6,8,4,1,7,3,6
