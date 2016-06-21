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
use Crypt::Blowfish;
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
            'passwords|c=s',
            'create',
            'force',
            'name|n=s',
            'test|T!',
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
            Dump(App::PasswdMgr::List->new(contents => { name => 'Base Menu' }))
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

   use App::PasswdMgr;

   # Brief but working code example(s) here showing the most common usage(s)
   # This section will be as far as many users bother reading, so make it as
   # educational and exemplary as possible.

=head1 DESCRIPTION

=head1 SUBROUTINES/METHODS

=head3 C<new ( $search, )>

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
