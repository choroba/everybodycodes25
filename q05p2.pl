#!/usr/bin/perl
use warnings;
use strict;
use experimental qw( signatures );
use feature qw{ say };

use ARGV::OrDATA;

sub quality($line) {
    chomp $line;
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
    return $quality
}

my ($min, $max) = ('INF', -1);
while (my $line = <>) {
    my $q = quality($line);
    $min = $q if $q < $min;
    $max = $q if $q > $max;
}
say $max - $min;

__DATA__
1:2,4,1,1,8,2,7,9,8,6
2:7,9,9,3,8,3,8,8,6,8
3:4,7,6,9,1,8,3,7,2,2
4:6,4,2,1,7,4,5,5,5,8
5:2,9,3,8,3,9,5,2,1,4
6:2,4,9,6,7,4,1,7,6,8
7:2,3,7,6,2,2,4,1,4,2
8:5,1,5,6,8,3,1,8,3,9
9:5,7,7,3,7,2,3,8,6,7
10:4,1,9,3,8,5,4,3,5,5
