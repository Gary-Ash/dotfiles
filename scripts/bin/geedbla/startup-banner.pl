#!/usr/bin/env perl
#*****************************************************************************************
# startup-banner.pl
#
# Terminal startup banner
#
# Author   :  Gary Ash <gary.ash@icloud.com>
# Created  :  11-Jan-2020  2:23pm
# Modified :   7-Mar-2021  6:13pm
#
# Copyright © 2020-2021 By Gee Dbl A All rights reserved.
#*****************************************************************************************

#*****************************************************************************************
# Libraries
#*****************************************************************************************
use v5.18;
use strict;
use warnings;
use Foundation;
use MIME::Base64;
use File::Basename;

#*****************************************************************************************
# global variables
#*****************************************************************************************
my $continuous  = 0;
my $theme       = 0;
my $columns     = `tput cols`;
my $displayedLogo =  0;

#*****************************************************************************************
# parse command line
#*****************************************************************************************
while (scalar(@ARGV)) {
    my $argument = shift @ARGV;

    if ($argument =~ /-c|--continuous/) {
        $continuous = 1;
        $SIG{'INT'} = sub {
        print "\033[?25h\n\n";
        exit 1;
        };
     }
    elsif ($argument =~ /-l|--light/) {
        $theme      = 1;
    }
    elsif ($argument =~ /-d|--dark/) {
        $theme      = 0;
    }
    else {
        print STDERR "**** Unknown argument: $argument\n";
        exit(2);
    }
}

#*****************************************************************************************
# visual theme variables
#*****************************************************************************************
my $boldText       = `tput bold`;
my $headingText    = "$boldText\033[38;5;255m";
my $highlightText  = "$boldText\033[38;5;255m";
my $normalInfoText = "\x1b[0m";
my $problemText    = "$boldText\033[38;5;160m";

if ($theme == 1) {
    $headingText    = "$boldText\033[38;5;0m";
    $highlightText  = "$boldText\033[38;5;196m";
}

do {
    my @specs     = ();
    my @results   = ();
    my $specsLine = 2;

    #*****************************************************************************************
    # gather system information
    #*****************************************************************************************
    my $hardwareData = `system_profiler SPHardwareDataType SPSoftwareDataType  SPDisplaysDataType`;
    my $dfData       = `df -H /`;
    my $batteryData  = `pmset -g batt`;
    my $shell        = $ENV{'SHELL'};
    my $internalIP   = `ipconfig getifaddr en0`;
    my $externalIP   = `/usr/bin/dig +short myip.opendns.com \@resolver1.opendns.com`;

    #*****************************************************************************************
    # parse user name
    #*****************************************************************************************
    @results = $hardwareData =~ /User Name: (.*)\n/;
    push @specs, "User         : $results[0]";

    #*****************************************************************************************
    # parse OS name and version
    #*****************************************************************************************
    @results = $hardwareData =~ /System Version: (.*)\n/;
    my @os_version = split / /, $results[0];
    if ($os_version[1] =~ /10.12.*/)    { $os_version[0] = "macOS Sierra";              }
    elsif ($os_version[1] =~ /10.13.*/) { $os_version[0] = "macOS High Sierra";         }
    elsif ($os_version[1] =~ /10.14.*/) { $os_version[0] = "macOS Mojave";              }
    elsif ($os_version[1] =~ /10.15.*/) { $os_version[0] = "macOS Catalina";            }
    elsif ($os_version[1] =~ /11.0.*/)  { $os_version[0] = "macOS Big Sur";             }
    $results[0] = "$os_version[0] $os_version[1] $os_version[2]";
    push @specs, "OS           : $results[0]";

    #*****************************************************************************************
    # Homebrew package manager
    #*****************************************************************************************
    if (-x "/usr/local/bin/brew") {
        `brew update &> /dev/null`;
        my $output = `brew list --formula`;

        @results = split(/\s/, $output);
        my $installed = scalar @results;

        $output = `brew outdated`;

        @results = split(/\s/, $output);
        my $outdated = scalar @results;
        if ($outdated > 0) {
            $outdated = $highlightText . $outdated . $normalInfoText;
        }
        push @specs, "Homebrew     : $installed Packages $outdated Updates";
    }

    #*****************************************************************************************
    # parse the current shell details
    #*****************************************************************************************
    if ($shell =~ /bash/) {
        my $v = `$shell -c 'echo \${BASH_VERSINFO[0]}.\${BASH_VERSINFO[1]}.\${BASH_VERSINFO[2]}'`;
        chomp $v;
        $shell = "Bash v$v ($shell)";
    }
    elsif ($shell =~ /zsh/) {
        my $v = `$shell -c 'echo \$ZSH_VERSION'`;
        chomp $v;
        $shell = "ZSH v$v ($shell)";
    }

    $shell = "Shell        : $shell";
    push @specs, $shell;

    #*****************************************************************************************
    # parse machine data
    #*****************************************************************************************
    my $machineSpecs;
    @results = $hardwareData =~ /Computer Name: (.*)\n/;
    my $machine = "Machine      : $results[0]";

    my $modelListFile = "/System/Library/PrivateFrameworks/ServerInformation.framework/Versions/A/Resources/English.lproj/SIMachineAttributes.plist";
    if (!-e $modelListFile) {
        $modelListFile = "/System/Library/PrivateFrameworks/ServerInformation.framework/Versions/A/Resources/en.lproj/SIMachineAttributes.plist";
        @results = $hardwareData =~ /Model Identifier: (.*)\n/;
        my $hardwareID = $results[0];
        if (-f $modelListFile) {
            my $plistData = NSDictionary->dictionaryWithContentsOfFile_($modelListFile);
            my $modelDict = $plistData->objectForKey_($hardwareID);
            if ($modelDict && $$modelDict) {
                my $localized = $modelDict->objectForKey_("_LOCALIZABLE_");
                $machine = $machine . " - " .$localized->objectForKey_("marketingModel")->UTF8String();
            }
            else {
                if ($hardwareID eq "MacBookPro16,1") { $machine = $machine . " - 16\" MacBook Pro (2019) True Tone Display" }
                if ($hardwareID eq "iMac20,2") { $machine = $machine . " - iMac 5k 27\" (2020) True Tone Display" }
            }
        }
    }

    push @specs, $machine;
    @results      = $hardwareData =~ /(Total Number of Cores: )(.*)\n/;
    $machineSpecs = "             : $results[1] ";
    @results      = $hardwareData =~ /(Processor Speed: )(.*)\n/;
    $machineSpecs .= "$results[1] ";
    @results = $hardwareData =~ /(Processor Name: )(.*)\n/;
    $machineSpecs .= "$results[1] Cores ";
    @results = $hardwareData =~ /(Memory: )(.*)\n/;
    $machineSpecs .= "$results[1] Memory";
    push @specs, $machineSpecs;

   	@results      = $hardwareData =~ /(Chipset Model: )(.*)\n/;
    $machineSpecs = "             : $results[1] ";
    @results      = $hardwareData =~ /(VRAM \(Total\): )(.*)\n/;
    $machineSpecs .= " - $results[1] Video RAM";
    push @specs, $machineSpecs;

    #*****************************************************************************************
    # parse the battery status
    #*****************************************************************************************
    chomp $batteryData;

    if ($batteryData ne "Now drawing from \'AC Power\'") {
        @results = $batteryData =~ /([0-9]+%)/;
        if ($batteryData =~ /InternalBattery/) {
            if ($batteryData =~ /Now drawing from \'AC Power\'/) {
                push @specs, "Power        : Charging on AC Power Battery charge at $results[0]";
            }
            else {
                push @specs, "Power        : Running on Battery Power charge at $results[0]";
            }
        }
    }

    #*****************************************************************************************
    # parse IP addresses
    #*****************************************************************************************
    chomp($internalIP);
    chomp($externalIP);
    push @specs, "IP Addresses : $internalIP/$externalIP";

    #*****************************************************************************************
    # parse the boot disk information
    #*****************************************************************************************
    @results = $hardwareData =~ /(Boot Volume: )(.*)\n/;

    $dfData = substr($dfData, index($dfData, "\n") + 1);
    $dfData =~ s/\s\s*/ /g;
    my @dfSplit = split(/\s/, $dfData);

    $dfData = "Size: $dfSplit[1] Used: $dfSplit[2]  Free: $dfSplit[3]";
    $dfData =~ s/T/ TB/g;
    $dfData =~ s/G/ GB/g;

    push @specs, "Boot Disk    : $results[1] $dfData";

    #*****************************************************************************************
    # parse up time information
    #*****************************************************************************************
    @results = $hardwareData =~ /Time since boot: (.*)\n/;
    push @specs, "Up Time      : $results[0]";

    #*****************************************************************************************
    # calculate the column for the machine specs
    #*****************************************************************************************
    my $longest = 0;
    for my $item (@specs) {
        my $len = length($item);
        if ($len > $longest) {
            $longest = $len;
        }
    }
    print "\ec\e[3J", `tput clear`;
    my $specsColumn = int(($columns - $longest) / 2);
    for my $text (@specs) {
        my $theHeadingText = "";
        my $colonIndex = index($text, ":");
        if ($colonIndex > -1) {
            $theHeadingText = substr($text, 0, $colonIndex + 1);
            $text = substr($text, $colonIndex + 1);
        }
        print "\033[$specsLine;${specsColumn}H${headingText}${theHeadingText}${normalInfoText}${text}";
        ++$specsLine;
    }

    if (!$displayedLogo) {
        $displayedLogo = 1;
        displayLogo();
    }

    flush STDOUT;
    if ($continuous == 1) {
        sleep 350;
    }
} until ($continuous == 0);

print "\033[?25h\n\n";

sub displayLogo {
    if ($ENV{'TERM_PROGRAM'} eq "iTerm.app" && $ENV{'TERM'} ne "screen-256color") {
        my $raw = '';
        my $logoEncoded = '';
        my $startSequence;
        my $endSequence;
        my $filename = dirname(__FILE__) . "/pictures/apple-logo.png";
        open(my $fh, '<:raw', $filename) or die "$filename\n";

        while (1) {
            my $success = read($fh, $raw, 19*1024, length($raw));
            die $! if not defined $success;
            last if not $success;
        }
        close($fh);
        $logoEncoded = encode_base64($raw);
        print "\033[1;10H\033]1337;File=;inline=1:$logoEncoded\07";
    }
    else {
        my $logoLine = 0;
        while (defined(my $logoText = <DATA>)) {
            chomp $logoText;
            my $commaIndex = index($logoText, ",");
            my $color = substr($logoText, 0, $commaIndex);
            $color =~ s/\s+$//;

            $color = "\033[38;5;160m" if ($color eq "RED");
            $color = "\033[38;5;40m"  if ($color eq "GREEN");
            $color = "\033[38;5;33m"  if ($color eq "BLUE");
            $color = "\033[38;5;226m" if ($color eq "YELLOW" && $theme == 0);
            $color = "\033[38;5;142m" if ($color eq "YELLOW" && $theme == 1);
            $color = "\033[38;5;208m" if ($color eq "ORANGE");
            $color = "\033[38;5;129m" if ($color eq "PURPLE");

            $logoText = substr($logoText, $commaIndex + 1);

            print "\033[${logoLine};4H${color}${logoText}${normalInfoText}";
            ++$logoLine;
        }
    }
}

#*****************************************************************************************
# Data
#*****************************************************************************************
#<<<
__DATA__
GREEN,            ###
GREEN,           ###
GREEN,         ###
GREEN,  #######    #######
YELLOW,######################
YELLOW,#####################
ORANGE,####################
ORANGE,####################
RED   ,#####################
RED   ,######################
PURPLE, ####################
PURPLE,  ##################
BLUE  ,   ################
BLUE  ,     ####    #####
