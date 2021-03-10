#!/usr/bin/env zsh
#*****************************************************************************************
# ocd.sh
#
# Update system software and clean macOS settings
#
# Author   :  Gary Ash <gary.ash@icloud.com>
# Created  :  11-Jan-2020  2:23pm
# Modified :   9-Mar-2021  4:58pm
#
# Copyright © 2020-2021 By Gee Dbl A All rights reserved.
#*****************************************************************************************

#*****************************************************************************************
# load utilities from scripting libraries
#*****************************************************************************************
autoload get_sudo_password
autoload start_persistant_sudo
autoload stop_persistant_sudo

#*****************************************************************************************
# set a exit trap to make sure the persistant sudo thread is always cleaned up
#*****************************************************************************************
trap finish EXIT

finish() {
    if [[ -n "$SUDO_PASSWORD" ]]; then
        stop_persistant_sudo
        unset SUDO_PASSWORD
    fi
}

#*****************************************************************************************
# parse the command line arguments
#*****************************************************************************************
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --update-libs)
            updateLibs=1
            shift
        ;;

        *)
            echo "Unknown parameter passed: $1"
            exit 1
        ;;
    esac
done

#-----------------------------------------------------------------------------------------

defaults write com.apple.Safari IncludeInternalDebugMenu 1

SUDO_PASSWORD=$(get_sudo_password)
error_log="$TMPDIR/Error.txt"

cd ~ || return
#*****************************************************************************************
# brew
#*****************************************************************************************
if command -v brew &> /dev/null; then
    brew update                                                     &> "$error_log"
    brew upgrade                                                    &> "$error_log"
    brew upgrade --cask                                             &> "$error_log"
    brew cleanup                                                    &> "$error_log"
    rm -rf `brew --cache`                                           &> /dev/null
fi

if [[ updateLibs -eq 1 ]]; then
    #*********************************************************************************
    # ruby update
    #*********************************************************************************
    if command -v gem &> /dev/null; then
        gem update --system                                             &> "$error_log"
        gem update                                                      &> "$error_log"
        gem cleanup                                                     &> "$error_log"
    fi

    #*********************************************************************************
    # python 3 update
    #*********************************************************************************
    if command -v pip3 &> /dev/null; then
        pip3 install --trusted-host pypi.org --trusted-host files.pythonhosted.org--update pip                                   &> "$error_log"
        for p in $(pip3 list --trusted-host pypi.org --trusted-host files.pythonhosted.org -o --format freeze); do
            p=${p%%=*}
            pip3 install --trusted-host pypi.org --trusted-host files.pythonhosted.org -U "$p"                                    &> "$error_log"
            pip3 install --trusted-host pypi.org --trusted-host files.pythonhosted.org 'python-language-server[all]'              &> "$error_log"
        done
    fi
fi

find "$HOME/Library/Application Support/AddressBook" -name "*.abbu.tbz" -delete &> /dev/null
find "/Users/Shared/CleanMyMac X/" -depth 1 ! -name ".licence" -exec rm -rfv {} \; &> /dev/null
find "$HOME/Sites" \( -name "Gemfile.lock" -or -name ".sass-cache" -or -name ".jekyll*" -or -name "_site" \) -exec rm -rfv {} \; &> /dev/null

#*****************************************************************************************
# clean my git projects
#*****************************************************************************************
for f in $(find "$HOME/Developer" -d -name ".git"); do
    cd "$f"
    git gc --aggressive     &> /dev/null
done

start_persistant_sudo "$SUDO_PASSWORD"
#****************************************************************************************
# Pause Time Machine while updating and cleaning
#****************************************************************************************
sudo tmutil stopbackup
sudo tmutil disable

#*****************************************************************************************
# empty trash
#*****************************************************************************************
emulate sh -c 'sudo rm -rf ~/.Trash/* '                             &> /dev/null
emulate sh -c 'sudo rm -rf /Volumes/*/.Trashes'                     &> /dev/null
emulate sh -c 'sudo rm -rf ~/.Trash /Volumes/*/.Trashes'            &> /dev/null

#*****************************************************************************************
# clean up Time Machine local backups and turn it back on
#*****************************************************************************************
IFS=$'\n' snapshots=($(sudo tmutil listlocalsnapshots /Volumes/))
for snapshot in ${snapshots[*]}; do
    snapshot="${snapshot#com.apple.TimeMachine.*}"
    snapshot="${snapshot%% *}"
    sudo tmutil deletelocalsnapshots "$snapshot" &> /dev/null
done
unset IFS

#*****************************************************************************************
# notification center clean
#*****************************************************************************************
sudo rm -rf "$(getconf DARWIN_USER_DIR)com.apple.notificationcenter" &> /dev/null
sudo killall usernoted

#*****************************************************************************************
# clean system settings and trash
#*****************************************************************************************
sudo find -x "$HOME" -name "*.DS_Store" -type f -delete                          &> /dev/null
echo -n '' | pbcopy
sudo periodic daily weekly monthly

for processes ("Twitterrific" "Twitter" "Dock" "Safari" "Finder" "Slack" "cfprefsd" "ColorSnapper2"); do
    killall "$processes" &> /dev/null
done

find "$HOME/Library/Application Support/com.apple.sharedfilelist/"  \
    ! -name "com.apple.LSSharedFileList.FavoriteItems.sfl2"         \
    ! -name "com.apple.LSSharedFileList.FavoriteVolumes.sfl2"       \
    ! -name "com.apple.LSSharedFileList.ProjectsItems.sfl2"         \
    ! -name "com.apple.LSSharedFileList.iCloudItems.sfl2" -delete          &> /dev/null

rm -f "$HOME/Library/ApplicationSupport"                                   &> /dev/null
rm -rf "$HOME/Movies/Motion\ Templates"                                    &> /dev/null
rm -f "$error_log"  
find "$HOME/Developer" -type d -name "*xcuserdatad" ! -name "garyash.xcuserdatad" -exec rm -rf {} \;        &> /dev/null 
find "$HOME/Documents" -type d -name "*xcuserdatad" ! -name "garyash.xcuserdatad" -exec rm -rf {} \;        &> /dev/null
sudo find /private/  -type d -name "org.llvm*" -exec rm -rf {} \;           &> /dev/null
sudo find /private/  -type d -name "com.apple.dt.Xcode" -exec rm -rf {} \;  &> /dev/null

#*****************************************************************************************
# keep permissions in the /Applications folder good
#*****************************************************************************************
sudo chown -R root:wheel /Applications/*                                    &> /dev/null
sudo chmod -R 755 /Applications/*                                           &> /dev/null
sudo xattr -cr /Applications/*                                              &> /dev/null

#*****************************************************************************************
# build the bookmarks list for Safari clean up
#*****************************************************************************************
/usr/bin/perl << "BOOKMARKS"
#!/usr/bin/env perl
use strict;
use Foundation;

my @bookMarks;

sub getbookmarks {
    open(my $tmpFileHandle, ">", $ENV{"HOME"} ."/Downloads/Bookmarks.txt") || die "Error creating bookmark file - $!\n";

    sub processChildren {
        my $children = shift;

        for (my $itemIndex = 0;$itemIndex < $children->count;++$itemIndex) {
            my $item = $children->objectAtIndex_($itemIndex);
            if ($item && $$item) {
                my $url = $item->objectForKey_("URLString");
                if ($url && $$url) {
                    my $nsurl = NSURL->URLWithString_($url);
                    my $input = $nsurl->host()->UTF8String;

                    my $firstdot = index($input, '.');
                    my $lastdot = rindex($input, '.');

                    if ($firstdot > -1 && $firstdot != $lastdot) {
                        $input = substr($input, $firstdot + 1);
                    }

                    print $tmpFileHandle $input, "\n";
                    push(@bookMarks, $input);
                  }

                my $nextChildren = $item->objectForKey_("Children");
                if ($nextChildren && $$nextChildren) {
                    processChildren($nextChildren);
                }
            }
        }
    }

    my $bookmarkFile = $ENV{"HOME"} ."/Library/Safari/bookmarks.plist";
    my $bookmarkPlist = NSDictionary->dictionaryWithContentsOfFile_($bookmarkFile);
    if ($bookmarkPlist && $$bookmarkPlist) {
        my $children = $bookmarkPlist->objectForKey_("Children");
        processChildren($children);
    }
}

getbookmarks();

my $HOME = $ENV{"HOME"};
for my $file (<$HOME/Library/Safari/LocalStorage/*>) {
    my $found = 0;
    for my $bookkmark (@bookMarks) {
        if (index($file,, $bookkmark) != -1) {
            $found = 1;
            last;
        }
        if ($found == 0) {
            unlink($file);
        }
    }
}
BOOKMARKS

if [[ -d "/Applications/Twitterrific.app" ]]; then
    open "/Applications/Twitterrific.app"
elif [[ -d "/Applications/Twitter.app" ]]; then
    open "/Applications/Twitter.app"
fi

osascript <<"END"               &> /dev/null
try
    tell application "Keyboard Maestro Engine" to quit
end try

(*****************************************************************************************
 * clean mac Mail
 ****************************************************************************************)
try
    tell application "Mail" to activate
    repeat while application "Mail" is not running
        delay 0.2
    end repeat
    delay 4
    tell application "System Events" to tell process "Mail"
        set frontmost to true
        click checkbox 1 of group 1 of window 1
        click menu item "Erase Junk Mail" of menu 1 of menu bar item "Mailbox" of menu bar 1
        delay 1
        click button "Erase" of sheet 1 of window 1
        delay 1
        click menu item "In All Accounts…" of menu 1 of menu item "Erase Deleted Items" of menu 1 of menu bar item "Mailbox" of menu bar 1
        delay 1
        
        click button "Erase" of sheet 1 of window 1
        delay 1
        click menu item "Previous Recipients" of menu 1 of menu bar item "Window" of menu bar 1
        delay 1
        
        try
            if number of rows in table 1 of scroll area 1 of window 1 > 0 then
                delay 0.5
                keystroke tab
                keystroke "a" using {command down}
                click button "Remove From List" of window 1
                delay 0.3
            end if
        end try
        keystroke "w" using {command down}
        delay 2
        click menu item "Quit Mail" of menu 1 of menu bar item "Mail" of menu bar 1
    end tell
end try

(*****************************************************************************************
 * clean Safari
 ****************************************************************************************)
try
    set bookmarks to {}
    set filename to (POSIX path of (path to downloads folder from user domain)) & "bookmarks.txt"
    set txt to paragraphs of (read POSIX file filename)
    repeat with lineTxt in txt
        if length of lineTxt is greater than 0 then
            copy lineTxt to the end of bookmarks
        end if
    end repeat
    try
        tell application "Safari" to quit
        delay 3
    end try
    
    tell application "Safari" to activate
    delay 3
    
    set defaultDelim to AppleScript's text item delimiters
    set AppleScript's text item delimiters to " "
    
    tell application "Safari" to activate
    repeat while application "Safari" is not running
        delay 0.2
    end repeat
    tell application "System Events" to tell process "Safari"
        set frontmost to true
        try
            if exists radio button 1 of radio group 1 of group 1 of splitter group 1 of window 1 then
                click radio button 1 of radio group 1 of group 1 of splitter group 1 of window 1
                delay 1
                click button 1 of toolbar 1 of window 1
            end if
            click menu item "Hide History" of menu 1 of menu bar item "History" of menu bar 1
            click menu item "Sync iCloud History" of menu 1 of menu bar item "Debug" of menu bar 1

            delay 6
            click button "Show Search Menu" of group 7 of toolbar 1 of window 1
            delay 0.5
            set row_index to 1
            set number_items to number of rows in table 1 of scroll area 1 of group 5 of toolbar 1 of window 1
            select row row_index of table 1 of scroll area 1 of group 5 of toolbar 1 of window 1

            repeat until row_index = number_items
                key code 125
                set row_index to row_index + 1
            end repeat
            if row_index > 4 then
                key code 36
            else
                key code 53
            end if
            delay 0.5
        end try

        click menu item "Show All History" of menu 1 of menu bar item "History" of menu bar 1
        delay 0.5
        try
            keystroke "a" using command down
            keystroke (ASCII character 127)
            delay 1
        end try
        click menu item "Hide History" of menu 1 of menu bar item "History" of menu bar 1
        click menu item "Sync iCloud History" of menu 1 of menu bar item "Debug" of menu bar 1

        set keepingSites to {¬
            "bing.com", ¬
            "live.com", ¬
            "duckduckgo.com", ¬
            "discord.com", ¬
            "stackexchange.com", ¬
            "sublimehq.com", ¬
            "superuser.com"}
        
        set deleteAnyway to {¬
            "t.co", ¬
            "2dgameartguru.com", ¬
            "blendswap.com", ¬
            "codeandweb.com", ¬
            "comicscontinuum.com", ¬
            "agner.org", ¬
            "swiftpm.co", ¬
            "swiftpm.com", ¬
            "mapeditor.org", ¬
            "udemy.com", ¬
            "macpaw.com", ¬
            "wtfautolayout.com", ¬
            "71squared.com", ¬
            "beautifyconverter.com", ¬
            "freeformatter.com", ¬
            "sanctum.geek.nz", ¬
            "graphicriver.net", ¬
            "jscreenfix.com", ¬
            "johncodeos.com", ¬
            "johncodeos.com", ¬
            "opengameart.org", ¬
            "sqlitebrowser.org", ¬
            "pfiddlesoft.com", ¬
            "geedbla.com", ¬
            "gitignore.io", ¬
            "packagecontrol.io", ¬
            "probot.github.io", ¬
            "jamendo.com", ¬
            "tutsplus.com", ¬
            "itch.io", ¬
            "nshipster.com", ¬
            "iterm2.com", ¬
            "shields.io", ¬
            "escapistmagazine.com"}
        
        keystroke "," using {command down}
        delay 3
        click button 7 of toolbar 1 of the first window
        click button "Manage Website Data…" of group 1 of group 1 of window 1
        repeat
            set number_items to number of rows of table 1 of scroll area 1 of sheet 1 of window 1
            if number_items > 10 then
                exit repeat
            end if
            delay 6
        end repeat
        keystroke tab
        
        set done_count to 1
        set row_index to 1
        select row row_index of table 1 of scroll area 1 of sheet 1 of window 1
        
        repeat while done_count > 0
            try
                repeat
                    select row row_index of table 1 of scroll area 1 of sheet 1 of window 1
                    delay 0.01
                    
                    set r to row row_index of table 1 of scroll area 1 of sheet 1 of window 1
                    try
                        set txt to (get value of static text 1 of UI element 1 of r) as string
                    on error msg number errNum
                        set txt to ""
                        set done_count to done_count + 1
                        
                    end try
                    set removeBookmark to 1
                    repeat with bookmark in bookmarks
                        set bookmark to bookmark as string
                        if txt is equal to bookmark then
                            set removeBookmark to 0
                            exit repeat
                        end if
                    end repeat
                    
                    if removeBookmark = 1 then
                        repeat with keepIt in keepingSites
                            set keepIt to keepIt as string
                            if txt is equal to keepIt then
                                set removeBookmark to 0
                                exit repeat
                            end if
                        end repeat
                    else
                        repeat with deleteIt in deleteAnyway
                            set deleteIt to deleteIt as string
                            if txt is equal to deleteIt then
                                set removeBookmark to 1
                                exit repeat
                            end if
                        end repeat
                    end if
                    
                    if removeBookmark = 1 then
                        click button "Remove" of sheet 1 of window "Privacy"
                    else
                        key code 125
                        set row_index to row_index + 1
                    end if
                    delay 0.5
                end repeat
                
            on error msg number errNum
                if errNum = -1719 then
                    set done_count to done_count - 1
                end if
                set AppleScript's text item delimiters to defaultDelim
            end try
        end repeat
        
        delay 0.5
        select row 1 of table 1 of scroll area 1 of sheet 1 of window 1
        key code 125
        delay 0.5
        click button "Done" of sheet 1 of window "Privacy"
        delay 1
        click button 1 of toolbar 1 of the first window
        delay 0.3
        click button 1 of window 1
        delay 2
        click menu item "Sync iCloud History" of menu 1 of menu bar item "Debug" of menu bar 1
        delay 10
    end tell
end try

(*****************************************************************************************
 * clean up Twitterrific windows
 ****************************************************************************************)
tell application "System Events"
    set twitterrific to (path to applications folder as text) & "Twitterrific.app"

    if exists folder twitterrific then
        tell application "System Events" to tell process "Twitterrific"
            set frontmost to true
            delay 0.5
            click menu item "Preferences…" of menu 1 of menu bar item "Twitterrific" of menu bar 1
            click button "Accounts" of toolbar 1 of window "Preferences"
            click button "Clear Cache" of window "Preferences"
            click button "OK" of sheet 1 of window "Preferences"
            click button "General" of toolbar 1 of window "Preferences"
            click button 1 of window "Preferences"

            click checkbox 2 of window 1
            delay 0.1
            repeat 10 times
                key code 126 using {command down}
                delay 1
            end repeat
        end tell

        delay 3.5
        tell application "System Events"
            click UI element "Twitterrific" of list 1 of application process "Dock"
        end tell

        tell application "System Events" to tell process "Twitterrific"
            set frontmost to true
            click checkbox 2 of window 1
            delay 0.05
            click checkbox 1 of window 1
        end tell
    end if
end tell

(*****************************************************************************************
 * clean up Twitter windows
 ****************************************************************************************)
if application "Twitter" is running then
    try
        tell application "Twitter" to activate
        tell application "System Events" to tell process "Twitter"
            click menu item "Home" of menu 1 of menu bar item "View" of menu bar 1
        end tell
    end try
end if

(*****************************************************************************************
 * clean Marked 2
 ****************************************************************************************)
try
    tell application "Marked 2"
        activate
        tell application "System Events" to tell process "Marked 2"
            click menu item "Clear Menu" of menu 1 of menu item "Open Recent" of menu 1 of menu bar item "File" of menu bar 1
        end tell
        quit
    end tell
end try

(*****************************************************************************************
 * clean FaceTime
 ****************************************************************************************)
 try
    tell application "FaceTime"
        activate
        tell application "System Events"
            click menu item "Remove all Recents" of menu of menu bar item "FaceTime" of menu bar of process "FaceTime"
        end tell
        quit
    end tell
end try

(****************************************************************************************
 * clean Music
 ****************************************************************************************)
tell application "Music" to launch
delay 2
tell application "System Events" to tell process "Music"
    set frontmost to true
    delay 3
    
    try
        click menu item "Switch from MiniPlayer" of menu 1 of menu bar item "Window" of menu bar 1
    end try
    try
        click menu item "Show Playing Next" of menu 1 of menu bar item "View" of menu bar 1
    end try

    try
        click button "History" of group 3 of splitter group 1 of window "Music"
        set grp to 3
    on error
        set grp to 4
    end try

    try
        try
            click button "History" of group grp of splitter group 1 of window "Music"
        end try
        delay 2
        set row_index to 1
        set total_rows to (number of rows of table 1 of scroll area 1 of group grp of splitter group 1 of window "Music")
        if total_rows > 1 then
            repeat until row_index > total_rows
                select row row_index of table 1 of scroll area 1 of group grp of splitter group 1 of window "Music"
                set row_index to row_index + 1
                delay 0.1
            end repeat
            click button "Clear" of UI element 1 of row total_rows of table 1 of scroll area 1 of group grp of splitter group 1 of window "Music"
        end if
    end try

    try
        try
            click button "Playing Next" of group grp of splitter group 1 of window "Music"
        end try
        delay 2
        set row_index to 1
        set total_rows to (number of rows of table 1 of scroll area 1 of group grp of splitter group 1 of window "Music")
        if total_rows > 1 then
            repeat until row_index > total_rows
                select row row_index of table 1 of scroll area 1 of group grp of splitter group 1 of window "Music"
                set row_index to row_index + 1
                delay 0.1
            end repeat
            click button "Clear" of UI element 1 of row total_rows of table 1 of scroll area 1 of group grp of splitter group 1 of window "Music"
        end if

    end try
    try
        click button "History" of group grp of splitter group 1 of window "Music"
    end try
    delay 0.2
    try
        click menu item "Hide Playing Next" of menu 1 of menu bar item "View" of menu bar 1
    end try
end tell
tell application "Music" to quit

(*****************************************************************************************
 * clean Xcode
 ****************************************************************************************)
tell application "Xcode" to activate
tell application "System Events" to tell process "Xcode"
    delay 2
    click menu item "Clear Menu" of menu of menu item "Open Recent" of menu of menu bar item "File" of menu bar 1
end tell
tell application "Xcode" to quit

(*****************************************************************************************
 * clean Messages
 ****************************************************************************************)
try
    set repFlag to 1
    repeat while repFlag = 1
        tell application "Messages"
            activate
            delay 1
            tell application "System Events" to tell process "Messages"
                try
                    click menu item "Delete Conversation…" of menu 1 of menu bar item "File" of menu bar 1
                end try

                try
                    delay 1
                    click button "Delete" of sheet 1 of window 1
                on error
                    set repFlag to 0
                end try
            end tell
        end tell
        tell application "Messages" to quit
        delay 2
    end repeat
    delay 2
end try

(*****************************************************************************************
 * clean up Pastebot
 ****************************************************************************************)
try
    tell application "Pastebot" to quit
    delay 0.2
end try

try
    tell application "Pastebot" to launch
    repeat while application "Pastebot" is not running
        delay 0.1
    end repeat
    
    tell application "System Events" to tell process "Pastebot"
        set frontmost to true
        try
            delay 0.2
            click menu item "Clear Clipboard" of menu 1 of menu bar item "Edit" of menu bar 1
            delay 0.2
            click button "Clear" of window ""
        end try
        delay 0.2
        click menu item "Close Window" of menu 1 of menu bar item "File" of menu bar 1
    end tell
end try

try
    tell application "System Events" to tell process "ColorSnapper2"
        set frontmost to true
        key code 53
    end tell
end try

(*****************************************************************************************
 * clean up Finder windows
 ****************************************************************************************)
 try
    tell application "Finder"
        activate
        repeat with w in (get every Finder window)
            activate w
            tell application "System Events" to tell process "Finder"
                keystroke "a" using {command down}
                delay 0.5
                key code 123
                keystroke "a" using {command down, option down}
                delay 0.5
            end tell
        end repeat
        
        set desktopBounds to bounds of window of desktop
        set w to round (((item 3 of desktopBounds) - 1100) / 2) rounding as taught in school
        set h to round (((item 4 of desktopBounds) - 1000) / 2) rounding as taught in school
        set finderBounds to {w, h, 1100 + w, 1000 + h}
        
        try
            set (bounds of window 1) to finderBounds
        on error
            make new Finder window to home
        end try
        set (bounds of window 1) to finderBounds
        close every window
        
        tell application "System Events" to tell process "Finder"
            click menu item "Clear Menu" of menu of menu item "Recent Items" of menu of menu bar item 1 of menu bar 1
            click menu item "Clear Menu" of menu of menu item "Recent Folders" of menu of menu bar item "Go" of menu bar 1
        end tell
    end tell
end try

(*****************************************************************************************
 * clean iTerm2
 ****************************************************************************************)
try
    tell application "iTerm"
        activate
        delay 0.01

        tell application "System Events" to tell process "iTerm2"
            click menu item "Clear Buffer" of menu 1 of menu bar item "Edit" of menu bar 1
            click menu item "Clear Scrollback Buffer" of menu 1 of menu bar item "Edit" of menu bar 1
            if exists splitter group 1 of window 1 then
                click button 3 of splitter group 1 of window 1
                click button "OK" of window 1

                click button 6 of splitter group 1 of window 1
                click button "OK" of window 1
            end if
        end tell
    end tell
end try
END

sudo /usr/bin/perl  <<'PERL'                                                 &> /dev/null
#!/usr/bin/env perl
#*****************************************************************************************
# libraries used
#*****************************************************************************************
use strict;
use warnings;
use Foundation;
use utf8;
use Encode qw(decode encode);
use JSON::PP;
use XML::Simple;
use File::Find;
use File::Path qw(remove_tree);

#*****************************************************************************************
# globals
#*****************************************************************************************
our $HOME = $ENV{'HOME'};

our @plistKeysToDelete = (
    "NewBookmarksLocationUUID",                                       "RecentSearchStrings",
    "FXRecentFolders",                                                "GoToField",
    "RecentApplications",                                             "RecentDocuments",
    "RecentServers",                                                  "Hosts",
    "ExpandedURLs",                                                   "last_textureFileName",
    "FXRecentFolders",                                                "FXLastSearchScope",
    "GoToField",                                                      "NSNavPanel",
    "NSNavRecentPlaces",                                              "NSNavLastRootDirectory",
    "NSNavLastCurrentDirectory",                                      "RecentSearchStrings",
    "LRUDocumentPaths",                                               "TSAOpenedTemplates.Pages",
    "NSReplacePboard",                                                "ExpandedURLs",
    "SelectedURLs",                                                   "NSReplacePboard",
    "Apple CFPasteboard find",                                        "Apple CFPasteboard replace",
    "Apple CFPasteboard general",                                     "findHistory",
    "replaceHistory",                                                 "MGRecentURLPropertyLists",
    "OakFindPanelOptions",                                            "Folder Search Options",
    "recentFileList",                                                 "RecentDirectories",
    "NSRecentXCProjectDocuments",                                     "last_dataFileName",
    "lastSpritesFolder",                                              "main.lastFileName",
    "defaults.settingsAbsPath",                                       "main.lastFileName",
    "DefaultCheckOutDirectory",                                       "RecentWorkingCopies",
    "kProjectBasePath",                                               "LastOpenedScene",
    "ABBookWindowController-MainBookWindow-personListController",     "IDEFileTemplateChooserAssistantSelectedTemplateCategory",
    "IDEFileTemplateChooserAssistantSelectedTemplateName",            "IDERecentEditorDocuments",
    "XCOpenWorkspaceDocuments",                                       "IDETemplateCompletionDefaultPath",
    "IDETemplateOptions",                                             "IDEDefaultPrimaryEditorFrameSizeForPaths",
    "IDEDocViewerLastViewedURLKey",                                   "IDESourceControlRecentsFavoritesRepositoriesUserDefaultsKey",
    "Xcode3ProjectTemplateChooserAssistantSelectedTemplateCategory",  "Xcode3ProjectTemplateChooserAssistantSelectedTemplateName",
    "Xcode3TargetTemplateChooserAssistantSelectedTemplateCategory",   "Xcode3TargetTemplateChooserAssistantSelectedTemplateName",
    "Xcode3ProjectTemplateChooserAssistantSelectedTemplateSection",   "recentFileList",
    "lastSpritesFolder",                                              "main.lastFileName",
    "last_name",                                                      "last_textureFileName",
    "lastExporter",                                                   "findRecentPlaces",
    "RecentWebSearches",                                              "recentSearches",
    "Xcode3TargetTemplateChooserAssistantSelectedTemplateName_macOS", "Xcode3TargetTemplateChooserAssistantSelectedTemplateName_iOS",
    "Xcode3TargetTemplateChooserAssistantSelectedTemplateName_tvOS",  "SGTRecentFileSearches",
    "IDEFileTemplateChooserAssistantSelectedTemplateSection",         "Xcode3ProjectTemplateChooserAssistantSelectedTemplateName_tvOS",
    "IDEFileTemplateChooserAssistantSelectedTemplateName_tvOS",       "Xcode3ProjectTemplateChooserAssistantSelectedTemplateName_macOS",
    "Xcode3ProjectTemplateChooserAssistantSelectedTemplateName_iOS",  "Xcode3TargetTemplateChooserAssistantSelectedTemplateSection",
    "DVTTextCompletionRecentCompletions",                             "GoToFieldHistory",
    "HistoryColors",                                                  "recentSearches",
    "recentSearchHints",                                              "IDETemplateCompletionDefaultPath",
    "SHKRecentServices",                                              "FavoriteColors",
    "LastSetWindowSizeForDocument",                                   "recentCatalogPaths",
    "IDELastBreakpointActionClassName",                               "RecentFindStrings",
    "IDEFileTemplateChooserAssistantSelectedTemplateName_iOS",        "RecentReplaceStrings",
    "IDESwiftMigrationAssistantReviewFilesSelectedChoice",            "IDERunActionSelectedTab",
    "DVTIgnoredDevices",                                              "IBGlobalLastEditorTargetRuntime",
    "IBDocumentOutlineViewMode",                                      "IDELibrary.lastSelectedLibraryExtensionIDByEditorID",
    "IBGlobalLastEditorTargetRuntime",                                "CurrentAlertPreferencesSelection",
    "DVTRecentCustomColors",                                          "IDEProvisioningTeamManagerLastSelectedTeamID",
);

our @itemsToDelete = (
    ["/Library/Logs/DiagnosticReports",                                                                        1],
    ["$HOME/.config/zsh/histfile",                                                                             1],
    ["$HOME/.config/zsh/histfile",                                                                             1],
    ["$HOME/.config/zsh/.zsh_history",                                                                         1],
    ["$HOME/.config/zsh/zcompdump-*",                                                                          1],
    ["$HOME/Library/Autosave Information",                                                                     0],
    ["$HOME/Library/Application Support/Steam",                                                                0],
    ["$HOME/Library/Application Support/JetBrains",                                                            0],
    ["$HOME/Library/Application Support/iLifeMediaBrowser",                                                    0],
    ["$HOME/Library/Application Support/CrashReporter",                                                        0],
    ["$HOME/Library/Application Support/dmd",                                                                  0],
    ["$HOME/Library/Application Support/iMovie",                                                               0],
    ["$HOME/Library/Application Support/CleanMyMac X HealthMonitor",                                           0],
    ["$HOME/Library/Application Support/CleanMyMac X Menu",                                                    0],
    ["$HOME/Library/Application Support/Translation",                                                          0],
    ["$HOME/Library/Application Support/CleanMyMac X Menu",                                                    0],
    ["$HOME/Library/Developer/Xcode/UserData/IDEEditorInteractivityHistory",                                   0],
    ["$HOME/Library/Developer/Xcode/DocumentationCache",                                                       0],
    ["$HOME/.config/configstore",                                                                              0],
    ["$HOME/.cocoapods",                                                                                       0],
    ["/$HOME/Library/Caches/Homebrew",                                                                         0],
    ["/$HOME/Library/Cookies/Hocom.kapeli.dashdoc.binarycookies",                                              0],
    ["/$HOME/Library/Cookies/org.m0k.transmission.binarycookies",                                              0],
    ["/$HOME/Library/Caches/com.apple.dt.Xcode",                                                               0],
    ["$HOME/Library/Autosave Information",                                                                     0],
    ["$HOME/Library/Saved Application State",                                                                  0],
    ["$HOME/Library/Application Support/CrashReporter",                                                        0],
    ["$HOME/Pictures/iSkysoft VideoConverterUltimate",                                                         0],
    ["$HOME/Movies/iSkysoft VideoConverterUltimate",                                                           0],
    ["$HOME/Library/Preferences/com.apple.LaunchServices",                                                     0],
    ["$HOME/Library/Preferences/UITextInputContextIdentifiers.plist",                                          0],
    ["$HOME/Library/Preferences/com.apple.EmojiCache.plist",                                                   1],
    ["$HOME/Library/Preferences/com.apple.EmojiPreferences.plist",                                             1],
    ["$HOME/Movies/Motion Templates",                                                                          0],
    ["$HOME/Movies/iMovie Library.imovielibrary",                                                              0],
    ["$HOME/Movies/iMovie Theater.theater",                                                                    0],
    ["$HOME/.npm",                                                                                             0],
    ["$HOME/.subversion",                                                                                      0],
    ["$HOME/.node_modules",                                                                                    0],
    ["$HOME/.android/",                                                                                        0],
    ["$HOME/.bash_history",                                                                                    0],
    ["$HOME/.python_history",                                                                                  0],
    ["$HOME/.zcompcache",                                                                                      0],
    ["$HOME/.local",                                                                                           0],
    ["$HOME/.bundle",                                                                                          0],
    ["$HOME/.gem",                                                                                             0],
    ["$HOME/.oracle_jre_usage",                                                                                0],
    ["$HOME/.bash_sessions",                                                                                   0],
    ["$HOME/.gradle",                                                                                          0],
    ["$HOME/.recently-used",                                                                                   0],
    ["$HOME/.cmake",                                                                                           0],
    ["$HOME/.solargraph",                                                                                      0],
    ["$HOME/.TemporaryItems",                                                                                  0],
    ["$HOME/.thumbnails",                                                                                      0],
    ["$HOME/Library/Cookies/com.apple.Safari.SearchHelper.binarycookies",                                      0],
    ["$HOME/Library/Application Support/iPhone Simulator",                                                     0],
    ["$HOME/Library/Messages/Archive",                                                                         0],
    ["$HOME/Library/Messages/Attachments",                                                                     0],
    ["$HOME/Library/Metadata/com.apple.IntelligentSuggestions",                                                1],
    ["$HOME/Library/Application Support/Xcode",                                                                1],
    ["$HOME/Library/Developer/Xcode/Archives",                                                                 0],
    ["$HOME/Library/Developer/Xcode/snapshots",                                                                0],
    ["$HOME/Library/Developer/Xcode/DerivedData",                                                              0],
    ["$HOME/Library/Developer/Xcode/UserData/*.xcuserstate",                                                   1],
    ["$HOME/Library/Developer/Xcode/UserData/IDEEditorInteractivityHistory",                                   0],
    ["$HOME/Library/Application Support/Alfred/usage.data",                                                    1],
    ["$HOME/Library/Application Support/Sublime Merge/Local/Backup Session.sublime_session",                   0],
    ["$HOME/Library/Application Support/Sublime Merge/Cache",                                                  1],
    ["$HOME/Library/Application Support/Sublime Text/Backup",                                                  0],
    ["$HOME/Library/Application Support/Sublime Text/Cache",                                                   1],
    ["$HOME/Library/Application Support/Sublime Text/Index",                                                   1],
    ["$HOME/Library/Application Support/Sublime Text/Local/Backup Session.sublime_session",                    0],
    ["$HOME/Library/Application Support/Sublime Text/Packages/User/Package Control.cache",                     1],
    ["$HOME/Library/Application Support/Sublime Text (Safe Mode)",                                             0],
    ["$HOME/Library/Application Support/CallHistoryDB",                                                        0],
    ["$HOME/Library/Application Support/CallHistoryTransactions",                                              0],
    ["$HOME/Library/Caches/com.apple.Safari/Webpage Previews",                                                 1],
    ["$HOME/Library/Caches/com.apple.Safari/Cache.*",                                                          1],
    ["$HOME/Library/Caches/com.apple.Safari/fsCachedData",                                                     1],
    ["$HOME/Library/Caches/com.apple.Safari/WebKitCache",                                                      1],
    ["$HOME/Library/Caches/com.apple.Safari/Webpage Previews",                                                 1],
    ["$HOME/Library/Safari/Configurations.plist.signed",                                                       1],
    ["$HOME/Library/Caches/com.apple.Safari/Cache.db",                                                         1],
    ["$HOME/Library/Safari/CloudBookmarksMigrationCoordinator",                                                0],
    ["$HOME/Library/Safari/Databases",                                                                         1],
    ["$HOME/Library/Safari/Cloud*",                                                                            1],
    ["$HOME/Library/Safari/LastSession.plist",                                                                 1],
    ["$HOME/Library/Safari/TopSites.plist",                                                                    1],
    ["$HOME/Library/Safari/Downloads.plist",                                                                   1],
    ["$HOME/Library/Safari/WebFeedSources.plist",                                                              1],
    ["$HOME/Library/Safari/SearchDescriptions.plist",                                                          1],
    ["$HOME/Library/Safari/RecentlyClosedTabs.plist",                                                          1],
    ["$HOME/Library/Preferences/test_network.plist",                                                           1],
    ["$HOME/Library/Preferences/com.apple.sharekit.recents.plist",                                             1],
    ["$HOME/Library/Preferences/com.trolltech.plist",                                                          1],
    ["$HOME/Library/Preferences/com.qtproject.plist",                                                          1],
    ["$HOME/Library/Application Support/Dash/Temp",                                                            1],
    ["$HOME/Library/Developer/Xcode/DocumentationCache",                                                       0],
    ["$HOME/Library/Developer/Xcode/UserData/IB Support",                                                      0],
    ["$HOME/Library/Developer/Xcode/Products",                                                                 0],
    ["$HOME/Library/Caches/com.apple.dt.Xcode",                                                                0],
    ["$HOME/Library/Containers/com.koolesache.ColorSnapper2/Data/Library/Caches/com.koolesache.ColorSnapper2", 0],
    ["/private/var/folders/3j/tgfs5z8x2wg2krlgnzj4jzc00000gn/C/com.koolesache.ColorSnapper2",                  0],
    ["/private/var/folders/3j/tgfs5z8x2wg2krlgnzj4jzc00000gn/T/com.koolesache.ColorSnapper2",                  0],
    ["/private/var/folders/3j/tgfs5z8x2wg2krlgnzj4jzc00000gn/C/com.koolesache.ColorSnapper2Helper",            0],
    ["/private/var/folders/3j/tgfs5z8x2wg2krlgnzj4jzc00000gn/T/com.koolesache.ColorSnapper2Helper",            0],
    ["$HOME/Library/Application Support/Keyboard Maestro/Keyboard Maestro Recent Applications.plist",          0],
    ["$HOME/Library/Application Support/Keyboard Maestro/Keyboard Maestro Clipboards.kmchunked",               0],
    ["$HOME/Downloads/Bookmarks.txt",                                                                          0],
    ["/Library/Logs",                                                                                          1],
    ["$HOME/Library/Colors/NSColorPanelSwatches.plist",                                                        1],
    ["$HOME/ibrary/Preferences/embeddedBinaryValidationUtility.plist",                                         1],
    ["$HOME/Library/Containers/com.apple.podcasts/Data/Library/Preferences/com.apple.podcasts.plist",          0],
    ["$HOME/Library/Application Support/Microsoft Edge/Default/Sessions",                                      0],
    ["$HOME/Library/Application Support/Microsoft Edge/Default/*History*",                                     0],
    ["$HOME/Library/Application Support/Microsoft Edge/Default/Local Storage",                                 0],
    ["$HOME/Library/Application Support/Microsoft Edge/Default/Top Sites",                                     0],
    ["$HOME/Library/Application Support/Microsoft Edge/Default/Top Sites-journal",                             0],
 );

#*****************************************************************************************
# script main line
#*****************************************************************************************
podcastapp();
texturePacker();
plists();
deleteFilesAndFolders();
xcode();
sublimeText();
sublimeMerge();

#*****************************************************************************************
# Sublime Text
#*****************************************************************************************
sub sublimeText {
    my $filename = "$HOME/Library/Application Support/Sublime Text/Local/Session.sublime_session";
    my @keysToDelete = ("auto_complete", "file_history", "replace", "find_state", "find_in_files", "project", "buffers", "command_palette", "workspace_name", "folders");

    if (-e $filename) {
    open(my $configFile, "<", $filename);
    my $json = do { local $/; <$configFile> };
    close($configFile);
    my $utf8 = encode("UTF-8", $json);

    my $config = decode_json($utf8);
    delete $config->{'workspaces'};
    delete $config->{'folder_history'};
    delete $config->{'windows'};

    for my $key (@keysToDelete) {
        delete $config->{'settings'}->{'new_window_settings'}->{$key};
    }
    $json = encode_json($config);
    open($configFile, ">:encoding(UTF-8)", $filename);
    print $configFile $json;
    close($configFile);
    }
 }

#*****************************************************************************************
# Sublime Merge
#*****************************************************************************************
sub sublimeMerge {
    my $filename = "$HOME/Library/Application Support/Sublime Merge/Local/Session.sublime_session";
    my @keysToDelete = ("windows", "recent", "window_positions", "select_repository");

    if (-e $filename) {
    open(my $configFile, "<", $filename);
    my $json = do { local $/; <$configFile> };
    close($configFile);
    my $utf8 = encode("UTF-8", $json);

    my $config = decode_json($utf8);
    for my $key (@keysToDelete) {
        delete $config->{$key};
    }

    my %newWindow = ("window_height" => 1281.0, "window_width" => 1822.0);
    $config->{"new_window_session"} = \%newWindow;
    $config->{"project_dir"} = "$HOME/Developer";
    $json = encode_json($config);
    open($configFile, ">:encoding(UTF-8)", $filename);
    print $configFile $json;
    close($configFile);
    }
 }

#*****************************************************************************************
# Texture Packer
#*****************************************************************************************
sub texturePacker {
    my $plistFile = "$HOME/Library/Preferences/de.code-and-web.TexturePacker.plist";
    my $plist     = NSMutableDictionary->dictionaryWithContentsOfFile_($plistFile);
    if ($plist && $$plist) {
        my $keyNamesArray = $plist->allKeys();
        my $items         = $keyNamesArray->count;
        for (my $index = 0; $index < $items; ++$index) {
            my $key = $keyNamesArray->objectAtIndex_($index)->UTF8String();
            if ($key =~ /[A-Za-z0-9\-\.]*Users/) {
                $plist->removeObjectForKey_($key);
            }
        }
        unlink($plistFile);
        $plist->writeToFile_atomically_($plistFile, "0");
    }
}

#*****************************************************************************************
# Podcast 
#*****************************************************************************************
sub podcastapp {
    my $plistFile = "$HOME/Library/Containers/com.apple.podcasts/Data/Library/Preferences/com.apple.podcasts.plist";
    my $plist     = NSMutableDictionary->dictionaryWithContentsOfFile_($plistFile);
    if ($plist && $$plist) {
        my $keyNamesArray = $plist->allKeys();
        my $items         = $keyNamesArray->count;
        for (my $index = 0; $index < $items; ++$index) {
            my $key = $keyNamesArray->objectAtIndex_($index)->UTF8String();
            if ($key =~ /playState:.*/) {
                $plist->removeObjectForKey_($key);
            }
        }
        unlink($plistFile);
        $plist->writeToFile_atomically_($plistFile, "0");
    }
}

#*****************************************************************************************
# process the plists in the Preferences folder
#*****************************************************************************************
sub plists {
    foreach my $plistFile (glob "$HOME/Library/Preferences/*.plist") {
        eval {
            my $plistData = NSMutableDictionary->dictionaryWithContentsOfFile_($plistFile);
            foreach my $key (@plistKeysToDelete) {
                $plistData->removeObjectForKey_($key);
            }
            $plistData->writeToFile_atomically_($plistFile, "0");
        };
    }
    find(\&processFiles, "$HOME/Library/Containers");
    find(\&processFiles, "$HOME/Library/SyncedPreferences");
}

#*****************************************************************************************
# delete junk from a list of file and folders
#*****************************************************************************************
sub deleteFilesAndFolders {
    my %removeTreeOptions = (
        safe      => 1,
        verbose   => 0,
        keep_root => 1
    );
    for my $item (0 .. $#itemsToDelete) {
        my $i                         = "\"" . $itemsToDelete[$item][0] . "\"";
        my @actualFilesAndDirectories = glob $i;
        for my $delete (@actualFilesAndDirectories) {
            if (-f $delete) {
                unlink($delete);
            }
            else {
                $removeTreeOptions{keep_root} = $itemsToDelete[$item][1];
                remove_tree($delete, \%removeTreeOptions);
            }
        }
    }
    my $temp = $ENV{'TMPDIR'};
    $removeTreeOptions{keep_root} = 1;
    remove_tree($temp, \%removeTreeOptions);
}

#*****************************************************************************************
# Xcode settings
#*****************************************************************************************
sub xcode {
    my $plistFile ="$HOME/Library/Preferences/com.apple.dt.Xcode.plist";
    my $plist     = NSMutableDictionary->dictionaryWithContentsOfFile_($plistFile);
    if ($plist) {
        my $options         = NSMutableDictionary->dictionary();
        my %templateOptions = (
            "languageChoice"         => "Swift",
            "bundleIdentifierPrefix" => "com.geedbla",
            "organizationName"       => "Gee Dbl A",
            "hasUITests"             => "true",
            "hasUnitTests"           => "true",
            "storyboardBased"        => "true",
            "appLifecycle"           => "Cocoa",
        );
        foreach my $key (keys %templateOptions) {
            $options->setObject_forKey_($templateOptions{$key}, $key);
        }
        $plist->setObject_forKey_($options, "IDETemplateOptions");
        $plist->setObject_forKey_("~/Developer/", "NSNavLastRootDirectory");
        $plist->writeToFile_atomically_($plistFile, "0");
    }
 }

#*****************************************************************************************
# process the plists in the Containers folder
#*****************************************************************************************
sub processFiles {
    if ($File::Find::name =~ /\.plist$/) {
        eval {
            my $plistData = NSMutableDictionary->dictionaryWithContentsOfFile_($File::Find::name);
            foreach my $key (@plistKeysToDelete) {
                $plistData->removeObjectForKey_($key);
            }

            my $valuesDic = $plistData->objectForKey_("values");
            if ($valuesDic && $$valuesDic) {
               my $valuesDicM = $valuesDic->mutableCopy;
               foreach my $key (@plistKeysToDelete) {
                    $valuesDicM->removeObjectForKey_($key);
                }
                $plistData->setObject_forKey_($valuesDicM, "values")
            }

            $plistData->writeToFile_atomically_($File::Find::name, "0");
        };
    }
}
PERL

CACHE=$(getconf DARWIN_USER_CACHE_DIR)
rm -rf ${CACHE}com.apple.DeveloperTools                    &> /dev/null
rm -rf ${CACHE}org.llvm.clang.$(whoami)/ModuleCache        &> /dev/null
rm -rf ${CACHE}org.llvm.clang/ModuleCache                  &> /dev/null
find "$HOME/Library/Caches" -type d -name "com.apple.dt.*" -exec rm -rf {} \;

DTMP=$(getconf DARWIN_USER_TEMP_DIR)
find "$DTMP" -name "*.swift" -delete
find "$DTMP" -name "ibtool*" -delete
find "$DTMP" -name "*IBTOOLD*" -delete
find "$DTMP" -name "sources-*" -delete
find "$DTMP" -name "com.apple.dt.*" -delete
find "$DTMP" -name "com.apple.test.* " -delete
rm -rf ${DTMP}xcrun_db                                      &> /dev/null

xcrun simctl delete unavailable                             &> /dev/null
xcrun simctl shutdown all                                   &> /dev/null
xcrun simctl erase all                                      &> /dev/null

printf "\ec\e[3J"
dscacheutil -flushcache                                     &> /dev/null
sudo killall -HUP mDNSResponder                             &> /dev/null
sudo update_dyld_shared_cache -force  &> /dev/null
sudo purge                            &> /dev/null
find "$HOME/Library/Developer" -type d -name "[A-Za-z0-9]* Device Logs" -exec rm -rfv {} \; &> /dev/null
sqlite3 "$(find "$HOME/Library/Mail" -name "Envelope Index")" vacuum

finish
defaults delete com.apple.Safari IncludeInternalDebugMenu
killall sharedfilelistd         &> /dev/null
killall cfprefsd                &> /dev/null
open -a "/Applications/Keyboard Maestro.app/Contents/MacOS/Keyboard Maestro Engine.app"
open -a "/Applications/ColorSnapper2.app"

save-simulator.pl -l myPhone "$HOME/Developer/data/phone-image.zip"
save-simulator.pl -l myiPadPro "$HOME/Developer/data/phone-image.zip"

cat <<"XCODE_BREAKPOINTS" > "$HOME/Library/Developer/Xcode/UserData/xcdebugger/Breakpoints_v2.xcbkptlist"
<?xml version="1.0" encoding="UTF-8"?>
<Bucket
   uuid = "UserGlobalBreakpointBucket"
   type = "2"
   version = "2.0">
   <Breakpoints>
      <BreakpointProxy
         BreakpointExtensionID = "Xcode.Breakpoint.SymbolicBreakpoint">
         <BreakpointContent
            uuid = "E29DF884-B98D-4E34-B697-EB011F81DBA2"
            shouldBeEnabled = "No"
            nameForDebugger = "AutolayoutBreakpoint"
            ignoreCount = "0"
            continueAfterRunningActions = "Yes"
            symbolName = "UIViewAlertForUnsatisfiableConstraints"
            moduleName = "">
            <Actions>
               <BreakpointActionProxy
                  ActionExtensionID = "Xcode.BreakpointAction.ShellCommand">
                  <ActionContent
                     command = "/usr/local/bin/geedbla/wtf-autolayout.py"
                     arguments = "@(NSString *)[(id)$arg2 description]@"
                     waitUntilDone = "NO">
                  </ActionContent>
               </BreakpointActionProxy>
            </Actions>
            <Locations>
            </Locations>
         </BreakpointContent>
      </BreakpointProxy>
   </Breakpoints>
</Bucket>
XCODE_BREAKPOINTS

osascript <<"END2"
try
    tell application "System Events" to tell process "ColorSnapper2"
        set frontmost to true
        key code 53
    end tell
end try

tell application "Safari" to quit
set volume output volume 50 with output muted --100%
set volume without output muted
END2
perl /usr/local/bin/geedbla/startup-banner.pl

