---
name: file-header-skill
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
6. **Copyright** — `Copyright © YYYY By Gary Ash All rights reserved.` (if the current year differs from the last year in the copyright line, form a range ending in the current year: `2025` becomes `2025-2026`, and `2024-2025` becomes `2024-2026`)

## Timestamp Format

All timestamps use the format: `DD-MMM-YYYY HH:MMxm`

Examples: ` 7-Feb-2026  4:22pm`, `19-Mar-2026 11:05am`

- Day and hour are two characters wide; a single digit is right-aligned with a leading space
- Month is three-letter abbreviation with first letter capitalized
- Time uses 12-hour format with `am`/`pm` (no space before am/pm)
- One space separates the date and time; a single-digit hour's leading space makes it look like two

## Comment Syntax Selection

### Multiline comment style (`/* */`)

Use for languages that support multiline comment delimiters:
- C, C++, Objective-C, Objective-C++, Java, JavaScript, TypeScript, Swift, CSS

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
- Opening line: `/*` followed by 88 asterisks (90 characters total)
- Each interior line starts with ` * ` (space-asterisk-space)
- Closing line: a space, 88 asterisks, then `/` (90 characters total)
- The asterisk border lines are exactly 90 characters wide

### AppleScript block comment style (`(* *)`)

AppleScript has no `/* */` comments. It uses `(* ... *)` for block comments
(and `--` or `#` for single-line). Use this style for `.applescript` files.

A `.scpt` file is compiled binary — never edit it as text. Convert it to source
first with `osadecompile <file.scpt> > <file.applescript>`, add the header to the
`.applescript`, and recompile with `osacompile -o <file.scpt> <file.applescript>`
if a `.scpt` is still needed.

Template:
```
(*****************************************************************************************
 * filename.applescript
 *
 * brief summary of the file contents
 *
 * Author   :  Gary Ash <gary.ash@icloud.com>
 * Created  :   7-Feb-2026  4:22pm
 * Modified :
 *
 * Copyright © 2026 By Gary Ash All rights reserved.
 ****************************************************************************************)
```

Rules:
- Opening line: `(*` followed by 88 asterisks (90 characters total)
- Each interior line starts with ` * ` (space-asterisk-space)
- Closing line: a space, 88 asterisks, then `)` (90 characters total)
- The asterisk border lines are exactly 90 characters wide

### Single-line comment style (`//`)

Use for languages where `//` is the conventional comment style:
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
// Modified :
//
// Copyright © 2026 By Gary Ash All rights reserved.
//****************************************************************************************
```

### Hash comment style (`#`)

Use for scripting languages and other `#`-comment files:
- Python, Ruby, Perl, Bash, Shell, Bats, CMake

**Python** includes shebang and encoding lines before the header:
```
#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#*****************************************************************************************
# filename.py
#
# brief summary of the file contents
#
# Author   :  Gary Ash <gary.ash@icloud.com>
# Created  :   7-Feb-2026  4:21pm
# Modified :
#
# Copyright © 2026 By Gary Ash All rights reserved.
#*****************************************************************************************
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

**Perl** scripts (`.pl`) include shebang and pragmas; modules (`.pm`) and tests (`.t`) omit the shebang line but keep the pragmas:
```
#!/usr/bin/env perl
use v5.34;
use strict;
use warnings;
use utf8;
#*****************************************************************************************
# filename.pl
#
# brief summary of the file contents
#
# Author   :  Gary Ash <gary.ash@icloud.com>
# Created  :  24-Sep-2026  9:15pm
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

**Bats** test files (`.bats`) use the Bats shebang and no strict-mode line (Bats manages
errors itself):
```
#!/usr/bin/env bats
#*****************************************************************************************
# filename.bats
#
# brief summary of the file contents
#
# Author   :  Gary Ash <gary.ash@icloud.com>
# Created  :  30-Sep-2026  4:10pm
# Modified :
#
# Copyright © 2026 By Gary Ash All rights reserved.
#*****************************************************************************************
```

**CMake** (`CMakeLists.txt`, `.cmake`) has no shebang or pragma lines; the header is the
first line of the file:
```
#*****************************************************************************************
# CMakeLists.txt
#
# brief summary of the file contents
#
# Author   :  Gary Ash <gary.ash@icloud.com>
# Created  :  30-Sep-2026  4:10pm
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
3. If the current year differs from the last copyright year, update to a year range ending in the current year (e.g., `2025` → `2025-2026`, `2024-2025` → `2024-2026`)
4. Do not change the Created timestamp
5. Update the file name if the file has been renamed
6. Update the description if the file's purpose has changed

## Argument Handling

- If `$ARGUMENTS` is a filename, add or update the header in that file
- If `$ARGUMENTS` is "update <filename>", update the Modified timestamp and copyright year
- If `$ARGUMENTS` is a language name, show the header template for that language
- Otherwise, treat as a general request about file headers
