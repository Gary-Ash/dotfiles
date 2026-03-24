(*****************************************************************************************
 * BBEditLibrary.scpt
 *
 * Shared library of handlers for BBEdit comment scripts
 *
 * Author   :  Gary Ash <gary.ash@icloud.com>
 * Created  :  10-Aug-2024  8:01pm
 * Modified :  25-Mar-2026 11:08pm
 *
 * Copyright © 2024-2026 By Gary Ash All rights reserved.
 ****************************************************************************************)


(*****************************************************************************************
 * word wrap text
 ****************************************************************************************)
on wordWrap(inputText, prefix, maxLength)
	set LF to (ASCII character 10)
	set wrappedText to ""
	set maxLen to maxLength - (length of prefix)
	
	set textParagraphs to paragraphs of inputText
	
	repeat with paragraphText in textParagraphs
		set remainingText to paragraphText
		
		repeat while length of remainingText > maxLen
			set spacePos to maxLen
			
			repeat while spacePos > 0
				if character spacePos of remainingText is " " then exit repeat
				set spacePos to spacePos - 1
			end repeat
			
			if spacePos = 0 then set spacePos to maxLen
			
			set wrappedText to wrappedText & prefix & (text 1 thru spacePos of remainingText) & LF
			
			set remainingText to text (spacePos + 1) thru -1 of remainingText
		end repeat
		
		set wrappedText to wrappedText & prefix & remainingText & LF
	end repeat
	
	return wrappedText
end wordWrap

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
 * This subroutine will format the current date in my preferred time stamp format of
 * DD-MMM-YYYY HH:MM[am/pm]
 ****************************************************************************************)
on formatDateTimeStamp()
	set d to current date
	
	set theDay to day of d
	set theMonth to text 1 thru 3 of (month of d as text)
	set theYear to year of d
	
	set theHour to hours of d
	set theMinute to minutes of d
	
	if theHour ≥ 12 then
		set suffix to "pm"
	else
		set suffix to "am"
	end if
	
	if theHour = 0 then
		set theHour to 12
	else if theHour > 12 then
		set theHour to theHour - 12
	end if
	
	if theDay < 10 then
		set theDay to " " & theDay
	end if
	
	if theHour < 10 then
		set theHour to " " & theHour
	end if
	
	if theMinute < 10 then
		set theMinute to "0" & theMinute
	end if
	
	set formattedDate to theDay & "-" & theMonth & "-" & theYear & " " & theHour & ":" & theMinute & suffix
	return formattedDate
end formatDateTimeStamp


(*****************************************************************************************
 * Set the cursor position
 *****************************************************************************************)
on setCursorPosition(lineNumber, columnNumber)
	tell application "BBEdit"
		activate
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
	set c_style to {"ANSI C", "C++", "Objective-C", "Objective-C++", "Swift", "Go", "Java", "JavaScript", "TypeScript", "PHP", "CSS", "SCSS", "SQL"}
	set slash_style to {"Rust", "JSP", "Zig"}
	set HTML_style to {"HTML", "XML", "Svelte"}
	
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



