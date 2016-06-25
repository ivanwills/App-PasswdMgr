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

App::PasswdMgr::Password::Param - <One-line description of module's purpose>

=head1 VERSION

This documentation refers to App::PasswdMgr::Password::Param version 0.0.1


=head1 SYNOPSIS

   use App::PasswdMgr::Password::Param;

   # Brief but working code example(s) here showing the most common usage(s)
   # This section will be as far as many users bother reading, so make it as
   # educational and exemplary as possible.


=head1 DESCRIPTION

A full description of the module and its features.

May include numerous subsections (i.e., =head2, =head3, etc.).


=head1 SUBROUTINES/METHODS

A separate section listing the public components of the module's interface.

These normally consist of either subroutines that may be exported, or methods
that may be called on objects belonging to the classes that the module
provides.

Name the section accordingly.

In an object-oriented module, this section should begin with a sentence (of the
form "An object of this class represents ...") to give the reader a high-level
context to help them understand the methods that are subsequently described.


=head3 C<new ( $search, )>

Param: C<$search> - type (detail) - description

Return: App::PasswdMgr::Password::Param -

Description:

=cut


=head1 DIAGNOSTICS

A list of every error and warning message that the module can generate (even
the ones that will "never happen"), with a full explanation of each problem,
one or more likely causes, and any suggested remedies.

=head1 CONFIGURATION AND ENVIRONMENT

A full explanation of any configuration system(s) used by the module, including
the names and locations of any configuration files, and the meaning of any
environment variables or properties that can be set. These descriptions must
also include details of any configuration language used.

=head1 DEPENDENCIES

A list of all of the other modules that this module relies upon, including any
restrictions on versions, and an indication of whether these required modules
are part of the standard Perl distribution, part of the module's distribution,
or must be installed separately.

=head1 INCOMPATIBILITIES

A list of any modules that this module cannot be used in conjunction with.
This may be due to name conflicts in the interface, or competition for system
or program resources, or due to internal limitations of Perl (for example, many
modules that use source code filters are mutually incompatible).

=head1 BUGS AND LIMITATIONS

A list of known problems with the module, together with some indication of
whether they are likely to be fixed in an upcoming release.

Also, a list of restrictions on the features the module does provide: data types
that cannot be handled, performance issues and the circumstances in which they
may arise, practical limitations on the size of data sets, special cases that
are not (yet) handled, etc.

The initial template usually just has:

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
