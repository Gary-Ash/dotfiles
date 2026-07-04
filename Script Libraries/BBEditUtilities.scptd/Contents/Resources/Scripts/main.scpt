(****************************************************************************************
 * BBEditUtilities.scptd
 *
 * BBEdit scripting utilities library
 *
 * Author   :  Gary Ash <gary.ash@icloud.com>
 * Created  :  3-Jul-2026  8:50pm
 * Modified :
 *
 * Copyright © 2026 By Gary Ash All rights reserved.
 ***************************************************************************************)

use scripting additions

(****************************************************************************************
 * check the copyright statement organization against the the list of mine or ones that
 * i work with and return true or false
 ****************************************************************************************)
on checkOrganization(organizationName)
	set organizations to settings()
	
	repeat with org in organizations
		if (org as string) = (organizationName as string) then
			return true
		end if
	end repeat
	return false
end checkOrganization

(*****************************************************************************************
 * read the settings from the setting plist
 ****************************************************************************************)
on settings()
	set thePropertyListFilePath to "~/Library/Application Support/BBEdit/geedbla-settings.plist"
	
	try
		tell application "System Events"
			tell property list file thePropertyListFilePath
				return value of property list item "Organizations"
			end tell
		end tell
	on error
		set defaultOrganizations to {"Gary Ash", "Gee Dbl A"}
		tell application "System Events"
			set theParentDictionary to make new property list item with properties {kind:record}
			set thePropertyListFile to make new property list file with properties {contents:theParentDictionary, name:thePropertyListFilePath}
			tell property list items of property list file thePropertyListFilePath
				make new property list item at end with properties {kind:list, name:"Organizations", value:defaultOrganizations}
			end tell
		end tell
		
		return defaultOrganizations
	end try
end settings

(*****************************************************************************************
 * Set the cursor position
 *****************************************************************************************)
on setCursorPosition(lineNumber, columnNumber)
	tell application "BBEdit"
		try
			set theLineReference to (line lineNumber of text document 1)
			select insertion point before (character columnNumber of theLineReference)
		on error
			try
				set theLineReference to (line lineNumber of text document 1)
				select insertion point after last character of theLineReference
			on error
				try
					select insertion point before character 1 of text document 1
				end try
			end try
		end try
	end tell
end setCursorPosition

(******************************************************************************************
 * Insert the given text string at the insertion point and advance it
 *****************************************************************************************)
on insertText(txt)
	tell application "BBEdit"
		activate
		set cursor_loc to 1
		try
			set cursor_loc to characterOffset of selection
		end try
		set selection to txt
		try
			select insertion point before character (cursor_loc + (length of txt)) of document 1
		end try
	end tell
end insertText

(*******************************************************************************************
 * This routine will take the given source language and return a pair of comment characters
 * that should be used for that language
 ******************************************************************************************)
on getCommentCharacters(lang)
	set semicolon_style to {"INI", "Lisp"}
	set slash_style to {"Rust", "JSP", "Zig"}
	set HTML_style to {"HTML", "XML", "Svelte"}
	set c_style to {"ANSI C", "C++", "C#", "Objective-C", "Objective-C++", "PHP", "Swift", "Go", "Java", "JavaScript", "TypeScript", "PHP", "CSS", "SCSS", "SQL"}
	
	repeat with l in semicolon_style
		if (l as text) is equal to lang then
			set commentCharacters to {";", ""}
			return commentCharacters
		end if
	end repeat
	
	repeat with l in c_style
		if (l as text) is equal to lang then
			set commentCharacters to {"/*", "*/"}
			return commentCharacters
		end if
	end repeat
	
	repeat with l in slash_style
		if (l as text) is equal to lang then
			set commentCharacters to {"//", ""}
			return commentCharacters
		end if
	end repeat
	
	if lang is equal to "Python" then
		set commentCharacters to {"# ", ""}
		return commentCharacters
	end if
	
	repeat with l in HTML_style
		if (l as text) is equal to lang then
			set commentCharacters to {"<!--", " -->"}
			return commentCharacters
		end if
	end repeat
	
	set commentCharacters to {"#", ""}
	return commentCharacters
end getCommentCharacters

