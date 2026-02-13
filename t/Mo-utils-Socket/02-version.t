use strict;
use warnings;

use Mo::utils::Socket;
use Test::More 'tests' => 2;
use Test::NoWarnings;

# Test.
is($Mo::utils::Socket::VERSION, 0.01, 'Version.');
