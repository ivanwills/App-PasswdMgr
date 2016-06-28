package App::PasswdMgr::Base;

# Created on: 2016-06-20 18:14:54
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
use IO::Prompt;
use Term::Size::Any qw/chars/;
use Term::Screen;

our $VERSION = version->new('0.0.1');

has contents => (
    is      => 'rw',
    default => sub {{}},
);
has parent => ( is => 'rw' );
has name   => ( is => 'rw' );

sub show {
    my ($self, $retry) = @_;

    if ( ! $retry ) {
        $self->clear;
    }

    my %actions = (
        q => {
            description => "Quit",
        },
        %{ $self->actions },
    );

    my $i = 0;
    for my $content (sort {lc $a cmp lc $b} keys %{ $self->contents }) {
        my $suffix = $self->suffix($content);
        $actions{$i++} = {
            description => "$content$suffix",
            content     => $content,
        };
    }

    my $menu = $self->menu(%actions);
    print $menu;

    my $ans = $self->question(
        -p => '> ',
        ( $i <= 10 ? '-one_char' : () ),
    );
    $self->clear;

    return if $ans eq '' || $ans eq 'q';

    my $method = exists $actions{$ans} && $actions{$ans}{method};

    return $self->$method() if $method;

    if ( ! exists $actions{$ans} ) {
        my @actions = sort keys %actions;
        print "\nPlease choose one of " . ( join ', ', @actions[0..$#actions-1] ) . " or $actions[-1]!\n";
        $retry++;
        return if $retry > 10;
        return $self->show($retry);
    }

    $self->contents->{$actions{$ans}{content}}->can('show')
        ? $self->contents->{$actions{$ans}{content}}->show
        : $self->edit($actions{$ans}{content});

    return $self->show;
}

sub clear {
    my ($cols, $rows) = chars();
    Term::Screen->new->at(0,0)->puts(' ' x ( $rows * $cols ));
}

sub menu {
    my ($self, %menu) = @_;
    my @ordered = sort {$a =~ /^\d+$/ && $b =~ /^\d+$/ ? $a <=> $b : $a cmp $b} keys %menu;

    print $self->name && $self->full_name || "Select one :", "\n";

    my $menu = '';
    for my $item (@ordered) {
        $menu .= sprintf "\t%2s  %s\n", $item, $menu{$item}{description};
    }

    return $menu;
}

sub full_name {
    my ($self) = @_;

    return $self->name if ! $self->parent;

    return $self->parent->full_name . ' / ' . $self->name . $self->parent->suffix($self->name);
}

sub suffix {''}

sub rename {
    my ($self) = @_;

    print $self->full_name . "\n";
    my $new_name = $self->question('New name: ');
    if ( $new_name ) {
        if ( $self->parent->contents->{$new_name} ) {
            print "A '$new_name' already exists!\n";
        }
        else {
            my $old_name = $self->name;
            $self->name($new_name);
            $self->parent->contents->{$new_name} = $self;
            delete $self->parent->contents->{$old_name};
        }
    }

    return $self->show;
}

sub _new {
    my ($self, $text, $type) = @_;
    my $name = $self->question( -p => $text );

    if ( ! $name ) {
        return $self->show(1);
    }
    elsif ( $name =~ /^_/ ) {
        print "Can't start with underscores!\n";
        return $self->show(1);
    }
    elsif ( exists $self->contents->{$name} ) {
        $self->clear;
        print "'$name' already exists!\n";
        return $self->show(1);
    }

    $self->contents->{$name} = $type->new(
        parent => $self,
        name   => $name,
    );

    $self->contents->{$name}->show;

    return $self->show;
}

sub question {
    my ($self, @args) = @_;
    return '' . prompt(@args);
}

1;

__END__

=head1 NAME

App::PasswdMgr::Base - Base class for object stored by App::PasswdMgr

=head1 VERSION

This documentation refers to App::PasswdMgr::Base version 0.0.1

=head1 SYNOPSIS

   use App::PasswdMgr::Base;

   # Brief but working code example(s) here showing the most common usage(s)
   # This section will be as far as many users bother reading, so make it as
   # educational and exemplary as possible.

=head1 DESCRIPTION

=head1 SUBROUTINES/METHODS

=head2 C<show ()>

=head2 C<clear ()>

=head2 C<menu ()>

=head2 C<full_name ()>

=head2 C<suffix ()>

=head2 C<rename ()>

=head2 C<_new ()>

=head2 C<question ()>

=head1 ATTRIBUTES

=over 4

=item contents

Stores the item's data

=item parent

A reference to the parent item

=item name

The name of the item

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
