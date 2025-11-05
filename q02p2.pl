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

my $engraved = 0;
for (my $i = $x; $i <= $x + 1000; $i += 10) {
  COORD:
    for (my $j = $y; $j <= $y + 1000; $j += 10) {
        my $r = 'Complex'->new(0, 0);
        my $c = 'Complex'->new($i, $j);
        my $d = 'Complex'->new(100000,100000);
        for (1 .. 100) {
            $r = $r->mult($r);
            $r = $r->div($d);
            $r = $r->add($c);
            print(' '),
            next COORD if $r->[0] > 1000000
                       || $r->[0] < -1000000
                       || $r->[1] > 1000000
                       || $r->[1] < -1000000;
        }
        ++$engraved;
        print 'W';
    }
    print "\n";
}
say $engraved;

__DATA__
A=[35300,-64910]

