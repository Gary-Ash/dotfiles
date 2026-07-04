(****************************************************************************************
 * TextUtilities.scptd
 *
 * A library of text utilities 
 *
 * Author   :  Gary Ash <gary.ash@icloud.com>
 * Created  :  3-Jul-2026  8:54pm
 * Modified :
 *
 * Copyright © 2026 By Gary Ash All rights reserved.
 ***************************************************************************************)

use scripting additions

(*****************************************************************************************
 * build a string by repeating a character a given number of times
 ****************************************************************************************)
on repeatChar(theChar, theCount)
	set theRun to ""
	repeat theCount times
		set theRun to theRun & theChar
	end repeat
	return theRun
end repeatChar

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

(*****************************************************************************************
 * This subroutine will format the current date in my preferred time stamp format of
 * DD-MMM-YYYY HH:MM[am/pm]
 ****************************************************************************************)
on formatDateTimeStamp()
	set d to current date
	
	set theDay to day of d
	set theMonth to text 1 thru 3 of ((month of d) as text)
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
	
	-- Pad values
	if theMinute < 10 then
		set theMinute to "0" & theMinute
	else
		set theMinute to theMinute as text
	end if
	
	set theDay to theDay as text
	set theHour to theHour as text
	set theYear to theYear as text
	
	set formattedDate to theDay & "-" & theMonth & "-" & theYear & "  " & theHour & ":" & theMinute & suffix
	
	return formattedDate
end formatDateTimeStamp

