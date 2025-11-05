#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

use FindBin ();
use lib $FindBin::Bin;
use Complex;

my $sample = <>;
my ($x, $y) = $sample =~ /(-?\d+),(-?\d+)/;
my $A = 'Complex'->new($x, $y);
my $r = 'Complex'->new(0, 0);
for (1 .. 3) {
    $r = $r->mult($r);
    $r = $r->div('Complex'->new(10, 10));
    $r = $r->add($A);
}
say $r->show;

__DATA__
A=[25,9]
