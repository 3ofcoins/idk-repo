#!/usr/bin/perl -w
use strict;

use constant JENKINS_BASE_URL => 'http://localhost:8080';

use Cwd;
use File::Basename;
use File::Copy;
use File::Path;
use File::Spec::Functions;
use Getopt::Long qw(:config auto_help);
use Pod::Usage;

use LWP::UserAgent;
use XML::Simple;

# Find default for Jenkins root
our $jenkins_root = Cwd::realpath(__FILE__);
do {
  $jenkins_root = dirname($jenkins_root);
} until ( -f catfile($jenkins_root, 'config.xml') || $jenkins_root eq '/' );
undef $jenkins_root if $jenkins_root eq '/';
our $jenkins_url = 'http://localhost:8080';

GetOptions(
  'jenkins-root=s' => \$jenkins_root,
  'jenkins-url=s' => \$jenkins_url
) or die;

die "Can't figure out Jenkins root\n" unless $jenkins_root;

$jenkins_url =~ s/\/*$//;       # drop trailing slashes

my $backup_dir = XMLin(catfile($jenkins_root, 'backup.xml'))->{targetDirectory};
my $full_dir = catfile($backup_dir, 'full');

print "Jenkins root: $jenkins_root\nJenkins URL: $jenkins_url\nBackup directory: $backup_dir\n";

our ( $ua, $tarball, $resp, $finished );

$ua = LWP::UserAgent->new;
$ua->default_header('OdinAuth-User' => 'system');

sub GET {
  my $url = shift;
  my $resp = $ua->get( $jenkins_url . $url );
  die "Problem with GET $url: $resp" if $resp->is_error();
  $resp;
}

GET '/backup/launchBackup';

WAIT: while ( 1 ) {
  sleep 5;
  $resp = GET '/backup/progressiveBackupLog';
  for ( split /^/, $resp->content ) {
    if ( /Full backup file name : (\S+)/ ) {
      print "Backup tarball: $1\n" unless $tarball;
      $tarball = $1;
    }
    last WAIT if /Backup end at/;
  }
}

if ( -e "$full_dir~" ) {
  print "Removing $full_dir~\n";
  rmtree "$full_dir~" or die "Could not remove old backup: $!";
}

if ( -e $full_dir ) {
  print "Moving $full_dir to $full_dir~\n";
  move $full_dir, "$full_dir~" or die "Could not move last backup: $!";
}

print "Extracting $tarball to $full_dir\n";

mkdir $full_dir or die "Could not create directory for backup: $!";

open LOG, ">".catfile($full_dir, 'backup.log')
  or die "Could not write log: $!";
print LOG $resp->content;
close LOG;

exec "tar -C $full_dir -xzf $tarball";

__END__

=head1 NAME

backup-jenkins.pl

=head1 SYNOPSIS

backup-jenkins.pl [--jenkins-root=/path/to/jenkins/root] [--jenkins-url=URL]
