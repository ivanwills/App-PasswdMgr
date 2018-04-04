use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name       => 'App::PasswdMgr',
    license           => 'perl',
    dist_author       => 'Ivan Wills <ivan.wills@gmail.com>',
    dist_version_from => 'lib/App/PasswdMgr.pm',
    requires          => {
        'perl'                    => '5.016',
        'Clipboard'               => 0,
        'Crypt::CBC'              => 0,
        'Crypt::Cipher::Blowfish' => 0,
        'Crypt::HSXKPasswd'       => 'v3.6',
        'Crypt::RandPasswd'       => '0.06',
        'Crypt::YAPassGen'        => '0.02',
        'Digest::SHA'             => 0,
        'Getopt::Alt'             => 0,
        'IO::Prompt'              => 0,
        'List::Util'              => 0,
        'Moo'                     => 2,
        'Path::Tiny'              => 0,
        'Scalar::Util'            => 0,
        'String::MkPasswd'        => '0.05',
        'Term::Screen'            => 0,
        'Term::Size::Any'         => 0,
        'Try::Tiny'               => 0,
        'YAML::Syck'              => 0,
        'version'                 => 0,
    },
    build_requires => {
        'Test::More'     => '0.88',
        'Test::Warnings' => '0.026',
    },
    add_to_cleanup     => [ 'App-PasswdMgr-*' ],
    create_license     => 1,
    meta_merge => {
        resources => {
            repository => 'git://github.com/ivanwills/App-PasswdMgr.git',
            bugtracker => 'http://rt.cpan.org/NoAuth/Bugs.html?Dist=App::PasswdMgr',
        },
    },
);

$builder->create_build_script();
