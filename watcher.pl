#!/usr/bin/env perl
#===============================================================================
#
#         FILE: watcher.pl
#
#        USAGE: ./watcher.pl
#
#  DESCRIPTION: sync stuff over ssh
#
#        NOTES: ---
#       AUTHOR: Alexandros Kechagias (akech), osakech@gmail.com
# ORGANIZATION:
#      VERSION: 1.0
#      CREATED: 06/27/2017 06:44:32 PM
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;
use feature 'say';
use Linux::Inotify2;
use Getopt::Std;
use Data::Dumper;

my %opts;
getopts('p:',\%opts);
die "the path is the goal!" unless $opts{p};

# TODO create groups of event types like r/w/all
# TODO crate a option for every event type
# TODO create multiple watchers
# TODO enable options for excluding files and or dirs
# TODO trigger cmds
# TODO it's a very slow atm because of IN_ALL_EVENTS, the decision which events to listen has to be made in the watcher
# TODO maybe just use lsyncd if features overlap too much -> come up with a reason not to hate LUA

# TODO trigger a specific set of cmds for each event type or all?

# create a new object
my $inotify = new Linux::Inotify2
  or die "Unable to create new inotify object: $!";

# create watch
$inotify->watch( $opts{p}, IN_ALL_EVENTS )
  or die "watch creation failed";

while () {
    my @events = $inotify->read;
    unless ( @events > 0 ) {
        say "read error: $!";
        last;
    }
    foreach my $e (@events) {
        my $filename = $e->fullname;
        say "$filename object was accessed"                                    if $e->IN_ACCESS;
        say "$filename object was modified"                                    if $e->IN_MODIFY;
        say "$filename object metadata changed"                                if $e->IN_ATTRIB;
        say "$filename writable fd to file / to object was closed"             if $e->IN_CLOSE_WRITE;
        say "$filename readonly fd to file / to object closed"                 if $e->IN_CLOSE_NOWRITE;
        say "$filename object was opened"                                      if $e->IN_OPEN;
        say "$filename file was moved from this object (directory)"            if $e->IN_MOVED_FROM;
        say "$filename file was moved to this object (directory)"              if $e->IN_MOVED_TO;
        say "$filename file was created in this object (directory)"            if $e->IN_CREATE;
        say "$filename file was deleted from this object (directory)"          if $e->IN_DELETE;
        say "$filename object itself was deleted"                              if $e->IN_DELETE_SELF;
        say "$filename object itself was moved"                                if $e->IN_MOVE_SELF;
#        say "$filename all of the above events"                                if $e->IN_ALL_EVENTS;
#        say "$filename only send event once"                                   if $e->IN_ONESHOT;
#        say "$filename only watch the path if it is a directory"               if $e->IN_ONLYDIR;
#        say "$filename don't follow a sym link"                                if $e->IN_DONT_FOLLOW;
#        say "$filename not supported with the current version of this module " if $e->IN_MASK_ADD;
    }
}

