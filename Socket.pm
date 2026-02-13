package Mo::utils::Socket;

use base qw(Exporter);
use strict;
use warnings;

use English;
use Error::Pure qw(err);
use Readonly;
use Socket qw(SOL_SOCKET SO_TYPE);

Readonly::Array our @EXPORT_OK => qw(check_socket);

our $VERSION = 0.01;

sub check_socket {
	my ($self, $key) = @_;

	_check_key($self, $key) && return;

	# e.g. IO::Socket->new without open.
	if (! defined fileno($self->{$key})) {
		err "Parameter '$key' doesn't contain valid socket.",
			'Error', 'File descriptor does not exist',
		;
	}

	# Other.
	my $opt = getsockopt($self->{$key}, SOL_SOCKET, SO_TYPE);
	if (! defined $opt) {
		err "Parameter '$key' doesn't contain valid socket.",
			'Error', $ERRNO,
		;
	}

	return;
}

sub _check_key {
	my ($self, $key) = @_;

	if (! exists $self->{$key} || ! defined $self->{$key}) {
		return 1;
	}

	return 0;
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

Mo::utils::Socket - Mo socket utilities.

=head1 SYNOPSIS

 use Mo::utils::Socket qw(check_socket);

 check_socket($self, $key);

=head1 DESCRIPTION

Mo socket utilities for checking of data objects.

=head1 SUBROUTINES

=head2 C<check_socket>

 check_socket($self, $key);

Check parameter defined by C<$key> if it's open socket or not.
Value could be undefined.

Returns undef.

=head1 ERRORS

 check_socket():
         Parameter '%s' doesn't contain valid socket.
                 Error: %s

=head1 EXAMPLE1

=for comment filename=check_socket_ok.pl

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

=head1 EXAMPLE2

=for comment filename=check_socket_fail.pl

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

=head1 DEPENDENCIES

L<English>,
L<Error::Pure>,
L<Exporter>,
L<Readonly>,
L<Socket>.

=head1 SEE ALSO

=over

=item L<Mo>

Micro Objects. Mo is less.

=item L<Mo::utils>

Mo utilities.

=back

=head1 REPOSITORY

L<https://github.com/michal-josef-spacek/Mo-utils-Socket>

=head1 AUTHOR

Michal Josef Špaček L<mailto:skim@cpan.org>

L<http://skim.cz>

=head1 LICENSE AND COPYRIGHT

© 2026 Michal Josef Špaček

BSD 2-Clause License

=head1 VERSION

0.01

=cut
