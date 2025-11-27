#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

my %plant;
my %free;
my @tests;

my $last_plant;
while (<>) {
    if (/Plant (.+) with thickness (.+):/) {
        my ($plant, $thickness) = @{^CAPTURE};
        $plant{$plant}{THICK} = $thickness;
        $last_plant = $plant;

    } elsif (/- free branch with thickness (.+)/) {
        $plant{$last_plant}{FREE} = $1;
        undef $free{$last_plant};

    } elsif (/- branch to Plant (.+) with thickness (.+)/) {
        my ($plant, $thickness) = @{^CAPTURE};
        $plant{$plant}{CONNECT}{$last_plant} = $thickness;
    } elsif (/[01 ]+/) {
        push @tests, [split ' '];
    }
}

my %forbidden;
for my $plant (keys %plant) {
    my $brings = grep $_ > 0, values %{ $plant{$plant}{CONNECT} };
    if (! $brings) {
        undef $forbidden{$plant};
    }
    die "UNCLEAR $plant" if $brings > 0 && $brings != keys %{ $plant{$plant}{CONNECT} }
}

unshift @tests, [map exists $forbidden{$_} ? 0 : 1, 1 .. keys %free];

my $max;
my $sum = 0;
for my $test (@tests) {
    my %agenda;
    for my $plant (keys %free) {
        $plant{$plant}{ENERGY} = $plant{$plant}{FREE} * $test->[ $plant - 1 ];
        for my $next (keys %{ $plant{$plant}{CONNECT} }) {
            undef $agenda{$next}{ $plant{$plant}{CONNECT}{$next} }{$plant};
        }
    }

    while (%agenda) {
        my %next;
        for my $plant (keys %agenda) {
            for my $thickness (keys %{ $agenda{$plant} }) {
                for my $from (keys %{ $agenda{$plant}{$thickness} }) {
                    my $boost = $thickness * ($plant{$from}{ENERGY} // 0);
                    $plant{$plant}{ENERGY} += $boost
                        if ($plant{$from}{ENERGY} // 0) >= $plant{$from}{THICK};
                    for my $next (keys %{ $plant{$plant}{CONNECT} }) {
                        undef $next{$next}{ $plant{$plant}{CONNECT}{$next} }
                              {$plant};
                    }
                }
            }
        }
        %agenda = %next;
    }

    my ($last) = grep ! keys %{ $plant{$_}{CONNECT} }, keys %plant;
    my $energy = ($plant{$last}{ENERGY} // 0) >= $plant{$last}{THICK}
        ? $plant{$last}{ENERGY}
        : 0;
    if (! defined $max) {
        $max = $energy;
    } else {
        $sum += $max - $energy if $energy;
    }
    delete $plant{$_}{ENERGY} for keys %plant;
}
say $sum;

__DATA__
Plant 1 with thickness 1:
- free branch with thickness 1

Plant 2 with thickness 1:
- free branch with thickness 1

Plant 3 with thickness 1:
- free branch with thickness 1

Plant 4 with thickness 1:
- free branch with thickness 1

Plant 5 with thickness 8:
- branch to Plant 1 with thickness -8
- branch to Plant 2 with thickness 11
- branch to Plant 3 with thickness 13
- branch to Plant 4 with thickness -7

Plant 6 with thickness 7:
- branch to Plant 1 with thickness 14
- branch to Plant 2 with thickness -9
- branch to Plant 3 with thickness 12
- branch to Plant 4 with thickness 9

Plant 7 with thickness 23:
- branch to Plant 5 with thickness 17
- branch to Plant 6 with thickness 18


0 1 0 0
0 1 0 1
0 1 1 1
1 1 0 1
