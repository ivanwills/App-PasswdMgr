package App::PasswdMgr::Password::Encrypted;

# Created on: 2016-06-23 06:55:30
# Create by:  Ivan Wills
# $Id$
# $Revision$, $HeadURL$, $Date$
# $Revision$, $Source$, $Date$

use Moo;
use warnings;
use version;
use Carp;
use Scalar::Util;
use List::Util;
#use List::MoreUtils;
use Data::Dumper qw/Dumper/;
use English qw/ -no_match_vars /;

extends 'App::PasswdMgr::Password::Param';

our $VERSION = version->new('0.0.1');

has '+types' => (
    default => sub {{
        'Auto generate'  => 'generate',
        'Enter password' => 'hand',
    }},
);
has '+value_question' => (
    default => sub {return {
        -p => 'Password: ',
        -e => '*',
    }},
);

sub actions {
    {
        c => {
            description => 'Put password into clipboard',
            method      => 'clipboard',
        },
        n => {
            description => 'Insert new parameter',
            method      => 'new_parameter',
        },
        p => {
            description => 'Enter password',
            method      => 'enter_password',
        },
        s => {
            description => 'Show password',
            method      => 'show_password',
        },
        r => {
            description => 'Rename group',
            method      => 'rename',
        },
    }
}

sub suffix {
    return '(********)';
}

sub enter_value {
    my ($self) = @_;
    return $self->type eq 'hand';
}

1;

__END__

=head1 NAME

App::PasswdMgr::Password::Encrypted - An encrypted param for password

=head1 VERSION

This documentation refers to App::PasswdMgr::Password::Encrypted version 0.0.1

=head1 SYNOPSIS

   use App::PasswdMgr::Password::Encrypted;

   # Brief but working code example(s) here showing the most common usage(s)
   # This section will be as far as many users bother reading, so make it as
   # educational and exemplary as possible.


=head1 DESCRIPTION

=head1 SUBROUTINES/METHODS

=head2 C<actions ()>

Returns a hash ref of available actions

=head2 C<suffix ()>

Adds a '(*****)' to passwords

=head2 C<enter_value ()>

Returns true if the password is to be a user entered value

=head1 ATTRIBUTES

=over 4

=item types

Returns the menu of password types

=item value_question

Returns the parameters for asking to enter a password

=back

=head1 DIAGNOSTICS

=head1 CONFIGURATION AND ENVIRONMENT

=head1 DEPENDENCIES

=head1 INCOMPATIBILITIES

=head1 BUGS AND LIMITATIONS

There are no known bugs in this module.

Please report problems to Ivan Wills (ivan.wills@gmail.com).

Patches are welcome.

=head1 AUTHOR

Ivan Wills - (ivan.wills@gmail.com)

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2016 Ivan Wills (14 Mullion Close, Hornsby Heights, NSW Australia 2077).
All rights reserved.

This module is free software; you can redistribute it and/or modify it under
the same terms as Perl itself. See L<perlartistic>.  This program is
distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.

=cut
