#!/usr/bin/env perl

use strict;
use warnings;

use Error::Pure;
use Mo::utils::Socket qw(check_socket);

$Error::Pure::TYPE = 'Error';

my $self = {
        'key' => 'xx',
};
check_socket($self, 'key');

# Print out.
print "ok\n";

# Output like:
# #Error [../Mo/utils/Socket.pm:25] Parameter 'key' doesn't contain valid socket.