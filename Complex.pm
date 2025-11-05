package Complex;
use warnings;
use strict;

{   package Complex;
    use experimental qw( signatures );

    sub new($class, $x, $y) {
        bless [$x, $y], $class
    }

    sub add($self, $c) {
        'Complex'->new($self->[0] + $c->[0], $self->[1] + $c->[1])
    }

    sub mult($self, $c) {
        'Complex'->new($self->[0] * $c->[0] - $self->[1] * $c->[1],
                       $self->[0] * $c->[1] + $self->[1] * $c->[0])
    }

    sub div($self, $c) {
        'Complex'->new(int($self->[0] / $c->[0]), int($self->[1] / $c->[1]))
    }

    sub show($self) {
        '[' . $self->[0] . ',' . $self->[1] . ']'
    }
}

if ($ENV{TEST}) {
    eval {
        use Test2::V0;

        is 'Complex'->new(1,1)->add('Complex'->new(2,2)), [3,3], 'add 1';
        is 'Complex'->new(2,5)->add('Complex'->new(3,7)), [5,12], 'add 2';
        is 'Complex'->new(-2,5)->add('Complex'->new(10,-1)), [8,4], 'add 3';
        is 'Complex'->new(-1,-2)->add('Complex'->new(-3,-4)), [-4,-6], 'add 4';

        is 'Complex'->new(1,1)->mult('Complex'->new(2,2)), [0,4], 'mult 1';
        is 'Complex'->new(2,5)->mult('Complex'->new(3,7)), [-29,29], 'mult 2';
        is 'Complex'->new(-2,5)->mult('Complex'->new(10,-1)), [-15,52], 'mult 3';
        is 'Complex'->new(-1,-2)->mult('Complex'->new(-3,-4)), [-5,10], 'mult 4';

        is 'Complex'->new(10,12)->div('Complex'->new(2,2)), [5,6], 'div 1';
        is 'Complex'->new(11,12)->div('Complex'->new(3,5)), [3,2], 'div 2';
        is 'Complex'->new(-10,-12)->div('Complex'->new(2,2)), [-5,-6], 'div 3';
        is 'Complex'->new(-11,-12)->div('Complex'->new(3,5)), [-3,-2], 'div 4';

        done_testing();
    }
}

__PACKAGE__
