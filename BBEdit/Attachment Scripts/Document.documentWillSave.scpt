(*****************************************************************************************
 * Document.documentWillSave.scpt
 *
 * Update my file heading comment
 *
 * Author   :  Gary Ash <gary.ash@icloud.com>
 * Created  :  30-Jan-2026  2:43pm
 * Modified :  22-Jul-2026  1:41pm
 *
 * Copyright © 2026 By Gary Ash All rights reserved.
 ****************************************************************************************)

use BBEditUtilities : script "BBEditUtilities"
use TextUtilities : script "TextUtilities"
use scripting additions

on documentWillSave(doc)
	my updateHeaderComment(doc)
end documentWillSave

on updateHeaderComment(td)
	tell application "BBEdit"
		set saveLine to startLine of selection of (window of td)
		set saveCol to startColumn of selection of (window of td)
		
		set copyrightResult to (find ¬
			"Copyright © (20[0-9]*-20[0-9]*|20[0-9]*)\\s*By\\s*(.*)\\s*All rights reserved." searching in (td) ¬
			selecting match true ¬
			options {search mode:grep, starting at top:true})
		
		if (found of copyrightResult) is equal to true then
			set copyrightLine to startLine of selection
			set lineText to contents of line copyrightLine of td as string
			
			set byPos to offset of " By " in lineText
			set allPos to offset of " All rights reserved." in lineText
			set organizationName to texts (byPos + 4) thru (allPos - 1) of lineText
			
			set copyPos to offset of "Copyright © " in lineText
			set yearFromCopyright to texts (copyPos + 12) thru (copyPos + 15) of lineText
			
			if BBEditUtilities's checkOrganization(organizationName) is equal to true and copyrightLine < 20 then
				if (year of (current date) as string) > yearFromCopyright then
					try
						find "Copyright © " & yearFromCopyright & ¬
							"(-[0-9]*)?\\s*By" searching in td ¬
							selecting match true ¬
							options {search mode:grep, starting at top:true}
						set selection to "Copyright © " & yearFromCopyright & "-" & (year of (current date) as string) & " By"
					end try
				end if
				
				set modifiedResult to (find ¬
					"(Modified|Updated)\\s*:.*" searching in td ¬
					selecting match true ¬
					options {search mode:grep, starting at top:true})
				
				if (found of modifiedResult) is equal to true then
					find ¬
						":.*$" searching in selection ¬
						selecting match true ¬
						options {search mode:grep}
					
					delete selection
					
					set stamp to TextUtilities's formatDateTimeStamp()
					set selection to ((":  " & stamp) as string)
				end if
			end if
		end if
	end tell
	BBEditUtilities's setCursorPosition(saveLine, saveCol)
end updateHeaderComment

