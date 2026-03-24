(*****************************************************************************************
 * HeadingComment.scpt
 *
 * Insert my file heading comment into the BBEdit document
 *
 * Author   :  Gary Ash <gary.ash@icloud.com>
 * Created  :  30-Jan-2026  2:43pm
 * Modified :  25-Mar-2026 11:08pm
 *
 * Copyright © 2026 By Gary Ash All rights reserved.
 ****************************************************************************************)

use script "BBEditLibrary"
use scripting additions

tell application "BBEdit"
	activate
	set lang to (get source language of text document 1)
	set filename to (get name of text document 1)
	set theLineNumber to ((startLine of selection) of text window 1)
end tell

tell script "BBEditLibrary"
	set organizations to settings()
	set shebang to (my makeShebangLine(lang))
	set commentCharacters to (getCommentCharacters(lang))
	set comment to shebang
	set comment to (comment & (item 1 of commentCharacters))
	set LF to (ASCII character 10)
	
	if length of (item 2 of commentCharacters) > 0 then
		set insideLine to " * "
	else
		set insideLine to (item 1 of commentCharacters) & " "
	end if
	
	
	set decoratorCount to 90 - (length of (item 1 of commentCharacters))
	
	repeat decoratorCount times
		set comment to (comment & "*")
	end repeat
	set comment to (comment & LF)
	
	set comment to (comment & insideLine & filename & LF)
	set comment to (comment & insideLine & LF)
	set comment to (comment & insideLine & LF)
	set comment to (comment & insideLine & LF)
	set comment to (comment & insideLine & "Author   :  Gary Ash <gary.ash@icloud.com>" & LF)
	set comment to (comment & insideLine & "Created  :  " & formatDateTimeStamp() & LF)
	set comment to (comment & insideLine & "Modified :  " & LF)
	set comment to (comment & insideLine & LF)
	set comment to (comment & insideLine & "Copyright © " & ((year of (current date)) as text) & " By " & (item 1 of organizations) & " All rights reserved." & LF)
	
	set license to (my askForLicense())
	if license is equal to "cancel" then
		return
	end if
	
	if license is not equal to "" then
		set license to (wordWrap(license, insideLine, 89))
		set comment to comment & license
	end if
	
	set decoratorCount to 90 - (length of (item 2 of commentCharacters))
	if length of (item 2 of commentCharacters) > 0 then
		set comment to (comment & " ")
		set decoratorCount to decoratorCount - 1
	else
		set comment to (comment & (item 1 of commentCharacters))
		set decoratorCount to decoratorCount - (length of (item 1 of commentCharacters))
	end if
	
	repeat decoratorCount times
		set comment to (comment & "*")
	end repeat
	set comment to (comment & (item 2 of commentCharacters) & "
")
	
	setCursorPosition(1, 1)
	insertText(comment)
	
	if shebang is not equal to "" then
		set oldDelims to AppleScript's text item delimiters
		set AppleScript's text item delimiters to LF
		set numberOfLines to (count of text items of shebang) - 1
		set AppleScript's text item delimiters to oldDelims
	else
		set numberOfLines to 0
	end if
	
	set theLineNumber to (4 + numberOfLines)
	setCursorPosition(theLineNumber, (length of insideLine as text) + 1)
end tell

on askForLicense()
	tell application "BBEdit" to activate
	
	set license to "" as string
	set theLicenseChoices to {"None", "Open", "Closed"}
	set theLicense to (choose from list theLicenseChoices with prompt "Select a license:" default items {"None"}) as string
	
	if theLicense is equal to "Closed" then
		set license to getLicense("Closed-LICENSE.markdown")
	else if theLicense is equal to "Open" then
		set license to getLicense("Open-LICENSE.markdown")
	else if theLicense is equal to "None" then
	else
		set license to "cancel"
	end if
	
	return license
end askForLicense

on getLicense(licenseFileName)
	set filename to (the POSIX path of (path to application support from user domain))
	set filename to filename & "BBEdit/Scripts/Licenses/"
	set filename to filename & licenseFileName
	set txt to (read filename)
	return txt as string
end getLicense

(*******************************************************************************************
 * This routine will take the given source language and return a shebang line if needed
 ******************************************************************************************)
on makeShebangLine(lang)
	set linefeed to (ASCII character 10)
	set shebang to ""
	
	if lang is equal to "Unix Shell Script" then
		set shebang to "#!/usr/bin/env bash" & linefeed & "set -euo pipefail" & linefeed
	else if lang is equal to "Perl" then
		set shebang to "#!/usr/bin/env perl" & linefeed
	else if lang is equal to "Python" then
		set shebang to "#!/usr/bin/env python3" & linefeed & "# -*- coding: utf-8 -*-" & linefeed
	else if lang is equal to "Ruby" then
		set shebang to "#!/usr/bin/env ruby" & linefeed & "# encoding: utf-8" & linefeed
	end if
	
	return shebang
end makeShebangLine


