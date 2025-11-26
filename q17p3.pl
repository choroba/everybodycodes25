#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;
use List::Util qw{ min };

my ($vy, $vx, $sy, $sx);
my @grid;
while (<>) {
    chomp;
    ($vy, $vx) = ($. - 1, pos() - 1) if /@/g;
    ($sy, $sx) = ($. - 1, pos() - 1) if /S/g;
    push @grid, [split //];
}
$grid[$vy][$vx] = 0;
$grid[$sy][$sx] = 0;

my @path;
RADIUS:
for my $radius (0 .. $#grid / 2) {
    for my $y (0 .. $#grid) {
        for my $x (0 .. $#{ $grid[$y] }) {
            if (($vx - $x) * ($vx - $x) + ($vy - $y) * ($vy - $y)
                <= $radius * $radius
            ) {
                last if $sy == $y && $sx == $x;

                $grid[$y][$x] = -1;
            }
        }
    }

    my %seen;
    my %agenda = (0 => {$sy => {$sx => 0}});
    my $step = 0;
    while (1) {
        for my $y (keys %{ $agenda{$step} }) {
            for my $x (keys %{ $agenda{$step}{$y} }) {
                my $from = $agenda{$step}{$y}{$x};
                next if $seen{$y}{$x}{$from};

                $seen{$y}{$x}{$from} = $step;

                for my $yx ([$y - 1, $x], [$y + 1, $x],
                            [$y, $x - 1], [$y, $x + 1]
                ) {
                    my ($yy, $xx) = @$yx;

                    next if $yy < 0 || $xx < 0
                         || $yy > $#grid || $xx > $#{ $grid[0] };

                    next if -1 == $grid[$yy][$xx];

                    if (my $already = $seen{$yy}{$xx}{ 3 - $from }) {
                        push @path, $radius * ($already + $step)
                            if $already + $step < 30 * ($radius + 1);
                    }

                    my $s = $step + $grid[$yy][$xx];
                    $agenda{$s}{$yy}{$xx} = $yy < $vy  ? 0
                                          : $yy > $vy  ? $from
                                          : $xx < $vx ? 1 : 2;
                }
            }
        }
        last RADIUS if @path;

        until (exists $agenda{++$step}) {
            next RADIUS if $step > 30 * $radius;
        }
    }
}

say min(@path);

__DATA__
2645233S5466644
634566343252465
353336645243246
233343552544555
225243326235365
536334634462246
666344656233244
6426432@2366453
364346442652235
253652463426433
426666225623563
555462553462364
346225464436334
643362324542432
463332353552464
