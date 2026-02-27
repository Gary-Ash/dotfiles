# Project Guidelines for Claude

## Commit Messages

Format:
```
[TYPE]: <Title Cased short summary>

<description>

[optional footer]
```

The first commit of a new project should be: `Initial commit`

Types:
- FEATURE: New functionality
- BUGFIX: Bug fixes
- TIDY: Documentation changes, code style changes
- REFACTOR: Code refactoring (structural changes, no behavior change)
- TEST: Adding or modifying tests

Rules:
- Type in square brackets, uppercase
- Description in imperative mood ("Add" not "Added")
- Blank line between subject and body
- Body uses bullet points for multiple changes
- Wrap at 72 characters

Examples:
```
[FEATURE]: Add Password Reset Functionality

- Add forgot password form
- Implement email verification flow
- Add password reset endpoint
```

```
[TIDY]: Clean up authentication module

- Remove unused imports
- Standardize naming conventions
```

```
[TEST]: Add edge cases for rate limiting
```

```
[REFACTOR]: Extract validation into separate module
```

## Code Style

- Do not add inline comments to generated code
- Follow existing project conventions for formatting
- All new source files MUST include the appropriate file header comment from the templates below

## File Header Comment Templates

Every new source file must include a file header comment. Use the appropriate template based on the language. Replace "file name" with the actual file name, set "Created" to the current date/time, and use the current year in the copyright line.

Rules for maintaining file headers:
- Replace "brief summary of the file contents" with a concise description of what the file actually contains
- Every time you edit a file, update the "Modified" field with the current date and time (same format as "Created")
- If the current year differs from the year in the copyright line, append "-<current year>" to form a range (e.g., "Copyright © 2026-2027"). Do not modify it if the current year is already present.

### Rust and other `//` comment languages

```
//****************************************************************************************
// file name
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

### C, C++, Objective-C, Objective-C++, Swift and other `/* */` comment languages

```
/*****************************************************************************************
 * file name
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

### Python

```
#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# ****************************************************************************************
#  file name
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

### Ruby

```
#!/usr/bin/env ruby
# encoding: utf-8
#*****************************************************************************************
# file name
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

### Perl

```
#!/usr/bin/env perl
#*****************************************************************************************
# file name
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

### Shell scripts (Bash)

```
#!/usr/bin/env bash
set -euo pipefail
#*****************************************************************************************
# file name
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

## Development Approach

- Test-Driven Development (Kent Beck style)
  1. Write a failing test
  2. Make it pass with minimal code
  3. Refactor (tidy)
- Tidy First: small structural changes before behavior changes
- Prefer small, focused commits that do one thing

## Languages

- Swift: primary
  - Xcode and Swift Package Manager only (no CocoaPods, Carthage, etc.)
- Perl: primary
- C++: performance-critical work
  - Modern C++ (C++20), memory-safe idioms (smart pointers, RAII, no raw new/delete)
  - CMake only, cross-platform (no platform-specific APIs without abstraction)
  - Always build with sanitizers (ASan, UBSan) during development

## Testing

- Tests come first
- Each commit should leave tests passing
- Separate refactoring commits from behavior-changing commits
