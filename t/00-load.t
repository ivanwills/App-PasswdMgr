#!/usr/bin/perl

use strict;
use warnings;
use Test::More;
use Test::Warnings;

BEGIN {
    use_ok( 'App::PasswdMgr' );
}

diag( "Testing App::PasswdMgr $App::PasswdMgr::VERSION, Perl $], $^X" );
done_testing();
