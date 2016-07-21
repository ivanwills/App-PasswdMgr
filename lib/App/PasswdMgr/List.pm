package App::PasswdMgr::List;

# Created on: 2016-06-20 17:29:11
# Create by:  Ivan Wills
# $Id$
# $Revision$, $HeadURL$, $Date$
# $Revision$, $Source$, $Date$

use Moo;
use warnings;
use version;
use Carp;
use English qw/ -no_match_vars /;
use App::PasswdMgr::Password;

extends 'App::PasswdMgr::Base';

our $VERSION = version->new('0.0.1');

sub actions {
    my ($self) = @_;
    my $actions = {
        p => {
            description => 'New password',
            method      => 'new_password',
        },
        g => {
            description => 'New group',
            method      => 'new_group',
        },
    };
    if ( $self->parent ) {
        $actions->{d} = {
            description => 'Delete this group (and ' . (keys %{$self->contents}) . ' items)',
            method      => 'delete',
        };
        $actions->{r} = {
            description => 'Rename group',
            method      => 'rename',
        };
    }
    return $actions;
}

sub suffix {
    my ($self, $content) = @_;
    return $content eq 'name'                            ? undef
        : ref $self->contents->{$content} eq __PACKAGE__ ? ''
        :                                                  ' (password)';
}

sub new_group {
    my ($self) = @_;
    return $self->_new( "New groups name: ", 'App::PasswdMgr::List' );
}

sub new_password {
    my ($self) = @_;
    return $self->_new( "New password's name: ", 'App::PasswdMgr::Password' );
}

1;

__END__

=head1 NAME

App::PasswdMgr::List - Stores a list of PasswdMgr items

=head1 VERSION

This documentation refers to App::PasswdMgr::List version 0.0.1

=head1 SYNOPSIS

   use App::PasswdMgr::List;

   # Brief but working code example(s) here showing the most common usage(s)
   # This section will be as far as many users bother reading, so make it as
   # educational and exemplary as possible.


=head1 DESCRIPTION

=head1 SUBROUTINES/METHODS

=head2 C<actions ()>

Returns a hash ref of available actions for the current list.

=head2 C<suffix ( $content )>

Returns the suffix '(password)' if the item is a L<App::PasswdMgr::Password>
item.

=head2 C<new_group ()>

Creates new group L<App::PasswordMgr::List> of list items.

=head2 C<new_password ()>

Creates a new password item

=head2 C<delete ()>

Deletes the current group from the parent list.

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
