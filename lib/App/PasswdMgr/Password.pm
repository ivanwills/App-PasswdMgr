package App::PasswdMgr::Password;

# Created on: 2016-06-20 17:29:26
# Create by:  Ivan Wills
# $Id$
# $Revision$, $HeadURL$, $Date$
# $Revision$, $Source$, $Date$

use Moo;
use warnings;
use version;
use Carp;
use Data::Dumper qw/Dumper/;
use English qw/ -no_match_vars /;
use App::PasswdMgr::Password::Param;
use App::PasswdMgr::Password::Encrypted;

extends 'App::PasswdMgr::Base';

our $VERSION = version->new('0.0.1');

sub actions {
    my ($self) = @_;
    my $actions = {
        n => {
            description => 'New parameter',
            method      => 'new_parameter',
        },
        p => {
            description => 'Enter password',
            method      => 'enter_password',
        },
        r => {
            description => 'Rename',
            method      => 'rename',
        },
        d => {
            description => 'Delete',
            method      => 'delete',
        },
    };

    if ( $self->contents->{password} ) {
        $actions = {
            %$actions,
            c => {
                description => 'Put password into clipboard',
                method      => 'clipboard',
            },
            s => {
                description => 'Show password',
                method      => 'show_password',
            },
        };
    }

    return $actions;
}

sub suffix {
    my ($self, $content) = @_;
    return ref $self->contents->{$content} ? ' ' . $self->contents->{$content}->suffix : '';
}

sub edit {
    my ($self, $content) = @_;

    return $self->show;
}

sub clipboard {
    my ($self, $content) = @_;

    $self->contents->{password}->clipboard(1);

    return $self->show;
}

before show => sub {
    my ($self) = @_;

    $self->new_parameter(1) if !%{ $self->contents };
    $self->enter_password(1) if !%{ $self->contents };

    return;
};

sub new_parameter {
    my ($self, $hide) = @_;

    my $param = App::PasswdMgr::Password::Param->new(
        parent => $self,
    )->set;

    if ( $param->value ne '' ) {
        $self->contents->{$param->name} = $param;
    }

    return $hide || $self->show;
}

sub enter_password {
    my ($self, $hide) = @_;

    if ( $self->contents->{password} ) {
        $self->contents->{password}->edit;
    }
    else {
        $self->contents->{password} = App::PasswdMgr::Password::Encrypted->new(
            parent => $self,
            name   => 'password',
        )->set;
    }

    return $hide || $self->show;
}

sub show_password {
    my ($self, $content) = @_;

    print $self->full_name . ":\n" . $self->contents->{password}->value . "\n";

    $self->pause;

    return $self->show;
}

1;

__END__

=head1 NAME

App::PasswdMgr::Password - Stores the passwords for passwdmgr

=head1 VERSION

This documentation refers to App::PasswdMgr::Password version 0.0.1

=head1 SYNOPSIS

   use App::PasswdMgr::Password;

   # Brief but working code example(s) here showing the most common usage(s)
   # This section will be as far as many users bother reading, so make it as
   # educational and exemplary as possible.


=head1 DESCRIPTION

=head1 SUBROUTINES/METHODS

=head2 C<actions ()>

Returns a hash ref of available actions for the current password.

=head2 C<suffix ( $content )>

Returns the suffix '(password)' if the item is a L<App::PasswdMgr::Password>
item.

=head2 C<edit ()>

Change the name of the password

=head2 C<clipboard ()>

Copy the password to the clipboard.

=head2 C<before: show ()>

First time show is called this will get the user to fill out details.

=head2 C<new_parameter ()>

Create a new parameter (L<App::PasswdMgr::Password::Param>) for the password

=head2 C<enter_password ()>

Add/change the stored password

=head2 C<show_password ()>

Show the password unencrypted.

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
