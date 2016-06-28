#!/usr/bin/perl

use strict;
use warnings;
use Test::More;
use Test::Warnings;

BEGIN {
    use_ok('App::PasswdMgr');
    use_ok('App::PasswdMgr::Base');
    use_ok('App::PasswdMgr::List');
    use_ok('App::PasswdMgr::Password');
    use_ok('App::PasswdMgr::Password::Param');
    use_ok('App::PasswdMgr::Password::Encrypted');
}

diag( "Testing App::PasswdMgr $App::PasswdMgr::VERSION, Perl $], $^X" );
done_testing();
