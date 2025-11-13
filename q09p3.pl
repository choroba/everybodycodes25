#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;
use List::Util qw{ sum };

my @scales;
while (<>) {
    chomp;
    s/^[0-9]+://;
    push @scales, [split //];
}

my %parents_of;
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
            undef @{ $parents_of{$maybe_child} }{$p1, $p2};
            say STDERR "$p1 and $p2 are parents of $maybe_child";
        }
    }
}

my %family;
$family{$_} = $_ for 0 .. $#scales;

for my $child (keys %parents_of) {
    my @parents = keys %{ $parents_of{$child} };
    for my $parent (@parents) {
        my $oldf = $family{$parent};
        $family{$parent} = $family{$child};
        say(STDERR "$parent belongs to $child");

        $family{$_} = $family{$child}
            for grep $oldf == $family{$_}, keys %family;
    }
}

my %size;
my $max = (values %family)[0];
for my $m (values %family) {
    ++$size{$m};
    $max = $m if $size{$m} > $size{$max};
}
my @members = grep $family{$_} == $max, keys %family;
say sum(@members, scalar @members);

__DATA__
1:GCAGGCGAGTATGATACCCGGCTAGCCACCCC
2:TCTCGCGAGGATATTACTGGGCCAGACCCCCC
3:GGTGGAACATTCGAAAGTTGCATAGGGTGGTG
4:GCTCGCGAGTATATTACCGAACCAGCCCCTCA
5:GCAGCTTAGTATGACCGCCAAATCGCGACTCA
6:AGTGGAACCTTGGATAGTCTCATATAGCGGCA
7:GGCGTAATAATCGGATGCTGCAGAGGCTGCTG
