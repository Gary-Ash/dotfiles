#!/usr/bin/env perl
#*****************************************************************************************
# fix-xcode-templates.pl
#
# This script will "fix" the internal xcode project and file templates my searching for
# instances of the comment marker // ___FILEHEADER___ and removing double slashes.
#
# NOTE: This script must be run sudo 
#
# Author   :  Gary Ash <gary.ash@icloud.com>
# Created  :  20-Feb-2021 11:03pm
# Modified :  20-Feb-2021 11:59pm
#
# Copyright © 2021 By Gee Dbl A All rights reserved.
#*****************************************************************************************

#****************************************************************************************
# libraries
#****************************************************************************************
use strict;
use warnings;
use File::Find;
use File::Basename;

#*****************************************************************************************
# script main line
#*****************************************************************************************
my %processFilesOptions = (
    wanted      => \&processFiles,
    no_chdir    => 1,
    bydepth     => 0,
    follow_skip => 2,
);

find(\%processFilesOptions, "/Applications/Xcode.app/Contents");
open(my $sourcefile, ">/Applications/Xcode.app/Contents/Developer/Library/Xcode/Templates/File Templates/MultiPlatform/Resource/Strings File.xctemplate/___FILEBASENAME___.strings")
	    	|| die "*** Unable to read the strings - $!\n";

print $sourcefile "___FILEHEADER___" ;
close($sourcefile);

#*****************************************************************************************
# process a source file
#*****************************************************************************************
sub processFiles {
    return if $_ eq "." or $_ eq "..";
    return if $_  =~ /^.git\//;
    return if !-f $_;
    return if index($_, '\r') < 0;

    my ($base, $dir, $ext) = fileparse($File::Find::name);

    if ($ext =~ /.[c|cc|cpp|h|hh|hpp|pch|m|mm|swift|metal]/) {
    	open(my $sourcefile, "<$File::Find::name") || die "*** Unable to read the $File::Find::name - $!\n";
    	my $source = do { local $/; <$sourcefile> };
    	close($sourcefile);
 	   $source =~ s/\/\/\w*___FILEHEADER___/___FILEHEADER___/g;
 
	    open($sourcefile, ">$File::Find::name")
	    	|| die "*** Unable to read the $File::Find::name - $!\n";

	    print $sourcefile $source;
	    close($sourcefile);
    }
 }
