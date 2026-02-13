use strict;
use warnings;

use Check::Socket 0.03;
use English;
use Error::Pure::Utils qw(clean);
use File::Temp qw(tempfile);
use IO::Socket;
use Mo::utils::Socket qw(check_socket);
use Socket qw(AF_UNIX SOCK_STREAM PF_UNSPEC);
use Test::More 'tests' => 7;
use Test::NoWarnings;

# Test.
my $self = {};
my $ret = check_socket($self, 'key');
is($ret, undef, 'Right not exist key.');

# Test.
$self = {
	'key' => undef,
};
$ret = check_socket($self, 'key');
is($ret, undef, "Value is undefined, that's ok.");

# Test.
$self = {
	'key' => IO::Socket->new,
};
eval {
	check_socket($self, 'key');
};
is($EVAL_ERROR, "Parameter 'key' doesn't contain valid socket.\n",
	"Parameter 'key' doesn't contain valid socket (IO::Socket->new).");
clean();

# Test.
my ($tmp_fh) = tempfile();
$self = {
	'key' => $tmp_fh,
};
eval {
	check_socket($self, 'key');
};
is($EVAL_ERROR, "Parameter 'key' doesn't contain valid socket.\n",
	"Parameter 'key' doesn't contain valid socket (temporary file handle).");
clean();

SKIP: {
	skip $Check::Socket::ERROR_MESSAGE, 2 unless Check::Socket::check_socket();

	my ($sock1, $sock2);
	skip "Cannot use socketpair: $ERRNO", 2
		unless socketpair($sock1, $sock2, AF_UNIX, SOCK_STREAM, PF_UNSPEC);

	# Test.
	$self = {
		'key' => $sock1,
	};
	$ret = check_socket($self, 'key');
	is($ret, undef, 'Right value (socket created by socketpair).');

	# Test.
	$self = {
		'key' => IO::Socket->new('Domain' => AF_UNIX),
	};
	$ret = check_socket($self, 'key');
	is($ret, undef, 'Right value (AF_UNIX socket).');
};
