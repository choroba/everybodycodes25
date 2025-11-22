#!/usr/bin/perl
use warnings;
use strict;
use experimental qw( signatures );
use feature qw{ say };

use ARGV::OrDATA;

{   package My::Map;
    use parent 'AI::Pathfinding::AStar';

    use List::Util qw { uniq };

    my @DIRS = ([-1, 0], [0, 1], [1, 0], [0, -1]);

    sub new($class, $instructions) {
        my $self = bless {}, $class;
        my $y = my $x = my $dir = 0;
        my %grid = (x => {0 => undef},y => {0 => undef});
        for my $instruction (@$instructions) {
            #warn $instruction;
            my ($turn, $length) = $instruction =~ /^([LR])(.+)/;
            $dir += 'R' eq $turn ? 1 : -1;
            $dir %= @DIRS;
            my $yy = $y + $DIRS[$dir][0] * $length;
            my $xx = $x + $DIRS[$dir][1] * $length;
            if ($DIRS[$dir][0]) {
                my @s = sort { $a <=> $b } $y, $yy;
                undef $self->{V}{$x}{"@s"};
            } else {
                my @s = sort { $a <=> $b } $x, $xx;
                undef $self->{H}{$y}{"@s"};
            }
            $y = $yy;
            $x = $xx;
            undef $grid{x}{$x};
            undef $grid{y}{$y};
        }
        my %compress;
        for my $dir (qw( x y )) {
            my @s = sort { $a <=> $b } uniq(
                                           map +($_ - 1 .. $_ + 1),
                                           keys %{ $grid{$dir} });
            my $i = 0;
            $compress{$dir}{$_} = $i++ for @s;
        }
        $self->{compress} = \%compress;
        $self->{decompress}{$_} = {reverse %{ $compress{$_} }} for qw( x y );
        my %DIR = (h => 'y', v => 'x');
        for my $dir (qw( h v )) {
            my $dir2 = 'h' eq $dir ? 'v' : 'h';
            for my $distance (keys %{ $self->{ uc $dir } }) {
                my $fromto = delete $self->{ uc $dir }{$distance};
                for my $pair (keys %$fromto) {
                    my ($from, $to) = split / /, $pair;
                    my ($cf, $ct) = map $compress{ $DIR{$dir2} }{$_},
                                    $from, $to;
                    warn "NO Compress $from $to" if ! defined $cf || ! defined $ct;
                    undef $self->{$dir}
                                 { $compress{ $DIR{$dir} }{$distance} }
                                 {"$cf $ct"};
                }
            }
        }
        delete @$self{qw{ H V }};
        $self->{end} = "$y $x";
        return $self
    }

    sub getSurrounding($self, $from, $to) {
        #warn "$from => $to\n";
        my ($yd0, $xd0) = split / /, $from;
        my ($ydE, $xdE) = split / /, $to;
        my $y0 = $self->{compress}{y}{$yd0};
        my $x0 = $self->{compress}{x}{$xd0};
        my $yE = $self->{compress}{y}{$ydE};
        my $xE = $self->{compress}{x}{$xdE};
        my @neighbours;
      DIR:
        for my $dir (@DIRS) {
            my $l = $y0 + $dir->[0];
            my $k = $x0 + $dir->[1];
            my $dl = $self->{decompress}{y}{$l};
            my $dk = $self->{decompress}{x}{$k};
            #warn "=> $l $k / $dl $dk";
            next if ! defined $dl || ! defined $dk;
            my $distance = abs($yd0 - $dl) + abs($xd0 - $dk);
            push @neighbours, ["$dl $dk", $distance, 0]
                if $self->{end} eq "$dl $dk";
            for my $h (keys %{ $self->{h} }) {
                if (exists $self->{h}{$l}) {
                    for my $range (keys %{ $self->{h}{$l} }) {
                        my ($from, $to) = split / /, $range;
                        next DIR if $from <= $k && $k <= $to;
                    }
                }
            }
            for my $v (keys %{ $self->{v} }) {
                if (exists $self->{v}{$k}) {
                    for my $range (keys %{ $self->{v}{$k} }) {
                        my ($from, $to) = split / /, $range;
                        next DIR if $from <= $l && $l <= $to;
                    }
                }
            }
            my $d = abs($yd0 - $dl) + abs($xd0 - $dk);
            push @neighbours, ["$dl $dk", $d,
                               sqrt(($ydE - $dl) ** 2 + ($xdE - $dk) ** 2)];
        }
        return \@neighbours
    }
}


my @instructions = split /,/, <>;
chomp $instructions[-1];
my $map = 'My::Map'->new(\@instructions);
my $path = $map->findPath('0 0', $map->{end});

my $add = 0;
for my $i (1 .. $#$path) {
    my ($y0, $x0) = split / /, $path->[ $i - 1 ];
    my ($y1, $x1) = split / /, $path->[$i];
    $add += abs($y0 - $y1) + abs($x0 - $x1) - 1
        if abs($y0 - $y1) > 1 || abs($x0 - $x1) > 1;
}
say @$path - 1 + $add;

__DATA__
L6,L3,L6,R3,L6,L3,L3,R6,L6,R6,L6,L6,R3,L3,L3,R3,R3,L6,L6,L3
