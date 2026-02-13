#!/usr/bin/env perl

use strict;
use warnings;

use English;
use Mo::utils::Socket qw(check_socket);
use Socket qw(AF_UNIX SOCK_STREAM PF_UNSPEC);

socketpair(my $sock1, my $sock2, AF_UNIX, SOCK_STREAM, PF_UNSPEC)
        or die "socketpair: $ERRNO";
my $self = {
        'key' => $sock1,
};
check_socket($self, 'key');

# Print out.
print "ok\n";

# Output:
# ok