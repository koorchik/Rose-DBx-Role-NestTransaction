package Rose::DBx::Role::NestTransaction;

use strict;
use warnings;

use Role::Tiny;

=head1 NAME

Rose::DBx::Role::NestTransaction - Nested transactions support for Rose::DB::Object

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS
	# Define yout DB class
	package MyDB;
	use base 'Rose::DB';
    
    use Role::Tiny::With;
	with 'Rose::DBx::Role::NestTransaction';
    
	Somewhere in your code

	MyDB->new_or_cached->nest_transaction(sub {
        User->new( name => 'name' )->save();
    });


=head1 DESCRIPTION

This module provides a role for Rose::DB. Just consume the role in your Rose::DB subclass

=head1 METHODS

=head2 nest_transaction

These methods behaves like do_transaction but it repects existing transactions and do not start new one if the transaction already started. On error it revert transaction and rethrow exception

=cut

sub nest_transaction {
    my ($self, $cb) = @_;
    
    if ( $self->in_transaction ) {
        $cb->();
    } else {
        $self->do_transaction($cb) or die $self->error;    
    }
}

=head1 AUTHOR

Viktor Turskyi, C<< <koorchik at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-rose-dbx-role-nestedtransaction at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Rose-DBx-Role-NestTransaction>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.


=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Rose::DBx::Role::NestTransaction


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Rose-DBx-Role-NestTransaction>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Rose-DBx-Role-NestTransaction>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Rose-DBx-Role-NestTransaction>

=item * Search CPAN

L<http://search.cpan.org/dist/Rose-DBx-Role-NestTransaction/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2012 Viktor Turskyi.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1; # End of Rose::DBx::Role::NestTransaction
