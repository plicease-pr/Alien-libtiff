use strict;
use warnings;
use Test::More tests => 3;
use Test::Alien;
use Alien::libtiff;
use File::Temp;

alien_ok 'Alien::libtiff';

my $dest = File::Temp->new( TEMPLATE => 'fooXXXX', SUFFIX => '.tiff' );

run_ok(['tiffcp', 't/x.tiff', "$dest"])
  ->success;

