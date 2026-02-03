# Project Guidelines for Claude

## Commit Messages

Format:
```
[TYPE]: <description>

[optional body]

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

- Do not add comments to generated code
- Follow existing project conventions for formatting

## Development Approach

- Test-Driven Development (Kent Beck style)
  1. Write a failing test
  2. Make it pass with minimal code
  3. Refactor (tidy)
- Tidy First: small structural changes before behavior changes
- Prefer small, focused commits that do one thing

## Languages

- Swift: primary
- Perl: primary

## Testing

- Tests come first
- Each commit should leave tests passing
- Separate refactoring commits from behavior-changing commits
