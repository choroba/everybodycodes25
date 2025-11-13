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

my %maybe_child;
@maybe_child{0, 1, 2} = ();
for my $pos (0 .. $#{ $scales[0] }) {
    my @symbols = map $_->[$pos], @scales;
    next if $symbols[0] eq $symbols[1] && $symbols[1] eq $symbols[2];
    delete $maybe_child{0} if $symbols[1] eq $symbols[2];
    delete $maybe_child{1} if $symbols[0] eq $symbols[2];
    delete $maybe_child{2} if $symbols[1] eq $symbols[0];
}
my $child = (keys %maybe_child)[0];


my @degrees;
for my $parent (grep $_ != $child, 0 .. $#scales) {
    my $degree = 0;
    for my $pos (0 .. $#{ $scales[$parent] }) {
        ++$degree if $scales[$parent][$pos] eq $scales[$child][$pos];
    }
    push @degrees, $degree;
}
say $degrees[0] * $degrees[1];

__DATA__
1:CAAGCGCTAAGTTCGCTGGATGTGTGCCCGCG
2:CTTGAATTGGGCCGTTTACCTGGTTTAACCAT
3:CTAGCGCTGAGCTGGCTGCCTGGTTGACCGCG
