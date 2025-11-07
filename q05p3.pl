#!/usr/bin/perl
use warnings;
use strict;
use experimental qw( signatures );
use feature qw{ say };

use ARGV::OrDATA;

sub fishbone($line) {
    chomp $line;
    my ($id, @numbers) = split /[:,]/, $line;

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
    return $id, $quality, \@spine
}

sub sword_compare {
    my $cmp_quality = $a->[1] <=> $b->[1];
    return $cmp_quality if $cmp_quality;

    my $level = 0;
    while ($a->[2][$level]) {
        my $A = join "", @{ $a->[2][$level] // [""] };
        my $B = join "", @{ $b->[2][$level] // [""] };
        my $cmp_level = $A <=> $B;
        return $cmp_level if $cmp_level;
        ++$level
    }
    return $a->[0] <=> $b->[0]
}


my @swords;
while (my $line = <>) {
    push @swords, [fishbone($line)];
}

@swords = sort sword_compare @swords;

my $checksum = 0;
for my $i (0 .. $#swords) {
    $checksum += $swords[$i][0] * ($#swords - $i + 1);
}

say $checksum;

__DATA__
1:7,1,9,1,6,9,8,3,7,2
2:7,1,9,1,6,9,8,3,7,2
