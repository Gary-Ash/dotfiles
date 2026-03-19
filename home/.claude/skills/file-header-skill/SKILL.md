---
name: file-header
description: Ensure source files include a consistent metadata header comment using the correct comment syntax for the language. Use when creating new source files or when the user asks to add, fix, or update file headers. Handles Created/Modified timestamps, copyright years, and language-appropriate comment syntax.
allowed-tools: Read, Write, Edit, Glob, Grep, Bash
argument-hint: [filename or language]
---

# Source File Header Comment Skill

Ensure all source files include a consistent metadata header using the correct comment syntax for the file's language.

## Header Fields

Every header must include these fields in order:

1. **File name** — the actual name of the file
2. **Description** — a brief summary of the file's contents
3. **Author** — `Gary Ash <gary.ash@icloud.com>`
4. **Created** — set once when the file is first created, never changed
5. **Modified** — updated on every meaningful edit (use the latest time if multiple edits occur on the same day)
6. **Copyright** — `Copyright © YYYY By Gary Ash All rights reserved.` (if the current year differs from the year in the copyright line, append `-<current year>` to form a range)

## Timestamp Format

All timestamps use the format: `DD-MMM-YYYY  H:MMxm`

Examples: ` 7-Feb-2026  4:22pm`, `19-Mar-2026 11:05am`

- Single-digit days are right-aligned with a leading space
- Month is three-letter abbreviation with first letter capitalized
- Time uses 12-hour format with `am`/`pm` (no space before am/pm)
- Two spaces between the date and time portions

## Comment Syntax Selection

### Multiline comment style (`/* */`)

Use for languages that support multiline comment delimiters:
- C, C++, Objective-C, Objective-C++, Java, JavaScript, TypeScript, Swift, AppleScript, Pascal, CSS

Template:
```
/*****************************************************************************************
 * filename.ext
 *
 * brief summary of the file contents
 *
 * Author   :  Gary Ash <gary.ash@icloud.com>
 * Created  :   7-Feb-2026  4:22pm
 * Modified :
 *
 * Copyright © 2026 By Gary Ash All rights reserved.
 ****************************************************************************************/
```

Rules:
- Opening line: `/*` followed by asterisks to fill 89 characters total
- Each interior line starts with ` * ` (space-asterisk-space)
- Closing line: space followed by asterisks to fill 88 characters, then `/`
- The asterisk border lines are exactly 89 characters wide

### Single-line comment style (`//`)

Use for languages with `//` comments that do not have multiline delimiters or where `//` is conventional:
- Rust, Zig, Go

Template:
```
//****************************************************************************************
// filename.ext
//
// brief summary of the file contents
//
// Author   :  Gary Ash <gary.ash@icloud.com>
// Created  :   7-Feb-2026  4:27pm
// Modified :  27-Feb-2026  4:59pm
//
// Copyright © 2026 By Gary Ash All rights reserved.
//****************************************************************************************
```

### Hash comment style (`#`)

Use for scripting languages:
- Python, Ruby, Perl, Bash, Shell

**Python** includes shebang and encoding lines before the header:
```
#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# ****************************************************************************************
#  filename.py
#
# brief summary of the file contents
#
#  Author   :  Gary Ash <gary.ash@icloud.com>
#  Created  :   7-Feb-2026  4:21pm
#  Modified :
#
#  Copyright © 2026 By Gary Ash All rights reserved.
# ****************************************************************************************
```

**Ruby** includes shebang and encoding:
```
#!/usr/bin/env ruby
# encoding: utf-8
#*****************************************************************************************
# filename.rb
#
# brief summary of the file contents
#
# Author   :  Gary Ash <gary.ash@icloud.com>
# Created  :   7-Feb-2026  4:19pm
# Modified :
#
# Copyright © 2026 By Gary Ash All rights reserved.
#*****************************************************************************************
```

**Perl** includes shebang:
```
#!/usr/bin/env perl
#*****************************************************************************************
# filename.pl
#
# brief summary of the file contents
#
# Author   :  Gary Ash <gary.ash@icloud.com>
# Created  :   7-Feb-2026  4:16pm
# Modified :
#
# Copyright © 2026 By Gary Ash All rights reserved.
#*****************************************************************************************
```

**Bash** includes shebang and strict mode:
```
#!/usr/bin/env bash
set -euo pipefail
#*****************************************************************************************
# filename.sh
#
# brief summary of the file contents
#
# Author   :  Gary Ash <gary.ash@icloud.com>
# Created  :   3-Feb-2026  8:19pm
# Modified :
#
# Copyright © 2026 By Gary Ash All rights reserved.
#*****************************************************************************************
```

## Workflow

### Adding a header to a new file
1. Determine the language from the file extension
2. Select the appropriate comment syntax template
3. Set the file name, a brief description, and the Created timestamp to the current date/time
4. Leave Modified blank
5. Set the copyright year to the current year

### Updating a header on an existing file
1. Read the file and locate the existing header
2. Update the Modified timestamp to the current date/time
3. If the current year differs from the copyright year, update to a year range (e.g., `2025-2026`)
4. Do not change the Created timestamp
5. Update the file name if the file has been renamed
6. Update the description if the file's purpose has changed

## Argument Handling

- If `$ARGUMENTS` is a filename, add or update the header in that file
- If `$ARGUMENTS` is "update <filename>", update the Modified timestamp and copyright year
- If `$ARGUMENTS` is a language name, show the header template for that language
- Otherwise, treat as a general request about file headers
