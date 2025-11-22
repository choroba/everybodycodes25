#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

my @DIRS = ([-1, 0], [0, 1], [1, 0], [0, -1]);

my @instructions = split /,/, <>;
chomp $instructions[-1];

my $y = my $x = my $dir = 0;
my %grid = (0 => {0 => 'S'});
for my $instruction (@instructions) {
    my ($turn, $length) = $instruction =~ /^([LR])(.+)/;
    $dir += 'R' eq $turn ? 1 : -1;
    $dir %= @DIRS;
    for my $step (1 .. $length) {
        $y += $DIRS[$dir][0];
        $x += $DIRS[$dir][1];
        $grid{$y}{$x} = '#';
    }
}
$grid{$y}{$x} = 'E';

my $steps = 0;
my %agenda = ('0 0' => undef);
while (! exists $agenda{"$y $x"}) {
    my %next;
    for my $ji (keys %agenda) {
        my ($j, $i) = split / /, $ji;
        for my $dir (@DIRS) {
            my $l = $j + $dir->[0];
            my $k = $i + $dir->[1];
            if (($grid{$l}{$k} // 'E') eq 'E') {
                undef $next{"$l $k"};
                $grid{$l}{$k} //= '.';
            }
        }
    }
    ++$steps;
    %agenda = %next;
}

say $steps;

__DATA__
L6,L3,L6,R3,L6,L3,L3,R6,L6,R6,L6,L6,R3,L3,L3,R3,R3,L6,L6,L3
