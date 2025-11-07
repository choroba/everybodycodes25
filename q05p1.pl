#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

chomp( my $line = <> );
$line =~ s/^[0-9]+://;
my @numbers = split /,/, $line;

my @spine = ([undef, shift @numbers]);
NUMBER:
for my $number (@numbers) {
    for my $segment (@spine) {
        if (!defined $segment->[0] && $number < $segment->[1]) {
            $segment->[0] = $number;
            next NUMBER
        }
        if (!defined $segment->[2] && $number > $segment->[1]) {
            $segment->[2] = $number;
            next NUMBER
        }
    }
    push @spine, [undef, $number];
}
my $quality = join "", map $_->[1], @spine;
say $quality;

__DATA__
58:5,3,7,8,9,10,4,5,7,8,8
