package App::PasswdMgr::Password::Param;

# Created on: 2016-06-22 07:19:55
# Create by:  Ivan Wills
# $Id$
# $Revision$, $HeadURL$, $Date$
# $Revision$, $Source$, $Date$

use Moo;
use warnings;
use version;
use Carp;
use English qw/ -no_match_vars /;
use Clipboard qw//;

extends 'App::PasswdMgr::Base';

our $VERSION = version->new('0.0.1');

has [qw/value type/] => ( is => 'rw' );
has types => (
    is      => 'rw',
    default => sub {{
        Username => 'username',
        Key      => 'key',
        Other    => 'other',
    }},
);
has value_question => (
    is      => 'rw',
    default => sub {return {
        -p => 'Value: ',
    }},
);

sub actions {
    {
        c => {
            description => 'Copy into clipboard',
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
        d => {
            description => 'Delete',
            method      => 'delete',
        },
    }
}

sub set {
    my ($self) = @_;

    my$name;
    my $type = $self->question(
        -p => 'Parameter type: ',
        -m => $self->types,
    );

    if ( $type eq 'other' ) {
        $name = $self->question('Name: ');
    }
    else {
        $name = ucfirst $type;
    }
    $self->name($name) if !$self->name;
    $self->type($type);

    if ($self->enter_value) {
        my $value = $self->question(%{ $self->value_question });
        $self->value($value);
    }

    return $self;
}

sub enter_value {1}

sub suffix {
    my ($self) = @_;

    return '(' . $self->value . ')';
}

sub clipboard {
    my ($self, $hide) = @_;

    Clipboard->copy( $self->value );

    return $hide || $self->show;
}

1;

__END__

=head1 NAME

App::PasswdMgr::Password::Param - A parameter for a password

=head1 VERSION

This documentation refers to App::PasswdMgr::Password::Param version 0.0.1

=head1 SYNOPSIS

   use App::PasswdMgr::Password::Param;

   # Brief but working code example(s) here showing the most common usage(s)
   # This section will be as far as many users bother reading, so make it as
   # educational and exemplary as possible.


=head1 DESCRIPTION

=head1 SUBROUTINES/METHODS

=head2 C<actions ()>

Returns a hash ref of available actions

=head2 C<suffix ()>

Adds the value when displaying the parameter.

=head2 C<enter_value ()>

Returns true if the password is to be a user entered value

=head2 C<clipboard ()>

Copy's the parameters value to the system clipboard.

=head2 C<set ()>

This method is used to allow the user to set/update the parameter

=head1 ATTRIBUTES

=over 4

=item types

Returns the menu of password types

=item type

Stores the type of parameter

=item value

Stores the value of the parameter

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
