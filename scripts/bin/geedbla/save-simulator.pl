#!/usr/bin/env perl
#*****************************************************************************************
# save-simulator.pl
#
# This script will save and restore the state of the iOS simulator
#
# Author   :  Gary Ash <gary.ash@icloud.com>
# Created  :   8-Jan-2021 11:33pm
# Modified :  17-Jan-2021  3:07pm
# 
# Copyright © 2021 By Gee Dbl A All rights reserved.
#*****************************************************************************************

#*****************************************************************************************
# libraries used
#*****************************************************************************************
use strict;
use warnings;
use Foundation;
use File::Find;
use File::Path;
use Archive::Zip;

my %simulators;
my $HOME       = $ENV{"HOME"};
my $simulators = "$HOME/Library/Developer/CoreSimulator/Devices";

if ($#ARGV == 0 && $ARGV[0] =~ /-h|--help/) {
	help()
}
elsif ($#ARGV == 2 && $ARGV[0] =~ /-s|--save/) {
	find(\&getSimulators, $simulators);

	my $UDID = $simulators{$ARGV[1]};
	if ($UDID) {
		my $zipPath = "$simulators/$UDID/data";
	    my $zipPackage = Archive::Zip->new();
	    $zipPackage->addTree($zipPath, undef);
	    $zipPackage->writeToFileNamed($ARGV[2]);
	    undef $zipPackage;
	}
	else {
		print "No simulator named - $ARGV[1]\n";
		exit(-1);
	}
}
elsif ($#ARGV == 2 && $ARGV[0] =~ /-l|--load/) {
	find(\&getSimulators, $simulators);
	my $UDID = $simulators{$ARGV[1]};
	if ($UDID) {
		my $zipPath = "$simulators/$UDID/data";
		rmtree($zipPath);
	    my $zipPackage = Archive::Zip->new();
	    $zipPackage->read($ARGV[2]);
	    $zipPackage->extractTree(undef, $zipPath);
	    undef $zipPackage;
	}
	else {
		print "No simulator named - $ARGV[1]\n";
		exit(-1);
	}

}
else {
	print "Command syntax error.\n";
	help();
}
#-----------------------------------------------------------------------------------------

sub getSimulators {
	return if ($File::Find::name !~ /\/device.plist/);
    my $plist = NSMutableDictionary->dictionaryWithContentsOfFile_($File::Find::name);
    if ($plist && $$plist) {
	    my $name = $plist->objectForKey_("name")->UTF8String;
	    my $UDID = $plist->objectForKey_("UDID")->UTF8String;
	    my $platform = $plist->objectForKey_("runtime")->UTF8String;
	    if ($platform =~ /.*iOS*/) {
	    	$simulators{$name} = $UDID ;
	    }
	}
}

#*****************************************************************************************
# display the help message
#*****************************************************************************************
sub help {
	print <<"HELP";
$0 - Save and restore the state of of iOS simulator

-h | --help		Display this help message
-s | --save		Save the state of the named simulator to a zip file of the given name
-l | --load		Load the state of the named simulator from the given zip file
HELP
exit(0)
}