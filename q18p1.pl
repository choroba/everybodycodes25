#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use ARGV::OrDATA;

my %plant;
my %free;

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
    }
}

my %agenda;
for my $plant (keys %free) {
    $plant{$plant}{ENERGY} = $plant{$plant}{FREE};
    for my $next (keys %{ $plant{$plant}{CONNECT} }) {
        undef $agenda{$next}{ $plant{$plant}{CONNECT}{$next} }{$plant};
    }
}

while (%agenda) {
    my %next;
    for my $plant (keys %agenda) {
        for my $thickness (keys %{ $agenda{$plant} }) {
            for my $from (keys %{ $agenda{$plant}{$thickness} }) {
                $plant{$plant}{ENERGY} += $thickness * $plant{$from}{ENERGY};
                for my $next (keys %{ $plant{$plant}{CONNECT} }) {
                    undef $next{$next}{ $plant{$plant}{CONNECT}{$next} }{$plant}
                        if $plant{$plant}{ENERGY} >= $plant{$plant}{THICK};
                }
            }
        }
    }
    %agenda = %next;
}

my ($last) = grep ! keys %{ $plant{$_}{CONNECT} }, keys %plant;
say $plant{$last}{ENERGY};

__DATA__
Plant 1 with thickness 1:
- free branch with thickness 1

Plant 2 with thickness 1:
- free branch with thickness 1

Plant 3 with thickness 1:
- free branch with thickness 1

Plant 4 with thickness 17:
- branch to Plant 1 with thickness 15
- branch to Plant 2 with thickness 3

Plant 5 with thickness 24:
- branch to Plant 2 with thickness 11
- branch to Plant 3 with thickness 13

Plant 6 with thickness 15:
- branch to Plant 3 with thickness 14

Plant 7 with thickness 10:
- branch to Plant 4 with thickness 15
- branch to Plant 5 with thickness 21
- branch to Plant 6 with thickness 34
