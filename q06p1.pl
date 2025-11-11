#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

chomp( my $mentors_novices = <> );
$mentors_novices =~ tr/Aa//cd;

my $current = 0;
my $sum = 0;
for my $char (split //, $mentors_novices) {
    ++$current if 'A' eq $char;
    $sum += $current if 'a' eq $char;
}

say $sum;

__DATA__
ABabACacBCbca
