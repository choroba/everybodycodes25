#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

my ($vy, $vx);
my @grid;
while (<>) {
    chomp;
    ($vy, $vx) = ($. - 1, pos() - 1) if /@/g;
    push @grid, [split //];
}
$grid[$vy][$vx] = 0;

my @max = (0, 0);
for my $radius (1 .. $#grid / 2) {
    my $sum = 0;
    for my $y (0 .. $#grid) {
        for my $x (0 .. $#{ $grid[$y] }) {
            if (($vx - $x) * ($vx - $x) + ($vy - $y) * ($vy - $y)
                <= $radius * $radius
            ) { 
                $sum += $grid[$y][$x];
                $grid[$y][$x] = 0;
            }
        }
    }
    @max = ($sum, $radius) if $sum > $max[0];
}

say $max[0] * $max[1];

__DATA__
4547488458944
9786999467759
6969499575989
7775645848998
6659696497857
5569777444746
968586@767979
6476956899989
5659745697598
6874989897744
6479994574886
6694118785585
9568991647449
