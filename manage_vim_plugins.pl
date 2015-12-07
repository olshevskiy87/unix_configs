#!/usr/bin/perl

use strict;
use warnings;
use JSON::Parse 'json_file_to_perl';
use Getopt::Long qw(GetOptions);
use IPC::Cmd qw(can_run);
use File::Spec qw(catdir);
use File::HomeDir;
use File::chdir;
use File::Path qw(rmtree make_path);
use Carp qw(carp);
use English qw(-no_match_vars);

use vars qw($VERSION);
$VERSION = '0.001';

my $git_exec = can_run('git')
    or die "error: git is not enabled/installed. exit.\n";

my $bundle_path = File::Spec->catdir((
    File::HomeDir->my_home,
    '.vim/bundle'
));
my $plugins_fname = 'plugins.json';
my $update = 0;
my $help = 0;

GetOptions(
    'bundle_path=s' => \$bundle_path,
    'plugins=s' => \$plugins_fname,
    'update' => \$update,
    'help|?' => \$help
) or usage();

if ($help || !$bundle_path || !$plugins_fname) {
    usage();
}

if (! -d $bundle_path) {
    carp 'bundle path doesn\'t exist. try to create... ';
    if (scalar make_path($bundle_path)) {
        carp "ok.\n";
    } else {
        die "error. exit.\n";
    }
}
if (! -f $plugins_fname) {
    die "error: file with plugins list doesn't exist. exit.\n";
}

my $all_plugins = json_file_to_perl($plugins_fname);
my $plugin_path;
for my $plugin (@{$all_plugins}) {
    printf "%-15s: %s\n",
        $plugin->{name},
        ($plugin->{enable} ? $plugin->{url} : 'disabled');

    $plugin_path = File::Spec->catdir((
        $bundle_path,
        $plugin->{name}
    ));
    if ($plugin->{enable}) {
        # we must install or update plugin
        if (-d $plugin_path) {
            # plugin is installed - pull changes if needed
            if ($update) {
                local $CWD = $plugin_path;
                `git pull`;
            }
        } else {
            # plugin is not installed - clone it
            carp "plugin [$plugin->{name}] not found. create it...\n";
            local $CWD = $bundle_path;
            `git clone -q $plugin->{url} $plugin->{name}`;
        }
    } else {
        # delete plugin if exist
        if (-d $plugin_path) {
            carp "plugin [$plugin->{name}] disabled, but still exist. remove it...\n";
            rmtree($plugin_path);
        }
    }
}

sub usage {
    die <<"EOF";
Stupid vim plugins manager.
Usage:
    $PROGRAM_NAME [OPTIONS]
Options:
    --bundle_path=PATH  vim bundles path (default: '~/.vim/bundle')
    --plugins=FILENAME  path to the json-file with required plugins (default: 'plugins.json')
    --update            update plugin if already exist
    -? | --help         show this help, then exit
EOF
}

