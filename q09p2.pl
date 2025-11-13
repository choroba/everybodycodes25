#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

my @scales;
while (<>) {
    chomp;
    s/^[0-9]+://;
    push @scales, [split //];
}

my $sum = 0;
for my $maybe_child (0 .. $#scales) {
    for my $p1 (0 .. $#scales - 1) {
        next if $p1 == $maybe_child;

      PARENT:
        for my $p2 ($p1 + 1 .. $#scales) {
            next if $p2 == $maybe_child;

            for my $pos (0 .. $#{ $scales[0] }) {
                my @symbols = map $_->[$pos], @scales[$maybe_child, $p1, $p2];
                next PARENT if $symbols[0] ne $symbols[1]
                            && $symbols[0] ne $symbols[2];
            }
            my @degrees;
            for my $parent ($p1, $p2) {
                my $degree = 0;
                for my $pos (0 .. $#{ $scales[$parent] }) {
                    ++$degree if $scales[$parent][$pos]
                                 eq $scales[$maybe_child][$pos];
                }
                push @degrees, $degree;
            }
            $sum += $degrees[0] * $degrees[1];
        }
    }
}

say $sum;

__DATA__
1:GCAGGCGAGTATGATACCCGGCTAGCCACCCC
2:TCTCGCGAGGATATTACTGGGCCAGACCCCCC
3:GGTGGAACATTCGAAAGTTGCATAGGGTGGTG
4:GCTCGCGAGTATATTACCGAACCAGCCCCTCA
5:GCAGCTTAGTATGACCGCCAAATCGCGACTCA
6:AGTGGAACCTTGGATAGTCTCATATAGCGGCA
7:GGCGTAATAATCGGATGCTGCAGAGGCTGCTG
