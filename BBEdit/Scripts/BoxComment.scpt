(*****************************************************************************************
 * BoxComment.scpt
 *
 * Insert a box comment into the BBEdit document
 *
 * Author   :  Gary Ash <gary.ash@icloud.com>
 * Created  :  30-Jan-2026  2:43pm
 * Modified :  25-Mar-2026 11:08pm
 *
 * Copyright © 2026 By Gary Ash All rights reserved.
 ****************************************************************************************)

use script "BBEditLibrary"
use scripting additions

tell application "BBEdit" to activate

set decoratorDialog to (display dialog ¬
	"Please enter the character to use to build the comment" with title ¬
	"Enter Decorator Character" default answer ¬
	"*" buttons {"Ok", "Cancel"} default button 1)

if (button returned of decoratorDialog) is equal to "Cancel" then
	return
end if

tell application "BBEdit"
	activate
	
	set lang to (get source language of text document 1)
	set theLineNumber to ((startLine of selection) of text window 1)
	set theColumnNumber to ((startColumn of selection) of text window 1)
end tell

tell script "BBEditLibrary"
	set LF to (ASCII character 10)
	
	set commentCharacters to (getCommentCharacters(lang))
	set comment to (item 1 of commentCharacters)
	set decoratorCount to 91 - (length of comment) - theColumnNumber
	
	repeat decoratorCount times
		set comment to (comment & (text returned of decoratorDialog))
	end repeat
	set comment to (comment & LF)
	
	repeat theColumnNumber - 1 times
		set comment to (comment & " ")
	end repeat
	
	if length of (item 2 of commentCharacters) > 0 then
		set comment to (comment & " * " & LF)
		repeat theColumnNumber times
			set comment to (comment & " ")
		end repeat
	else
		if (item 1 of commentCharacters) ends with " " then
			set comment to (comment & (item 1 of commentCharacters) & LF)
		else
			set comment to (comment & (item 1 of commentCharacters) & " " & LF)
		end if
	end if
	
	if length of (item 2 of commentCharacters) > 0 then
		set decoratorCount to 87 - theColumnNumber
		set comment to (comment & "*")
		set theColumnNumber to theColumnNumber + 2
	else
		set decoratorCount to 90 - (length of (item 2 of commentCharacters)) - theColumnNumber
		repeat theColumnNumber - 1 times
			set comment to (comment & " ")
		end repeat
		set comment to (comment & (item 1 of commentCharacters))
		set theColumnNumber to theColumnNumber + 1
	end if
	
	
	repeat decoratorCount times
		set comment to (comment & (text returned of decoratorDialog))
	end repeat
	set comment to (comment & (item 2 of commentCharacters))
	
	insertText(comment)
	setCursorPosition(theLineNumber + 1, theColumnNumber + 1)
end tell

