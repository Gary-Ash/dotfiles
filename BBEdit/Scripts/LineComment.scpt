(*****************************************************************************************
 * LineComment.scpt
 *
 * Insert a separator line comment into the BBEdit document
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
	set theColumnNumber to ((startColumn of selection) of text window 1)
end tell

tell script "BBEditLibrary"
	set decoratorDialog to (display dialog ¬
		"Please enter the character to use to build the comment" with title ¬
		"Enter Decorator Character" default answer ¬
		"*" buttons {"Ok", "Cancel"} default button 1)
	
	if (button returned of decoratorDialog) is equal to "Cancel" then
		return
	end if
	
	set commentCharacters to (getCommentCharacters(lang))
	set comment to (item 1 of commentCharacters)
	set decoratorCount to 91 - (length of comment) - (length of (item 2 of commentCharacters)) - theColumnNumber
	
	repeat decoratorCount times
		set comment to (comment & (text returned of decoratorDialog))
	end repeat
	
	set comment to (comment & (item 2 of commentCharacters) & "
")
	insertText(comment)
end tell

