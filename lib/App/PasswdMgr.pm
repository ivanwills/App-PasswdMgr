package App::PasswdMgr;

# Created on: 2016-06-17 06:58:25
# Create by:  Ivan Wills
# $Id$
# $Revision$, $HeadURL$, $Date$
# $Revision$, $Source$, $Date$

use Moo;
use warnings;
use version;
use Carp;
use English qw/ -no_match_vars /;
use Getopt::Alt;
use Path::Tiny;
use YAML::Syck qw/ Load Dump /;
use Crypt::CBC;
use Crypt::Cipher::Blowfish;
use Digest::SHA qw/sha512_base64/;
use IO::Prompt;
use App::PasswdMgr::List;

our $VERSION     = version->new('0.0.1');

has [qw/cbc opt data/] => ( is => 'rw' );

sub run {
    my ($self) = @_;

    my ($options, $cmd, $opt) = get_options(
        {
            name        => 'passwdmgr',
            conf_prefix => '.',
            helper      => 1,
            default     => {
                test   => 0,
                passwords => "$ENV{HOME}/.passwdmgr",
            },
        },
        [
            'passwords|p=s',
            'dump|d',
            'create',
            'force',
        ],
    );

    $self->opt($options);
    if ( $options->create || !-f $self->opt->passwords ) {
        $self->create;
    }
    else {
        $self->build_cbc();
    }

    $self->data( Load( $self->cbc->decrypt( scalar path($self->opt->passwords)->slurp )));

    if ( !ref $self->data || ! $self->data->can('show') ) {
        warn "Bad password!\n";
        return;
    }
    if ( $options->dump ) {
        print Dump($self->data);
        exit 1;
    }

    $self->data->show;

    path($self->opt->passwords)->spew( scalar $self->cbc->encrypt( Dump($self->data) ) );

    return;
}

sub build_cbc {
    my ($self, $confirm) = @_;

    my $key = prompt( -p => 'Password: ', -e => '*' ) || die "No key!";
    my $iv  = Crypt::CBC->random_bytes(8);

    if ($confirm) {
        my $confirm = prompt( -p => 'Re-enter password: ', -e => '*' );

        die "Passwords don't match!\n" if $key ne $confirm;
    }

    $self->cbc(
        Crypt::CBC->new(
            -cipher => 'Cipher::Blowfish',
            -key    => $key,
        )
    );

    return;
}

sub create {
    my ($self) = @_;

    if ( -f $self->opt->passwords && $self->opt->force ) {
        die "Won't try to replace existing file '" . $self->opt->passwords ."'!\n";
    }

    $self->build_cbc(1);

    path($self->opt->passwords)->spew(
        scalar $self->cbc->encrypt(
            Dump(App::PasswdMgr::List->new(contents => {}, name => 'Base Menu' ))
        )
    );
}


1;

__END__

=head1 NAME

App::PasswdMgr - A command line password manager

=head1 VERSION

This documentation refers to App::PasswdMgr version 0.0.1

=head1 SYNOPSIS

    passwdmgr [options]
    passwdmgr (-p|--passwords) password-file

  OPTIONS:
    -p --passwords[=]file
                    File with stored passwords (Default ~/.passwdmgr)
    -c --create     Create new passwords file
    -f --force      Force the overwritting of existing passwords file
    -v --verbose    Show verbose information
       --version    Show passwdmrg version
       --help       Show this help
       --man        Show full help documentation

=head1 DESCRIPTION

=head1 SUBROUTINES/METHODS

=head2 C<run ()>

Runs the whole thing

=head2 C<build_cbc ( $confirm )>

Set up the decryption object

=head2 C<create ()>

Create a new passwordmgr file.

=head1 ATTRIBUTES

=over 4

=item cbc

The L<Crypt::CBC> object for encrypting the data.

=item opt

Command line optons.

=item data

The internal decrypted passwords.

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
