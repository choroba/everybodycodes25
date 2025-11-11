#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

chomp( my $mentors_novices = <> );

my %current;
my $sum = 0;
for my $char (split //, $mentors_novices) {
    if ($char =~ /[A-Z]/) {
        ++$current{ lc $char };
    } else {
        $sum += $current{$char};
    }
}

say $sum;

__DATA__
ABabACacBCbca
